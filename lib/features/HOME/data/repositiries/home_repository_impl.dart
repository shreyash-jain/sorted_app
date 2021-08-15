import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:dartz/dartz_streaming.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:sorted/core/error/failures.dart';
import 'package:sorted/core/global/injection_container.dart';
import 'package:sorted/core/network/network_info.dart';
import 'package:sorted/features/FEED/domain/entities/feed_post_entity.dart';
import 'package:sorted/features/FEED/data/models/feed_model.dart';
import 'package:sorted/features/HOME/data/datasources/home_cloud_data_source.dart';
import 'package:sorted/features/HOME/data/datasources/home_native_data_source.dart';
import 'package:sorted/features/HOME/data/datasources/home_remote_api_data_source.dart';
import 'package:sorted/features/HOME/data/datasources/home_shared_pref_data_source.dart';
import 'package:sorted/features/HOME/data/models/affirmation.dart';
import 'package:sorted/features/HOME/data/models/blog_textbox.dart';
import 'package:sorted/features/HOME/data/models/blogs.dart';
import 'package:sorted/features/HOME/data/models/challenge_model.dart';
import 'package:sorted/features/HOME/data/models/inspiration.dart';
import 'package:sorted/features/HOME/data/models/motivation/pep_talks.dart';
import 'package:sorted/features/HOME/data/models/motivation/transformation.dart';
import 'package:sorted/features/HOME/data/models/placeholder_info.dart' as ph;
import 'package:sorted/features/HOME/data/models/recipes/recipe.dart';
import 'package:sorted/features/HOME/data/models/recipes/recipe_step.dart';
import 'package:sorted/features/HOME/data/models/recipes/recipe_nutrition.dart';

import 'package:sorted/features/HOME/data/models/recipes/recipe_howto.dart';
import 'package:sorted/features/HOME/data/models/recipes/recipe_to_ingredient.dart';
import 'package:sorted/features/HOME/data/models/recipes/video_recipe.dart';

import 'package:sorted/features/HOME/data/models/recipes/tagged_recipe.dart';
import 'package:sorted/features/HOME/domain/entities/day_affirmations.dart';
import 'package:sorted/features/HOME/domain/entities/display_thumbnail.dart';
import 'package:sorted/features/HOME/domain/entities/unsplash_image.dart';
import 'package:sorted/features/HOME/domain/repositories/home_repository.dart';

class HomeRepositoryImpl implements HomeRepository {
  final HomeCloud remoteDataSource;
  final HomeNative nativeDataSource;
  final HomeSharedPref sharedPref;
  final NetworkInfo networkInfo;
  final HomeRemoteApi remoteApi;

  final _random = new Random();

  HomeRepositoryImpl(
      {@required this.remoteApi,
      @required this.remoteDataSource,
      @required this.nativeDataSource,
      @required this.sharedPref,
      @required this.networkInfo});

  @override
  Future<Either<Failure, InspirationModel>> get inspiration async {
    Either<Failure, InspirationModel> result = Left(NetworkFailure());
    DateTime now = DateTime.now();
    if ((await sharedPref.lastUpdatedInspiration)
        .isAfter(DateTime(now.year, now.month, now.day, 0, 00))) {
      try {
        return Right(await nativeDataSource.todayInspiration);
      } on Exception {
        result = Left(NativeDatabaseException());
      }
    }
    if (await networkInfo.isConnected) {
      try {
        List<InspirationModel> inspirationsFromCloud =
            await remoteDataSource.inspirations;
        if (inspirationsFromCloud != null && inspirationsFromCloud.length > 0) {
          result = Right(inspirationsFromCloud[0]);
          nativeDataSource.addInspirations(inspirationsFromCloud);
        } else {
          try {
            InspirationModel inspirationsFromNative =
                await nativeDataSource.todayInspiration;
            if (inspirationsFromNative != null) {
              result = Right(inspirationsFromNative);
            } else
              result = Left(ServerFailure());
          } on Exception {
            result = Left(NativeDatabaseException());
          }
        }
      } on Exception {
        result = Left(ServerFailure());
      }

      sharedPref.updateInspiration(now);
    } else {
      try {
        InspirationModel inspirationsFromNative =
            await nativeDataSource.todayInspiration;
        if (inspirationsFromNative != null) {
          result = Right(inspirationsFromNative);
        } else
          result = Left(ServerFailure());
      } on Exception {
        result = Left(NativeDatabaseException());
      }
    }
    return result;
  }

  Future<Either<Failure, List<UnsplashImage>>> get networkImages async {
    print("networkImages" + " " + "LoadedState");
    Either<Failure, List<UnsplashImage>> result = Left(NetworkFailure());

    List<UnsplashImage> fetchedImagesRemote = [];
    List<UnsplashImage> fetchedImagesNative = [];

    DateTime now = DateTime.now();

    try {
      print("networkImages" + " " + "3");
      fetchedImagesNative = await nativeDataSource.unsplashImages;
      print(fetchedImagesNative.length);
    } on Exception {
      print("networkImages" + " " + "4");
      result = Left(NativeDatabaseException());
    }
    bool isLocalDataAvailable =
        ((fetchedImagesNative) != null && (fetchedImagesNative).length > 0);
    if (await networkInfo.isConnected) {
      print("networkImages" + " " + "5");

      try {
        print("networkImages" + " " + "6");
        fetchedImagesRemote = await remoteApi.fetchWallpapers();
        print(fetchedImagesRemote.length);
        result = Right(fetchedImagesRemote);
        if (fetchedImagesRemote.length > 0) {
          await nativeDataSource.deleteUnsplashImagesTable();
          nativeDataSource.addUnsplashImagesDetails(fetchedImagesRemote);
        }
      } on Exception {
        result = Right(getCacheUnsplashImages());
      }
    } else {
      if (!isLocalDataAvailable) {
        print("networkImages" + " " + "9");

        result = Right(getCacheUnsplashImages());
      } else {
        print("networkImages" + " " + "10");

        result = Right(fetchedImagesNative);
      }
    }
    print("networkImages" + "  :" + result.toString());
    return result;
  }

  int next(int min, int max) => min + _random.nextInt(max - min);

  @override
  Future<Either<Failure, List<DisplayThumbnail>>> get thumbnails async {
    print("thumbnails" + " " + "LoadedState");
    Either<Failure, List<DisplayThumbnail>> result = Left(NetworkFailure());
    List<ph.Placeholder> thumbnailDetailsRemote = [];
    List<ph.Placeholder> thumbnailsDetailsNative = [];
    DateTime now = DateTime.now();
    // if ((await sharedPref.lastUpdatedThumbnailDetail)
    //     .isAfter(DateTime(now.year, now.month, now.day, 4, 00))) {
    //   try {
    //     print("thumbnails"+" "+"1");
    //     thumbnailsDetailsNative = await nativeDataSource.thumbnailDetails;
    //     print("thumbnails"+" length : "+thumbnailsDetailsNative.length.toString());
    //     print("thumbnails"+" "+"2");
    //     List<DisplayThumbnail> thumbnailUrls = [];
    //     for (int i = 0; i < thumbnailsDetailsNative.length; i++) {
    //       int selectImageId = next(1, thumbnailsDetailsNative[i].total);
    //       String path = thumbnailsDetailsNative[i].path +
    //           "/" +
    //           selectImageId.toString() +
    //           ".png";
    //       print("path is here " + path);
    //       String url =
    //           await sl<StorageReference>().child(path).getDownloadURL();
    //       thumbnailUrls.add(
    //         DisplayThumbnail(
    //             thumbnailUrl: url, category: thumbnailsDetailsNative[i].name),
    //       );
    //     }
    //     result = Right(thumbnailUrls);
    //     return result;
    //   } on Exception {
    //     result = Left(NativeDatabaseException());
    //   }
    // }

    try {
      print("thumbnails" + " " + "3");
      thumbnailsDetailsNative = await nativeDataSource.thumbnailDetails;
    } on Exception {
      print("thumbnails" + " " + "4");
      result = Left(NativeDatabaseException());
    }
    bool isLocalDataAvailable = ((thumbnailsDetailsNative) != null &&
        (thumbnailsDetailsNative).length > 0);
    if (await networkInfo.isConnected) {
      print("thumbnails" + " " + "5");
      if (!isLocalDataAvailable) {
        try {
          print("thumbnails" + " " + "6");
          thumbnailDetailsRemote = await remoteDataSource.thumbnailDetails;
          if (thumbnailDetailsRemote != null &&
              thumbnailDetailsRemote.length > 0) {
            List<DisplayThumbnail> thumbnailUrls = [];
            for (int i = 0; i < thumbnailDetailsRemote.length; i++) {
              int selectImageId = next(1, thumbnailDetailsRemote[i].total);
              String path = thumbnailDetailsRemote[i].path +
                  "/" +
                  selectImageId.toString() +
                  ".png";
              print("path is here " + path);
              String url = await sl<Reference>().child(path).getDownloadURL();
              thumbnailUrls.add(
                DisplayThumbnail(
                    thumbnailUrl: url,
                    category: thumbnailDetailsRemote[i].name),
              );
            }
            result = Right(thumbnailUrls);
            print("thumbnails" + "  :" + thumbnailUrls.length.toString());
          }
        } on Exception {
          result = Left(ServerFailure());
        }
      } else {
        print("thumbnails" + " " + "6");
        List<DisplayThumbnail> thumbnailUrls = [];
        for (int i = 0; i < thumbnailsDetailsNative.length; i++) {
          int selectImageId = next(1, thumbnailsDetailsNative[i].total);
          String path = thumbnailsDetailsNative[i].path +
              "/" +
              selectImageId.toString() +
              ".png";
          print("path is here " + path);
          String url = await sl<Reference>().child(path).getDownloadURL();
          thumbnailUrls.add(DisplayThumbnail(
              thumbnailUrl: url, category: thumbnailsDetailsNative[i].name));
        }
        result = Right(thumbnailUrls);
        try {
          print("thumbnails" + " " + "7");
          remoteDataSource.thumbnailDetails.then((value) async {
            await nativeDataSource.deleteThumbnailTable();
            nativeDataSource.addThumbnailDetails(value);
            sharedPref.updateThumbnailDetail(now);
          });
        } on Exception {
          print("thumbnails" + " " + "8");
          result = Left(ServerFailure());
        }
      }
    } else {
      if (!isLocalDataAvailable) {
        print("thumbnails" + " " + "9");
        List<DisplayThumbnail> thumbnailUrls = [
          DisplayThumbnail(
              thumbnailUrl: "https://source.unsplash.com/100x100/?work",
              category: "work"),
          DisplayThumbnail(
              thumbnailUrl: "https://source.unsplash.com/100x100/?happy",
              category: "confidence"),
          DisplayThumbnail(
              thumbnailUrl: "https://source.unsplash.com/100x100/?joy",
              category: "evening"),
          DisplayThumbnail(
              thumbnailUrl: "https://source.unsplash.com/100x100/?smile",
              category: "morning"),
          DisplayThumbnail(
              thumbnailUrl: "https://source.unsplash.com/100x100/?fit",
              category: "health"),
          DisplayThumbnail(
              thumbnailUrl: "https://source.unsplash.com/100x100/?sunshine",
              category: "relationship"),
          DisplayThumbnail(
              thumbnailUrl: "https://source.unsplash.com/100x100/?emotion",
              category: "wealth"),
          DisplayThumbnail(
              thumbnailUrl: "https://source.unsplash.com/100x100/?morning",
              category: "beauty"),
        ];
        result = Right(thumbnailUrls);
      } else {
        print("thumbnails" + " " + "10");
        List<DisplayThumbnail> thumbnailUrls = [];
        for (int i = 0; i < thumbnailsDetailsNative.length; i++) {
          int selectImageId = next(1, thumbnailsDetailsNative[i].total);
          String path = thumbnailsDetailsNative[i].path +
              "/" +
              selectImageId.toString() +
              ".png";
          print("path is here " + path);
          String url = await sl<Reference>().child(path).getDownloadURL();
          thumbnailUrls.add(DisplayThumbnail(
              thumbnailUrl: url, category: thumbnailsDetailsNative[i].name));
        }
        result = Right(thumbnailUrls);
      }
    }
    print("thumbnails" + "  :" + result.toString());
    return result;
  }

  getCacheUnsplashImages() {
    List<UnsplashImage> images = [
      UnsplashImage(
          imageUrl:
              "https://images.unsplash.com/photo-1600194990375-5d1d0b28781c?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjE2NjUyMH0",
          imageUrlThumb:
              "https://images.unsplash.com/photo-1600194990375-5d1d0b28781c?ixlib=rb-1.2.1&q=80&fm=jpg&crop=entropy&cs=tinysrgb&w=200&fit=max&ixid=eyJhcHBfaWQiOjE2NjUyMH0",
          profileLink: "https://unsplash.com/@windows",
          firstName: "Windows",
          lastName: "",
          downloadLink: "https://unsplash.com/photos/PnkX_rp53SE/download"),
      UnsplashImage(
          imageUrl:
              "https://images.unsplash.com/photo-1600506247590-4f2e2d1146fd?ixlib=rb-1.2.1&q=80&fm=jpg&crop=entropy&cs=tinysrgb&w=1080&fit=max&ixid=eyJhcHBfaWQiOjE2NjUyMH0",
          imageUrlThumb:
              "https://images.unsplash.com/photo-1600506247590-4f2e2d1146fd?ixlib=rb-1.2.1&q=80&fm=jpg&crop=entropy&cs=tinysrgb&w=200&fit=max&ixid=eyJhcHBfaWQiOjE2NjUyMH0",
          profileLink: "https://unsplash.com/@christianchen",
          firstName: "Christian Chen",
          lastName: "",
          downloadLink: "https://unsplash.com/photos/E-prxgqPJrQ/download"),
      UnsplashImage(
        imageUrl:
            "https://images.unsplash.com/photo-1600585154526-990dced4db0d?ixlib=rb-1.2.1&q=80&fm=jpg&crop=entropy&cs=tinysrgb&w=1080&fit=max&ixid=eyJhcHBfaWQiOjE2NjUyMH0",
        imageUrlThumb:
            "https://images.unsplash.com/photo-1600585154526-990dced4db0d?ixlib=rb-1.2.1&q=80&fm=jpg&crop=entropy&cs=tinysrgb&w=200&fit=max&ixid=eyJhcHBfaWQiOjE2NjUyMH0",
        profileLink: "https://unsplash.com/@rarchitecture_melbourne",
        firstName: "R ARCHITECTURE",
        lastName: "",
        downloadLink: "https://unsplash.com/photos/JvQ0Q5IkeMM/download",
      ),
      UnsplashImage(
          imageUrl:
              "https://images.unsplash.com/photo-1600442715978-d0268caa17f5?ixlib=rb-1.2.1&q=80&fm=jpg&crop=entropy&cs=tinysrgb&w=1080&fit=max&ixid=eyJhcHBfaWQiOjE2NjUyMH0",
          imageUrlThumb:
              "https://images.unsplash.com/photo-1600442715978-d0268caa17f5?ixlib=rb-1.2.1&q=80&fm=jpg&crop=entropy&cs=tinysrgb&w=200&fit=max&ixid=eyJhcHBfaWQiOjE2NjUyMH0",
          profileLink: "https://unsplash.com/@karsten116",
          firstName: "Karsten Winegeart",
          lastName: "",
          downloadLink: "https://unsplash.com/photos/a5HB3E0B01g/download"),
      UnsplashImage(
          imageUrl:
              "https://images.unsplash.com/photo-1600607658294-718c49de5818?ixlib=rb-1.2.1&q=80&fm=jpg&crop=entropy&cs=tinysrgb&w=1080&fit=max&ixid=eyJhcHBfaWQiOjE2NjUyMH0",
          imageUrlThumb:
              "https://images.unsplash.com/photo-1600607658294-718c49de5818?ixlib=rb-1.2.1&q=80&fm=jpg&crop=entropy&cs=tinysrgb&w=200&fit=max&ixid=eyJhcHBfaWQiOjE2NjUyMH0",
          profileLink: "https://unsplash.com/@windows",
          firstName: "Elena Mozhvilo",
          lastName: "",
          downloadLink: "https://unsplash.com/photos/NTEsfmfpaoI/download"),
      UnsplashImage(
          imageUrl:
              "https://images.unsplash.com/photo-1600629941230-3d92efee3dcd?ixlib=rb-1.2.1&q=80&fm=jpg&crop=entropy&cs=tinysrgb&w=1080&fit=max&ixid=eyJhcHBfaWQiOjE2NjUyMH0",
          imageUrlThumb:
              "https://images.unsplash.com/photo-1600629941230-3d92efee3dcd?ixlib=rb-1.2.1&q=80&fm=jpg&crop=entropy&cs=tinysrgb&w=200&fit=max&ixid=eyJhcHBfaWQiOjE2NjUyMH0",
          profileLink: "https://unsplash.com/@kkalerry",
          firstName: "Klara Kulikova",
          lastName: "",
          downloadLink: "https://unsplash.com/photos/fJxKscvr7Lo/download"),
      UnsplashImage(
          imageUrl:
              "https://images.unsplash.com/photo-1600534769525-67e3f925b45e?ixlib=rb-1.2.1&q=80&fm=jpg&crop=entropy&cs=tinysrgb&w=1080&fit=max&ixid=eyJhcHBfaWQiOjE2NjUyMH0",
          imageUrlThumb:
              "https://images.unsplash.com/photo-1600534769525-67e3f925b45e?ixlib=rb-1.2.1&q=80&fm=jpg&crop=entropy&cs=tinysrgb&w=200&fit=max&ixid=eyJhcHBfaWQiOjE2NjUyMH0",
          profileLink: "https://unsplash.com/@windows",
          firstName: "Ryunosuke Kikuno",
          lastName: "",
          downloadLink: "https://unsplash.com/photos/8dvE8QoXLwc/download"),
      UnsplashImage(
          imageUrl:
              "https://images.unsplash.com/photo-1600701603269-0664606b94eb?ixlib=rb-1.2.1&q=80&fm=jpg&crop=entropy&cs=tinysrgb&w=1080&fit=max&ixid=eyJhcHBfaWQiOjE2NjUyMH0",
          imageUrlThumb:
              "https://images.unsplash.com/photo-1600701603269-0664606b94eb?ixlib=rb-1.2.1&q=80&fm=jpg&crop=entropy&cs=tinysrgb&w=200&fit=max&ixid=eyJhcHBfaWQiOjE2NjUyMH0",
          profileLink: "https://unsplash.com/@hamzaports",
          firstName: "Hamza Oulad",
          lastName: "",
          downloadLink: "https://unsplash.com/photos/J7yfieVErXc/download"),
      UnsplashImage(
          imageUrl:
              "https://images.unsplash.com/photo-1600194990375-5d1d0b28781c?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjE2NjUyMH0",
          imageUrlThumb:
              "https://images.unsplash.com/photo-1600194990375-5d1d0b28781c?ixlib=rb-1.2.1&q=80&fm=jpg&crop=entropy&cs=tinysrgb&w=200&fit=max&ixid=eyJhcHBfaWQiOjE2NjUyMH0",
          profileLink: "https://unsplash.com/@windows",
          firstName: "Windows",
          lastName: "",
          downloadLink: "https://unsplash.com/photos/PnkX_rp53SE/download"),
      UnsplashImage(
          imageUrl:
              "https://images.unsplash.com/photo-1600506247590-4f2e2d1146fd?ixlib=rb-1.2.1&q=80&fm=jpg&crop=entropy&cs=tinysrgb&w=1080&fit=max&ixid=eyJhcHBfaWQiOjE2NjUyMH0",
          imageUrlThumb:
              "https://images.unsplash.com/photo-1600506247590-4f2e2d1146fd?ixlib=rb-1.2.1&q=80&fm=jpg&crop=entropy&cs=tinysrgb&w=200&fit=max&ixid=eyJhcHBfaWQiOjE2NjUyMH0",
          profileLink: "https://unsplash.com/@christianchen",
          firstName: "Christian Chen",
          lastName: "",
          downloadLink: "https://unsplash.com/photos/E-prxgqPJrQ/download"),
      UnsplashImage(
        imageUrl:
            "https://images.unsplash.com/photo-1600585154526-990dced4db0d?ixlib=rb-1.2.1&q=80&fm=jpg&crop=entropy&cs=tinysrgb&w=1080&fit=max&ixid=eyJhcHBfaWQiOjE2NjUyMH0",
        imageUrlThumb:
            "https://images.unsplash.com/photo-1600585154526-990dced4db0d?ixlib=rb-1.2.1&q=80&fm=jpg&crop=entropy&cs=tinysrgb&w=200&fit=max&ixid=eyJhcHBfaWQiOjE2NjUyMH0",
        profileLink: "https://unsplash.com/@rarchitecture_melbourne",
        firstName: "R ARCHITECTURE",
        lastName: "",
        downloadLink: "https://unsplash.com/photos/JvQ0Q5IkeMM/download",
      ),
      UnsplashImage(
          imageUrl:
              "https://images.unsplash.com/photo-1600442715978-d0268caa17f5?ixlib=rb-1.2.1&q=80&fm=jpg&crop=entropy&cs=tinysrgb&w=1080&fit=max&ixid=eyJhcHBfaWQiOjE2NjUyMH0",
          imageUrlThumb:
              "https://images.unsplash.com/photo-1600442715978-d0268caa17f5?ixlib=rb-1.2.1&q=80&fm=jpg&crop=entropy&cs=tinysrgb&w=200&fit=max&ixid=eyJhcHBfaWQiOjE2NjUyMH0",
          profileLink: "https://unsplash.com/@karsten116",
          firstName: "Karsten Winegeart",
          lastName: "",
          downloadLink: "https://unsplash.com/photos/a5HB3E0B01g/download"),
      UnsplashImage(
          imageUrl:
              "https://images.unsplash.com/photo-1600607658294-718c49de5818?ixlib=rb-1.2.1&q=80&fm=jpg&crop=entropy&cs=tinysrgb&w=1080&fit=max&ixid=eyJhcHBfaWQiOjE2NjUyMH0",
          imageUrlThumb:
              "https://images.unsplash.com/photo-1600607658294-718c49de5818?ixlib=rb-1.2.1&q=80&fm=jpg&crop=entropy&cs=tinysrgb&w=200&fit=max&ixid=eyJhcHBfaWQiOjE2NjUyMH0",
          profileLink: "https://unsplash.com/@windows",
          firstName: "Elena Mozhvilo",
          lastName: "",
          downloadLink: "https://unsplash.com/photos/NTEsfmfpaoI/download"),
      UnsplashImage(
          imageUrl:
              "https://images.unsplash.com/photo-1600629941230-3d92efee3dcd?ixlib=rb-1.2.1&q=80&fm=jpg&crop=entropy&cs=tinysrgb&w=1080&fit=max&ixid=eyJhcHBfaWQiOjE2NjUyMH0",
          imageUrlThumb:
              "https://images.unsplash.com/photo-1600629941230-3d92efee3dcd?ixlib=rb-1.2.1&q=80&fm=jpg&crop=entropy&cs=tinysrgb&w=200&fit=max&ixid=eyJhcHBfaWQiOjE2NjUyMH0",
          profileLink: "https://unsplash.com/@kkalerry",
          firstName: "Klara Kulikova",
          lastName: "",
          downloadLink: "https://unsplash.com/photos/fJxKscvr7Lo/download"),
      UnsplashImage(
          imageUrl:
              "https://images.unsplash.com/photo-1600534769525-67e3f925b45e?ixlib=rb-1.2.1&q=80&fm=jpg&crop=entropy&cs=tinysrgb&w=1080&fit=max&ixid=eyJhcHBfaWQiOjE2NjUyMH0",
          imageUrlThumb:
              "https://images.unsplash.com/photo-1600534769525-67e3f925b45e?ixlib=rb-1.2.1&q=80&fm=jpg&crop=entropy&cs=tinysrgb&w=200&fit=max&ixid=eyJhcHBfaWQiOjE2NjUyMH0",
          profileLink: "https://unsplash.com/@windows",
          firstName: "Ryunosuke Kikuno",
          lastName: "",
          downloadLink: "https://unsplash.com/photos/8dvE8QoXLwc/download"),
      UnsplashImage(
          imageUrl:
              "https://images.unsplash.com/photo-1600701603269-0664606b94eb?ixlib=rb-1.2.1&q=80&fm=jpg&crop=entropy&cs=tinysrgb&w=1080&fit=max&ixid=eyJhcHBfaWQiOjE2NjUyMH0",
          imageUrlThumb:
              "https://images.unsplash.com/photo-1600701603269-0664606b94eb?ixlib=rb-1.2.1&q=80&fm=jpg&crop=entropy&cs=tinysrgb&w=200&fit=max&ixid=eyJhcHBfaWQiOjE2NjUyMH0",
          profileLink: "https://unsplash.com/@hamzaports",
          firstName: "Hamza Oulad",
          lastName: "",
          downloadLink: "https://unsplash.com/photos/J7yfieVErXc/download"),
      UnsplashImage(
          imageUrl:
              "https://images.unsplash.com/photo-1600194990375-5d1d0b28781c?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjE2NjUyMH0",
          imageUrlThumb:
              "https://images.unsplash.com/photo-1600194990375-5d1d0b28781c?ixlib=rb-1.2.1&q=80&fm=jpg&crop=entropy&cs=tinysrgb&w=200&fit=max&ixid=eyJhcHBfaWQiOjE2NjUyMH0",
          profileLink: "https://unsplash.com/@windows",
          firstName: "Windows",
          lastName: "",
          downloadLink: "https://unsplash.com/photos/PnkX_rp53SE/download"),
      UnsplashImage(
          imageUrl:
              "https://images.unsplash.com/photo-1600506247590-4f2e2d1146fd?ixlib=rb-1.2.1&q=80&fm=jpg&crop=entropy&cs=tinysrgb&w=1080&fit=max&ixid=eyJhcHBfaWQiOjE2NjUyMH0",
          imageUrlThumb:
              "https://images.unsplash.com/photo-1600506247590-4f2e2d1146fd?ixlib=rb-1.2.1&q=80&fm=jpg&crop=entropy&cs=tinysrgb&w=200&fit=max&ixid=eyJhcHBfaWQiOjE2NjUyMH0",
          profileLink: "https://unsplash.com/@christianchen",
          firstName: "Christian Chen",
          lastName: "",
          downloadLink: "https://unsplash.com/photos/E-prxgqPJrQ/download"),
      UnsplashImage(
        imageUrl:
            "https://images.unsplash.com/photo-1600585154526-990dced4db0d?ixlib=rb-1.2.1&q=80&fm=jpg&crop=entropy&cs=tinysrgb&w=1080&fit=max&ixid=eyJhcHBfaWQiOjE2NjUyMH0",
        imageUrlThumb:
            "https://images.unsplash.com/photo-1600585154526-990dced4db0d?ixlib=rb-1.2.1&q=80&fm=jpg&crop=entropy&cs=tinysrgb&w=200&fit=max&ixid=eyJhcHBfaWQiOjE2NjUyMH0",
        profileLink: "https://unsplash.com/@rarchitecture_melbourne",
        firstName: "R ARCHITECTURE",
        lastName: "",
        downloadLink: "https://unsplash.com/photos/JvQ0Q5IkeMM/download",
      ),
      UnsplashImage(
          imageUrl:
              "https://images.unsplash.com/photo-1600442715978-d0268caa17f5?ixlib=rb-1.2.1&q=80&fm=jpg&crop=entropy&cs=tinysrgb&w=1080&fit=max&ixid=eyJhcHBfaWQiOjE2NjUyMH0",
          imageUrlThumb:
              "https://images.unsplash.com/photo-1600442715978-d0268caa17f5?ixlib=rb-1.2.1&q=80&fm=jpg&crop=entropy&cs=tinysrgb&w=200&fit=max&ixid=eyJhcHBfaWQiOjE2NjUyMH0",
          profileLink: "https://unsplash.com/@karsten116",
          firstName: "Karsten Winegeart",
          lastName: "",
          downloadLink: "https://unsplash.com/photos/a5HB3E0B01g/download"),
      UnsplashImage(
          imageUrl:
              "https://images.unsplash.com/photo-1600607658294-718c49de5818?ixlib=rb-1.2.1&q=80&fm=jpg&crop=entropy&cs=tinysrgb&w=1080&fit=max&ixid=eyJhcHBfaWQiOjE2NjUyMH0",
          imageUrlThumb:
              "https://images.unsplash.com/photo-1600607658294-718c49de5818?ixlib=rb-1.2.1&q=80&fm=jpg&crop=entropy&cs=tinysrgb&w=200&fit=max&ixid=eyJhcHBfaWQiOjE2NjUyMH0",
          profileLink: "https://unsplash.com/@windows",
          firstName: "Elena Mozhvilo",
          lastName: "",
          downloadLink: "https://unsplash.com/photos/NTEsfmfpaoI/download"),
      UnsplashImage(
          imageUrl:
              "https://images.unsplash.com/photo-1600629941230-3d92efee3dcd?ixlib=rb-1.2.1&q=80&fm=jpg&crop=entropy&cs=tinysrgb&w=1080&fit=max&ixid=eyJhcHBfaWQiOjE2NjUyMH0",
          imageUrlThumb:
              "https://images.unsplash.com/photo-1600629941230-3d92efee3dcd?ixlib=rb-1.2.1&q=80&fm=jpg&crop=entropy&cs=tinysrgb&w=200&fit=max&ixid=eyJhcHBfaWQiOjE2NjUyMH0",
          profileLink: "https://unsplash.com/@kkalerry",
          firstName: "Klara Kulikova",
          lastName: "",
          downloadLink: "https://unsplash.com/photos/fJxKscvr7Lo/download"),
      UnsplashImage(
          imageUrl:
              "https://images.unsplash.com/photo-1600534769525-67e3f925b45e?ixlib=rb-1.2.1&q=80&fm=jpg&crop=entropy&cs=tinysrgb&w=1080&fit=max&ixid=eyJhcHBfaWQiOjE2NjUyMH0",
          imageUrlThumb:
              "https://images.unsplash.com/photo-1600534769525-67e3f925b45e?ixlib=rb-1.2.1&q=80&fm=jpg&crop=entropy&cs=tinysrgb&w=200&fit=max&ixid=eyJhcHBfaWQiOjE2NjUyMH0",
          profileLink: "https://unsplash.com/@windows",
          firstName: "Ryunosuke Kikuno",
          lastName: "",
          downloadLink: "https://unsplash.com/photos/8dvE8QoXLwc/download"),
      UnsplashImage(
          imageUrl:
              "https://images.unsplash.com/photo-1600701603269-0664606b94eb?ixlib=rb-1.2.1&q=80&fm=jpg&crop=entropy&cs=tinysrgb&w=1080&fit=max&ixid=eyJhcHBfaWQiOjE2NjUyMH0",
          imageUrlThumb:
              "https://images.unsplash.com/photo-1600701603269-0664606b94eb?ixlib=rb-1.2.1&q=80&fm=jpg&crop=entropy&cs=tinysrgb&w=200&fit=max&ixid=eyJhcHBfaWQiOjE2NjUyMH0",
          profileLink: "https://unsplash.com/@hamzaports",
          firstName: "Hamza Oulad",
          lastName: "",
          downloadLink: "https://unsplash.com/photos/J7yfieVErXc/download"),
      UnsplashImage(
          imageUrl:
              "https://images.unsplash.com/photo-1600194990375-5d1d0b28781c?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjE2NjUyMH0",
          imageUrlThumb:
              "https://images.unsplash.com/photo-1600194990375-5d1d0b28781c?ixlib=rb-1.2.1&q=80&fm=jpg&crop=entropy&cs=tinysrgb&w=200&fit=max&ixid=eyJhcHBfaWQiOjE2NjUyMH0",
          profileLink: "https://unsplash.com/@windows",
          firstName: "Windows",
          lastName: "",
          downloadLink: "https://unsplash.com/photos/PnkX_rp53SE/download"),
      UnsplashImage(
          imageUrl:
              "https://images.unsplash.com/photo-1600506247590-4f2e2d1146fd?ixlib=rb-1.2.1&q=80&fm=jpg&crop=entropy&cs=tinysrgb&w=1080&fit=max&ixid=eyJhcHBfaWQiOjE2NjUyMH0",
          imageUrlThumb:
              "https://images.unsplash.com/photo-1600506247590-4f2e2d1146fd?ixlib=rb-1.2.1&q=80&fm=jpg&crop=entropy&cs=tinysrgb&w=200&fit=max&ixid=eyJhcHBfaWQiOjE2NjUyMH0",
          profileLink: "https://unsplash.com/@christianchen",
          firstName: "Christian Chen",
          lastName: "",
          downloadLink: "https://unsplash.com/photos/E-prxgqPJrQ/download"),
      UnsplashImage(
        imageUrl:
            "https://images.unsplash.com/photo-1600585154526-990dced4db0d?ixlib=rb-1.2.1&q=80&fm=jpg&crop=entropy&cs=tinysrgb&w=1080&fit=max&ixid=eyJhcHBfaWQiOjE2NjUyMH0",
        imageUrlThumb:
            "https://images.unsplash.com/photo-1600585154526-990dced4db0d?ixlib=rb-1.2.1&q=80&fm=jpg&crop=entropy&cs=tinysrgb&w=200&fit=max&ixid=eyJhcHBfaWQiOjE2NjUyMH0",
        profileLink: "https://unsplash.com/@rarchitecture_melbourne",
        firstName: "R ARCHITECTURE",
        lastName: "",
        downloadLink: "https://unsplash.com/photos/JvQ0Q5IkeMM/download",
      ),
      UnsplashImage(
          imageUrl:
              "https://images.unsplash.com/photo-1600442715978-d0268caa17f5?ixlib=rb-1.2.1&q=80&fm=jpg&crop=entropy&cs=tinysrgb&w=1080&fit=max&ixid=eyJhcHBfaWQiOjE2NjUyMH0",
          imageUrlThumb:
              "https://images.unsplash.com/photo-1600442715978-d0268caa17f5?ixlib=rb-1.2.1&q=80&fm=jpg&crop=entropy&cs=tinysrgb&w=200&fit=max&ixid=eyJhcHBfaWQiOjE2NjUyMH0",
          profileLink: "https://unsplash.com/@karsten116",
          firstName: "Karsten Winegeart",
          lastName: "",
          downloadLink: "https://unsplash.com/photos/a5HB3E0B01g/download"),
      UnsplashImage(
          imageUrl:
              "https://images.unsplash.com/photo-1600607658294-718c49de5818?ixlib=rb-1.2.1&q=80&fm=jpg&crop=entropy&cs=tinysrgb&w=1080&fit=max&ixid=eyJhcHBfaWQiOjE2NjUyMH0",
          imageUrlThumb:
              "https://images.unsplash.com/photo-1600607658294-718c49de5818?ixlib=rb-1.2.1&q=80&fm=jpg&crop=entropy&cs=tinysrgb&w=200&fit=max&ixid=eyJhcHBfaWQiOjE2NjUyMH0",
          profileLink: "https://unsplash.com/@windows",
          firstName: "Elena Mozhvilo",
          lastName: "",
          downloadLink: "https://unsplash.com/photos/NTEsfmfpaoI/download"),
      UnsplashImage(
          imageUrl:
              "https://images.unsplash.com/photo-1600629941230-3d92efee3dcd?ixlib=rb-1.2.1&q=80&fm=jpg&crop=entropy&cs=tinysrgb&w=1080&fit=max&ixid=eyJhcHBfaWQiOjE2NjUyMH0",
          imageUrlThumb:
              "https://images.unsplash.com/photo-1600629941230-3d92efee3dcd?ixlib=rb-1.2.1&q=80&fm=jpg&crop=entropy&cs=tinysrgb&w=200&fit=max&ixid=eyJhcHBfaWQiOjE2NjUyMH0",
          profileLink: "https://unsplash.com/@kkalerry",
          firstName: "Klara Kulikova",
          lastName: "",
          downloadLink: "https://unsplash.com/photos/fJxKscvr7Lo/download"),
    ];
    return images;
  }

  @override
  Future<Either<Failure, List<DayAffirmation>>> get todayAffirmations async {
    Either<Failure, List<DayAffirmation>> result = Left(ServerFailure());
    DateTime now = DateTime.now();
    print("todayAffirmations" + " " + "1");
    List<DayAffirmation> resultAffirmations = [];
    List<DayAffirmation> nativeAffirmations = [];
    List<AffirmationModel> remoteAffirmations = [];
    List<AffirmationModel> savedAffirmations = [];
    List<DayAffirmation> favAffirmationsConverted = [];
    List<DayAffirmation> remoteAffirmationsConverted = [];
    List<DayAffirmation> savedAffirmationsConverted = [];

    if ((await sharedPref.lastUpdatedAffirmation)
        .isAfter(DateTime(now.year, now.month, now.day, 0, 00))) {
      try {
        print("todayAffirmations" + " " + "2");
        nativeAffirmations = await nativeDataSource.dayAffirmations;
        return Right(nativeAffirmations);
      } on Exception {
        print("todayAffirmations" + " " + "3");
        result = Left(NativeDatabaseException());
      }
    }
    var categoryToUrl = new Map();
    var userUrlMap = new Map();
    int networkCount = 0;
    List<String> unusedUrl = [];
    Either<Failure, List<DisplayThumbnail>> thumbnailUrls = await thumbnails;
    Either<Failure, List<UnsplashImage>> unsplashImages = await networkImages;
    List<UnsplashImage> remoteImages = getCacheUnsplashImages();
    thumbnailUrls.fold((l) {
      return (Left(l));
    }, (r) {
      r.forEach((element) {
        print(element.thumbnailUrl);
        unusedUrl.add(element.category);
        categoryToUrl[element.category] = element.thumbnailUrl;
        userUrlMap[element.category] = 1;
      });
    });
    unsplashImages.fold((l) {
      return (Left(l));
    }, (r) {
      if (r.length > 0) remoteImages = r;
    });

    try {
      print("todayAffirmations" + " " + "4");
      List<AffirmationModel> favAffirmations =
          await nativeDataSource.favAffirmations;
      print("todayAffirmations" + " " + "5");
      if (favAffirmations != null && favAffirmations.length > 0) {
        favAffirmations.forEach((element) {
          int wordLen = element.text.split(" ").length;
          int waitTime = getWaitTime(wordLen);
          DayAffirmation thisAffirmation = DayAffirmation(
              cloudId: element.id,
              text: element.text,
              isFav: true,
              read: false,
              waitSeconds: waitTime,
              thumbnailUrl: categoryToUrl[element.category],
              category: element.category,
              imageUrl: remoteImages[networkCount].imageUrl,
              sImageUrl: remoteImages[networkCount].imageUrlThumb,
              photoGrapherName: remoteImages[networkCount].firstName,
              downloadLink: remoteImages[networkCount].downloadLink,
              profileLink: remoteImages[networkCount].profileLink,
              lastSeen: now);
          networkCount++;
          favAffirmationsConverted.add(thisAffirmation);
          if (resultAffirmations
                  .where(
                      (element) => element.cloudId == thisAffirmation.cloudId)
                  .length ==
              0) {
            resultAffirmations.add(thisAffirmation);
          }
        });
      }
      if (await networkInfo.isConnected) {
        remoteAffirmations = await remoteDataSource.affirmations;
        print("todayAffirmations" +
            " length : " +
            remoteAffirmations.length.toString());
        print("todayAffirmations" + " " + "6");

        if (remoteAffirmations != null) {
          remoteAffirmations.forEach((element) {
            unusedUrl.remove(element.category);
          });
          print(unusedUrl);

          remoteAffirmations.forEach((element) {
            print(element.category);
            print(userUrlMap[element.category]);
            int wordLen = element.text.split(" ").length;
            int waitTime = getWaitTime(wordLen);
            DayAffirmation thisAffirmation = DayAffirmation(
                cloudId: element.id,
                text: element.text,
                thumbnailUrl: categoryToUrl[element.category],
                isFav: false,
                waitSeconds: waitTime,
                read: false,
                category: element.category,
                imageUrl: remoteImages[networkCount].imageUrl,
                sImageUrl: remoteImages[networkCount].imageUrlThumb,
                photoGrapherName: remoteImages[networkCount].firstName,
                downloadLink: remoteImages[networkCount].downloadLink,
                profileLink: remoteImages[networkCount].profileLink,
                lastSeen: now);
            networkCount++;
            userUrlMap[element.category] = 0;
            remoteAffirmationsConverted.add(thisAffirmation);
            if (resultAffirmations
                    .where(
                        (element) => element.cloudId == thisAffirmation.cloudId)
                    .length ==
                0) {
              resultAffirmations.add(thisAffirmation);
            }
          });
        }
        nativeDataSource.addAffirmationsToSaved(remoteAffirmations);
        sharedPref.updateAffirmation(now);
        print("todayAffirmations" + " " + "7");
      } else {
        savedAffirmations = await nativeDataSource.savedAffirmations;
        print("todayAffirmations" + " " + "8");
        if (savedAffirmations != null) {
          savedAffirmations.forEach((element) {
            unusedUrl.remove(element.category);
          });
          savedAffirmations.forEach((element) {
            int wordLen = element.text.split(" ").length;
            int waitTime = getWaitTime(wordLen);
            DayAffirmation thisAffirmation = DayAffirmation(
                cloudId: element.id,
                waitSeconds: waitTime,
                text: element.text,
                isFav: false,
                read: false,
                thumbnailUrl: categoryToUrl[element.category],
                category: element.category,
                imageUrl: remoteImages[networkCount].imageUrl,
                sImageUrl: remoteImages[networkCount].imageUrlThumb,
                photoGrapherName: remoteImages[networkCount].firstName,
                downloadLink: remoteImages[networkCount].downloadLink,
                profileLink: remoteImages[networkCount].profileLink,
                lastSeen: now);
            networkCount++;
            userUrlMap[element.category] = 0;
            savedAffirmationsConverted.add(thisAffirmation);

            if (resultAffirmations
                    .where(
                        (element) => element.cloudId == thisAffirmation.cloudId)
                    .length ==
                0) {
              resultAffirmations.add(thisAffirmation);
            }
          });
        }
      }
      result = Right(resultAffirmations);
      await nativeDataSource.deleteDayAffirmationTable();
      nativeDataSource.addAffirmationsToCurrentDay(resultAffirmations);
      print("todayAffirmations" + " " + "9");
    } on Exception {
      print("todayAffirmations" + " " + "10");
      result = Left(NativeDatabaseException());
    }
    return result;
  }

  int getWaitTime(int wordLen) {
    int avgTime = (wordLen / 2.3).floor();
    if (avgTime < 8)
      return 8;
    else
      return avgTime;
  }

  @override
  Future<Either<Failure, void>> addToFav(AffirmationModel affirmation) async {
    Failure failure;
    try {
      bool doFavExist = await nativeDataSource.doFavExists(affirmation);
      if (!doFavExist) {
        nativeDataSource.addToFav(affirmation);
        remoteDataSource.addAffirmationsToFav(affirmation);
      }
      return (Right(null));
    } on Exception {
      return Left(NativeDatabaseException());
    }
  }

  @override
  Future<Either<Failure, void>> removeFromFav(
      AffirmationModel affirmation) async {
    Failure failure;
    try {
      bool doFavExist = await nativeDataSource.doFavExists(affirmation);
      if (doFavExist) {
        nativeDataSource.deleteFromFav(affirmation);
        remoteDataSource.deleteAffirmationsFromFav(affirmation);
      }
      return (Right(null));
    } on Exception {
      return Left(NativeDatabaseException());
    }
  }

  @override
  Future<Either<Failure, void>> updateCurrentAffirmation(
      DayAffirmation affirmation) async {
    Failure failure;
    try {
      nativeDataSource.updateDayAffirmation(affirmation);

      return (Right(null));
    } on Exception {
      return Left(NativeDatabaseException());
    }
  }

  @override
  // TODO: implement blogs
  Future<Either<Failure, List<BlogModel>>> get blogs =>
      throw UnimplementedError();

  @override
  Future<Either<Failure, BlogModel>> getBlogFromId(int id) async {
    Failure failure;
    if (await networkInfo.isConnected) {
      try {
        BlogModel blog = await remoteDataSource.getBlogFromId(id);

        return (Right(blog));
      } on Exception {
        return Left(ServerFailure());
      }
    } else
      return Left(NetworkFailure());
  }

  @override
  Future<Either<Failure, List<BlogTextboxModel>>> getTextBoxesOfBlog(
      int blogId) async {
    Failure failure;
    if (await networkInfo.isConnected) {
      try {
        List<BlogTextboxModel> blog =
            await remoteDataSource.getTextBoxes(blogId);

        return (Right(blog));
      } on Exception {
        return Left(ServerFailure());
      }
    } else
      return Left(NetworkFailure());
  }

  @override
  Future<Either<Failure, List<TaggedRecipe>>> getTaggedRecipes(
      int count) async {
    Failure failure;
    Either<Failure, List<TaggedRecipe>> result = Left(NetworkFailure());
    DateTime now = DateTime.now();

    if ((await sharedPref.lastUpdatedRecipes)
        .isAfter(DateTime(now.year, now.month, now.day, 0, 00))) {
      try {

        return Right(await nativeDataSource.taggedRecipes);
      } on Exception {
        result = Left(NativeDatabaseException());
      }
    }
    if (await networkInfo.isConnected) {
      try {
        List<TaggedRecipe> cloudData =
            await remoteDataSource.getTaggedRecipes(count);
        if (cloudData != null && cloudData.length > 0) {
          result = Right(cloudData);

          nativeDataSource.deleteRecipeTable();
          nativeDataSource.addTaggedRecipes(cloudData);
        } else {
          try {
            List<TaggedRecipe> nativeData =
                await nativeDataSource.taggedRecipes;
                
            if (nativeData != null) {
              result = Right(nativeData);
            } else
              result = Left(ServerFailure());
          } on Exception {
            result = Left(NativeDatabaseException());
          }
        }
      } on Exception {
        result = Left(ServerFailure());
      }

      sharedPref.updateRecipes(now);
    } else {
      try {
        List<TaggedRecipe> nativeData = await nativeDataSource.taggedRecipes;
        if (nativeData != null) {
          result = Right(nativeData);
        } else
          result = Left(ServerFailure());
      } on Exception {
        result = Left(NativeDatabaseException());
      }
    }
    return result;
  }

  @override
  Future<Either<Failure, TaggedRecipe>> getTaggedRecipesOfId(int id) async {
    Failure failure;
    if (await networkInfo.isConnected) {
      try {
        TaggedRecipe recipe = await remoteDataSource.getTaggedRecipesOfId(id);

        return (Right(recipe));
      } on Exception {
        return Left(ServerFailure());
      }
    } else
      return Left(NetworkFailure());
  }

  @override
  Future<Either<Failure, TransformationModel>> getTransformationStory() async {
    Failure failure;
    Either<Failure, TransformationModel> result = Left(NetworkFailure());
    DateTime now = DateTime.now();
    if ((await sharedPref.lastUpdatedTranformationStory)
        .isAfter(DateTime(now.year, now.month, now.day, 0, 00))) {
      try {
        return Right(await nativeDataSource.transformation);
      } on Exception {
        result = Left(NativeDatabaseException());
      }
    }
    if (await networkInfo.isConnected) {
      try {
        TransformationModel cloudData =
            await remoteDataSource.getTransformationStory();
        if (cloudData != null) {
          result = Right(cloudData);
          nativeDataSource.deleteTransformationTable();
          nativeDataSource.addTransformation(cloudData);
        } else {
          try {
            TransformationModel nativeData =
                await nativeDataSource.transformation;
            if (nativeData != null) {
              result = Right(nativeData);
            } else
              result = Left(ServerFailure());
          } on Exception {
            result = Left(NativeDatabaseException());
          }
        }
      } on Exception {
        result = Left(ServerFailure());
      }

      sharedPref.updateTransformationStory(now);
    } else {
      try {
        TransformationModel nativeData = await nativeDataSource.transformation;
        if (nativeData != null) {
          result = Right(nativeData);
        } else
          result = Left(ServerFailure());
      } on Exception {
        result = Left(NativeDatabaseException());
      }
    }
    return result;
  }

  @override
  Future<Either<Failure, VideoRecipe>> getVideoRecipe() async {
    Failure failure;
    if (await networkInfo.isConnected) {
      try {
        VideoRecipe videoRecipe = await remoteDataSource.getVideoRecipe();

        return (Right(videoRecipe));
      } on Exception {
        return Left(ServerFailure());
      }
    } else
      return Left(NetworkFailure());
  }

  @override
  Future<Either<Failure, RecipeModel>> getRecipeById(int id) async {
    if (await networkInfo.isConnected) {
      try {
        RecipeModel recipe = await remoteDataSource.getRecipeById(id);

        return (Right(recipe));
      } on Exception {
        return Left(ServerFailure());
      }
    } else
      return Left(NetworkFailure());
  }

  @override
  Future<Either<Failure, List<BlogModel>>> getBlogs(count) async {
    if (await networkInfo.isConnected) {
      try {
        List<BlogModel> recipe = await remoteDataSource.getBlog(count);

        return (Right(recipe));
      } on Exception {
        return Left(ServerFailure());
      }
    } else
      return Left(NetworkFailure());
  }








  @override
  Future<Either<Failure, int>> addPost(PostModel post) async {
    if (await networkInfo.isConnected) {
      try {
        return (Right(await remoteDataSource.addPost(post)));
      } on Exception {
        return Left(ServerFailure());
      }
    } else
      return Left(NetworkFailure());
  }

  @override
  Future<Either<Failure, ChallengeModel>> getChallengeOfTheDay() async {
    Failure failure;

    Either<Failure, ChallengeModel> result = Left(NetworkFailure());
    DateTime now = DateTime.now();
    if ((await sharedPref.lastUpdatedChallenge)
        .isAfter(DateTime(now.year, now.month, now.day, 0, 00))) {
      try {
        var thisChallenge = await nativeDataSource.challenge;
        if (thisChallenge.id != -1) return Right(thisChallenge);
      } on Exception {
        result = Left(NativeDatabaseException());
      }
    }
    if (await networkInfo.isConnected) {
      try {
        ChallengeModel cloudData =
            await remoteDataSource.getChallengeOfTheDay();
        if (cloudData != null) {
          result = Right(cloudData);
          nativeDataSource.deleteChallengeTable();
          nativeDataSource.addChallenge(cloudData);
        } else {
          try {
            ChallengeModel nativeData = await nativeDataSource.challenge;
            if (nativeData != null) {
              result = Right(nativeData);
            } else
              result = Left(ServerFailure());
          } on Exception {
            result = Left(NativeDatabaseException());
          }
        }
      } on Exception {
        result = Left(ServerFailure());
      }

      sharedPref.updateChallenge(now);
    } else {
      try {
        ChallengeModel nativeData = await nativeDataSource.challenge;
        if (nativeData != null) {
          result = Right(nativeData);
        } else
          result = Left(ServerFailure());
      } on Exception {
        result = Left(NativeDatabaseException());
      }
    }
    return result;
  }

  @override
  Future<Either<Failure, FeedPostEntity>> getFeed(
      int limit, DocumentSnapshot<Object> lastDoc) async {
    if (await networkInfo.isConnected) {
      try {
        return (Right(await remoteDataSource.getFeed(limit, lastDoc)));
      } on Exception {
        return Left(ServerFailure());
      }
    } else
      return Left(NetworkFailure());
  }

  @override
  Future<Either<Failure, PepTalkModel>> getMotivationOfTheDay() async {
    Failure failure;
    Either<Failure, PepTalkModel> result = Left(NetworkFailure());
    DateTime now = DateTime.now();
    if ((await sharedPref.lastUpdatedPepTalk)
        .isAfter(DateTime(now.year, now.month, now.day, 0, 00))) {
      try {
        return Right(await nativeDataSource.pepTalk);
      } on Exception {
        result = Left(NativeDatabaseException());
      }
    }
    if (await networkInfo.isConnected) {
      try {
        PepTalkModel cloudData = await remoteDataSource.getMotivationOfTheDay();
        if (cloudData != null) {
          result = Right(cloudData);
          nativeDataSource.deleteTalkTable();
          nativeDataSource.addPepTalk(cloudData);
        } else {
          try {
            PepTalkModel nativeData = await nativeDataSource.pepTalk;
            if (nativeData != null) {
              result = Right(nativeData);
            } else
              result = Left(ServerFailure());
          } on Exception {
            result = Left(NativeDatabaseException());
          }
        }
      } on Exception {
        result = Left(ServerFailure());
      }

      sharedPref.updateChallenge(now);
    } else {
      try {
        PepTalkModel nativeData = await nativeDataSource.pepTalk;
        if (nativeData != null) {
          result = Right(nativeData);
        } else
          result = Left(ServerFailure());
      } on Exception {
        result = Left(NativeDatabaseException());
      }
    }
    return result;
  }


}

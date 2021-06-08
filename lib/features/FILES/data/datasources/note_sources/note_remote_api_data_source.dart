import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:sorted/core/global/constants/constants.dart';
import 'package:sorted/features/HOME/domain/entities/unsplash_image.dart';

abstract class NoteRemoteApi {
  Future<List<UnsplashImage>> fetchWallpapers(String search);
}

const INSPIRATION_PHOTO_ENDPOINT =
    'https://api.unsplash.com/photos/random?count=30&query=wallpaper&orientation=portrait&';

class NoteRemoteApiDataSourceImpl implements NoteRemoteApi {
  var _parsedResponse;

  NoteRemoteApiDataSourceImpl();

  @override
  Future<List<UnsplashImage>> fetchWallpapers(String search) {
    // TODO: implement fetchWallpapers
    throw UnimplementedError();
  }

}

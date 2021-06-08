import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:sorted/core/global/constants/constants.dart';
import 'package:sorted/features/HOME/domain/entities/unsplash_image.dart';

abstract class GoalRemoteApi {
  Future<List<UnsplashImage>> fetchWallpapers(String search);
}

const INSPIRATION_PHOTO_ENDPOINT =
    'https://api.unsplash.com/photos/random?count=30&query=wallpaper&orientation=portrait&';

class GoalRemoteApiDataSourceImpl implements GoalRemoteApi {
  var _parsedResponse;

  GoalRemoteApiDataSourceImpl();
  Future<List<UnsplashImage>> fetchWallpapers(String search) async {
    List<UnsplashImage> images = [];
    print("HomeRemoteApiDataSourceImpl #######");

    http.Response response = await http.get(Uri.parse(INSPIRATION_PHOTO_ENDPOINT+
        'client_id=${UnsplashApi.kAccessKey}'));
    print(response.body);
    if (response.statusCode == 200) {
      print("response successful #######");
      print(response.body);

      _parsedResponse = json.decode(response.body);
      Iterable i = _parsedResponse;
      images = i.map((model) => UnsplashImage.fromJson(model)).toList();
     
    }
    return images;
  }
}

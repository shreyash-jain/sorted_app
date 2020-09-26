import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:sorted/core/global/constants/constants.dart';
import 'package:sorted/features/HOME/domain/entities/unsplash_image.dart';

abstract class HomeRemoteApi {
  Future<List<UnsplashImage>> fetchWallpapers();
}

const LOGGED_IN_STATE_TAG = 'LoggedIn';
const SIGN_IN_ID_TAG = 'google_name';
const LAST_UPDATED_INSPIRATIONS_TAG = 'inspiration_last_updated';
const LAST_UPDATED_AFFIRMATIONS_TAG = 'affirmations_last_updated';
const LAST_UPDATED_THUMBNAILS_TAG = 'thumbnail_last_updated';
const LAST_UPDATED_PLACEHOLDER_TAG = 'placeholder_last_updated';
const CURRENT_DEVICE_NAME_ID_TAG = 'device_name';
const INSPIRATION_PHOTO_ENDPOINT =
    'https://api.unsplash.com/photos/random?count=30&query=wallpaper&orientation=portrait&';

class HomeRemoteApiDataSourceImpl implements HomeRemoteApi {
  var _parsedResponse;

  HomeRemoteApiDataSourceImpl();
  Future<List<UnsplashImage>> fetchWallpapers() async {
    List<UnsplashImage> images = [];
    print("HomeRemoteApiDataSourceImpl #######");

    http.Response response = await http.get(INSPIRATION_PHOTO_ENDPOINT+
        'client_id=${UnsplashApi.kAccessKey}');
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

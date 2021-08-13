import 'dart:io';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:device_info/device_info.dart';
import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

import 'package:googleapis/calendar/v3.dart';
import 'package:meta/meta.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sorted/core/authentication/GoogleHttpClient.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sorted/core/error/failures.dart';
import 'package:sorted/core/global/database/cacheDataClass.dart';
import 'package:sorted/core/global/entities/day_at_sortit.dart';
import 'package:sorted/core/global/injection_container.dart';

import 'package:sorted/core/global/models/user_details.dart';
import 'package:sorted/core/services/notifications/entitites/success_message.dart';

abstract class NotificationRemoteDataSource {
   Future<Either<Failure, SuccessOTPResponse>> sendOTP(String mobileNumber);
}

class NotificationCloudDataSourceImpl implements NotificationRemoteDataSource {
  final FirebaseFirestore cloudDb;
  final FirebaseAuth auth;
  final Dio dio;

  NotificationCloudDataSourceImpl({
    this.dio,
    @required this.cloudDb,
    @required this.auth,
  });


  String optEndpoint =
      "https://us-central1-sorted-98c02.cloudfunctions.net/serverutility/sendOtp";





      

  @override
  Future<Either<Failure, SuccessOTPResponse>> sendOTP(
      String mobileNumber) async {
    try {
      var token = await auth.currentUser.getIdToken();

      dio.options.headers["Authorization"] = "Bearer $token";

      var response = await dio.post(optEndpoint,
          data: {'phoneNo': mobileNumber},
          options: Options(
            headers: {"Bearer": "$token"},
          ));

      return (Right(SuccessOTPResponse.fromJson(response.data)));
    } on DioError catch (e) {
      if (e.response.statusCode == 400) return Left(InvalidPhoneNuber());
      return Left(ServerFailure());
    }
  }

  Future<void> saveDeviceToken() async {
    print("token " + saveDeviceToken.toString());
    User user = auth.currentUser;

    var result = await auth.currentUser.getIdToken();

    final FirebaseMessaging _fcm = FirebaseMessaging.instance;

    // Get the token for this device
    String fcmToken = await _fcm.getToken();
    print("token " + fcmToken.toString());

    // Save it to Firestore
    if (fcmToken != null) {
      var tokens = cloudDb
          .collection('users')
          .doc(user.uid)
          .collection("user_data")
          .doc("data")
          .collection('private')
          .doc('token');

      tokens.set({
        'token': FieldValue.arrayUnion([fcmToken]),
        'createdAt': FieldValue.serverTimestamp(), // optional
      }, SetOptions(merge: true));
    }
  }
}

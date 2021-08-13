import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:sorted/core/error/failures.dart';
import 'package:sorted/core/global/entities/day_at_sortit.dart';
import 'package:sorted/core/global/injection_container.dart';
import 'package:sorted/core/authentication/auth_cloud_data_source.dart';
import 'package:sorted/core/error/exceptions.dart';
import 'package:rxdart/rxdart.dart';
import 'package:sorted/core/global/models/auth_user.dart';
import 'dart:async';
import 'package:meta/meta.dart';
import 'package:sorted/core/network/network_info.dart';
import 'package:sorted/core/services/notifications/entitites/success_message.dart';
import 'package:sorted/core/services/notifications/notification_remote_data_source.dart';

class NotificationRepository {
  // Dependencies

  NotificationRepository(
      {this.networkInfo,
      FirebaseAuth firebaseAuth,
      NotificationRemoteDataSource notificationDataSource})
      : _firebaseAuth = firebaseAuth ?? sl.get<FirebaseAuth>(),
        _remoteDataSource = notificationDataSource;

  final FirebaseAuth _firebaseAuth;
  final NotificationRemoteDataSource _remoteDataSource;
  final NetworkInfo networkInfo;
  // Shared State for Widgets
  //Observable<FirebaseUser> user;

  Stream<String> url;

 @override
  Future<Either<Failure, SuccessOTPResponse>> sendOTP(
      String mobileNumber) async {
    Failure failure;
    if (await networkInfo.isConnected) {
      try {
        var result = await _remoteDataSource.sendOTP(mobileNumber);

        return (result);
      } on Exception {
        return Left(ServerFailure());
      }
    } else
      return Left(NetworkFailure());
  }

 
 
}

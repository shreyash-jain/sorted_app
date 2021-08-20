import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sorted/core/authentication/bloc/authentication_bloc.dart';
import 'package:auto_route/auto_route.dart';
import 'package:sorted/core/authentication/remote_auth_repository.dart';
import 'package:sorted/core/global/blocs/deeplink_bloc/deeplink_bloc.dart';
import 'package:sorted/core/global/injection_container.dart';
import 'package:sorted/core/routes/router.gr.dart';

class SplashPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    print("splash");
    return Scaffold(
      body: Center(
          child: Container(
        width: 70,
        height: 70,
        child: BlocListener<AuthenticationBloc, AuthenticationState>(
          listener: (context, state) async {
            print(state);
            switch (state.status) {
              case AuthenticationStatus.authenticated:
                print("authenticated");
                final FirebaseMessaging _fcm = FirebaseMessaging.instance;

                // Get the token for this device
                String fcmToken = await _fcm.getToken();
                sl<AuthenticationRepository>().saveDeviceToken(fcmToken);
                context.router.removeLast();
                FirebaseMessaging.instance.onTokenRefresh.listen((token) {
                  sl<AuthenticationRepository>().saveDeviceToken(token);
                });

                context.router.push(
                  MyStartRoute(title: "start Page"),
                );

                break;
              case AuthenticationStatus.unauthenticated:
                // todo: send to onboarding page
                print("un-authenticated");

                context.router.removeLast();
                context.router.push(
                  OnboardRoute(title: "start Page"),
                );

                // _navigator.pushAndRemoveUntil<void>(
                //   LoginPage.route(),
                //   (route) => false,
                // );
                print("send to onboarding");
                break;
              default:
                break;
            }
          },
          child: new FlareActor("assets/animations/logo.flr",
              alignment: Alignment.center,
              fit: BoxFit.contain,
              animation: "Untitled"),
        ),
      )),
    );
  }
}

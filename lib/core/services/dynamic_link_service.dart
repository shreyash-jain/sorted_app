import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sorted/features/CONNECT/presentation/pages/class_list.dart';

class DynamicLinkService {
  Future handleDynamicLinks() async {
    // Startup from dynamic link logic
    // get initial dynamic link the app is launching from the link
    final PendingDynamicLinkData data =
        await FirebaseDynamicLinks.instance.getInitialLink();
    _handleDeepLink(data);

    // into foregroung from dynamic link logic
    FirebaseDynamicLinks.instance.onLink(
        onSuccess: (PendingDynamicLinkData dynamicLinkData) async {
      _handleDeepLink(dynamicLinkData);
    }, onError: (OnLinkErrorException e) async {
      print('Dynamic Link Failed:  ${e.message}');
    });
  }

  void _handleDeepLink(PendingDynamicLinkData data) {
    final Uri deeplink = data?.link;
    if (deeplink != null) {
      print('handleDeepLink | deeplink: $deeplink');

      var isClass = deeplink.pathSegments.contains('class');
      if (isClass) {
        var classId = deeplink.queryParameters['id'];
        if (classId != null) {
          print("handleDeepLink " + classId);
          Get.to(() => ClassListPage(classId: classId));
        }
      }
    }
  }
}

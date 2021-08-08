import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sorted/core/global/blocs/deeplink_bloc/deeplink_bloc.dart';
import 'package:sorted/core/global/database/cache_deep_link.dart';
import 'package:sorted/core/global/injection_container.dart';
import 'package:sorted/core/global/models/deep_link_data/deep_link_data.dart';
import 'package:sorted/features/CONNECT/data/models/package_model.dart';
import 'package:sorted/features/CONNECT/presentation/pages/request_pages/class_list.dart';
import 'package:sorted/features/HOME/data/models/class_model.dart';

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
      var isConsultation = deeplink.pathSegments.contains('consultation');
      var isPackage = deeplink.pathSegments.contains('package');

      if (isClass) {
        print("Deeplink data added");
        // sl<CacheDeepLinkDataClass>()
        //     .setDeepLinkType(DeepLinkType(1, deeplink.toString()));
        var classId = deeplink.queryParameters['id'];
        if (classId != null) {
          print("handleDeepLink " + classId);
          print("set data from deep link   -   >   none");

          sl<DeeplinkBloc>().add(AddDeeplinkData(
              DeepLinkType(1, deeplink.toString()),
              classEnrollData: ClassEnrollData(classId, ClassModel())));
          // sl<CacheDeepLinkDataClass>()
          //     .setClassEnrollData(ClassEnrollData(classId, ClassModel()));
        }
      } else if (isConsultation) {
        var trainerId = deeplink.queryParameters['id'];
        sl<DeeplinkBloc>().add(AddDeeplinkData(
            DeepLinkType(2, deeplink.toString()),
            consultationEnrollData: ConsultationEnrollData(trainerId, [])));
      } else if (isPackage) {
        var packageId = deeplink.queryParameters['id'];
        sl<DeeplinkBloc>().add(AddDeeplinkData(
            DeepLinkType(3, deeplink.toString()),
            packageEnrollData:
                PackageEnrollData(packageId, ConsultationPackageModel())));
      }
    }
  }
}

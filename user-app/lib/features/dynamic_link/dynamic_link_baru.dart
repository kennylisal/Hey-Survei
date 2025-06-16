//https://jideije-emeka.medium.com/flutter-how-to-create-dynamic-link-and-route-users-to-a-specific-page-in-your-app-8fd834ec1aa8
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:survei_aplikasi/features/app/router/router_constant.dart';

class DynamicLinkBaru {
  FirebaseDynamicLinks dynamicLinks = FirebaseDynamicLinks.instance;

  // handleLink(PendingDynamicLinkData dynamicLinkData, BuildContext context) {
  //   final Uri deepLink = dynamicLinkData.link;
  //   print(deepLink.queryParameters);
  //   var isReferral = deepLink.pathSegments.contains('idSurvei');
  //   print("ini isreferal $isReferral");
  //   if (isReferral) {
  //     print("masuk is referal");
  //     if (deepLink.toString().isNotEmpty) {
  //       try {
  //         Map sharedList = deepLink.queryParameters;

  //         String idSurvei = sharedList["idSurvei"];
  //         idSurvei.replaceAll('+', ' ');
  //         context.pushNamed(RouteConstant.detailDynamic,
  //             pathParameters: {'idSurvei': idSurvei});
  //       } catch (e) {
  //         debugPrint(e.toString());
  //         context.pushNamed(RouteConstant.auth);
  //       }
  //     }
  //   } else {
  //     context.pushNamed(RouteConstant.auth);
  //   }
  // }

  handleLink(PendingDynamicLinkData dynamicLinkData, BuildContext context) {
    try {
      final Uri deepLink = dynamicLinkData.link;
      if (deepLink.toString().isNotEmpty) {
        try {
          Map sharedList = deepLink.queryParameters;
          String idSurvei = sharedList["idSurvei"];
          context.pushNamed(RouteConstant.detailDynamic,
              pathParameters: {'idSurvei': idSurvei});
        } catch (e) {
          debugPrint(e.toString());
          context.goNamed(RouteConstant.auth);
        }
      } else {
        context.goNamed(RouteConstant.auth);
      }
    } catch (e) {
      print(e);
    }
  }

  void initDynamicLinks(BuildContext context) async {
    dynamicLinks.onLink.listen((dynamicLinkData) {
      print("masuk 1============================");
      handleLink(dynamicLinkData, context);
      // print("masuk 1============================");
      // final Uri deepLink = dynamicLinkData.link;
      // print(deepLink);
      // var isReferral = deepLink.pathSegments.contains('idSurvei');
      // // Map sharedList = deepLink.queryParameters;
      // // print(sharedList);
      // print("ini isReferral $isReferral");
      // if (isReferral) {
      //   if (deepLink.toString().isNotEmpty) {
      //     try {
      //       Map sharedList = deepLink.queryParameters;
      //       String idSurvei = sharedList["idSurvei"];
      //       print(idSurvei);
      //       // context.pushNamed(RouteConstant.faq);
      //       // context.pushNamed(RouteConstant.percobaan,
      //       //     pathParameters: {'kata': ""});
      //       // AppRouter().router.pushNamed(RouteConstant.faq);
      //     } catch (e) {
      //       debugPrint(e.toString());
      //     }
      //   }
      // } else {
      //   context.pushNamed(RouteConstant.home);
      // }
    });

    await dynamicLinks.getInitialLink().then((data) {
      print("masuk 2============================");
      if (data != null) {
        handleLink(data, context);
      }
      // context.pushNamed(RouteConstant.home);
      // print(data);
      // final Uri? deepLink = data?.link;
      // var isReferral = deepLink?.pathSegments.contains('idSurvei');
      // print("isreferal => $isReferral");
      // if (isReferral == true && deepLink != null) {
      //   if (deepLink.toString().isNotEmpty) {
      //     print("masuk ifXXXXXXXXXXXXXXXXXXXXXXXXX");
      //     try {
      //       Map sharedList = deepLink.queryParameters;
      //       String idSurvei = sharedList["idSurvei"];
      //       print(idSurvei);
      //       // context.pushNamed(RouteConstant.faq);
      //       // context.pushNamed(RouteConstant.faq);
      //       // context.pushNamed(RouteConstant.percobaan,
      //       //     pathParameters: {'kata': ""});
      //     } catch (e) {
      //       debugPrint(e.toString());
      //     }
      //   } else {
      //     print("masuk else EEEEEEEEEEEEEEEEEEEEE");
      //     context.pushNamed(RouteConstant.home);
      //   }
      // }
    });
  }
}


  // Future<String> createDynamicLink(
  //     {required bool shortLink, required String code}) async {
  //   final DynamicLinkParameters parameters = DynamicLinkParameters(
  //       link: Uri.parse('https://YOUR_URL_PREFIX_HERE/ref?id=$code'),
  //       uriPrefix: 'https://YOUR_URL_PREFIX_HERE',
  //       androidParameters: const AndroidParameters(
  //         packageName: 'YOUR_ANDROID_PACKAGE_NAME',
  //       ),
  //       iosParameters: const IOSParameters(
  //         bundleId: 'YOUR_IOS_BUNDLE_ID',
  //       ),
  //       socialMetaTagParameters: SocialMetaTagParameters(
  //           title: 'Invest in real estate from your mobile device',
  //           description:
  //               'Invest in real estate and commodities from your mobile device',
  //           imageUrl: Uri.parse(
  //               'https://astravestapp.com/static/header-icon-1633cb142c4'
  //               '8f50d99c1d4f0d8657fc6.png')));
  //   Uri url;
  //   if (shortLink) {
  //     final ShortDynamicLink shortDynamicLink =
  //         await dynamicLinks.buildShortLink(parameters);
  //     url = shortDynamicLink.shortUrl;
  //   } else {
  //     url = await dynamicLinks.buildLink(parameters);
  //   }
  //   return url.toString();
  // }
  // https://heisurveiapp.page.link/?link=https://heisurveiapp.page.link/SURVEI?idSurvei=3099&apn=com.example.survei_aplikasi&efr=1

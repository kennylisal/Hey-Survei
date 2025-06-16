// import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
// import 'package:flutter/material.dart';

// class PercobaanGenerate extends StatelessWidget {
//   const PercobaanGenerate({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Center(
//         child: ElevatedButton(
//             onPressed: () async {
//               String tes = await DynamicBaru()
//                   .createDynamicLink(shortLink: true, code: "aha");
//               print(tes);
//               // print(DynamicBaru()
//               //     .createDynamicLink(shortLink: true, code: "ayaya"));
//             },
//             child: Text("sdjkfk")),
//       ),
//     );
//   }
// }

// class DynamicBaru {
//   FirebaseDynamicLinks dynamicLinks = FirebaseDynamicLinks.instance;
//   Future<String> createDynamicLink(
//       {required bool shortLink, required String code}) async {
//     final DynamicLinkParameters parameters = DynamicLinkParameters(
//       link: Uri.parse('https://heisurveiapp.page.link/survei/ref?id=$code'),
//       uriPrefix: 'https://heisurveiapp.page.link/survei',
//       androidParameters: const AndroidParameters(
//         packageName: 'com.example.survei_aplikasi',
//       ),
//       // iosParameters: const IOSParameters(
//       //   bundleId: 'YOUR_IOS_BUNDLE_ID',
//       // ),
//       // socialMetaTagParameters: SocialMetaTagParameters(
//       //     title: 'Invest in real estate from your mobile device',
//       //     description: 'Invest in real estate and commodities from your mobile device',
//       //     imageUrl: Uri.parse('https://astravestapp.com/static/header-icon-1633cb142c4'
//       //         '8f50d99c1d4f0d8657fc6.png')
//       // )
//     );
//     Uri url;
//     if (shortLink) {
//       final ShortDynamicLink shortDynamicLink =
//           await dynamicLinks.buildShortLink(parameters);
//       url = shortDynamicLink.shortUrl;
//     } else {
//       url = await dynamicLinks.buildLink(parameters);
//     }
//     return url.toString();
//   }
// }

//https://jideije-emeka.medium.com/flutter-how-to-create-dynamic-link-and-route-users-to-a-specific-page-in-your-app-8fd834ec1aa8
// import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
// import 'package:flutter/material.dart';
// import 'package:go_router/go_router.dart';
// import 'package:survei_aplikasi/features/app/router/router_constant.dart';

// class DynamicLinkBaru {
//   FirebaseDynamicLinks dynamicLinks = FirebaseDynamicLinks.instance;
//   Future<String> createDynamicLink(
//       {required bool shortLink, required String code}) async {
//     final DynamicLinkParameters parameters = DynamicLinkParameters(
//       link: Uri.parse('https://heisurveiapp.page.link/survei/ref?id=$code'),
//       uriPrefix: 'https://heisurveiapp.page.link',
//       androidParameters: const AndroidParameters(
//         packageName: 'com.example.survei_aplikasi',
//       ),
//       // iosParameters: const IOSParameters(
//       //   bundleId: 'YOUR_IOS_BUNDLE_ID',
//       // ),
//       // socialMetaTagParameters: SocialMetaTagParameters(
//       //     title: 'Invest in real estate from your mobile device',
//       //     description: 'Invest in real estate and commodities from your mobile device',
//       //     imageUrl: Uri.parse('https://astravestapp.com/static/header-icon-1633cb142c4'
//       //         '8f50d99c1d4f0d8657fc6.png')
//       // )
//     );
//     Uri url;
//     if (shortLink) {
//       final ShortDynamicLink shortDynamicLink =
//           await dynamicLinks.buildShortLink(parameters);
//       url = shortDynamicLink.shortUrl;
//     } else {
//       url = await dynamicLinks.buildLink(parameters);
//     }
//     return url.toString();
//   }
//   // Future<String> createDynamicLink(
//   //     {required bool shortLink, required String code}) async {
//   //   final DynamicLinkParameters parameters = DynamicLinkParameters(
//   //       link: Uri.parse('https://YOUR_URL_PREFIX_HERE/ref?id=$code'),
//   //       uriPrefix: 'https://YOUR_URL_PREFIX_HERE',
//   //       androidParameters: const AndroidParameters(
//   //         packageName: 'YOUR_ANDROID_PACKAGE_NAME',
//   //       ),
//   //       iosParameters: const IOSParameters(
//   //         bundleId: 'YOUR_IOS_BUNDLE_ID',
//   //       ),
//   //       socialMetaTagParameters: SocialMetaTagParameters(
//   //           title: 'Invest in real estate from your mobile device',
//   //           description:
//   //               'Invest in real estate and commodities from your mobile device',
//   //           imageUrl: Uri.parse(
//   //               'https://astravestapp.com/static/header-icon-1633cb142c4'
//   //               '8f50d99c1d4f0d8657fc6.png')));
//   //   Uri url;
//   //   if (shortLink) {
//   //     final ShortDynamicLink shortDynamicLink =
//   //         await dynamicLinks.buildShortLink(parameters);
//   //     url = shortDynamicLink.shortUrl;
//   //   } else {
//   //     url = await dynamicLinks.buildLink(parameters);
//   //   }
//   //   return url.toString();
//   // }
//   // https://heisurveiapp.page.link/?link=https://heisurveiapp.page.link/SURVEI?idSurvei=3099&apn=com.example.survei_aplikasi&efr=1

//   void initDynamicLinks(BuildContext context) async {
//     dynamicLinks.onLink.listen((dynamicLinkData) {
//       print("masuk 1============================");
//       final Uri deepLink = dynamicLinkData.link;
//       var isReferral = deepLink.pathSegments.contains('ref');

//       context.pushNamed(RouteConstant.percobaan,
//           pathParameters: {'kata': deepLink.toString()});
//       if (isReferral) {
//         if (deepLink.toString().isNotEmpty) {
//           try {
//             context.pushNamed(RouteConstant.faq);
//             // context.pushNamed(RouteConstant.percobaan,
//             //     pathParameters: {'kata': ""});
//           } catch (e) {
//             debugPrint(e.toString());
//           }
//         }
//       } else {
//         return;
//       }
//     });
//     await dynamicLinks.getInitialLink().then((data) {
//       print("masuk 2============================");
//       final Uri? deepLink = data?.link;
//       var isReferral = deepLink?.pathSegments.contains('ref');

//       if (isReferral == true) {
//         if (deepLink.toString().isNotEmpty) {
//           try {
//             context.pushNamed(RouteConstant.faq);
//             // context.pushNamed(RouteConstant.percobaan,
//             //     pathParameters: {'kata': ""});
//           } catch (e) {
//             debugPrint(e.toString());
//           }
//         } else {
//           return;
//         }
//       }
//     });
//   }
// }

// import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
// import 'package:flutter/material.dart';
// import 'package:share_plus/share_plus.dart';

// class HelperClass{

//   HelperClass();

//   void shareData(BuildContext context, String message, String subject){
//     final RenderBox box = context.f;
//     Share.share(message,
//         subject: subject,
//         sharePositionOrigin:
//         box.localToGlobal(Offset.zero) &
//         box.size);
//   }

//   Future<String> createDynamicLink(int id) async {

//     var parameters = DynamicLinkParameters(
//       uriPrefix: 'https://subdomain.domain.com',
//       link: Uri.parse('https://avasar.life/f?paramId=$id'),
//       androidParameters: AndroidParameters(
//         packageName: "com.city.deals",
//       ),
//       //Uncomment for iOS
//       // iosParameters: IosParameters(
//       //   bundleId: "com.exmple.test",
//       //   appStoreId: 'some valid app store id',
//       // ),
//     );

//     var shortLink = await parameters.buildShortLink();
//     var shortUrl = shortLink.shortUrl;

//     return shortUrl.toString();
//   }
// }

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class DynamicLinkCreator {
  Future<String>? buildDynamicLink(String idSurvei) async {
    String urlToReturn = "";
    final postUrl =
        "https://firebasedynamiclinks.googleapis.com/v1/shortLinks?key=AIzaSyD5QRy4eJIMnz9u_lKdh347fyXY3LMgv_o";

    final theUrl =
        // "https://heisurveiapp.page.link/?link=https://heisurveiapp.page.link/SURVEI?idSurvei=$idSurvei&apn=com.example.survei_aplikasi&efr=1";
        "https://heisurveiapp.page.link/?link=https://heisurveiapp.page.link/SURVEI?idSurvei=$idSurvei&apn=com.kenny6622.HeySurvei";
    // "https://heisurveiapp.page.link/?link=https://heisurveiapp.page.link";
    await http.post(Uri.tryParse(postUrl)!, body: {
      'longDynamicLink': theUrl,
    }).then(
      (http.Response response) {
        final int statusCode = response.statusCode;

        if (statusCode < 200 || statusCode > 400 || response == null) {
          throw new Exception("Error while fetching data");
        }
        var decoded = json.decode(response.body);
        urlToReturn = decoded['shortLink'];
        return decoded['shortLink'];
      },
    ).catchError((e) => debugPrint('error $e'));
    return urlToReturn;
  }
  //   Future<String>? buildDynamicLink(String idSurvei) async {
  //   String urlToReturn = "";
  //   final postUrl =
  //       "https://firebasedynamiclinks.googleapis.com/v1/shortLinks?key=AIzaSyD5QRy4eJIMnz9u_lKdh347fyXY3LMgv_o";

  //   final theUrl =
  //       "https://heisurveiapp.page.link/?link=https://heisurveiapp.page.link/SURVEI?idSurvei=$idSurvei&apn=com.example.survei_aplikasi&efr=1";
  //   await http.post(Uri.tryParse(postUrl)!, body: {
  //     'longDynamicLink': theUrl,
  //   }).then(
  //     (http.Response response) {
  //       final int statusCode = response.statusCode;

  //       if (statusCode < 200 || statusCode > 400 || response == null) {
  //         throw new Exception("Error while fetching data");
  //       }
  //       var decoded = json.decode(response.body);
  //       urlToReturn = decoded['shortLink'];
  //       return decoded['shortLink'];
  //     },
  //   ).catchError((e) => debugPrint('error $e'));
  //   return urlToReturn;
  // }
}

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:hei_survei/app/app.dart';
import 'package:hei_survei/firebase_options.dart';
import 'package:hei_survei/utils/shared_pref.dart';
import 'package:url_strategy/url_strategy.dart';

//import 'package:flutter_dotenv/flutter_dotenv.dart' as DotEnv;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  setPathUrlStrategy();
  await initHiveForFlutter();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await SharedPrefs.init();
  runApp(const ProviderScope(child: HeiSurveiApp()));
}
//kalau mau update flutter, pindah dulu ke A:work/flutter

//kalau dibilang notos fonts masalah
//flutter run -d chrome --web-renderer html


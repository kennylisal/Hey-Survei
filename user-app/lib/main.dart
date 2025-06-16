import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:survei_aplikasi/features/app/app.dart';
import 'package:survei_aplikasi/firebase_options.dart';
import 'package:survei_aplikasi/utils/shared_pref.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initHiveForFlutter();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await SharedPrefs.init();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  runApp(const ProviderScope(child: HeiSurveiApp()));
}

// class MyApp extends StatelessWidget {
//   const MyApp({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       debugShowCheckedModeBanner: false,
//       title: "bagian pertama",
//       theme: ThemeData(
//         scaffoldBackgroundColor: Colors.blue.shade50,
//         useMaterial3: true,
//         fontFamily: 'Merriweather',
//         colorScheme: ColorScheme.fromSeed(
//           seedColor: const Color.fromARGB(255, 0, 140, 255),
//         ),
//       ),
//       //home: LoadingBiasa(),
//       //home: LoadingBiasa(),

//       //home: ReportPage(),
//       //home: HalamanProfile(),
//       //home: HalamanFAQ(),
//       //home: HalamanSignUp(),
//       // home: HalamanLogin(),
//       //home: HalamanFAQ(),
//       //home: DetailSurvei(),
//       //home: HalamanSearch(),
//       //home: HalamanUtama(),
//       //home: SurveiKartu(),
//       // home: SoalSurvei(),
//     );
//   }
// }
//dynamic - links
//HeiSurveiApp.page.link/survei

//firebase app id
// web       1:181319302204:web:2bf1d6750a9f5b29811739
// android   1:181319302204:android:a08304d8356d1d07811739

// SHA1: FE:38:53:1D:E8:14:3E:1A:E1:BB:0C:9F:28:3A:9B:14:56:51:CA:81
// SHA-256: AB:13:87:46:3E:D9:AF:91:81:22:02:84:27:4B:B0:68:F5:9C:44:91:4C:7C:33:8F:C4:74:8C:5E:97:D3:D2:6F
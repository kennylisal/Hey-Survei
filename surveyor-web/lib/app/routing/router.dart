import 'package:go_router/go_router.dart';
import 'package:hei_survei/app/error_page.dart';
import 'package:hei_survei/app/routing/route_constant.dart';
import 'package:hei_survei/constants.dart';
import 'package:hei_survei/features/laporan/laporan_kartu/laporan_kartu.dart';
import 'package:hei_survei/features/laporan/laporan_klasik/laporan_klasik.dart';
import 'package:hei_survei/features/main/main_page.dart';
import 'package:hei_survei/features/auth/screens/halaman_auth.dart';
import 'package:hei_survei/features/auth/screens/login_baru.dart';
import 'package:hei_survei/features/auth/screens/regis_baru.dart';
import 'package:hei_survei/features/form/screens/halaman_form_kartu.dart';
import 'package:hei_survei/features/form/screens/halaman_form_klasik.dart';
import 'package:hei_survei/features/preview/screens/preview_kartu.dart';
import 'package:hei_survei/features/preview/screens/preview_klasik.dart';
import 'package:hei_survei/features/publish_survei/publish_baru.dart';
import 'package:hei_survei/features/publish_survei/publish_survei.dart';
import 'package:hei_survei/utils/kriptografi.dart';
import 'package:hei_survei/utils/shared_pref.dart';

import 'package:hei_survei/utils/transition_page.dart';

class AppRouter {
  GoRouter router = GoRouter(
    initialLocation: '/',
    routes: [
      GoRoute(
        path: '/publishSurvei',
        name: RouteConstant.publishSurvei,
        pageBuilder: (context, state) {
          return const TransitionPage(
            child: PublishSurveiBaru(),
          );
        },
      ),
      GoRoute(
        name: RouteConstant.home,
        path: '/home',
        pageBuilder: (context, state) =>
            const TransitionPage(child: HalamanUtama()),
      ),
      GoRoute(
        name: RouteConstant.login,
        path: '/login',
        pageBuilder: (context, state) => const TransitionPage(
          child: LoginBaru(),
        ),
      ),
      GoRoute(
        path: '/register',
        name: RouteConstant.register,
        pageBuilder: (context, state) => const TransitionPage(
          child: RegisBaru(),
        ),
      ),
      GoRoute(
        path: '/',
        name: RouteConstant.halamanAuth,
        pageBuilder: (context, state) =>
            const TransitionPage(child: AuthPage()),
      ),
      GoRoute(
        name: RouteConstant.formKlasik,
        path: '/formKlasik/:idForm',
        pageBuilder: (context, state) {
          final idForm = state.pathParameters['idForm'] as String;
          final id = Kriptografi.decrypt(idForm);
          return TransitionPage(
              child: HalamanFormKlasik(
            // idForm: idForm,
            idForm: id,
          ));
        },
      ),
      GoRoute(
        name: RouteConstant.previewKlasik,
        path: '/previewKlasik/:idForm',
        pageBuilder: (context, state) {
          final idForm = state.pathParameters['idForm'] as String;
          final id = Kriptografi.decrypt(idForm);
          // return TransitionPage(child: HalamanFormKlasik(idForm: idForm));
          return TransitionPage(
              child: HalamanPreviewKlasik(
            // idForm: idForm,
            idForm: id,
          ));
        },
      ),
      GoRoute(
        path: '/formKartu/:idForm',
        name: RouteConstant.formKartu,
        pageBuilder: (context, state) {
          final idForm = state.pathParameters['idForm'] as String;
          final id = Kriptografi.decrypt(idForm);
          return TransitionPage(
              child: HalamanFormKartu(
            // idForm: idForm,
            idForm: id,
          ));
        },
      ),
      GoRoute(
        path: '/previewKartu/:idForm',
        name: RouteConstant.previewKartu,
        pageBuilder: (context, state) {
          final idForm = state.pathParameters['idForm'] as String;
          final id = Kriptografi.decrypt(idForm);
          return TransitionPage(
              child: HalamanPreviewKartu(
            // idForm: idForm,
            idForm: id,
          ));
        },
      ),
      GoRoute(
        path: '/laporanKlasik/:idSurvei',
        name: RouteConstant.laporanKlasik,
        pageBuilder: (context, state) {
          final idSurvei = state.pathParameters['idSurvei'] as String;
          final id = Kriptografi.decrypt(idSurvei);
          return TransitionPage(child: ContainerLaporanKlasik(idSurvei: id));
          // return TransitionPage(
          //     child: HalamanLaporanKlasik(
          //   // idSurvei: idSurvei,
          //   idSurvei: id,
          // ));
        },
      ),
      GoRoute(
        path: '/laporanKartu/:idSurvei',
        name: RouteConstant.laporanKartu,
        pageBuilder: (context, state) {
          final idSurvei = state.pathParameters['idSurvei'] as String;
          final id = Kriptografi.decrypt(idSurvei);
          return TransitionPage(child: ContainerLaporanKartu(idSurvei: id));
          // return TransitionPage(
          //     child: HalamanLaporanKartu(
          //   // idSurvei: idSurvei,
          //   idSurvei: id,
          // ));
        },
      ),
    ],
    // errorBuilder: (context, state) {
    //   return AuthPage();
    // },
    redirect: (context, state) {
      final isUserAuthenticated = SharedPrefs.getString(prefUserId) ?? "";
      print(state.uri.toString() + " =>  $isUserAuthenticated");

      if (isUserAuthenticated == "" && state.uri.toString() == '/register') {
        print("masuk register no login");
        return '/register';
      }
      if (isUserAuthenticated == "" && state.uri.toString() == '/login') {
        print("masuk login no login");
        return '/login';
      }
      if (isUserAuthenticated == "") {
        print("no login");
        return '/login';
      }

      return null;
    },
    errorBuilder: (context, state) => const ErrorPage(),
  );
}

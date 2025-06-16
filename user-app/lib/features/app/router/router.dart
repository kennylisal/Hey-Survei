import 'package:go_router/go_router.dart';
import 'package:survei_aplikasi/constants.dart';
import 'package:survei_aplikasi/features/FAQ/halaman_faq.dart';
import 'package:survei_aplikasi/features/app/router/router_constant.dart';
import 'package:survei_aplikasi/features/auth/auth.dart';
import 'package:survei_aplikasi/features/auth/login.dart';
import 'package:survei_aplikasi/features/auth/signup.dart';
import 'package:survei_aplikasi/features/detail_survei/detail_baru.dart';
import 'package:survei_aplikasi/features/detail_survei/detail_sejarah.dart';
import 'package:survei_aplikasi/features/dynamic_link/detail_dynamic.dart';
import 'package:survei_aplikasi/features/form_kartu/form_kartu.dart';
import 'package:survei_aplikasi/features/form_klasik/form_klasik.dart';
import 'package:survei_aplikasi/features/home/home.dart';
import 'package:survei_aplikasi/features/home/home_baru.dart';
import 'package:survei_aplikasi/features/home/widgets/sejarah_kontribusi_home.dart';
import 'package:survei_aplikasi/features/laporan/penilaian.dart';
import 'package:survei_aplikasi/features/laporan/report.dart';
import 'package:survei_aplikasi/features/profile/auth_otp.dart';
import 'package:survei_aplikasi/features/profile/profile.dart';
import 'package:survei_aplikasi/features/rekomendasi/rekomendasi.dart';
import 'package:survei_aplikasi/features/search/search_katalog.dart';
import 'package:survei_aplikasi/features/term_agreement/kebijakan_privasi.dart';
import 'package:survei_aplikasi/features/term_agreement/kebijakan_utama.dart';
import 'package:survei_aplikasi/features/term_agreement/perjanjian_anggota.dart';
import 'package:survei_aplikasi/utils/shared_pref.dart';
import 'package:survei_aplikasi/utils/transition_page.dart';

class AppRouter {
  GoRouter router = GoRouter(
    routes: [
      GoRoute(
        path: '/login',
        name: RouteConstant.login,
        pageBuilder: (context, state) {
          return const TransitionPage(
            child: HalamanLogin(),
          );
        },
      ),
      GoRoute(
        path: '/kontribusiHome/:emailUser/:poinUser',
        name: RouteConstant.riwayatKontribusiHome,
        pageBuilder: (context, state) {
          final emailUser = state.pathParameters['emailUser'] as String;
          final poinUser = state.pathParameters['poinUser'] as String;
          int poin = int.parse(poinUser);
          return TransitionPage(
            child: SejarahKontribusiHome(emailUser: emailUser, pointUser: poin),
          );
        },
      ),
      GoRoute(
        path: '/signup',
        name: RouteConstant.signup,
        pageBuilder: (context, state) {
          return const TransitionPage(
            child: HalamanSignUp(),
          );
        },
      ),
      GoRoute(
        path: '/',
        name: RouteConstant.auth,
        pageBuilder: (context, state) {
          return const TransitionPage(
            child: AuthPage(),
          );
        },
      ),
      GoRoute(
        path: '/home',
        name: RouteConstant.home,
        pageBuilder: (context, state) {
          return const TransitionPage(
              // child: HomePage(),
              child: HomePageBaru());
        },
      ),
      GoRoute(
        path: '/profile',
        name: RouteConstant.profile,
        pageBuilder: (context, state) {
          return TransitionPage(
            child: HalamanProfile(),
          );
        },
      ),
      GoRoute(
        path: '/faq',
        name: RouteConstant.faq,
        pageBuilder: (context, state) {
          return const TransitionPage(
            child: HalamanFAQ(),
          );
        },
      ),
      GoRoute(
        path: '/rekomendasi',
        name: RouteConstant.rekomnedasi,
        pageBuilder: (context, state) {
          return const TransitionPage(
            child: HalamanRekomendasi(),
          );
        },
      ),
      GoRoute(
        path: '/detailSurvei',
        name: RouteConstant.detail,
        pageBuilder: (context, state) {
          return const TransitionPage(
            child: DetailSurveiX(),
          );
        },
      ),
      GoRoute(
        path: '/OTP',
        name: RouteConstant.otp,
        pageBuilder: (context, state) {
          return const TransitionPage(
            child: HalamanOTP(),
          );
        },
      ),
      GoRoute(
        name: RouteConstant.formKlasik,
        path: '/formKlasik/:idForm/:idSurvei',
        pageBuilder: (context, state) {
          final idForm = state.pathParameters['idForm'] as String;
          final idSurvei = state.pathParameters['idSurvei'] as String;
          return TransitionPage(
              child: ContainerFormKlasik(idForm: idForm, idSurvei: idSurvei));
        },
      ),
      GoRoute(
        name: RouteConstant.formKartu,
        path: '/formKartu/:idForm/:idSurvei',
        pageBuilder: (context, state) {
          final idForm = state.pathParameters['idForm'] as String;
          final idSurvei = state.pathParameters['idSurvei'] as String;
          return TransitionPage(
              child: ContainerFormKartu(idForm: idForm, idSurvei: idSurvei));
        },
      ),
      GoRoute(
        name: RouteConstant.detailDynamic,
        path: '/formKartu/:idSurvei',
        pageBuilder: (context, state) {
          final idSurvei = state.pathParameters['idSurvei'] as String;
          return TransitionPage(child: DetailSurveiDynamic(idSurvei: idSurvei));
        },
      ),
      GoRoute(
        name: RouteConstant.penilaianSurvei,
        path: '/penilaianSurvei/:email/:idSurvei',
        pageBuilder: (context, state) {
          final email = state.pathParameters['email'] as String;
          final idSurvei = state.pathParameters['idSurvei'] as String;
          return TransitionPage(
              child: HalamanPenilaian(email: email, idSurvei: idSurvei));
        },
      ),
      GoRoute(
        name: RouteConstant.laporSurvei,
        path: '/laporanSurvei/:email/:idSurvei',
        pageBuilder: (context, state) {
          final email = state.pathParameters['email'] as String;
          final idSurvei = state.pathParameters['idSurvei'] as String;
          final judulSurvei = state.pathParameters['judulSurvei'] as String;
          return TransitionPage(
              child: ReportPage(
            idSurvei: idSurvei,
            email: email,
            judulSurvei: judulSurvei,
          ));
        },
      ),
      GoRoute(
        name: RouteConstant.detailSejarah,
        path: '/detailSejarah/:tglPengisian/:idSurvei',
        pageBuilder: (context, state) {
          final idSurvei = state.pathParameters['idSurvei'] as String;
          final tglPengisian = state.pathParameters['tglPengisian'] as String;
          return TransitionPage(
              child: DetailSejarah(
                  idSurvei: idSurvei, tglPengisian: tglPengisian));
        },
      ),
      GoRoute(
        name: RouteConstant.search,
        path: '/search/:doCarikan',
        pageBuilder: (context, state) {
          final doCarikan = state.pathParameters['doCarikan'] as String;
          return TransitionPage(
              child: SearchKatalog(doCarikan: doCarikan == 'true'));
        },
      ),
      GoRoute(
        path: '/ketentuanSyarat',
        name: RouteConstant.ketentuanSyarat,
        pageBuilder: (context, state) {
          return const TransitionPage(
            child: KebijakanUtama(),
          );
        },
      ),
      GoRoute(
        path: '/perjanjianAnggota',
        name: RouteConstant.perjanjianAnggota,
        pageBuilder: (context, state) {
          return TransitionPage(
            child: PerjanjianAnggota(),
          );
        },
      ),
      GoRoute(
        path: '/kebijakanPrivasi',
        name: RouteConstant.kebijakanPrivasi,
        pageBuilder: (context, state) {
          return const TransitionPage(
            child: KebijakanPrivasi(),
          );
        },
      ),
    ],
    redirect: (context, state) {
      final isUserAuthenticated = SharedPrefs.getString(prefUserid);
      print(state.uri.toString());
      if (isUserAuthenticated == null && state.uri.toString() == '/signup') {
        return '/signup';
      }
      if (isUserAuthenticated == null && state.uri.toString() == '/login') {
        return '/login';
      }
      if (isUserAuthenticated == null &&
          state.uri.toString() == '/ketentuanSyarat') {
        return '/ketentuanSyarat';
      }
      if (isUserAuthenticated == null &&
          state.uri.toString() == '/perjanjianAnggota') {
        return '/perjanjianAnggota';
      }
      if (isUserAuthenticated == null &&
          state.uri.toString() == '/kebijakanPrivasi') {
        return '/kebijakanPrivasi';
      }
      if (isUserAuthenticated == null) {
        return '/login';
      }
      return null;
    },
  );
}

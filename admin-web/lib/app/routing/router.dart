import 'package:aplikasi_admin/app/routing/route_constant.dart';
import 'package:aplikasi_admin/features/auth/admin_login.dart';
import 'package:aplikasi_admin/features/dashboard/dashboard.dart';
import 'package:aplikasi_admin/features/formV2/screens/halaman_form_kartu.dart';
import 'package:aplikasi_admin/features/formV2/screens/halaman_form_klasik.dart';
import 'package:aplikasi_admin/features/laporan/laporan_kartu/laporan_kartu.dart';
import 'package:aplikasi_admin/features/laporan/laporan_klasik/laporan.dart';
import 'package:aplikasi_admin/features/preview/screens/preview_kartu.dart';
import 'package:aplikasi_admin/features/preview/screens/preview_klasik.dart';
import 'package:aplikasi_admin/features/survei/screens/publish_survei.dart';
import 'package:aplikasi_admin/utils/transition_page.dart';
import 'package:go_router/go_router.dart';

class AppRouter {
  GoRouter router = GoRouter(routes: [
    GoRoute(
      path: '/',
      name: RouterConstant.login,
      pageBuilder: (context, state) => TransitionPage(
        child: AdminLogin(),
      ),
    ),
    GoRoute(
      path: '/home',
      name: RouterConstant.home,
      pageBuilder: (context, state) => const TransitionPage(
        child: Dashboard(),
      ),
    ),
    GoRoute(
      path: '/formKartu/:idForm',
      name: RouterConstant.formKartu,
      pageBuilder: (context, state) {
        final idForm = state.pathParameters['idForm'] as String;
        return TransitionPage(child: HalamanFormKartu(idForm: idForm));
      },
    ),
    GoRoute(
      name: RouterConstant.formKlasik,
      path: '/formKlasik/:idForm',
      pageBuilder: (context, state) {
        final idForm = state.pathParameters['idForm'] as String;
        return TransitionPage(child: HalamanFormKlasik(idForm: idForm));
      },
    ),
    GoRoute(
      path: '/publishSurvei',
      name: RouterConstant.publishSurvei,
      pageBuilder: (context, state) {
        return TransitionPage(
          child: PublishBaru(),
        );
      },
    ),
    GoRoute(
      path: '/laporanKlasik/:idSurvei',
      name: RouterConstant.laporanKlasik,
      pageBuilder: (context, state) {
        final idSurvei = state.pathParameters['idSurvei'] as String;
        return TransitionPage(
          child: HalamanLaporanKlasik(idSurvei: idSurvei),
        );
      },
    ),
    GoRoute(
      path: '/laporanKartu/:idSurvei',
      name: RouterConstant.laporanKartu,
      pageBuilder: (context, state) {
        final idSurvei = state.pathParameters['idSurvei'] as String;
        return TransitionPage(
          child: HalamanLaporanKartu(idSurvei: idSurvei),
        );
      },
    ),
    GoRoute(
      path: '/previewKlasik/:idForm',
      name: RouterConstant.previewKlasik,
      pageBuilder: (context, state) {
        final idForm = state.pathParameters['idForm'] as String;
        return TransitionPage(
          child: HalamanPreviewKlasik(idForm: idForm),
        );
      },
    ),
    GoRoute(
      path: '/previewKaru/:idForm',
      name: RouterConstant.previewKartu,
      pageBuilder: (context, state) {
        final idForm = state.pathParameters['idForm'] as String;
        return TransitionPage(
          child: HalamanPreviewKartu(idForm: idForm),
        );
      },
    ),
  ]);
}

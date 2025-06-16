import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:hei_survei/app/app.dart';
import 'package:hei_survei/app/routing/route_constant.dart';
import 'package:hei_survei/constants.dart';
import 'package:hei_survei/features/transaksi/transaksi_controller.dart';
import 'package:hei_survei/utils/loading_biasa.dart';
import 'package:hei_survei/utils/shared_pref.dart';

class AuthPage extends ConsumerStatefulWidget {
  const AuthPage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _AuthPageState();
}

class _AuthPageState extends ConsumerState<AuthPage> {
  String? idUser;
  initKeranjang() async {
    int jumlah = await TransaksiController().getJumlahKeranjang();
    print("ini jumlah keranjang $jumlah");
    ref.read(jumlahKeranjangProvider.notifier).update((state) => jumlah);
  }

  initOrder() async {
    bool temp = await TransaksiController().getStatusOrder();
    ref.read(adaOrderProvider.notifier).update((state) => temp);
  }

  initData() async {
    idUser = SharedPrefs.getString(prefUserId) ?? "";
    print("masuk auth shared =>$idUser");
    if (idUser == "") {
      print("tidak ketemu shared pref");
      context.goNamed(RouteConstant.login);
    } else {
      try {
        if (ref.read(authProvider).user.email == "") {
          await ref
              .read(authProvider.notifier)
              .getDataUserAndSettingState(idUser!);
        }

        if (!context.mounted) return;
        context.goNamed(RouteConstant.home);
      } catch (e) {
        print("gagal loading data");
        context.goNamed(RouteConstant.register);
      }
    }
  }

  @override
  void initState() {
    initData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: LoadingBiasa(
      text: "Data akun sedang dimuat",
      pakaiKembali: false,
    ));
  }
}

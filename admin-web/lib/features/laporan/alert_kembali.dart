import 'package:aplikasi_admin/app/routing/route_constant.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class AlertUtil {
  showAlertKembali({
    required BuildContext context,
    required String pesanUtama,
    required String pesanLanjut,
    required String pesanBatal,
  }) {
    Widget cancelButton = TextButton(
      child: Text(
        // "Batal",
        pesanBatal,
        style: Theme.of(context).textTheme.titleLarge!.copyWith(
              fontSize: 17,
              fontWeight: FontWeight.bold,
            ),
      ),
      onPressed: () {
        Navigator.pop(context, 'Cancel');
      },
    );
    Widget continueButton = TextButton(
      child: Text(
        pesanLanjut,
        // "Kembali",
        style: Theme.of(context).textTheme.titleLarge!.copyWith(
              fontSize: 17,
              fontWeight: FontWeight.bold,
            ),
      ),
      onPressed: () {
        Navigator.pop(context);
        context.goNamed(RouterConstant.home);
      },
    );

    AlertDialog alert = AlertDialog(
      title: Text(
        "Peringatan",
        style: Theme.of(context)
            .textTheme
            .titleLarge!
            .copyWith(fontSize: 32, fontWeight: FontWeight.bold),
      ),
      content: Text(
        pesanUtama,
        // "Pastikan anda sudah menyimpan data form",
        style: Theme.of(context).textTheme.titleLarge!.copyWith(fontSize: 20),
      ),
      actions: [cancelButton, continueButton],
    );

    showDialog(
        context: context,
        builder: (context) {
          return alert;
        });
  }
}

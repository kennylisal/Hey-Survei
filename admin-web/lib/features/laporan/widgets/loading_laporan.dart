import 'package:aplikasi_admin/app/routing/route_constant.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:go_router/go_router.dart';

class LoadingLaporan extends StatelessWidget {
  LoadingLaporan({
    super.key,
    required this.text,
  });
  String text;
  showAlertKembali(BuildContext context) {
    Widget cancelButton = TextButton(
      child: Text(
        "Batal",
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
        "Kembali",
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
        "Pastikan anda sudah menyimpan data form",
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

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.transparent,
      child: Column(
        children: [
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 9),
            child: Center(
              child: InkWell(
                onTap: () => showAlertKembali(context),
                child: Row(
                  children: [
                    CircleAvatar(
                      backgroundColor: Colors.blue.shade700,
                      child: Icon(
                        Icons.chevron_left,
                        color: Colors.white,
                        size: 35,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Text(
                      "Kembali",
                      style: Theme.of(context)
                          .textTheme
                          .titleLarge!
                          .copyWith(fontSize: 18),
                      overflow: TextOverflow.ellipsis,
                    )
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height: 65),
          const SpinKitChasingDots(
            size: 350,
            color: Colors.lightBlue,
          ),
          const SizedBox(height: 20),
          Text(
            "Memuat, Mohon Tunggu",
            style: Theme.of(context)
                .textTheme
                .displaySmall!
                .copyWith(fontSize: 38, color: Colors.blue),
          ),
          const SizedBox(height: 5),
          Text(
            text,
            style: Theme.of(context)
                .textTheme
                .displaySmall!
                .copyWith(fontSize: 20, color: Colors.blueGrey.shade400),
          )
        ],
      ),
    );
  }
}

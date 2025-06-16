import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hei_survei/app/routing/route_constant.dart';

class SelesaiOrder extends StatelessWidget {
  const SelesaiOrder({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const SizedBox(height: 65),
        Center(
          child: Image.asset(
            'assets/no-trans-midtrans.png',
            height: 450,
          ),
        ),
        Text(
          "Silahkan Kembali Ke halaman utama",
          style: Theme.of(context).textTheme.displaySmall!.copyWith(
              fontSize: 38, color: Colors.black, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 9),
        Text(
          "Lalu Kunjungi Halaman Pembayaran",
          style: Theme.of(context).textTheme.displaySmall!.copyWith(
              fontSize: 38, color: Colors.black, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 30),
        ElevatedButton(
            style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue, padding: EdgeInsets.all(26)),
            onPressed: () {
              context.goNamed(RouteConstant.home);
            },
            child: Text("Kembali",
                style: Theme.of(context).textTheme.displayLarge!.copyWith(
                      color: Colors.white,
                      fontSize: 30,
                    ))),
      ],
    );
  }
}

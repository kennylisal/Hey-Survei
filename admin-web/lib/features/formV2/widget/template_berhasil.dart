import 'package:aplikasi_admin/app/routing/route_constant.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class TemplateBerhasil extends StatelessWidget {
  const TemplateBerhasil({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const SizedBox(height: 100),
        Center(
          child: Container(
            padding: EdgeInsets.all(6),
            decoration: BoxDecoration(
                color: Colors.white, borderRadius: BorderRadius.circular(16)),
            child: Image.asset(
              'assets/no-trans-midtrans.png',
              height: 360,
            ),
          ),
        ),
        Text(
          "Template Berhasil Diciptakan",
          style: Theme.of(context).textTheme.displaySmall!.copyWith(
              fontSize: 40, color: Colors.black, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 16),
        ElevatedButton(
            style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue, padding: EdgeInsets.all(26)),
            onPressed: () {
              context.goNamed(RouterConstant.home);
            },
            child: Text("Ke Halaman Utama",
                style: Theme.of(context).textTheme.displayLarge!.copyWith(
                      color: Colors.white,
                      fontSize: 24,
                    ))),
      ],
    );
  }
}

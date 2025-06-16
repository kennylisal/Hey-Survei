import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hei_survei/app/routing/route_constant.dart';

class SuksesPenerbitanSurvei extends StatelessWidget {
  const SuksesPenerbitanSurvei({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        children: [
          const SizedBox(height: 40),
          Center(
            child: Image.asset(
              'assets/no-trans-midtrans.png',
              height: 450,
            ),
          ),
          Text(
            "Silahkan Lanjut ke Halaman Pembayaran",
            style: Theme.of(context).textTheme.displaySmall!.copyWith(
                fontSize: 38, color: Colors.black, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 40),
          Center(
            child: SizedBox(
              height: 55,
              child: ElevatedButton(
                onPressed: () => context.goNamed(RouteConstant.halamanAuth),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  elevation: 5,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(9),
                  ),
                ),
                child: Text(
                  "Ke Pembayaran",
                  style: Theme.of(context).textTheme.titleLarge!.copyWith(
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        fontSize: 22,
                      ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

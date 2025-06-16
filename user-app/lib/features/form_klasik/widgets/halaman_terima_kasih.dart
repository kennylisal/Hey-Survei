import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:survei_aplikasi/features/app/router/router_constant.dart';
import 'package:survei_aplikasi/utils/currency_formatter.dart';

class TerimaKasihPengisianForm extends StatelessWidget {
  TerimaKasihPengisianForm({
    super.key,
    required this.insentif,
    required this.emailUser,
    required this.idSurvei,
  });
  int insentif;
  String idSurvei;
  String emailUser;
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const SizedBox(height: 20),
        Text(
          "Jawaban Anda Telah Diterima!",
          style: Theme.of(context).textTheme.displayMedium!.copyWith(
                fontSize: 24,
                color: Colors.black,
                fontWeight: FontWeight.bold,
              ),
        ),
        const SizedBox(height: 12),
        Text(
          "Terima Kasih atas Kontribusi Anda",
          style: Theme.of(context).textTheme.displayMedium!.copyWith(
                fontSize: 24,
                color: Colors.black,
                fontWeight: FontWeight.bold,
              ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 26),
        Center(
          child: Container(
            padding: const EdgeInsets.all(5),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
            ),
            child: Image.asset(
              'assets/rekomendasi.png',
              height: 180,
            ),
          ),
        ),
        const SizedBox(height: 24),
        Text(
          "Akun anda telah menerima",
          style: Theme.of(context).textTheme.displayMedium!.copyWith(
                fontSize: 27.5,
                color: Colors.black,
                fontWeight: FontWeight.bold,
              ),
        ),
        const SizedBox(height: 6),
        Text(
          CurrencyFormat.convertToIdr(insentif, 2),
          style: Theme.of(context).textTheme.displayMedium!.copyWith(
                fontSize: 30.5,
                color: Colors.black,
                fontWeight: FontWeight.bold,
              ),
        ),
        const SizedBox(height: 30),
        Container(
          height: 55,
          width: double.infinity,
          margin: const EdgeInsets.symmetric(horizontal: 40),
          decoration: BoxDecoration(
            border: Border.all(width: 1, color: Colors.black),
            borderRadius: BorderRadius.circular(8),
            color: Colors.blue,
          ),
          child: TextButton(
              onPressed: () => context.goNamed(RouteConstant.home),
              child: Text(
                "Ke Halaman utama",
                style: Theme.of(context).textTheme.displayMedium!.copyWith(
                    fontSize: 21,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1),
              )),
        ),
        const SizedBox(height: 30),
        TextButton(
            onPressed: () {
              context.pushNamed(RouteConstant.penilaianSurvei, pathParameters: {
                'email': emailUser,
                'idSurvei': idSurvei,
              });
            },
            child: Text(
              "Beri Penilaian",
              style: Theme.of(context).textTheme.displayMedium!.copyWith(
                    fontSize: 18,
                    color: Colors.blue,
                    fontWeight: FontWeight.bold,
                  ),
            ))
      ],
    );
  }
}

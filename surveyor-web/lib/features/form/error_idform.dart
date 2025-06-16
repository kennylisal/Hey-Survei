import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hei_survei/app/routing/route_constant.dart';

class ErrorIdForm extends StatelessWidget {
  const ErrorIdForm({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
        child: Column(
      children: [
        const SizedBox(height: 50),
        Center(
          child: Container(
            padding: const EdgeInsets.all(25),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Color.fromARGB(255, 103, 131, 255),
            ),
            child: Image.asset(
              'assets/logo-maaf.png',
              height: 320,
            ),
          ),
        ),
        const SizedBox(height: 6),
        Text(
          "Mohon Maaf Terjadi Kesalahan",
          style: Theme.of(context)
              .textTheme
              .displaySmall!
              .copyWith(fontSize: 33, color: Colors.black),
        ),
        const SizedBox(height: 6),
        Text(
          "Mohon kembali ke halaman utama untuk memuat form",
          style: Theme.of(context)
              .textTheme
              .displaySmall!
              .copyWith(fontSize: 18, color: Colors.grey.shade600),
        ),
        const SizedBox(height: 16),
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
                "Kembali",
                style: Theme.of(context).textTheme.titleLarge!.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      fontSize: 22,
                    ),
              ),
            ),
          ),
        ),
        const SizedBox(height: 16),
      ],
    ));
  }
}

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hei_survei/app/routing/route_constant.dart';

class ErrorPage extends StatelessWidget {
  const ErrorPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
          child: Column(
        children: [
          const SizedBox(height: 32),
          Center(
            child: Image.asset(
              'assets/no-draft.png',
              height: 360,
            ),
          ),
          Text(
            "Error 404",
            style: Theme.of(context)
                .textTheme
                .displaySmall!
                .copyWith(fontSize: 33, color: Colors.black),
          ),
          Text(
            "Halaman tidak tersedia",
            style: Theme.of(context)
                .textTheme
                .displaySmall!
                .copyWith(fontSize: 18, color: Colors.grey.shade600),
          ),
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
        ],
      )),
    );
  }
}

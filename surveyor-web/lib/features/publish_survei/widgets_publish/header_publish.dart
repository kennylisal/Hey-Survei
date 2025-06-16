import 'package:flutter/material.dart';

class HeaderPublish extends StatelessWidget {
  const HeaderPublish({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(top: 14, bottom: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                'assets/logo-app.png',
                height: 100,
              ),
              const SizedBox(width: 16),
              CircleAvatar(
                backgroundColor: Colors.lightBlueAccent,
                radius: 54,
                child: Image.asset(
                  'assets/beli.png',
                  height: 84,
                ),
              ),
            ],
          ),
          Text(
            "Publikasi Survei",
            style: Theme.of(context)
                .textTheme
                .titleLarge!
                .copyWith(fontSize: 32, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 4),
          Text(
            "Lengkapi detail-detail survei yang dibutuhkan untuk kelengkapan data",
            style: Theme.of(context)
                .textTheme
                .titleLarge!
                .copyWith(fontSize: 17, color: Colors.blueGrey.shade600),
          ),
          Text(
            "dan kustomisasi pilihan pulbikasikan survei",
            style: Theme.of(context)
                .textTheme
                .titleLarge!
                .copyWith(fontSize: 17, color: Colors.blueGrey.shade600),
          ),
        ],
      ),
    );
  }
}

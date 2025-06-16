import 'package:flutter/material.dart';

class HeaderRekomen extends StatelessWidget {
  const HeaderRekomen({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
        height: 90,
        width: double.infinity,
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.symmetric(horizontal: 28),
        decoration: BoxDecoration(
          color: Colors.deepOrangeAccent.shade400,
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(36),
            bottomRight: Radius.circular(36),
          ),
        ),
        child: Row(
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Survei Khusus',
                  style: Theme.of(context).textTheme.displayMedium!.copyWith(
                        fontSize: 25,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                ),
                Text(
                  'Untuk Anda ',
                  style: Theme.of(context).textTheme.displayMedium!.copyWith(
                        fontSize: 25,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                ),
              ],
            ),
            Spacer(),
            Container(
              padding: EdgeInsets.all(8),
              decoration: const BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
              ),
              child: Image.asset(
                'assets/logo-app.png',
                height: 50,
              ),
            ),
          ],
        ));
  }
}

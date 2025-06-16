import 'package:flutter/material.dart';

class LengkapiDataDemo extends StatelessWidget {
  LengkapiDataDemo({
    super.key,
    required this.size,
    required this.text1,
    required this.text2,
    this.text3 = "",
  });
  double size;
  String text1;
  String text2;
  String text3;
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(25),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Color.fromARGB(255, 103, 131, 255),
            ),
            child: Image.asset(
              'assets/logo-maaf.png',
              height: 250.0,
            ),
          ),
          const SizedBox(height: 28),
          Text(
            text1,
            style: Theme.of(context).textTheme.displayMedium!.copyWith(
                  fontSize: size,
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: 2),
          Text(
            text2,
            style: Theme.of(context).textTheme.displayMedium!.copyWith(
                  fontSize: size,
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
          ),
          Text(
            text3,
            style: Theme.of(context).textTheme.displayMedium!.copyWith(
                  fontSize: size,
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
          ),
        ],
      ),
    );
  }
}

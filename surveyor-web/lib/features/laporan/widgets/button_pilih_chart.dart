import 'package:flutter/material.dart';

class ButtonPilihChart extends StatelessWidget {
  ButtonPilihChart({
    super.key,
    required this.text,
    required this.onPressed,
    required this.isPicked,
  });
  String text;
  Function()? onPressed;
  bool isPicked;
  @override
  Widget build(BuildContext context) {
    return Container(
        width: 225,
        height: 40,
        margin: const EdgeInsets.only(bottom: 13, left: 20, right: 20),
        child: ElevatedButton(
            onPressed: onPressed,
            style: ElevatedButton.styleFrom(
              backgroundColor: (isPicked) ? Colors.green : Colors.blue,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            child: Text(
              text,
              style: Theme.of(context).textTheme.displayLarge!.copyWith(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.25,
                  ),
            )));
  }
}

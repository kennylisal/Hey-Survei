import 'package:flutter/material.dart';

class TombolCari extends StatelessWidget {
  TombolCari({
    super.key,
    required this.onPressed,
    required this.icon,
    required this.text,
  });
  Function() onPressed;
  String text;
  Icon icon;
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(left: 120),
      child: ElevatedButton.icon(
        icon: icon,
        label: Text(
          text,
          style: Theme.of(context).textTheme.displayLarge!.copyWith(
                color: Colors.white,
                fontSize: 35,
              ),
        ),
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 20),
          backgroundColor: Colors.blue,
        ),
        onPressed: onPressed,
      ),
    );
  }
}

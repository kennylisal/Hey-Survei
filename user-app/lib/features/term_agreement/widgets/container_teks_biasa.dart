import 'package:flutter/material.dart';

class ContainerTeksBiasa extends StatelessWidget {
  ContainerTeksBiasa({super.key, required this.text});
  String text;
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      width: double.infinity,
      child: Text(
        text,
        style: Theme.of(context).textTheme.displaySmall!.copyWith(
              fontSize: 15,
              color: Colors.black,
              fontWeight: FontWeight.bold,
              height: 1.4,
            ),
        textAlign: TextAlign.justify,
      ),
    );
  }
}

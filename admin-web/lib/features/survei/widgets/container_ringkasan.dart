import 'package:flutter/material.dart';

class ContainerRingkasan extends StatelessWidget {
  ContainerRingkasan({
    super.key,
    required this.text,
    required this.judul,
  });
  String judul;
  String text;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: Colors.grey.shade100,
          border: Border.all(
            width: 1,
            color: Colors.blueGrey,
          ),
          borderRadius: BorderRadius.circular(4)),
      margin: const EdgeInsets.only(top: 1),
      padding: const EdgeInsets.all(8),
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            judul,
            style: Theme.of(context).textTheme.titleLarge!.copyWith(
                  fontSize: 20,
                ),
          ),
          const SizedBox(height: 5),
          Text(
            text,
            style: Theme.of(context).textTheme.titleLarge!.copyWith(
                  fontSize: 17,
                  fontWeight: FontWeight.bold,
                ),
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';

class JawabanTeks extends StatelessWidget {
  const JawabanTeks({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(10, 8, 60, 20),
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Teks Normal",
            style: Theme.of(context)
                .textTheme
                .labelMedium!
                .copyWith(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          const Row(
            children: [
              Expanded(
                  child: Divider(
                color: Colors.black,
              ))
            ],
          )
        ],
      ),
    );
  }
}

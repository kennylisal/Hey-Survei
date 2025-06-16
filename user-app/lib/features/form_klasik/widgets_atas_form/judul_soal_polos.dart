import 'package:flutter/material.dart';

class JudulFormPolos extends StatelessWidget {
  JudulFormPolos({
    super.key,
    required this.judul,
  });
  final String judul;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Center(
          child: Text(
            judul,
            style: Theme.of(context)
                .textTheme
                .displayMedium!
                .copyWith(fontWeight: FontWeight.bold, fontSize: 28.5),
            textAlign: TextAlign.center,
            overflow: TextOverflow.ellipsis,
            maxLines: 2,
          ),
        ),
        const SizedBox(height: 15),
      ],
    );
  }
}

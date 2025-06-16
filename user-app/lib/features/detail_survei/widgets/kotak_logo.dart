import 'package:flutter/material.dart';

class KotakLogoKeterangan extends StatelessWidget {
  const KotakLogoKeterangan({
    super.key,
    required this.icons,
    required this.text,
  });
  final IconData icons;
  final String text;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 56,
          height: 56,
          decoration: BoxDecoration(
            color: Colors.blue.shade400,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(
            //Icons.monetization_on_rounded,
            icons,
            color: Colors.white,
            size: 44,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          text,
          style: Theme.of(context).textTheme.displayMedium!.copyWith(
                fontSize: 16,
                color: Colors.black.withOpacity(0.65),
              ),
          maxLines: 2,
        ),
      ],
    );
  }
}

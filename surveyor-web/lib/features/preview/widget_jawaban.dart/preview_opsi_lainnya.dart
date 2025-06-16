import 'package:flutter/material.dart';

class PreviewOpsiLainnya extends StatelessWidget {
  PreviewOpsiLainnya({super.key, required this.iconPilihan});
  final Widget iconPilihan;
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 6),
      padding: const EdgeInsets.only(bottom: 8),
      width: double.infinity,
      child: Row(
        children: [
          iconPilihan,
          const SizedBox(width: 8),
          const Flexible(
            child: TextField(
              enabled: false,
              decoration: InputDecoration(
                hintText: "Lainnya",
                border: UnderlineInputBorder(),
              ),
            ),
          ),
          IconButton(
            disabledColor: Colors.grey.shade400,
            icon: const Icon(
              Icons.remove_circle_outline,
              size: 30,
            ),
            onPressed: null,
          ),
        ],
      ),
    );
  }
}

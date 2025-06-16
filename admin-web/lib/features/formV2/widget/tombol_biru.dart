import 'package:flutter/material.dart';

class TombolBiru extends StatelessWidget {
  TombolBiru({super.key, required this.onPressed});
  final Function() onPressed;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: ElevatedButton.icon(
        onPressed: onPressed,
        icon: Icon(
          Icons.photo_size_select_actual_rounded,
          color: Colors.white,
        ),
        label: Text("Masukkan Gambar",
            style: Theme.of(context)
                .textTheme
                .titleLarge!
                .copyWith(fontSize: 12, color: Colors.white),
            overflow: TextOverflow.ellipsis),
        style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
      ),
    );
  }
}

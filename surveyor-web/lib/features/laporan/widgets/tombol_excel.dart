import 'package:flutter/material.dart';

class TombolExcel extends StatelessWidget {
  TombolExcel({super.key, required this.onPressed});
  Function() onPressed;
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16),
        width: 250,
        height: 50,
        child: ElevatedButton.icon(
          onPressed: onPressed,
          icon: const Icon(
            Icons.description,
            size: 19,
            color: Colors.black,
          ),
          label: Text(
            "Export Data",
            style:
                Theme.of(context).textTheme.titleLarge!.copyWith(fontSize: 20),
            overflow: TextOverflow.ellipsis,
          ),
          style: ElevatedButton.styleFrom(
              backgroundColor: Colors.greenAccent.shade400,
              side: BorderSide(color: Colors.black, width: 2)),
        ),
      ),
    );
  }
}

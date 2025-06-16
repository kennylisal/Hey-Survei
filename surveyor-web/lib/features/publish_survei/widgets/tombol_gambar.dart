import 'package:flutter/material.dart';

class TombolGambar extends StatelessWidget {
  TombolGambar({
    super.key,
    required this.isLoading,
    required this.onPressed,
  });
  bool isLoading;
  Function() onPressed;
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 230,
      height: 40,
      margin: const EdgeInsets.only(top: 14),
      child: (isLoading)
          ? Container(
              height: 35,
              width: 35,
              child: FittedBox(
                  child: CircularProgressIndicator(
                color: Colors.blue.shade600,
                strokeWidth: 5,
              )),
            )
          : ElevatedButton(
              style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(8))),
                  backgroundColor: Colors.blue),
              onPressed: onPressed,
              child: Text(
                "Pilih Gambar",
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context)
                    .textTheme
                    .titleLarge!
                    .copyWith(color: Colors.white, fontSize: 17),
              ),
            ),
    );
  }
}

import 'package:flutter/material.dart';

class RowUpdate extends StatelessWidget {
  RowUpdate({
    super.key,
    required this.onPressHapus,
    required this.onPressUpdate,
  });
  Function() onPressUpdate;
  Function() onPressHapus;
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Container(
          margin: const EdgeInsets.only(top: 3),
          child: ElevatedButton(
              onPressed: onPressUpdate,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                padding:
                    const EdgeInsets.symmetric(vertical: 12, horizontal: 18),
              ),
              child: Text(
                "Update",
                style: Theme.of(context).textTheme.displayLarge!.copyWith(
                      color: Colors.white,
                      fontSize: 19,
                      fontWeight: FontWeight.bold,
                    ),
              )),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 5.5),
          child: CircleAvatar(
            radius: 20,
            backgroundColor: Colors.redAccent.shade400,
            child: IconButton(
                onPressed: onPressHapus,
                icon: Icon(
                  Icons.delete,
                  color: Colors.white,
                )),
          ),
        )
      ],
    );
  }
}

class RowBaru extends StatelessWidget {
  RowBaru({
    super.key,
    required this.onPressedHapus,
    required this.onPressedTambah,
  });
  Function() onPressedTambah;
  Function() onPressedHapus;
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Container(
          margin: const EdgeInsets.only(top: 3),
          child: ElevatedButton(
              onPressed: onPressedTambah,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.greenAccent.shade400,
                padding:
                    const EdgeInsets.symmetric(vertical: 12, horizontal: 18),
              ),
              child: Text(
                "Tambahkan",
                style: Theme.of(context).textTheme.displayLarge!.copyWith(
                      color: Colors.white,
                      fontSize: 19,
                      fontWeight: FontWeight.bold,
                    ),
              )),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 5.5),
          child: CircleAvatar(
            radius: 20,
            backgroundColor: Colors.redAccent.shade400,
            child: IconButton(
                onPressed: onPressedHapus,
                icon: Icon(
                  Icons.delete,
                  color: Colors.white,
                )),
          ),
        )
      ],
    );
  }
}

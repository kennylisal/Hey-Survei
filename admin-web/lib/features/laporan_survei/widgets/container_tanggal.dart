import 'package:flutter/material.dart';

class PilihanTanggalLaporan extends StatefulWidget {
  PilihanTanggalLaporan({
    super.key,
    required this.controller,
    required this.onTap,
  });
  TextEditingController controller;
  Function() onTap;
  @override
  State<PilihanTanggalLaporan> createState() => _PilihanTanggalLaporanState();
}

class _PilihanTanggalLaporanState extends State<PilihanTanggalLaporan> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          "Tanggal Akhir",
          style: Theme.of(context).textTheme.displayLarge!.copyWith(
                color: Colors.black,
                fontSize: 27,
                fontWeight: FontWeight.bold,
              ),
        ),
        const SizedBox(height: 10),
        Container(
          width: 250,
          child: TextField(
            style: Theme.of(context).textTheme.displayLarge!.copyWith(
                  color: Colors.black,
                  fontSize: 22,
                ),
            controller:
                widget.controller, //editing controller of this TextField
            decoration: const InputDecoration(
              icon: Icon(Icons.calendar_today), //icon of text field
            ),
            readOnly: true, // when true user cannot edit text
            onTap: widget.onTap,
          ),
        ),
      ],
    );
  }
}

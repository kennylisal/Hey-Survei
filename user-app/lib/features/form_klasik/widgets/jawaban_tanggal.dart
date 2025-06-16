import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:survei_aplikasi/features/form_klasik/models/data_pertanyaan.dart';
import 'package:survei_aplikasi/features/form_klasik/state/controller_pertanyaan.dart';

class JawabanTanggalZ extends StatefulWidget {
  JawabanTanggalZ({
    super.key,
    required this.controller,
    required this.dataTanggal,
  });
  DataTanggal dataTanggal;
  PertanyaanController controller;
  @override
  State<JawabanTanggalZ> createState() => _JawabanTanggalZState();
}

class _JawabanTanggalZState extends State<JawabanTanggalZ> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          (widget.dataTanggal.date == null)
              ? Text(
                  "DD / MM / YYYY",
                  style: Theme.of(context)
                      .textTheme
                      .headlineLarge!
                      .copyWith(fontWeight: FontWeight.bold),
                )
              : Text(
                  DateFormat("dd / MMMM / yyyy")
                      .format(widget.dataTanggal.date!),
                  style: Theme.of(context)
                      .textTheme
                      .headlineLarge!
                      .copyWith(fontWeight: FontWeight.bold),
                ),
          const SizedBox(height: 16),
          ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
              onPressed: () async {
                DateTime? newDate = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    //initialDate: dataTanggal.date,
                    firstDate: DateTime(1900),
                    lastDate: DateTime(2100));

                if (newDate == null) return;
                setState(() {
                  widget.controller.gantiTanggal(newDate);
                });
              },
              child: Text("Pilih",
                  style: Theme.of(context)
                      .textTheme
                      .titleMedium!
                      .copyWith(color: Colors.white))),
        ],
      ),
    );
  }
}

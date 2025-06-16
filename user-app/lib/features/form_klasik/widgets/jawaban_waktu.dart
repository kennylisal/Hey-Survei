import 'package:flutter/material.dart';
import 'package:survei_aplikasi/features/form_klasik/models/data_pertanyaan.dart';
import 'package:survei_aplikasi/features/form_klasik/state/controller_pertanyaan.dart';

class JawabanWaktu extends StatefulWidget {
  JawabanWaktu({
    super.key,
    required this.dataWaktu,
    required this.controller,
  });
  DataWaktu dataWaktu;
  PertanyaanController controller;
  @override
  State<JawabanWaktu> createState() => _JawabanWaktuState();
}

class _JawabanWaktuState extends State<JawabanWaktu> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          (widget.dataWaktu.waktu == null)
              ? Text(
                  "XX : YY",
                  style: Theme.of(context)
                      .textTheme
                      .headlineLarge!
                      .copyWith(fontWeight: FontWeight.bold),
                )
              : Text(
                  "${widget.dataWaktu.waktu!.hour.toString().padLeft(2, '0')} : ${widget.dataWaktu.waktu!.minute.toString().padLeft(2, '0')}",
                  style: Theme.of(context)
                      .textTheme
                      .headlineLarge!
                      .copyWith(fontWeight: FontWeight.bold),
                ),
          const SizedBox(height: 16),
          ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
              onPressed: () async {
                TimeOfDay? newTime = await showTimePicker(
                    context: context, initialTime: TimeOfDay.now());

                if (newTime == null) return;
                setState(() {
                  widget.controller.gantiWaktu(newTime);
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

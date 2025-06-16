import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart' hide Text;
import 'package:hei_survei/features/laporan/widgets/quill_soal.dart';

class PembatasSoal extends StatelessWidget {
  PembatasSoal({
    super.key,
    required this.namaPembatas,
    required this.quillController,
  });
  QuillController quillController;
  String namaPembatas;
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 15),
      width: double.infinity,
      decoration: const BoxDecoration(
        border: Border(
          top: BorderSide(
            color: Color.fromARGB(255, 13, 171, 250),
            width: 5,
          ),
          bottom: BorderSide(
            color: Color.fromARGB(255, 13, 171, 250),
            width: 5,
          ),
        ),
        color: Colors.white,
      ),
      // decoration: const BoxDecoration(
      //   color: Colors.white,
      //   borderRadius: BorderRadius.all(Radius.circular(20)),
      // ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Container(
                  padding: const EdgeInsets.only(
                    left: 10,
                    top: 3,
                  ),
                  child: Text(
                    "Bagian : ",
                    style: Theme.of(context)
                        .textTheme
                        .titleMedium!
                        .copyWith(fontSize: 20),
                  )),
              Container(
                  padding: const EdgeInsets.only(
                    left: 10,
                    top: 3,
                  ),
                  child: Text(
                    namaPembatas,
                    style: Theme.of(context)
                        .textTheme
                        .titleMedium!
                        .copyWith(fontWeight: FontWeight.bold, fontSize: 20),
                  )),
            ],
          ),
          const SizedBox(height: 12),
          Center(
            child: Text(
              "Petunjuk",
              style: Theme.of(context).textTheme.titleMedium!.copyWith(
                    fontSize: 18,
                    color: Colors.black,
                  ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Flexible(
                child: Container(
                  margin: EdgeInsets.symmetric(vertical: 6),
                  padding: EdgeInsets.symmetric(vertical: 4),
                  decoration: BoxDecoration(
                    border: Border.all(width: 1),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: QuilSoalLaporan(
                    quillController: quillController,
                  ),
                ),
              )
            ],
          ),
        ],
      ),
    );
  }
}

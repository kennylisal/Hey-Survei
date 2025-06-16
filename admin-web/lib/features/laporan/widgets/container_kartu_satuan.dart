import 'package:aplikasi_admin/features/formV2/widget/quill_soal.dart';
import 'package:aplikasi_admin/features/laporan/models/jawaban_survei.dart';
import 'package:aplikasi_admin/features/laporan/models/pertanyaan_survei.dart';
import 'package:aplikasi_admin/features/laporan/widgets/gambar_soal.dart';
import 'package:aplikasi_admin/features/laporan/widgets/quill_soal.dart';
import 'package:flutter/material.dart';

class ContainerKartuY extends StatelessWidget {
  ContainerKartuY({
    super.key,
    required this.jawaban,
    required this.jawabanPertanyaan,
    required this.pertanyaanKartu,
  });
  PertanyaanKartu pertanyaanKartu;
  JawabanPertanyaan jawabanPertanyaan;
  Widget jawaban;
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 15),
      width: double.infinity,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(Radius.circular(20)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.only(
              left: 10,
              top: 3,
            ),
            child: Text(
              "Pertanyaan",
              style: Theme.of(context)
                  .textTheme
                  .titleMedium!
                  .copyWith(fontWeight: FontWeight.bold, fontSize: 20),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 157,
                height: 196,
                child: Center(
                    child: GambarSoal(urlGambar: pertanyaanKartu.urlGambar)),
              ),
              Flexible(
                  child: Container(
                margin: EdgeInsets.symmetric(vertical: 6),
                padding: EdgeInsets.symmetric(vertical: 4),
                height: 90,
                decoration: BoxDecoration(
                  border: Border.all(width: 1),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: QuilSoalLaporan(
                  quillController: pertanyaanKartu.quillController,
                ),
              ))
            ],
          ),
          jawaban,
          if (pertanyaanKartu.isWajib)
            Align(
              alignment: Alignment.bottomRight,
              child: Text(
                "*Wajib",
                style: Theme.of(context).textTheme.titleMedium!.copyWith(
                    fontSize: 12,
                    color: Colors.red,
                    fontWeight: FontWeight.bold),
              ),
            )
        ],
      ),
    );
  }
}

class ContainerKartuZ extends StatelessWidget {
  ContainerKartuZ({
    super.key,
    required this.jawaban,
    required this.jawabanPertanyaan,
    required this.pertanyaanKartu,
  });
  PertanyaanKartu pertanyaanKartu;
  JawabanPertanyaan jawabanPertanyaan;
  Widget jawaban;
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 15),
      width: double.infinity,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(Radius.circular(20)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.only(
              left: 10,
              top: 3,
            ),
            child: Text(
              "Pertanyaan",
              style: Theme.of(context)
                  .textTheme
                  .titleMedium!
                  .copyWith(fontWeight: FontWeight.bold, fontSize: 20),
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
                  height: 90,
                  decoration: BoxDecoration(
                    border: Border.all(width: 1),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: QuilSoalLaporan(
                    quillController: pertanyaanKartu.quillController,
                  ),
                ),
              ),
              Container(
                width: 157,
                height: 196,
                child: Center(
                    child: GambarSoal(urlGambar: pertanyaanKartu.urlGambar)),
              ),
            ],
          ),
          jawaban,
          if (pertanyaanKartu.isWajib)
            Align(
              alignment: Alignment.bottomRight,
              child: Text(
                "*Wajib",
                style: Theme.of(context).textTheme.titleMedium!.copyWith(
                    fontSize: 12,
                    color: Colors.red,
                    fontWeight: FontWeight.bold),
              ),
            )
        ],
      ),
    );
  }
}

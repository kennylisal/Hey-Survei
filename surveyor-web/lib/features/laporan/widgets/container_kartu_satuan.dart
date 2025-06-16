import 'package:flutter/material.dart';
import 'package:hei_survei/features/laporan/models/jawaban_survei.dart';
import 'package:hei_survei/features/laporan/models/pertanyaan_survei.dart';
import 'package:hei_survei/features/laporan/widgets/gambar_soal.dart';
import 'package:hei_survei/features/laporan/widgets/quill_soal.dart';

class ContainerKartuY extends StatelessWidget {
  ContainerKartuY({
    super.key,
    required this.jawaban,
    required this.jawabanPertanyaan,
    required this.pertanyaanKartu,
    required this.index,
    required this.isCabang,
    required this.totalSoal,
  });
  PertanyaanKartu pertanyaanKartu;
  JawabanPertanyaan jawabanPertanyaan;
  Widget jawaban;
  int index;
  int totalSoal;
  bool isCabang;
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
          if (!isCabang)
            Text(
              "${index} / $totalSoal",
              style: Theme.of(context).textTheme.displaySmall!.copyWith(
                    fontSize: 16,
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
            ),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 188,
                height: 227.5,
                child: Center(
                    child: GambarSoal(urlGambar: pertanyaanKartu.urlGambar)),
              ),
              const SizedBox(width: 12),
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
          const SizedBox(height: 24),
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
    required this.index,
    required this.isCabang,
    required this.totalSoal,
  });
  PertanyaanKartu pertanyaanKartu;
  JawabanPertanyaan jawabanPertanyaan;
  Widget jawaban;
  int index;
  int totalSoal;
  bool isCabang;
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
          if (!isCabang)
            Text(
              "${index} / $totalSoal",
              style: Theme.of(context).textTheme.displaySmall!.copyWith(
                    fontSize: 16,
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
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
              const SizedBox(width: 12),
              Container(
                width: 188,
                height: 227.5,
                child: Center(
                    child: GambarSoal(urlGambar: pertanyaanKartu.urlGambar)),
              ),
            ],
          ),
          const SizedBox(height: 24),
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

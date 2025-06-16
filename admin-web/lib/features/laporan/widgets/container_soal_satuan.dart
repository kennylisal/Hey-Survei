import 'package:aplikasi_admin/features/laporan/constanst.dart';
import 'package:aplikasi_admin/features/laporan/models/jawaban_survei.dart';
import 'package:aplikasi_admin/features/laporan/models/pertanyaan_survei.dart';
import 'package:aplikasi_admin/features/laporan/widgets/gambar_soal.dart';
import 'package:aplikasi_admin/features/laporan/widgets/quill_soal.dart';
import 'package:flutter/material.dart';

class ContainerPertanyaanJawabanLaporan extends StatelessWidget {
  ContainerPertanyaanJawabanLaporan({
    super.key,
    required this.dataPertanyaan,
    required this.jawabanPertanyaan,
    required this.jawaban,
  });
  PertanyaanKlasik dataPertanyaan;
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
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.end,
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
                  )),
              Container(
                  padding: const EdgeInsets.only(
                    right: 10,
                    top: 3,
                  ),
                  child: Row(
                    children: [
                      mapJenisSoal[jawabanPertanyaan.tipeSoal]!,
                      const SizedBox(width: 5),
                      Text(
                        jawabanPertanyaan.tipeSoal,
                        style: Theme.of(context)
                            .textTheme
                            .titleMedium!
                            .copyWith(fontSize: 14),
                      ),
                    ],
                  )),
            ],
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
                    quillController: dataPertanyaan.quillController,
                  ),
                ),
              )
            ],
          ),
          if (dataPertanyaan.isBergambar)
            Center(child: GambarSoal(urlGambar: dataPertanyaan.urlGambar)),
          Container(
            margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 12),
            child: Text(
              "Jawaban",
              style: Theme.of(context).textTheme.titleMedium!.copyWith(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                  ),
            ),
          ),
          jawaban,
          if (dataPertanyaan.isWajib)
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

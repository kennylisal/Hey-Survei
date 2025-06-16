import 'package:flutter/material.dart';
import 'package:hei_survei/features/laporan/constanst.dart';
import 'package:hei_survei/features/laporan/models/pertanyaan_survei.dart';
import 'package:hei_survei/features/laporan/widgets/gambar_soal.dart';
import 'package:hei_survei/features/laporan/widgets/quill_soal.dart';

class ContainerUtamaPresentaseLaporan extends StatelessWidget {
  ContainerUtamaPresentaseLaporan({
    super.key,
    required this.dataPertanyaan,
    required this.jawaban,
    required this.onPressed,
    required this.isSelected,
    required this.index,
    required this.isCabang,
    required this.totalSoal,
  });
  PertanyaanKlasik dataPertanyaan;
  Widget jawaban;
  Function()? onPressed;
  final bool isSelected;
  int index;
  int totalSoal;
  bool isCabang;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 15),
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.all(Radius.circular(20)),
        border: (isSelected)
            ? Border.all(
                width: 3.5,
                color: Colors.purpleAccent,
              )
            : null,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                      padding: const EdgeInsets.only(
                        left: 10,
                      ),
                      child: Text(
                        "Pertanyaan",
                        style: Theme.of(context)
                            .textTheme
                            .titleMedium!
                            .copyWith(
                                fontWeight: FontWeight.bold, fontSize: 18),
                      )),
                  const SizedBox(width: 5),
                  if (!isCabang)
                    Padding(
                      padding: const EdgeInsets.only(top: 3),
                      child: Text(
                        "${index} / $totalSoal",
                        style:
                            Theme.of(context).textTheme.displaySmall!.copyWith(
                                  fontSize: 16,
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                ),
                      ),
                    ),
                ],
              ),
              Container(
                  padding: const EdgeInsets.only(
                    right: 10,
                    top: 3,
                  ),
                  child: Row(
                    children: [
                      mapJenisSoal[dataPertanyaan.dataSoal.tipeSoal]!,
                      const SizedBox(width: 5),
                      Text(
                        dataPertanyaan.dataSoal.tipeSoal,
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
          Row(
            children: [Flexible(child: jawaban)],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const SizedBox(width: 16),
              IconButton.filled(
                  onPressed: onPressed, icon: Icon(Icons.settings))
            ],
          ),
          if (dataPertanyaan.isWajib)
            Text(
              "*Wajib",
              style: Theme.of(context).textTheme.titleMedium!.copyWith(
                  fontSize: 12, color: Colors.red, fontWeight: FontWeight.bold),
            )
        ],
      ),
    );
  }
}

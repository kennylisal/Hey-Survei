import 'package:aplikasi_admin/features/laporan/models/data_soal_lama.dart';
import 'package:flutter/material.dart';

class TabelJawabanLaporan extends StatelessWidget {
  TabelJawabanLaporan({
    super.key,
    required this.dataTabel,
    required this.mapHasil,
  });
  Map<int, List<String>> mapHasil;
  DataTabel dataTabel;
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 42, vertical: 14),
      child: Table(
        border: TableBorder.all(
          width: 2,
        ),
        children: [
          if (dataTabel.berjudul)
            TableRow(
              children: [
                for (var j = 0; j < dataTabel.baris; j++)
                  Container(
                    height: 35,
                    color: Colors.blue,
                    child: Center(
                      child: Text(dataTabel.listJudul[j].text,
                          style: Theme.of(context)
                              .textTheme
                              .titleMedium!
                              .copyWith(fontWeight: FontWeight.bold)),
                    ),
                  ),
              ],
            ),
          for (var i = 0; i < dataTabel.kolom; i++) //2 0 1
            TableRow(
              children: [
                for (var j = 0; j < dataTabel.baris; j++) //3 0 1 2
                  Container(
                      height: 50,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 15, vertical: 7),
                      child: Text(
                        mapHasil[j]![i],
                        style: Theme.of(context)
                            .textTheme
                            .titleMedium!
                            .copyWith(
                                fontSize: 16.25,
                                color: Colors.black,
                                wordSpacing: 1.2,
                                fontWeight: FontWeight.w400),
                      ))
              ],
            ),
        ],
      ),
    );
  }
}

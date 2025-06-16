import 'package:aplikasi_admin/features/halaman_pesan/halaman_pencairan.dart';
import 'package:aplikasi_admin/features/halaman_pesan/halaman_pencairan_surveyor.dart';
import 'package:aplikasi_admin/features/halaman_pesan/halaman_pesan.dart';
import 'package:flutter/material.dart';

enum PilihanLaporan {
  laporanKeluhan,
  laporanPengajuan,
}

class BarrelPesan extends StatefulWidget {
  BarrelPesan({
    super.key,
    required this.constraints,
  });
  BoxConstraints constraints;
  @override
  State<BarrelPesan> createState() => _BarrelPesanState();
}

class _BarrelPesanState extends State<BarrelPesan> {
  List<bool> isSelected = [true, false, false];

  Widget generateKonten() {
    if (isSelected[0]) {
      return HalamanPesan(constraints: widget.constraints);
    } else if (isSelected[1]) {
      return HalamanPengajuanPencairan(constraints: widget.constraints);
    } else {
      return HalamanPengajuanPencairanSurveyor(constraints: widget.constraints);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ToggleButtons(
          borderColor: Colors.black,
          fillColor: Colors.blueGrey.shade600,
          borderWidth: 2,
          selectedBorderColor: Colors.black,
          selectedColor: Colors.white,
          borderRadius: BorderRadius.circular(0),
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                'Laporan Keluhan',
                style: TextStyle(fontSize: 16),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                'Pengajuan Pencairan Partisipan',
                style: TextStyle(fontSize: 16),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                'Pengajuan Pencairan Surveyor',
                style: TextStyle(fontSize: 16),
              ),
            ),
          ],
          isSelected: isSelected,
          onPressed: (index) {
            setState(() {
              for (var i = 0; i < isSelected.length; i++) {
                isSelected[i] = i == index;
              }
            });
          },
        ),
        const SizedBox(height: 8),
        generateKonten(),
      ],
    );
  }
}

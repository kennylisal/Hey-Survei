import 'package:aplikasi_admin/features/laporan_survei/laporan_order.dart';
import 'package:aplikasi_admin/features/laporan_survei/laporan_survei.dart';
import 'package:flutter/material.dart';

enum PilihanLaporan {
  laporanSurvei,
  laporanOrder,
}

class BarrelLaporan extends StatefulWidget {
  BarrelLaporan({
    super.key,
    required this.constraints,
  });
  BoxConstraints constraints;
  @override
  State<BarrelLaporan> createState() => _BarrelLaporanState();
}

class _BarrelLaporanState extends State<BarrelLaporan> {
  List<bool> isSelected = [true, false];

  Widget generateKonten() {
    if (isSelected[0]) {
      return HalamanReportSurvei(constraints: widget.constraints);
    } else {
      return HalamanReportOrder(constraints: widget.constraints);
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
                'Laporan Survei',
                style: TextStyle(fontSize: 16),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                'Laporan Pembelian',
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

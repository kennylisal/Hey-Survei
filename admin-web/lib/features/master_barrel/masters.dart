import 'package:aplikasi_admin/features/master_faq/halaman_faq.dart';
import 'package:aplikasi_admin/features/master_kategori/halaman_kategori.dart';
import 'package:aplikasi_admin/features/master_reward/halaman_reward.dart';
import 'package:aplikasi_admin/features/master_survei/halaman_survei.dart';
import 'package:aplikasi_admin/features/master_user/halaman_user.dart';
import 'package:flutter/material.dart';

enum PilihanMaster {
  masterFAQ,
  masterKategori,
  masterReward,
  masterUser,
  masterSurvei
}

class BarrelMaster extends StatefulWidget {
  BarrelMaster({
    super.key,
    required this.constraints,
  });
  BoxConstraints constraints;
  @override
  State<BarrelMaster> createState() => _BarrelMasterState();
}

class _BarrelMasterState extends State<BarrelMaster> {
  List<bool> isSelected = [true, false, false, false, false];

  Widget generateKonten() {
    if (isSelected[0]) {
      return HalamanFAQ(constraints: widget.constraints);
    } else if (isSelected[1]) {
      return HalamanKategori(constraints: widget.constraints);
    } else if (isSelected[2]) {
      return HalamanReward(constraints: widget.constraints);
    } else if (isSelected[3]) {
      return HalamanUser(constraints: widget.constraints);
    } else {
      return HalamanSurvei(constraints: widget.constraints);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Center(
          child: ToggleButtons(
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
                  'Master FAQ',
                  style: TextStyle(fontSize: 16),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  'Master Kategori',
                  style: TextStyle(fontSize: 16),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  'Master Reward',
                  style: TextStyle(fontSize: 16),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  'Master User',
                  style: TextStyle(fontSize: 16),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  'Master Survei',
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
        ),
        const SizedBox(height: 8),
        generateKonten(),
      ],
    );
  }
}

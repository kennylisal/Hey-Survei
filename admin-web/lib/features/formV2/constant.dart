import 'package:flutter/material.dart';

class Item {
  final Tipesoal tipeSoal;
  final Icon icon;
  Item({
    required this.tipeSoal,
    required this.icon,
  });
}

List<Item> listMode = [
  Item(
    tipeSoal: Tipesoal.pilihanGanda,
    icon: const Icon(Icons.circle_outlined),
  ),
  Item(
    tipeSoal: Tipesoal.kotakCentang,
    icon: const Icon(Icons.check_box_rounded),
  ),
  Item(
    tipeSoal: Tipesoal.sliderAngka,
    icon: const Icon(Icons.stacked_line_chart),
  ),
  Item(
    tipeSoal: Tipesoal.tanggal,
    icon: const Icon(Icons.date_range),
  ),
  Item(
    tipeSoal: Tipesoal.waktu,
    icon: const Icon(Icons.access_time),
  ),
  Item(
    tipeSoal: Tipesoal.teks,
    icon: const Icon(Icons.text_fields),
  ),
  Item(
    tipeSoal: Tipesoal.paragraf,
    icon: const Icon(Icons.text_snippet_sharp),
  ),
  Item(
    tipeSoal: Tipesoal.tabel,
    icon: const Icon(Icons.table_chart),
  ),
  Item(
    tipeSoal: Tipesoal.imagePicker,
    icon: const Icon(Icons.image_search),
  ),
  Item(
    tipeSoal: Tipesoal.gambarGanda,
    icon: const Icon(Icons.image),
  ),
  Item(
    tipeSoal: Tipesoal.carousel,
    icon: const Icon(Icons.view_carousel),
  ),
  Item(
    tipeSoal: Tipesoal.urutanPilihan,
    icon: const Icon(Icons.stacked_bar_chart),
  ),
  Item(
    tipeSoal: Tipesoal.angka,
    icon: const Icon(Icons.numbers_rounded),
  ),
];

enum ModelSoal {
  modelX,
  modelY,
  modelZ,
}

extension ModelSoalString on ModelSoal {
  String get value {
    switch (this) {
      case ModelSoal.modelX:
        return "Model X";
      case ModelSoal.modelY:
        return "Model Y";
      case ModelSoal.modelZ:
        return "Model Z";
    }
  }
}

enum Tipesoal {
  pilihanGanda,
  kotakCentang,
  sliderAngka,
  gambarGanda,
  carousel,
  urutanPilihan,
  teks,
  paragraf,
  imagePicker,
  angka,
  tabel,
  waktu,
  tanggal,
}

extension TipeSoalString on Tipesoal {
  String get value {
    switch (this) {
      case Tipesoal.angka:
        return "Angka";
      case Tipesoal.carousel:
        return "Carousel";
      case Tipesoal.gambarGanda:
        return "Gambar Ganda";
      case Tipesoal.imagePicker:
        return "Image Picker";
      case Tipesoal.kotakCentang:
        return "Kotak Centang";
      case Tipesoal.paragraf:
        return "Teks Paragraf";
      case Tipesoal.pilihanGanda:
        return "Pilihan Ganda";
      case Tipesoal.sliderAngka:
        return "Slider Angka";
      case Tipesoal.tabel:
        return "Tabel";
      case Tipesoal.tanggal:
        return "Tanggal";
      case Tipesoal.teks:
        return "Teks";
      case Tipesoal.urutanPilihan:
        return "Urutan Pilihan";
      case Tipesoal.waktu:
        return "Waktu";
    }
  }
}

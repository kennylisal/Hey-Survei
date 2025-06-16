// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter_quill/flutter_quill.dart';

import 'package:survei_aplikasi/features/form_klasik/constant.dart';
import 'package:survei_aplikasi/features/form_klasik/models/data_pertanyaan.dart';
import 'package:survei_aplikasi/features/form_klasik/utility/data_utility.dart';

class PertanyaanState {
  QuillController documentQuill;
  bool isWajib;
  DataPertanyaan dataPertanyaan;
  TipePertanyaan tipePertanyaan;
  PertanyaanState({
    required this.documentQuill,
    required this.isWajib,
    required this.dataPertanyaan,
    required this.tipePertanyaan,
  });

  PertanyaanState copyWith({
    QuillController? documentQuill,
    bool? isWajib,
    DataPertanyaan? dataPertanyaan,
    TipePertanyaan? tipePertanyaan,
  }) {
    return PertanyaanState(
      documentQuill: documentQuill ?? this.documentQuill,
      isWajib: isWajib ?? this.isWajib,
      dataPertanyaan: dataPertanyaan ?? this.dataPertanyaan,
      tipePertanyaan: tipePertanyaan ?? this.tipePertanyaan,
    );
  }
}

class PembatasState extends PertanyaanState {
  String textPembatas;
  PembatasState({
    required super.documentQuill,
    required super.isWajib,
    required super.dataPertanyaan,
    required super.tipePertanyaan,
    required this.textPembatas,
  });

  factory PembatasState.fromMap(Map<String, dynamic> map) {
    QuillController quillController =
        DataUtility().makeQuillController(Delta.fromJson(map['petunjuk']));
    return PembatasState(
      documentQuill: quillController,
      isWajib: false,
      dataPertanyaan:
          DataPertanyaan(tipeSoal: Tipesoal.angka, idSoal: "pembatas biasa"),
      tipePertanyaan: TipePertanyaan.pembatasPertanyaan,
      textPembatas: map["bagian"] as String,
    );
  }
}

class PertanyaanStateKlasik extends PertanyaanState {
  bool isBergambar;
  String urlGambarSoal;

  PertanyaanStateKlasik({
    required super.documentQuill,
    required super.isWajib,
    required super.dataPertanyaan,
    required super.tipePertanyaan,
    required this.isBergambar,
    required this.urlGambarSoal,
  });

  factory PertanyaanStateKlasik.fromMap(Map<String, dynamic> map) {
    QuillController quillController = DataUtility()
        .makeQuillController(Delta.fromJson(map['pertanyaanSoal']));
    return PertanyaanStateKlasik(
      documentQuill: quillController,
      isWajib: (map["isWajib"] as int) == 1 ? true : false,
      dataPertanyaan: DataPertanyaan.generateData(map),
      tipePertanyaan: TipePertanyaan.pertanyaanKlasik,
      isBergambar: (map["isBergambar"] as int) == 1 ? true : false,
      urlGambarSoal: (map["isBergambar"] as int) == 1
          ? (map["urlGambarSoal"] as String)
          : "",
    );
  }

  @override
  PertanyaanStateKlasik copyWith({
    bool? isBergambar,
    String? urlGambarSoal,
    QuillController? documentQuill,
    bool? isWajib,
    DataPertanyaan? dataPertanyaan,
    TipePertanyaan? tipePertanyaan,
  }) {
    return PertanyaanStateKlasik(
      isBergambar: isBergambar ?? this.isBergambar,
      urlGambarSoal: urlGambarSoal ?? this.urlGambarSoal,
      dataPertanyaan: dataPertanyaan ?? this.dataPertanyaan,
      documentQuill: documentQuill ?? this.documentQuill,
      isWajib: isWajib ?? this.isWajib,
      tipePertanyaan: tipePertanyaan ?? this.tipePertanyaan,
    );
  }
}

class PertanyaanStateKlasikCabang extends PertanyaanStateKlasik {
  String kataJawaban;
  String kataPertanyaan;
  String idJawabanAsal; //ini id opsi

  PertanyaanStateKlasikCabang({
    required super.documentQuill,
    required super.isWajib,
    required super.dataPertanyaan,
    required super.tipePertanyaan,
    required super.isBergambar,
    required super.urlGambarSoal,
    required this.idJawabanAsal,
    required this.kataJawaban,
    required this.kataPertanyaan,
  });

  factory PertanyaanStateKlasikCabang.fromMap(Map<String, dynamic> map) {
    QuillController quillController = DataUtility()
        .makeQuillController(Delta.fromJson(map['pertanyaanSoal']));
    return PertanyaanStateKlasikCabang(
      documentQuill: quillController,
      isWajib: (map["isWajib"] as int) == 1 ? true : false,
      dataPertanyaan: DataPertanyaan.generateData(map),
      tipePertanyaan: TipePertanyaan.pertanyaanKlasikCabang,
      idJawabanAsal: (map["idJawabanAsal"] as String),
      kataJawaban: (map["kataJawaban"] as String),
      kataPertanyaan: (map["kataPertanyaan"] as String),
      isBergambar: (map["isBergambar"] as int) == 1 ? true : false,
      urlGambarSoal: (map["isBergambar"] as int) == 1
          ? (map["urlGambarSoal"] as String)
          : "",
    );
  }

  PertanyaanStateKlasikCabang copyWith({
    String? kataJawaban,
    String? kataPertanyaan,
    String? idJawabanAsal,
    bool? isBergambar,
    String? urlGambarSoal,
    QuillController? documentQuill,
    bool? isWajib,
    DataPertanyaan? dataPertanyaan,
    TipePertanyaan? tipePertanyaan,
  }) {
    return PertanyaanStateKlasikCabang(
      kataJawaban: kataJawaban ?? this.kataJawaban,
      kataPertanyaan: kataPertanyaan ?? this.kataPertanyaan,
      idJawabanAsal: idJawabanAsal ?? this.idJawabanAsal,
      dataPertanyaan: dataPertanyaan ?? this.dataPertanyaan,
      documentQuill: documentQuill ?? this.documentQuill,
      isBergambar: isBergambar ?? this.isBergambar,
      isWajib: isWajib ?? this.isWajib,
      tipePertanyaan: tipePertanyaan ?? this.tipePertanyaan,
      urlGambarSoal: urlGambarSoal ?? this.urlGambarSoal,
    );
  }
}

class PertanyaanStateKartu extends PertanyaanState {
  ModelSoal modelSoal;
  String urlGambar;

  PertanyaanStateKartu({
    required super.documentQuill,
    required super.isWajib,
    required super.dataPertanyaan,
    required super.tipePertanyaan,
    required this.modelSoal,
    required this.urlGambar,
  });

  factory PertanyaanStateKartu.fromMap(Map<String, dynamic> map) {
    QuillController quillController = DataUtility()
        .makeQuillController(Delta.fromJson(map['pertanyaanSoal']));
    return PertanyaanStateKartu(
      documentQuill: quillController,
      isWajib: (map["isWajib"] as int) == 1 ? true : false,
      dataPertanyaan: DataPertanyaan.generateData(map),
      tipePertanyaan: TipePertanyaan.pertanyaanKartu,
      modelSoal: ModelSoal.values.firstWhere(
          (element) => element.value == (map['modelPertanyaan'] as String)),
      urlGambar: (map["urlGambar"] as String),
    );
  }

  @override
  PertanyaanStateKartu copyWith({
    ModelSoal? modelSoal,
    String? urlGambar,
    QuillController? documentQuill,
    bool? isWajib,
    DataPertanyaan? dataPertanyaan,
    TipePertanyaan? tipePertanyaan,
  }) {
    return PertanyaanStateKartu(
      modelSoal: modelSoal ?? this.modelSoal,
      urlGambar: urlGambar ?? this.urlGambar,
      dataPertanyaan: dataPertanyaan ?? this.dataPertanyaan,
      documentQuill: documentQuill ?? this.documentQuill,
      isWajib: isWajib ?? this.isWajib,
      tipePertanyaan: tipePertanyaan ?? this.tipePertanyaan,
    );
  }
}

class PertanyaanStateKartuCabang extends PertanyaanStateKartu {
  String kataJawban;
  String idJawabanAsal;
  String kataPertanyaan;

  PertanyaanStateKartuCabang({
    required super.documentQuill,
    required super.isWajib,
    required super.dataPertanyaan,
    required super.tipePertanyaan,
    required super.modelSoal,
    required super.urlGambar,
    required this.kataJawban,
    required this.idJawabanAsal,
    required this.kataPertanyaan,
  });

  factory PertanyaanStateKartuCabang.fromMap(Map<String, dynamic> map) {
    QuillController quillController = DataUtility()
        .makeQuillController(Delta.fromJson(map['pertanyaanSoal']));
    return PertanyaanStateKartuCabang(
      documentQuill: quillController,
      isWajib: (map["isWajib"] as int) == 1 ? true : false,
      dataPertanyaan: DataPertanyaan.generateData(map),
      tipePertanyaan: TipePertanyaan.pertanyaanKartuCabang,
      modelSoal: ModelSoal.values.firstWhere(
          (element) => element.value == (map['modelPertanyaan'] as String)),
      urlGambar: (map["urlGambar"] as String),
      kataJawban: (map["kataJawaban"] as String),
      idJawabanAsal: (map["idJawabanAsal"] as String),
      kataPertanyaan: (map["kataPertanyaan"] as String),
    );
  }

  @override
  PertanyaanStateKartuCabang copyWith({
    String? kataJawban,
    String? idJawabanAsal,
    String? kataPertanyaan,
    ModelSoal? modelSoal,
    String? urlGambar,
    QuillController? documentQuill,
    bool? isWajib,
    DataPertanyaan? dataPertanyaan,
    TipePertanyaan? tipePertanyaan,
  }) {
    return PertanyaanStateKartuCabang(
      kataJawban: kataJawban ?? this.kataJawban,
      idJawabanAsal: idJawabanAsal ?? this.idJawabanAsal,
      kataPertanyaan: kataPertanyaan ?? this.kataPertanyaan,
      dataPertanyaan: dataPertanyaan ?? this.dataPertanyaan,
      documentQuill: documentQuill ?? this.documentQuill,
      isWajib: isWajib ?? this.isWajib,
      modelSoal: modelSoal ?? this.modelSoal,
      tipePertanyaan: tipePertanyaan ?? this.tipePertanyaan,
      urlGambar: urlGambar ?? this.urlGambar,
    );
  }
}

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

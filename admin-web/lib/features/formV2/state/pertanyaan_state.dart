// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart' hide Text;
import 'package:uuid/uuid.dart';

import 'package:aplikasi_admin/features/formV2/constant.dart';
import 'package:aplikasi_admin/features/formV2/data_utility.dart';
import 'package:aplikasi_admin/features/formV2/model/data_soal.dart';
import 'package:aplikasi_admin/features/formV2/state/form_controller.dart';

enum TipePertanyaan {
  pertanyaanKlasik,
  pertanyaanKartu,
  pertanyaanKlasikCabang,
  pertanyaanKartuCabang,
  pembatasPertanyaan,
}

class PembatasState extends PertanyaanState {
  TextEditingController controllerBagian;
  PembatasState({
    required this.controllerBagian,
    required super.quillController,
    required super.dataSoal,
    required super.isWajib,
    required super.tipePertanyaan,
    required super.formController,
  });

  Map<String, dynamic> getSoalData() {
    Map<String, dynamic> data = {};
    data['petunjuk'] = quillController.document.toDelta().toJson();
    data['bagian'] = controllerBagian.text;
    data['idSoal'] = dataSoal.idSoal;
    data['isPembatas'] = true;
    return data;
  }

  factory PembatasState.fromMap(
      Map<String, dynamic> map, FormController formController) {
    QuillController quillController =
        DataUtility().makeQuillController(Delta.fromJson(map['petunjuk']));
    TipePertanyaan tipePertanyaan = TipePertanyaan.pembatasPertanyaan;
    final controlleBagian =
        TextEditingController(text: map["bagian"] as String);
    final idSoal = map["idSoal"] as String;
    return PembatasState(
      controllerBagian: controlleBagian,
      quillController: quillController,
      dataSoal: DataSoal(tipeSoal: Tipesoal.angka, idSoal: idSoal),
      isWajib: false,
      tipePertanyaan: tipePertanyaan,
      formController: formController,
    );
  }
}

class PertanyaanState {
  FormController formController;
  QuillController quillController;
  DataSoal dataSoal;
  bool isWajib;
  TipePertanyaan tipePertanyaan;
  PertanyaanState({
    required this.quillController,
    required this.dataSoal,
    required this.isWajib,
    required this.tipePertanyaan,
    required this.formController,
  });

  persiapanCopySoal() {
    String idBaru = const Uuid().v4().substring(0, 8);
    dataSoal.gantiIdSoal(idBaru);
    if (dataSoal.tipeSoal == Tipesoal.pilihanGanda) {
      final temp = (dataSoal) as DataPilgan;
      for (var element in temp.listJawaban) {
        element.idData = "jawaban-" + const Uuid().v4().substring(0, 8);
      }
    }
  }

  String getIdJawabanAsalKlasik() {
    return (this as PertanyaanCabangKlasikState).idJawabanAsal;
  }

  String getIdJawabanAsalKartu() {
    return (this as PertanyaanCabangKartuState).idJawabanAsal;
  }

  bool isCabang() => (tipePertanyaan == TipePertanyaan.pertanyaanKartuCabang ||
      tipePertanyaan == TipePertanyaan.pertanyaanKlasikCabang);

  Tipesoal getTipe() => dataSoal.tipeSoal;

  PertanyaanState copyWith({
    QuillController? quillController,
    DataSoal? dataSoal,
    TipePertanyaan? tipePertanyaan,
    bool? isWajib,
    FormController? formController,
  }) {
    return PertanyaanState(
        quillController: quillController ?? this.quillController,
        dataSoal: dataSoal ?? this.dataSoal,
        tipePertanyaan: tipePertanyaan ?? this.tipePertanyaan,
        isWajib: isWajib ?? this.isWajib,
        formController: formController ?? this.formController);
  }
}

class PertanyaanKlasikState extends PertanyaanState {
  bool isBergambar;
  String urlGambar;
  PertanyaanKlasikState({
    required this.isBergambar,
    required this.urlGambar,
    required super.quillController,
    required super.dataSoal,
    required super.isWajib,
    required super.tipePertanyaan,
    required super.formController,
  });

  PertanyaanKlasikState copyWith({
    bool? isBergambar,
    String? urlGambar,
    QuillController? quillController,
    DataSoal? dataSoal,
    String? idSoal,
    bool? isWajib,
    TipePertanyaan? tipePertanyaan,
    FormController? formController,
  }) {
    return PertanyaanKlasikState(
      formController: formController ?? this.formController,
      isBergambar: isBergambar ?? this.isBergambar,
      urlGambar: urlGambar ?? this.urlGambar,
      quillController: quillController ?? this.quillController,
      dataSoal: dataSoal ?? this.dataSoal,
      isWajib: isWajib ?? this.isWajib,
      tipePertanyaan: tipePertanyaan ?? this.tipePertanyaan,
    );
  }

  factory PertanyaanKlasikState.fromMap(
      Map<String, dynamic> map, FormController formController) {
    QuillController quillController = DataUtility()
        .makeQuillController(Delta.fromJson(map['pertanyaanSoal']));
    TipePertanyaan tipePertanyaan = TipePertanyaan.pertanyaanKlasik;

    return PertanyaanKlasikState(
      isBergambar: (map["isBergambar"] as int) == 1 ? true : false,
      urlGambar: (map["isBergambar"] as int) == 1
          ? (map["urlGambarSoal"] as String)
          : "",
      quillController: quillController,
      dataSoal: DataSoal.generateData(map),
      isWajib: (map["isWajib"] as int) == 1 ? true : false,
      tipePertanyaan: tipePertanyaan,
      formController: formController,
    );
  }

  Map<String, dynamic> getSoalData() {
    Map<String, dynamic> data = {};
    data = dataSoal.getDataMap();
    data['isWajib'] = isWajib ? 1 : 0;
    data['pertanyaanSoal'] = quillController.document.toDelta().toJson();
    data['isBergambar'] = isBergambar ? 1 : 0;
    if (isBergambar) data["urlGambarSoal"] = urlGambar;
    return data;
  }
}

class PertanyaanCabangKlasikState extends PertanyaanKlasikState {
  String kataJawban;
  String idJawabanAsal; //ini sama dengan idOpsi
  String kataPertanyaan;

  PertanyaanCabangKlasikState(
      {required super.quillController,
      required super.dataSoal,
      required super.isWajib,
      required super.tipePertanyaan,
      required super.isBergambar,
      required super.urlGambar,
      required this.kataJawban,
      required this.idJawabanAsal,
      required this.kataPertanyaan,
      required super.formController});

  factory PertanyaanCabangKlasikState.fromMap(
      Map<String, dynamic> map, FormController formController) {
    QuillController quillController = DataUtility()
        .makeQuillController(Delta.fromJson(map['pertanyaanSoal']));
    TipePertanyaan tipePertanyaan = TipePertanyaan.pertanyaanKlasikCabang;
    return PertanyaanCabangKlasikState(
      quillController: quillController,
      dataSoal: DataSoal.generateData(map),
      isWajib: (map["isWajib"] as int) == 1 ? true : false,
      tipePertanyaan: tipePertanyaan,
      isBergambar: (map["isBergambar"] as int) == 1 ? true : false,
      urlGambar: (map["isBergambar"] as int) == 1
          ? (map["urlGambarSoal"] as String)
          : "",
      kataJawban: (map["kataJawaban"] as String),
      idJawabanAsal: (map["idJawabanAsal"] as String),
      kataPertanyaan: (map["kataPertanyaan"] as String),
      formController: formController,
    );
  }
  @override
  Map<String, dynamic> getSoalData() {
    Map<String, dynamic> data = {};
    data = dataSoal.getDataMap();
    data['isWajib'] = isWajib ? 1 : 0;
    data['pertanyaanSoal'] = quillController.document.toDelta().toJson();
    data['isBergambar'] = isBergambar ? 1 : 0;
    if (isBergambar) data["urlGambarSoal"] = urlGambar;
    data["kataPertanyaan"] = kataPertanyaan;
    data["idJawabanAsal"] = idJawabanAsal;
    data["kataJawaban"] = kataJawban;
    return data;
  }
}

class PertanyaanKartuState extends PertanyaanState {
  ModelSoal model;
  String urlGambar;
  PertanyaanKartuState(
      {required this.model,
      required this.urlGambar,
      required super.quillController,
      required super.dataSoal,
      required super.isWajib,
      required super.tipePertanyaan,
      required super.formController});

  PertanyaanKartuState copyWith({
    QuillController? quillController,
    DataSoal? dataSoal,
    String? idSoal,
    bool? isWajib,
    ModelSoal? model,
    String? urlGambar,
    TipePertanyaan? tipePertanyaan,
    FormController? formController,
  }) {
    return PertanyaanKartuState(
      quillController: quillController ?? this.quillController,
      dataSoal: dataSoal ?? this.dataSoal,
      isWajib: isWajib ?? this.isWajib,
      model: model ?? this.model,
      urlGambar: urlGambar ?? this.urlGambar,
      tipePertanyaan: tipePertanyaan ?? this.tipePertanyaan,
      formController: formController ?? this.formController,
    );
  }

  factory PertanyaanKartuState.fromMap(
      Map<String, dynamic> map, FormController formController) {
    QuillController quillController = DataUtility()
        .makeQuillController(Delta.fromJson(map['pertanyaanSoal']));
    TipePertanyaan tipePertanyaan = TipePertanyaan.pertanyaanKartu;
    print((map['tipeSoal'] as String));

    return PertanyaanKartuState(
      model: ModelSoal.values.firstWhere(
          (element) => element.value == (map['modelPertanyaan'] as String)),
      urlGambar: (map["urlGambar"] as String),
      quillController: quillController,
      dataSoal: DataSoal.generateData(map),
      isWajib: (map["isWajib"] as int) == 1 ? true : false,
      tipePertanyaan: tipePertanyaan,
      formController: formController,
    );
  }

  Map<String, dynamic> getSoalData() {
    Map<String, dynamic> data = {};
    data = dataSoal.getDataMap();
    data['isWajib'] = isWajib ? 1 : 0;
    data['pertanyaanSoal'] = quillController.document.toDelta().toJson();
    data["urlGambar"] = urlGambar;
    data["modelPertanyaan"] = model.value;
    return data;
  }
}

class PertanyaanCabangKartuState extends PertanyaanKartuState {
  String kataJawban;
  String idJawabanAsal;
  String kataPertanyaan;
  PertanyaanCabangKartuState({
    required super.model,
    required super.urlGambar,
    required super.quillController,
    required super.dataSoal,
    required super.isWajib,
    required super.tipePertanyaan,
    required this.kataJawban,
    required this.idJawabanAsal,
    required this.kataPertanyaan,
    required super.formController,
  });

  factory PertanyaanCabangKartuState.fromMap(
      Map<String, dynamic> map, FormController formController) {
    QuillController quillController = DataUtility()
        .makeQuillController(Delta.fromJson(map['pertanyaanSoal']));
    TipePertanyaan tipePertanyaan = TipePertanyaan.pertanyaanKartuCabang;
    return PertanyaanCabangKartuState(
      model: ModelSoal.values.firstWhere(
          (element) => element.value == (map['modelPertanyaan'] as String)),
      urlGambar: (map["urlGambar"] as String),
      quillController: quillController,
      dataSoal: DataSoal.generateData(map),
      isWajib: (map["isWajib"] as int) == 1 ? true : false,
      tipePertanyaan: tipePertanyaan,
      formController: formController,
      kataJawban: (map["kataJawaban"] as String),
      idJawabanAsal: (map["idJawabanAsal"] as String),
      kataPertanyaan: (map["kataPertanyaan"] as String),
    );
  }

  @override
  Map<String, dynamic> getSoalData() {
    Map<String, dynamic> data = {};
    data = dataSoal.getDataMap();
    data['isWajib'] = isWajib ? 1 : 0;
    data['pertanyaanSoal'] = quillController.document.toDelta().toJson();
    data["urlGambar"] = urlGambar;
    data["modelPertanyaan"] = model.value;
    data["kataPertanyaan"] = kataPertanyaan;
    data["idJawabanAsal"] = idJawabanAsal;
    data["kataJawaban"] = kataJawban;
    return data;
  }
}

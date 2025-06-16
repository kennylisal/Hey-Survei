// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:flutter/material.dart' hide Text;
import 'package:flutter_quill/flutter_quill.dart';
import 'package:hei_survei/features/laporan/models/data_soal_lama.dart';

class PertanyaanKartu {
  QuillController quillController;
  String urlGambar;
  String modelPertanyaan;
  bool isWajib;
  // bool? showOpsiLainnya;
  String idSoal;
  //
  DataSoal dataSoal;
  PertanyaanKartu({
    required this.quillController,
    required this.urlGambar,
    required this.modelPertanyaan,
    required this.isWajib,
    // this.showOpsiLainnya,
    required this.idSoal,
    required this.dataSoal,
  });

  PertanyaanKartu copyWith({
    QuillController? quillController,
    String? urlGambar,
    String? modelPertanyaan,
    bool? isWajib,
    bool? showOpsiLainnya,
    String? idSoal,
    DataSoal? dataSoal,
  }) {
    return PertanyaanKartu(
      quillController: quillController ?? this.quillController,
      urlGambar: urlGambar ?? this.urlGambar,
      modelPertanyaan: modelPertanyaan ?? this.modelPertanyaan,
      isWajib: isWajib ?? this.isWajib,
      // showOpsiLainnya: showOpsiLainnya ?? this.showOpsiLainnya,
      idSoal: idSoal ?? this.idSoal,
      dataSoal: dataSoal ?? this.dataSoal,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'urlGambar': urlGambar,
      'modelPertanyaan': modelPertanyaan,
      'isWajib': isWajib,
      // 'showOpsiLainnya': showOpsiLainnya,
      'idSoal': idSoal,
      'dataSoal': dataSoal.toMap(),
    };
  }

  factory PertanyaanKartu.fromMap(Map<String, dynamic> map) {
    Delta pertanyaanSoal = Delta.fromJson(map['pertanyaanSoal']);
    late Document quilDoc;
    if (pertanyaanSoal.isEmpty) {
      quilDoc = Document()..insert(0, '');
    } else {
      quilDoc = Document.fromDelta(pertanyaanSoal);
    }
    return PertanyaanKartu(
      quillController: QuillController(
        document: quilDoc,
        selection: const TextSelection.collapsed(offset: 0),
      ),
      urlGambar: map['urlGambar'] as String,
      modelPertanyaan: map['modelPertanyaan'] as String,
      isWajib: (map['isWajib'] as int) == 1,
      // showOpsiLainnya: true,
      idSoal: map['idSoal'] as String,
      dataSoal: DataSoal.generateDataSoal(map),
    );
  }

  String toJson() => json.encode(toMap());

  factory PertanyaanKartu.fromJson(String source) =>
      PertanyaanKartu.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'PertanyaanKartu(quillController: $quillController, urlGambar: $urlGambar, modelPertanyaan: $modelPertanyaan, isWajib: $isWajib,  idSoal: $idSoal, dataSoal: $dataSoal)';
  }
}

class PertanyaanKartuCabang extends PertanyaanKartu {
  String kataJawaban;
  String kataPertanyaan;
  String idJawabanAsal; //ini id opsi

  PertanyaanKartuCabang({
    required super.quillController,
    required super.urlGambar,
    required super.modelPertanyaan,
    required super.isWajib,
    required super.idSoal,
    required super.dataSoal,
    required this.kataJawaban,
    required this.kataPertanyaan,
    required this.idJawabanAsal,
  });

  factory PertanyaanKartuCabang.fromMap(Map<String, dynamic> map) {
    Delta pertanyaanSoal = Delta.fromJson(map['pertanyaanSoal']);
    late Document quilDoc;
    if (pertanyaanSoal.isEmpty) {
      quilDoc = Document()..insert(0, '');
    } else {
      quilDoc = Document.fromDelta(pertanyaanSoal);
    }
    return PertanyaanKartuCabang(
      quillController: QuillController(
        document: quilDoc,
        selection: const TextSelection.collapsed(offset: 0),
      ),
      urlGambar: map['urlGambar'] as String,
      modelPertanyaan: map['modelPertanyaan'] as String,
      isWajib: (map['isWajib'] as int) == 1,
      // showOpsiLainnya: true,
      idSoal: map['idSoal'] as String,
      dataSoal: DataSoal.generateDataSoal(map),
      idJawabanAsal: (map["idJawabanAsal"] as String),
      kataPertanyaan: (map["kataPertanyaan"] as String),
      kataJawaban: (map["kataJawaban"] as String),
    );
  }
  factory PertanyaanKartuCabang.fromJson(String source) =>
      PertanyaanKartuCabang.fromMap(
          json.decode(source) as Map<String, dynamic>);
}

class PertanyaanKlasik {
  //soal
  QuillController quillController;
  bool isBergambar;
  String urlGambar;
  bool isWajib;
  bool showOpsiLainnya;
  String idSoal;
  DataSoal dataSoal;
  PertanyaanKlasik({
    required this.quillController,
    required this.isBergambar,
    required this.urlGambar,
    required this.isWajib,
    required this.showOpsiLainnya,
    required this.dataSoal,
    required this.idSoal,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'isBergambar': isBergambar,
      'urlGambar': urlGambar,
      'isWajib': isWajib,
      'showOpsiLainnya': showOpsiLainnya,
      'idSoal': idSoal,
      'dataSoal': dataSoal.toMap(),
    };
  }

  factory PertanyaanKlasik.fromMap(Map<String, dynamic> map) {
    if (map['isPembatas'] == null) {
      bool isBergambar = (map['isBergambar'] as int) == 1;
      Delta pertanyaanSoal = Delta.fromJson(map['pertanyaanSoal']);
      late Document quilDoc;
      if (pertanyaanSoal.isEmpty) {
        quilDoc = Document()..insert(0, '');
      } else {
        quilDoc = Document.fromDelta(pertanyaanSoal);
      }
      return PertanyaanKlasik(
        quillController: QuillController(
          document: quilDoc,
          selection: const TextSelection.collapsed(offset: 0),
        ),
        isBergambar: isBergambar,
        urlGambar: (isBergambar) ? map['urlGambarSoal'] as String : "",
        isWajib: (map['isWajib'] as int) == 1,
        showOpsiLainnya: true,
        idSoal: map['idSoal'] as String,
        dataSoal: DataSoal.generateDataSoal(map),
      );
    } else {
      // quill disimpan di quill controller
      //String batas disimpan di urlGambar
      Delta pertanyaanSoal = Delta.fromJson(map['petunjuk']);
      late Document quilDoc;
      if (pertanyaanSoal.isEmpty) {
        quilDoc = Document()..insert(0, '');
      } else {
        quilDoc = Document.fromDelta(pertanyaanSoal);
      }
      String bagian = map['bagian'] as String;
      return PertanyaanKlasik(
        quillController: QuillController(
          document: quilDoc,
          selection: const TextSelection.collapsed(offset: 0),
        ),
        isBergambar: false,
        urlGambar: bagian,
        isWajib: false,
        showOpsiLainnya: false,
        idSoal: "pembatas biasa",
        dataSoal: DataSoal(tipeSoal: "pembatas", idSoal: "pembatas"),
      );
    }
  }

  String toJson() => json.encode(toMap());

  factory PertanyaanKlasik.fromJson(String source) =>
      PertanyaanKlasik.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'Pertanyaan(quillController: $quillController, isBergambar: $isBergambar, urlGambar: $urlGambar, isWajib: $isWajib, showOpsiLainnya: $showOpsiLainnya, idSoal: $idSoal, dataSoal: $dataSoal)';
  }
}

class PertanyaanKlasikCabang extends PertanyaanKlasik {
  String kataJawaban;
  String kataPertanyaan;
  String idJawabanAsal; //ini id opsi

  PertanyaanKlasikCabang({
    required super.quillController,
    required super.isBergambar,
    required super.urlGambar,
    required super.isWajib,
    required super.showOpsiLainnya,
    required super.dataSoal,
    required super.idSoal,
    required this.kataJawaban,
    required this.kataPertanyaan,
    required this.idJawabanAsal,
  });

  factory PertanyaanKlasikCabang.fromMap(Map<String, dynamic> map) {
    bool isBergambar = (map['isBergambar'] as int) == 1;
    Delta pertanyaanSoal = Delta.fromJson(map['pertanyaanSoal']);
    late Document quilDoc;
    if (pertanyaanSoal.isEmpty) {
      quilDoc = Document()..insert(0, '');
    } else {
      quilDoc = Document.fromDelta(pertanyaanSoal);
    }
    return PertanyaanKlasikCabang(
      quillController: QuillController(
        document: quilDoc,
        selection: const TextSelection.collapsed(offset: 0),
      ),
      isBergambar: isBergambar,
      urlGambar: (isBergambar) ? map['urlGambarSoal'] as String : "",
      isWajib: (map['isWajib'] as int) == 1,
      showOpsiLainnya: true,
      idSoal: map['idSoal'] as String,
      dataSoal: DataSoal.generateDataSoal(map),
      idJawabanAsal: (map["idJawabanAsal"] as String),
      kataPertanyaan: (map["kataPertanyaan"] as String),
      kataJawaban: (map["kataJawaban"] as String),
    );
  }

  factory PertanyaanKlasikCabang.fromJson(String source) =>
      PertanyaanKlasikCabang.fromMap(
          json.decode(source) as Map<String, dynamic>);
}

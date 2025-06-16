// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';

class DataSoal {
  //Delta pertanyaanSoal;
  String tipeSoal;
  String idSoal;
  DataSoal({
    required this.tipeSoal,
    required this.idSoal,
    //required this.pertanyaanSoal,
  });

  DataSoal copyWith({
    String? tipeSoal,
    String? idSoal,
  }) {
    return DataSoal(
      tipeSoal: tipeSoal ?? this.tipeSoal,
      idSoal: idSoal ?? this.idSoal,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'tipeSoal': tipeSoal,
      'idSoal': idSoal,
    };
  }

  String toJson() => json.encode(toMap());

  factory DataSoal.fromMap(Map<String, dynamic> map) {
    return DataSoal(
      tipeSoal: map['tipeSoal'] as String,
      idSoal: map['idSoal'] as String,
    );
  }

  @override
  String toString() => 'DataSoal(, tipeSoal: $tipeSoal, idSoal: $idSoal)';

  factory DataSoal.generateDataSoal(Map<String, dynamic> map) {
    String tipeSoal = map['tipeSoal'] as String;
    if (tipeSoal == "Pilihan Ganda" || tipeSoal == "Kotak Centang") {
      return DataPilgan.fromMap(map);
    } else if (tipeSoal == "Slider Angka") {
      return DataSlider.fromMap(map);
    } else if (tipeSoal == "Gambar Ganda" || tipeSoal == "Carousel") {
      return DataGambarGanda.fromMap(map);
    } else if (tipeSoal == "Tabel") {
      return DataTabel.fromMap(map);
    } else if (tipeSoal == "Urutan Pilihan") {
      return DataUrutan.fromMap(map);
    } else {
      return DataSoal.fromMap(map);
    }
  }
}

class DataSlider extends DataSoal {
  int min;
  int max;
  TextEditingController labelMax;
  TextEditingController labelMin;
  DataSlider({
    required this.min,
    required this.max,
    required this.labelMin,
    required this.labelMax,
    required super.tipeSoal,
    required super.idSoal,
  });

  @override
  DataSlider copyWith({
    int? min,
    int? max,
    TextEditingController? labelMin,
    TextEditingController? labelMax,
    String? tipeSoal,
    String? idSoal,
    Delta? pertanyaanSoal,
  }) {
    return DataSlider(
      min: min ?? this.min,
      max: max ?? this.max,
      labelMin: labelMin ?? this.labelMin,
      labelMax: labelMax ?? this.labelMax,
      tipeSoal: tipeSoal ?? this.tipeSoal,
      idSoal: idSoal ?? this.idSoal,
    );
  }

  @override
  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'min': min,
      'max': max,
      'labelMin': labelMin.text,
      'labelMax': labelMax.text,
      'tipeSoal': tipeSoal,
      'idSoal': idSoal,
    };
  }

  @override
  String toJson() => json.encode(toMap());

  factory DataSlider.fromMap(Map<String, dynamic> map) {
    return DataSlider(
      min: map['min'] as int,
      max: map['max'] as int,
      labelMax: TextEditingController(text: map['labelMin'] as String),
      labelMin: TextEditingController(
        text: map['labelMax'] as String,
      ),
      tipeSoal: map['tipeSoal'] as String,
      idSoal: map['idSoal'] as String,
    );
  }

  @override
  String toString() {
    return 'DataSlider(min: $min, max: $max, labelMin: ${labelMin.text}, labelMax: ${labelMax.text}, tipeSoal: $tipeSoal)';
  }
}

class DataGambarGanda extends DataSoal {
  List<DataGambar> listDataGambar;
  // List<OpsiGambar> listOpsiGambar;

  DataGambarGanda({
    required super.tipeSoal,
    required super.idSoal,
    required this.listDataGambar,
    // required this.listOpsiGambar,
  });

  @override
  DataGambarGanda copyWith({
    List<DataGambar>? listDataGambar,
    // List<OpsiGambar>? listOpsiGambar,
    String? tipeSoal,
    String? idSoal,
  }) {
    return DataGambarGanda(
      listDataGambar: listDataGambar ?? this.listDataGambar,
      // listOpsiGambar: listOpsiGambar ?? this.listOpsiGambar,
      tipeSoal: tipeSoal ?? this.tipeSoal,
      idSoal: idSoal ?? this.idSoal,
    );
  }

  @override
  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'tipeSoal': tipeSoal,
      'listJawaban': List.generate(
        listDataGambar.length,
        (index) => {
          'jawaban': listDataGambar[index].getUrl(),
          'idJawaban': listDataGambar[index].idData,
        },
      ),
      'idSoal': idSoal,
    };
  }

  @override
  String toJson() => json.encode(toMap());

  //   @override
  // Map<String, dynamic> toMap() {
  //   return <String, dynamic>{
  //     'tipeSoal': tipeSoal,
  //     'listJawaban': List.generate(
  //         listDataGambar.length, (index) => listDataGambar[index].getUrl()),
  //     'idSoal': idSoal,
  //   };
  // }

  // @override
  // String toJson() => json.encode(toMap());

  @override
  String toString() =>
      'DataGambarGanda(listDataGambar: ${listDataGambar.toString()},)';

  // factory DataGambarGanda.fromMap(Map<String, dynamic> map) {
  //   return DataGambarGanda(
  //     tipeSoal: map['tipeSoal'] as String,
  //     idSoal: map['idSoal'] as String,
  //     listDataGambar: [
  //       for (final jawaban in map['listJawaban'] as List)
  //         DataGambar(
  //           urlGambar: jawaban,
  //           idData: const Uuid().v4(),
  //           isError: false,
  //         ),
  //     ],
  //     listOpsiGambar: [],
  //   );
  // }
  factory DataGambarGanda.fromMap(Map<String, dynamic> map) {
    List<DataGambar> tempData = [];
    for (final jawaban in map['listJawaban'] as List) {
      tempData.add(DataGambar(
        urlGambar: jawaban['jawaban'] as String,
        idData: jawaban['idJawaban'] as String,
        isError: false,
      ));
    }
    return DataGambarGanda(
      tipeSoal: map['tipeSoal'] as String,
      idSoal: map['idSoal'] as String,
      listDataGambar: tempData,
      // listOpsiGambar: [],
    );
  }
}

class DataUrutan extends DataSoal {
  List<TextEditingController> listController;
  // List<OpsiUrutan> listOpsiUrutan;
  List<DataOpsi> listDataOpsi;
  DataUrutan({
    required super.tipeSoal,
    required super.idSoal,
    required this.listController,
    // required this.listOpsiUrutan,
    required this.listDataOpsi,
  });
  @override
  DataUrutan copyWith({
    List<TextEditingController>? listController,
    // List<OpsiUrutan>? listOpsiUrutan,
    String? tipeSoal,
    String? idSoal,
    List<DataOpsi>? listDataOpsi,
  }) {
    return DataUrutan(
      listController: listController ?? this.listController,
      tipeSoal: tipeSoal ?? this.tipeSoal,
      idSoal: idSoal ?? this.idSoal,
      // listOpsiUrutan: listOpsiUrutan ?? this.listOpsiUrutan,
      listDataOpsi: listDataOpsi ?? this.listDataOpsi,
    );
  }

  @override
  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'tipeSoal': tipeSoal,
      'idSoal': idSoal,
      'listJawaban': List.generate(
        listController.length,
        (index) => {
          'jawaban': listController[index].text,
          'idJawaban': listDataOpsi[index].idData,
        },
        //     {
        //   'jawaban': listController[index].text,
        //   'idJawaban': 'xert',
        // },
      ),
    };
  }

  // factory DataUrutan.fromMap(Map<String, dynamic> map) {
  //   return DataUrutan(
  //     tipeSoal: map['tipeSoal'] as String,
  //     idSoal: map['idSoal'] as String,
  //     listController: [
  //       for (final jawaban in map['listJawaban'] as List)
  //         TextEditingController(text: jawaban as String)
  //     ],
  //     listOpsiUrutan: [],
  //     listDataOpsi: [],
  //   );
  // }

  factory DataUrutan.fromMap(Map<String, dynamic> map) {
    List<DataOpsi> tempData = [];
    for (final jawaban in map['listJawaban'] as List) {
      tempData.add(
        DataOpsi(
          text: jawaban['jawaban'],
          idData: jawaban['idJawaban'],
        ),
      );
    }
    return DataUrutan(
      tipeSoal: map['tipeSoal'] as String,
      idSoal: map['idSoal'] as String,
      listController: List.generate(tempData.length,
          (index) => TextEditingController(text: tempData[index].text)),
      // listOpsiUrutan: [],
      listDataOpsi: tempData,
    );
  }
}

class DataPilgan extends DataSoal {
  bool lainnya;
  List<DataOpsi> listJawaban;
  // List<OpsiJawaban> listOpsiJawaban;
  List<TextEditingController> listController;
  DataPilgan({
    required this.lainnya,
    required this.listJawaban,
    required super.tipeSoal,
    required super.idSoal,
    // required this.listOpsiJawaban,
    required this.listController,
  });

  @override
  DataPilgan copyWith({
    bool? lainnya,
    List<DataOpsi>? listJawaban,
    // List<OpsiJawaban>? listOpsiJawaban,
    Delta? pertanyaanSoal,
    String? tipeSoal,
    String? idSoal,
    List<TextEditingController>? listController,
  }) {
    return DataPilgan(
      lainnya: lainnya ?? this.lainnya,
      listJawaban: listJawaban ?? this.listJawaban,
      // listOpsiJawaban: listOpsiJawaban ?? this.listOpsiJawaban,
      tipeSoal: tipeSoal ?? this.tipeSoal,
      idSoal: idSoal ?? this.idSoal,
      listController: listController ?? this.listController,
    );
  }

  @override
  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'tipeSoal': tipeSoal,
      'lainnya': lainnya ? 1 : 0,
      'listJawaban': List.generate(
          listController.length,
          (index) => {
                'jawaban': listController[index].text,
                'idJawaban': listJawaban[index].idData,
              }),
      'idSoal': idSoal,
    };
  }

  @override
  String toJson() => json.encode(toMap());

  factory DataPilgan.fromMap(Map<String, dynamic> map) {
    //siapkan meman data opsi disini
    List<DataOpsi> tempData = [];
    for (final jawaban in map['listJawaban'] as List) {
      tempData.add(DataOpsi(
        text: jawaban['jawaban'],
        idData: jawaban['idJawaban'],
      ));
    }

    return DataPilgan(
        // listOpsiJawaban: [],
        tipeSoal: map['tipeSoal'] as String,
        lainnya: (map['lainnya'] as int) == 1 ? true : false,
        idSoal: map['idSoal'] as String,
        listJawaban: tempData,
        listController: [
          for (final data in tempData) TextEditingController(text: data.text)
        ]);
  }

  @override
  String toString() => 'DataPilgan(listJawaban: $listJawaban || $idSoal)';
}

class DataTabel extends DataSoal {
  int baris;
  int kolom;
  bool berjudul;
  List<TextEditingController> listJudul;

  DataTabel({
    required super.tipeSoal,
    required super.idSoal,
    required this.kolom,
    required this.baris,
    this.berjudul = false,
    required this.listJudul,
  });

  @override
  DataTabel copyWith({
    int? baris,
    int? kolom,
    String? idSoal,
    String? tipeSoal,
    Delta? pertanyaanSoal,
    List<TextEditingController>? listJudul,
    bool? berjudul,
  }) {
    return DataTabel(
      baris: baris ?? this.baris,
      kolom: kolom ?? this.kolom,
      idSoal: idSoal ?? this.idSoal,
      tipeSoal: tipeSoal ?? this.tipeSoal,
      // pertanyaanSoal: pertanyaanSoal ?? this.pertanyaanSoal,
      listJudul: listJudul ?? this.listJudul,
      berjudul: berjudul ?? this.berjudul,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'baris': baris,
      'kolom': kolom,
      'berjudul': berjudul ? 1 : 0,
      'listJudul': List.generate(baris, (index) => listJudul[index].text),
      'tipeSoal': tipeSoal,
      'idSoal': idSoal,
    };
  }

  String toJson() => json.encode(toMap());

  factory DataTabel.fromMap(Map<String, dynamic> map) {
    int baris = map['baris'] as int;

    List<String> listJudul = List<String>.from(map['listJudul'] as List);

    List<TextEditingController> judul = [];

    for (var i = 0; i < 3; i++) {
      if (i < listJudul.length) {
        judul.add(TextEditingController(text: listJudul[i]));
      } else {
        judul.add(TextEditingController(text: "Judul ${i + 1}"));
      }
    }

    // for (var i = 0; i < 3 - baris; i++) {
    //   listJudul.add("Judul ${listJudul.length + 1}");
    // }

    //itu diatas ritual kalau jumlah barisnya kurang 3
    return DataTabel(
      // pertanyaanSoal: Delta.fromJson(map['pertanyaanSoal']),
      idSoal: map['idSoal'] as String,
      tipeSoal: map['tipeSoal'] as String,
      baris: baris,
      kolom: map['kolom'] as int,
      berjudul: (map['berjudul'] as int) == 1 ? true : false,
      listJudul: judul,
      // listJudul: List<String>.from((map['listJudul'] as List<String>),
    );
  }
  //factory DataTabel.fromJson(String source) => DataTabel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'DataTabel(baris: $baris, kolom: $kolom, berjudul: $berjudul, listJudul: $listJudul)';
  }
}

class DataOpsi {
  String text;
  String idData;
  DataOpsi({
    required this.text,
    required this.idData,
  });

  DataOpsi copyWith({
    String? text,
    String? idData,
  }) {
    return DataOpsi(
      text: text ?? this.text,
      idData: idData ?? this.idData,
    );
  }

  String getText() {
    return text;
  }

  @override
  String toString() => 'DataOpsi(text: $text, idData: $idData)';
}

class DataGambar {
  String urlGambar;
  String idData;
  bool isError;
  DataGambar({
    required this.urlGambar,
    required this.idData,
    required this.isError,
  });

  DataGambar copyWith({
    String? urlGambar,
    String? idData,
    bool? isError,
  }) {
    return DataGambar(
      urlGambar: urlGambar ?? this.urlGambar,
      idData: idData ?? this.idData,
      isError: isError ?? this.isError,
    );
  }

  String getUrl() {
    return urlGambar;
  }

  @override
  String toString() =>
      'DataGambar(urlGambar: $urlGambar, idData: $idData, isError: $isError)';
}

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:hei_survei/features/form/constant.dart';

class DataSoal {
  Tipesoal tipeSoal;
  String idSoal;
  DataSoal({
    required this.tipeSoal,
    required this.idSoal,
  });

  gantiIdSoal(String idSoalBaru) {
    idSoal = idSoalBaru;
  }

  DataSoal copyWith({
    Tipesoal? tipeSoal,
    String? idSoal,
  }) {
    return DataSoal(
      tipeSoal: tipeSoal ?? this.tipeSoal,
      idSoal: idSoal ?? this.idSoal,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'tipeSoal': tipeSoal.value,
      'idSoal': idSoal,
    };
  }

  factory DataSoal.fromMap(Map<String, dynamic> map) {
    String tipe = map['tipeSoal'] as String;
    return DataSoal(
      tipeSoal: Tipesoal.values.firstWhere((element) => element.value == tipe),
      idSoal: map['idSoal'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory DataSoal.fromJson(String source) =>
      DataSoal.fromMap(json.decode(source) as Map<String, dynamic>);

  DataSlider getDataSlider() => this as DataSlider;
  DataGambarGanda getDataGG() => this as DataGambarGanda;
  DataUrutan getDataUrutan() => this as DataUrutan;
  DataPilgan getDataPilgan() => this as DataPilgan;
  DataTabel getDataTabel() => this as DataTabel;

  factory DataSoal.generateData(Map<String, dynamic> map) {
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

  DataSoal copyDataSoal() {
    if (tipeSoal == Tipesoal.pilihanGanda ||
        tipeSoal == Tipesoal.kotakCentang) {
      return this as DataPilgan;
    } else if (tipeSoal == Tipesoal.gambarGanda ||
        tipeSoal == Tipesoal.carousel) {
      return this as DataGambarGanda;
    } else if (tipeSoal == Tipesoal.sliderAngka) {
      return this as DataSlider;
    } else if (tipeSoal == Tipesoal.tabel) {
      return this as DataTabel;
    } else if (tipeSoal == Tipesoal.urutanPilihan) {
      return this as DataUrutan;
    } else {
      return this;
    }
  }

  Map<String, dynamic> getDataMap() {
    if (tipeSoal == Tipesoal.pilihanGanda ||
        tipeSoal == Tipesoal.kotakCentang) {
      return (this as DataPilgan).toMap();
    } else if (tipeSoal == Tipesoal.gambarGanda ||
        tipeSoal == Tipesoal.carousel) {
      return (this as DataGambarGanda).toMap();
    } else if (tipeSoal == Tipesoal.sliderAngka) {
      return (this as DataSlider).toMap();
    } else if (tipeSoal == Tipesoal.tabel) {
      return (this as DataTabel).toMap();
    } else if (tipeSoal == Tipesoal.urutanPilihan) {
      return (this as DataUrutan).toMap();
    } else {
      return toMap();
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
    required super.idSoal,
    required super.tipeSoal,
  });

  @override
  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'min': min,
      'max': max,
      'labelMin': labelMin.text,
      'labelMax': labelMax.text,
      'tipeSoal': tipeSoal.value,
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
      tipeSoal: Tipesoal.sliderAngka,
      idSoal: map['idSoal'] as String,
    );
  }

  @override
  String toString() {
    return 'DataSlider(min: $min, max: $max, labelMin: ${labelMin.text}, labelMax: ${labelMax.text}, tipeSoal: $tipeSoal)';
  }

  @override
  DataSlider copyWith({
    int? min,
    int? max,
    TextEditingController? labelMax,
    TextEditingController? labelMin,
    Tipesoal? tipeSoal,
    String? idSoal,
  }) {
    return DataSlider(
      min: min ?? this.min,
      max: max ?? this.max,
      labelMax: labelMax ?? this.labelMax,
      labelMin: labelMin ?? this.labelMin,
      tipeSoal: tipeSoal ?? this.tipeSoal,
      idSoal: idSoal ?? this.idSoal,
    );
  }
}

class DataGambarGanda extends DataSoal {
  List<DataOpsi> listDataGambar;
  DataGambarGanda({
    required super.tipeSoal,
    required super.idSoal,
    required this.listDataGambar,
  });

  @override
  DataGambarGanda copyWith({
    List<DataOpsi>? listDataGambar,
    Tipesoal? tipeSoal,
    String? idSoal,
  }) {
    return DataGambarGanda(
      listDataGambar: listDataGambar ?? this.listDataGambar,
      tipeSoal: tipeSoal ?? this.tipeSoal,
      idSoal: idSoal ?? this.idSoal,
    );
  }

  @override
  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'tipeSoal': tipeSoal.value,
      'listJawaban': List.generate(
        listDataGambar.length,
        (index) => {
          'jawaban': listDataGambar[index].text,
          'idJawaban': listDataGambar[index].idData,
        },
      ),
      'idSoal': idSoal,
    };
  }

  factory DataGambarGanda.fromMap(Map<String, dynamic> map) {
    List<DataOpsi> tempData = [];

    for (final jawaban in map['listJawaban'] as List) {
      tempData.add(DataOpsi(
          text: jawaban['jawaban'] as String,
          idData: jawaban['idJawaban'] as String,
          textController: TextEditingController()));
    }
    String tipe = map['tipeSoal'] as String;
    Tipesoal tipePertanyaan =
        Tipesoal.values.firstWhere((element) => element.value == tipe);
    return DataGambarGanda(
      tipeSoal: tipePertanyaan,
      idSoal: map['idSoal'] as String,
      listDataGambar: tempData,
    );
  }
}

class DataUrutan extends DataSoal {
  List<DataOpsi> listDataOpsi;
  DataUrutan({
    required super.tipeSoal,
    required super.idSoal,
    required this.listDataOpsi,
  });

  @override
  DataUrutan copyWith({
    Tipesoal? tipeSoal,
    String? idSoal,
    List<DataOpsi>? listDataOpsi,
  }) {
    return DataUrutan(
      tipeSoal: tipeSoal ?? this.tipeSoal,
      idSoal: idSoal ?? this.idSoal,
      listDataOpsi: listDataOpsi ?? this.listDataOpsi,
    );
  }

  @override
  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'tipeSoal': tipeSoal.value,
      'idSoal': idSoal,
      'listJawaban': List.generate(
        listDataOpsi.length,
        (index) => {
          'jawaban': listDataOpsi[index].textController.text,
          'idJawaban': listDataOpsi[index].idData,
        },
      ),
    };
  }

  factory DataUrutan.fromMap(Map<String, dynamic> map) {
    List<DataOpsi> tempData = [];
    for (final jawaban in map['listJawaban'] as List) {
      tempData.add(
        DataOpsi(
          text: jawaban['jawaban'],
          idData: jawaban['idJawaban'],
          textController: TextEditingController(
            text: jawaban['jawaban'],
          ),
        ),
      );
    }

    return DataUrutan(
      tipeSoal: Tipesoal.urutanPilihan,
      idSoal: map['idSoal'] as String,
      listDataOpsi: tempData,
    );
  }
}

class DataPilgan extends DataSoal {
  bool lainnya;
  List<DataOpsi> listJawaban;

  DataPilgan({
    required this.lainnya,
    required this.listJawaban,
    required super.tipeSoal,
    required super.idSoal,
  });
  @override
  DataPilgan copyWith({
    bool? lainnya,
    List<DataOpsi>? listJawaban,
    Tipesoal? tipeSoal,
    String? idSoal,
  }) {
    return DataPilgan(
      lainnya: lainnya ?? this.lainnya,
      listJawaban: listJawaban ?? this.listJawaban,
      tipeSoal: tipeSoal ?? this.tipeSoal,
      idSoal: idSoal ?? this.idSoal,
    );
  }

  @override
  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'tipeSoal': tipeSoal.value,
      'lainnya': lainnya ? 1 : 0,
      'listJawaban': List.generate(
          listJawaban.length,
          (index) => {
                'jawaban': listJawaban[index].textController.text,
                'idJawaban': listJawaban[index].idData,
              }),
      'idSoal': idSoal,
    };
  }

  factory DataPilgan.fromMap(Map<String, dynamic> map) {
    String idSoal = map['idSoal'] as String;

    Tipesoal tipesoal = Tipesoal.values
        .firstWhere((element) => element.value == map['tipeSoal'] as String);

    List<DataOpsi> tempData = [];
    for (final jawaban in map['listJawaban'] as List) {
      tempData.add(
        DataOpsi(
          text: jawaban['jawaban'],
          idData: jawaban['idJawaban'],
          textController: TextEditingController(
            text: jawaban['jawaban'],
          ),
        ),
      );
    }

    return DataPilgan(
      tipeSoal: tipesoal,
      lainnya: (map['lainnya'] as int) == 1 ? true : false,
      idSoal: idSoal,
      listJawaban: tempData,
    );
  }
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
    Tipesoal? tipeSoal,
    List<TextEditingController>? listJudul,
    bool? berjudul,
  }) {
    return DataTabel(
      baris: baris ?? this.baris,
      kolom: kolom ?? this.kolom,
      idSoal: idSoal ?? this.idSoal,
      tipeSoal: tipeSoal ?? this.tipeSoal,
      listJudul: listJudul ?? this.listJudul,
      berjudul: berjudul ?? this.berjudul,
    );
  }

  @override
  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'baris': baris,
      'kolom': kolom,
      'berjudul': berjudul ? 1 : 0,
      'listJudul': List.generate(baris, (index) => listJudul[index].text),
      'tipeSoal': tipeSoal.value,
      'idSoal': idSoal,
    };
  }

  @override
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
    return DataTabel(
      idSoal: map['idSoal'] as String,
      tipeSoal: Tipesoal.tabel,
      baris: baris,
      kolom: map['kolom'] as int,
      berjudul: (map['berjudul'] as int) == 1 ? true : false,
      listJudul: judul,
    );
  }

  @override
  String toString() {
    return 'DataTabel(baris: $baris, kolom: $kolom, berjudul: $berjudul, listJudul: $listJudul)';
  }
}

class DataOpsi {
  String text;
  String idData;
  TextEditingController textController;
  DataOpsi({
    required this.text,
    required this.idData,
    required this.textController,
  });

  DataOpsi copyWith({
    String? text,
    String? idData,
    TextEditingController? textController,
  }) {
    return DataOpsi(
      text: text ?? this.text,
      idData: idData ?? this.idData,
      textController: textController ?? this.textController,
    );
  }

  String getText() {
    return text;
  }

  @override
  String toString() => 'DataOpsi(text: $text, idData: $idData)';
}

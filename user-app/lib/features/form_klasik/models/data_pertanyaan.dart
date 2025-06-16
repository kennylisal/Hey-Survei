import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:survei_aplikasi/features/form_klasik/constant.dart';

class DataPertanyaan {
  Tipesoal tipeSoal;
  String idSoal;
  DataPertanyaan({
    required this.tipeSoal,
    required this.idSoal,
  });

  factory DataPertanyaan.generateData(Map<String, dynamic> map) {
    String tipeSoal = map['tipeSoal'] as String;
    if (tipeSoal == "Pilihan Ganda") {
      return DataPilgan.fromMap(map);
    } else if (tipeSoal == "Kotak Centang") {
      return DataCheckBox.fromMap(map);
    } else if (tipeSoal == "Slider Angka") {
      return DataSlider.fromMap(map);
    } else if (tipeSoal == "Gambar Ganda" || tipeSoal == "Carousel") {
      return DataGambarGanda.fromMap(map);
    } else if (tipeSoal == "Tabel") {
      return DataTabel.fromMap(map);
    } else if (tipeSoal == "Urutan Pilihan") {
      return DataUrutan.fromMap(map);
    } else if (tipeSoal == "Waktu") {
      return DataWaktu.fromMap(map);
    } else if (tipeSoal == "Teks") {
      return DataTeks.fromMap(map);
    } else if (tipeSoal == "Teks Paragraf") {
      return DataTeks.fromMap(map);
    } else if (tipeSoal == "Tanggal") {
      return DataTanggal.fromMap(map);
    } else if (tipeSoal == "Image Picker") {
      return DataGambar.fromMap(map);
    } else {
      return DataAngka.fromMap(map);
    }
  }
}

class DataSlider extends DataPertanyaan {
  int min;
  int max;
  late double nilai;
  String labelMin;
  String labelMax;
  DataSlider({
    required this.min,
    required this.max,
    required this.labelMin,
    required this.labelMax,
    required super.tipeSoal,
    required super.idSoal,
  }) {
    nilai = min.toDouble();
  }

  Map<String, dynamic> toMap() {
    return {
      'tipeSoal': tipeSoal.value,
      'idSoal': idSoal,
      'jawaban': nilai,
    };
  }

  String toJson() => json.encode(toMap());

  factory DataSlider.fromMap(Map<String, dynamic> map) {
    return DataSlider(
      tipeSoal: Tipesoal.values.firstWhere(
          (element) => element.value == (map['tipeSoal'] as String)),
      idSoal: map['idSoal'] as String,
      labelMin: map['labelMin'] as String,
      labelMax: map['labelMax'] as String,
      min: map['min'] as int,
      max: map['max'] as int,
    );
  }
}

//*************asdasd */
class DataCheckBox extends DataPertanyaan {
  bool lainnya;
  List<DataOpsi> listOpsi;
  late Map<String, bool> mapCheck;
  DataCheckBox({
    required this.lainnya,
    required super.tipeSoal,
    required super.idSoal,
    required this.listOpsi,
    // required List<String> pilihanJawaban,
  }) {
    mapCheck = {for (final data in listOpsi) data.idPilihan: false};
    // mapCheck = Map.fromIterables(
    //   listOpsi,
    //   List.generate(pilihanJawaban.length, (index) => false),
    // );
    if (lainnya) mapCheck["Lainnya"] = false;
  }
  Map<String, dynamic> toMap() {
    final jawaban = [];
    for (final e in listOpsi) {
      if (mapCheck[e.idPilihan]!) {
        jawaban.add({
          'jawaban': e.pilihan,
          'idJawaban': e.idPilihan,
        });
      }
    }
    return {
      'tipeSoal': tipeSoal.value,
      'idSoal': idSoal,
      'jawaban': jawaban,
    };
  }

  String toJson() => json.encode(toMap());

  factory DataCheckBox.fromMap(Map<String, dynamic> map) {
    bool pakaiLainnya = (map['lainnya'] as int) == 1 ? true : false;
    return DataCheckBox(
        tipeSoal: Tipesoal.values.firstWhere(
            (element) => element.value == (map['tipeSoal'] as String)),
        idSoal: map['idSoal'] as String,
        lainnya: pakaiLainnya,
        listOpsi: [
          for (final jawaban in map['listJawaban'] as List)
            DataOpsi(
              pilihan: jawaban['jawaban'] as String,
              idPilihan: jawaban['idJawaban'] as String,
            ),
          if (pakaiLainnya)
            DataOpsi(
              pilihan: "Lainnya",
              idPilihan: 'Lainnya-xyz',
            ),
        ]);
  }
}

class DataTabel extends DataPertanyaan {
  int baris;
  int kolom;
  bool berjudul;
  List<String> listJudul;
  Map<int, List<TextEditingController>> mapController = {};
  DataTabel({
    required super.tipeSoal,
    required super.idSoal,
    required this.kolom,
    required this.baris,
    required this.berjudul,
    required this.listJudul,
  }) {
    //baris ->
    // kolom kebawah
    for (var i = 0; i < baris; i++) {
      mapController[i] = [
        for (var j = 0; j < kolom; j++) TextEditingController()
      ];
    }
  }

  Map<String, dynamic> toMap() {
    Map<String, List<String>> mapKiriman = {};
    for (final key in mapController.keys) {
      mapKiriman[key.toString()] = List.generate(mapController[key]!.length,
          (index) => mapController[key]![index].text);
    }
    // print(mapKiriman);
    return {
      'tipeSoal': tipeSoal.value,
      'idSoal': idSoal,
      'kolom': kolom,
      'baris': baris,
      'berjudul': berjudul,
      'jawaban': mapKiriman,
      // 'dataTabel': json.encode(mapKiriman),
    };
  }

  String toJson() => json.encode(toMap());
  factory DataTabel.fromMap(Map<String, dynamic> map) {
    int baris = map['baris'] as int;
    bool berjudul = (map['berjudul'] as int) == 1 ? true : false;
    List<String> judul = [];
    if (berjudul) {
      for (final element in map['listJudul'] as List) {
        judul.add(element as String);
      }
      //judul = List<String>.from(map['listJudul'] as List);
    }
    //print(map['listJudul']);
    for (var i = 0; i < 3 - baris; i++) {
      judul.add("Judul ${judul.length + 1}");
    }
    print(judul);
    return DataTabel(
      tipeSoal: Tipesoal.values.firstWhere(
          (element) => element.value == (map['tipeSoal'] as String)),
      idSoal: map['idSoal'] as String,
      baris: baris,
      kolom: map['kolom'] as int,
      berjudul: (map['berjudul'] as int) == 1 ? true : false,
      listJudul: judul,
    );
  }
}

class DataOpsi {
  String pilihan;
  String idPilihan;
  DataOpsi({
    required this.pilihan,
    required this.idPilihan,
  });

  @override
  String toString() =>
      'PilihanPilgan(pilihan: $pilihan, idPilihan: $idPilihan)';
}

class DataPilgan extends DataPertanyaan {
  List<DataOpsi> listPilihan;
  DataOpsi pilihan = DataOpsi(pilihan: "zxc", idPilihan: "zxc");

  DataPilgan({
    required super.tipeSoal,
    required super.idSoal,
    required this.listPilihan,
    required bool lainnya,
  }) {
    // if (lainnya)
    //   listPilihan.add(DataOpsi(pilihan: 'Lainnya', idPilihan: "pilihan LainX"));
  }
  Map<String, dynamic> toMap() {
    return {
      'tipeSoal': tipeSoal.value,
      'idSoal': idSoal,
      'jawaban': {
        'pilihan': pilihan.pilihan,
        'idPilihan': pilihan.idPilihan,
      }
      // 'jawaban': pilihan,
    };
  }

  String toJson() => json.encode(toMap());

  factory DataPilgan.fromMap(Map<String, dynamic> map) {
    bool pakaiLainnya = (map['lainnya'] as int) == 1 ? true : false;
    return DataPilgan(
      tipeSoal: Tipesoal.values.firstWhere(
          (element) => element.value == (map['tipeSoal'] as String)),
      idSoal: map['idSoal'] as String,
      lainnya: pakaiLainnya,
      //pilihan: "",
      listPilihan: [
        for (final jawaban in map['listJawaban'] as List)
          DataOpsi(
            pilihan: jawaban['jawaban'] as String,
            idPilihan: jawaban['idJawaban'] as String,
          ),
        if (pakaiLainnya)
          DataOpsi(
            pilihan: "Lainnya",
            idPilihan: 'Lainnya-xyz',
          ),
      ],
    );
  }

  @override
  String toString() =>
      'DataPilgan(listPilihan: $listPilihan, pilihan: $pilihan)';
}

class DataUrutan extends DataPertanyaan {
  List<DataOpsi> listPilihan;

  DataUrutan({
    required super.tipeSoal,
    required super.idSoal,
    required this.listPilihan,
  });

  Map<String, dynamic> toMap() {
    return {
      'tipeSoal': tipeSoal.value,
      'idSoal': idSoal,
      'jawaban': [
        for (var e in listPilihan)
          {
            'pilihan': e.pilihan,
            'idPilihan': e.idPilihan,
          },
      ]
    };
  }

  String toJson() => json.encode(toMap());

  factory DataUrutan.fromMap(Map<String, dynamic> map) {
    return DataUrutan(
      tipeSoal: Tipesoal.values.firstWhere(
          (element) => element.value == (map['tipeSoal'] as String)),
      idSoal: map['idSoal'] as String,
      listPilihan: [
        // for (final jawaban in map['listJawaban'] as List) jawaban as String
        for (final jawaban in map['listJawaban'] as List)
          DataOpsi(
            pilihan: jawaban['jawaban'] as String,
            idPilihan: jawaban['idJawaban'] as String,
          ),
      ],
    );
  }
}

class DataWaktu extends DataPertanyaan {
  TimeOfDay? waktu;
  DataWaktu({
    required super.tipeSoal,
    required super.idSoal,
    this.waktu,
  });
  Map<String, dynamic> toMap() {
    Map<String, int> jawaban = {};
    if (waktu == null) {
      jawaban = {'jam': 99, 'menit': 99};
    } else {
      jawaban = {
        'jam': waktu!.hour,
        'menit': waktu!.minute,
      };
    }

    return {
      'tipeSoal': tipeSoal.value,
      'idSoal': idSoal,
      'jawaban': jawaban,
    };
  }

  String toJson() => json.encode(toMap());

  factory DataWaktu.fromMap(Map<String, dynamic> map) {
    return DataWaktu(
      tipeSoal: Tipesoal.values.firstWhere(
          (element) => element.value == (map['tipeSoal'] as String)),
      idSoal: map['idSoal'] as String,
      waktu: null,
    );
  }
}

class DataTanggal extends DataPertanyaan {
  DateTime? date;

  DataTanggal({
    required super.tipeSoal,
    required super.idSoal,
    this.date,
  });

  Map<String, dynamic> toMap() {
    int tanggalKiriman = (date == null) ? -1 : date!.millisecondsSinceEpoch;
    return {
      'tipeSoal': tipeSoal.value,
      'idSoal': idSoal,
      'jawaban': tanggalKiriman,
    };
  }

  String toJson() => json.encode(toMap());

  factory DataTanggal.fromMap(Map<String, dynamic> map) {
    return DataTanggal(
      tipeSoal: Tipesoal.values.firstWhere(
          (element) => element.value == (map['tipeSoal'] as String)),
      idSoal: map['idSoal'] as String,
      // date: DateTime.now(),
      date: null,
    );
  }
}

class DataGambar extends DataPertanyaan {
  String urlGambar;

  DataGambar({
    required super.tipeSoal,
    required super.idSoal,
    required this.urlGambar,
  });

  Map<String, dynamic> toMap() {
    return {
      'tipeSoal': tipeSoal.value,
      'idSoal': idSoal,
      'jawaban': (urlGambar == "") ? "zxc" : urlGambar,
    };
  }

  String toJson() => json.encode(toMap());

  factory DataGambar.fromMap(Map<String, dynamic> map) {
    return DataGambar(
      tipeSoal: Tipesoal.values.firstWhere(
          (element) => element.value == (map['tipeSoal'] as String)),
      idSoal: map['idSoal'] as String,
      urlGambar: "",
    );
  }
}

class DataTeks extends DataPertanyaan {
  TextEditingController textController;
  DataTeks({
    required super.tipeSoal,
    required super.idSoal,
    required this.textController,
  });

  Map<String, dynamic> toMap() {
    return {
      'tipeSoal': tipeSoal.value,
      'idSoal': idSoal,
      'jawaban': textController.text,
    };
  }

  factory DataTeks.fromMap(Map<String, dynamic> map) {
    return DataTeks(
      tipeSoal: Tipesoal.values.firstWhere(
          (element) => element.value == (map['tipeSoal'] as String)),
      idSoal: map['idSoal'] as String,
      textController: TextEditingController(),
    );
  }

  //factory DataTeks.fromJson(String source) => DataTeks.fromMap(json.decode(source) as Map<String, dynamic>);
}

class DataAngka extends DataPertanyaan {
  TextEditingController textEditingController;

  DataAngka({
    required super.tipeSoal,
    required super.idSoal,
    required this.textEditingController,
  });

  Map<String, dynamic> toMap() {
    int jawaban = (textEditingController.text == "")
        ? -1
        : int.parse(textEditingController.text);
    return {
      'tipeSoal': tipeSoal.value,
      'idSoal': idSoal,
      'jawaban': jawaban,
    };
  }

  factory DataAngka.fromMap(Map<String, dynamic> map) {
    return DataAngka(
      tipeSoal: Tipesoal.values.firstWhere(
          (element) => element.value == (map['tipeSoal'] as String)),
      idSoal: map['idSoal'] as String,
      textEditingController: TextEditingController(),
    );
  }
}

class DataGambarGanda extends DataPertanyaan {
  List<DataOpsi> listUrlGambar;
  DataOpsi pilihan = DataOpsi(pilihan: "zxc", idPilihan: "zxc");
  DataGambarGanda({
    required super.tipeSoal,
    required super.idSoal,
    required this.listUrlGambar,
  });

  Map<String, dynamic> toMap() {
    return {
      'tipeSoal': tipeSoal.value,
      'idSoal': idSoal,
      'jawaban': {
        'pilihan': pilihan.pilihan,
        'idPilihan': pilihan.idPilihan,
      },
    };
  }

  String toJson() => json.encode(toMap());

  factory DataGambarGanda.fromMap(Map<String, dynamic> map) {
    return DataGambarGanda(
        tipeSoal: Tipesoal.values.firstWhere(
            (element) => element.value == (map['tipeSoal'] as String)),
        idSoal: map['idSoal'] as String,
        listUrlGambar: [
          for (final jawaban in map['listJawaban'] as List)
            DataOpsi(
              pilihan: jawaban['jawaban'] as String,
              idPilihan: jawaban['idJawaban'] as String,
            )
        ]);
  }
}

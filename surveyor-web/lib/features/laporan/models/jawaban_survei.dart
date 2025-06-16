import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:hei_survei/features/laporan/state/data_kumpulan_jawaban.dart';

// ignore_for_file: public_member_api_docs, sort_constructors_first
class ResponSurvei {
  DateTime tglPengisian;
  String emailPenjawab;
  List<JawabanPertanyaan> daftarJawaban;
  ResponSurvei({
    required this.tglPengisian,
    required this.emailPenjawab,
    required this.daftarJawaban,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'tglMenjawab': tglPengisian.millisecondsSinceEpoch,
      'emailPenjawab': emailPenjawab,
      'daftarJawaban': daftarJawaban.map((x) => x.toMap()).toList(),
    };
  }

  factory ResponSurvei.fromMap(Map<String, dynamic> map) {
    final tgl = map['tglPengisian'] as Timestamp;
    List<dynamic> listTemp = map['daftarJawaban'] as List<dynamic>;
    return ResponSurvei(
      tglPengisian: DateTime.fromMillisecondsSinceEpoch(tgl.seconds * 1000),
      emailPenjawab: map['emailPenjawab'] as String,
      daftarJawaban: List.generate(listTemp.length, (index) {
        return JawabanPertanyaan.fromJson(json.encode(listTemp[index]));
      }),
    );
  }
  //ini berhubungan dengan getPertanyaanFormKlasikX
  factory ResponSurvei.fromMapX(
      Map<String, dynamic> map, DataKumpulanJawabanController laporanUtama) {
    final tgl = map['tglPengisian'] as Timestamp;
    String emailPenjawab = map['emailPenjawab'] as String;
    List<dynamic> listTemp = map['daftarJawaban'] as List<dynamic>;
    return ResponSurvei(
      tglPengisian: DateTime.fromMillisecondsSinceEpoch(tgl.seconds * 1000),
      emailPenjawab: emailPenjawab,

      //--kau hanya tambahkan proses penyimpanan jawaban saja
      daftarJawaban: List.generate(listTemp.length, (index) {
        final temp = JawabanPertanyaan.fromJson(json.encode(listTemp[index]));
        final key =
            temp.idSoal; // ini IdSoal === nanti dibawah idJawaban pilihan
        //jika butuh simpan data soal yg dihapus juga, cabgnkan dibawah if tipe soal
        // print(emailPenjawab);
        if (temp.tipeSoal == "Pilihan Ganda") {
          final jawaban = temp.getJawabanPilgan()['idPilihan'] as String;

          // print(jawaban);
          if (jawaban != "zxc") {
            if (laporanUtama.getState()[temp.idSoal] != null) {
              if (laporanUtama.getState()[temp.idSoal]!.dataJawaban[jawaban] !=
                  null) {
                int nilai =
                    (laporanUtama.getNilaiMapInt(key, jawaban) as int) + 1;
                laporanUtama.gantiNilaiMapInt(key, jawaban, nilai);
              } else {
                laporanUtama.tambahKeyBaru(key, jawaban);
              }
            }
          }

          //ini template untuk misalnya perlu tampilkan jawaban terhapus
        } else if (temp.tipeSoal == "Kotak Centang") {
          // print("kotakCentang");
          final jawaban = temp.getJawabanKotakCentangX();
          if (laporanUtama.getState()[temp.idSoal] != null) {
            for (var element in jawaban) {
              if (laporanUtama
                      .getState()[temp.idSoal]!
                      .dataJawaban[element['idPilihan']!] !=
                  null) {
                int nilai =
                    (laporanUtama.getNilaiMapInt(key, element['idPilihan']!)) +
                        1;
                laporanUtama.gantiNilaiMapInt(
                    key, element['idPilihan']!, nilai);
              } else {
                laporanUtama.tambahKeyBaru(key, element['idPilihan']!);
              }
            }
          }
        } else if (temp.tipeSoal == "Gambar Ganda" ||
            temp.tipeSoal == "Carousel") {
          final jawaban = temp.getJawabanGGX()['idPilihan'];
          if (jawaban != "zxc") {
            if (laporanUtama.getState()[temp.idSoal] != null) {
              if (laporanUtama.getState()[temp.idSoal]!.dataJawaban[jawaban] !=
                  null) {
                int nilai =
                    (laporanUtama.getNilaiMapInt(key, jawaban!) as int) + 1;
                laporanUtama.gantiNilaiMapInt(key, jawaban, nilai);
              } else {
                laporanUtama.tambahKeyBaru(key, jawaban!);
              }
            }
          }
        } else if (temp.tipeSoal == "Urutan Pilihan") {
          //ingat yg dikasih ini ururtan dari pilihan yg ada
          //sepertinya ini perlu diubah supaya dia cmn ambil yg plg atas
          final jawaban = temp.getJawabanUrutanX();
          if (laporanUtama.getState()[temp.idSoal] != null) {
            if (laporanUtama.getState()[temp.idSoal]!.dataJawaban[jawaban] !=
                null) {
              int nilai =
                  (laporanUtama.getNilaiMapInt(key, jawaban) as int) + 1;
              laporanUtama.gantiNilaiMapInt(key, jawaban, nilai);
            } else {
              laporanUtama.tambahKeyBaru(key, jawaban);
            }
          }
        } else if (temp.tipeSoal == "Slider Angka") {
          final jawaban = temp.getJawabanAngka();
          if (jawaban != -99) {
            if (laporanUtama.getState()[temp.idSoal] != null) {
              if (laporanUtama
                      .getState()[temp.idSoal]!
                      .dataJawaban[jawaban.toString()] !=
                  null) {
                int nilai = (laporanUtama.getNilaiMapInt(
                        key, jawaban.toString()) as int) +
                    1;
                laporanUtama.gantiNilaiMapInt(key, jawaban.toString(), nilai);
              } else {
                laporanUtama.tambahKeyBaru(key, jawaban.toString());
              }
            }
          }
        } else if (temp.tipeSoal == "Teks" ||
            temp.tipeSoal == "Teks Paragraf") {
          final jawaban = temp.getJawabanTeks();
          if (jawaban != "") {
            if (laporanUtama.getState()[temp.idSoal] != null) {
              laporanUtama.masukkDataString(key, emailPenjawab, jawaban);
            }
          }
        } else if (temp.tipeSoal == "Angka" || temp.tipeSoal == "Tanggal") {
          final jawaban = temp.getJawabanAngka();
          if (jawaban != -99) {
            if (laporanUtama.getState()[temp.idSoal] != null) {
              laporanUtama.masukkDataInt(key, emailPenjawab, jawaban);
            }
          }
        } else if (temp.tipeSoal == "Waktu") {
          //untuk sekarang simpan saja dulu dalam bentuk time of day
          final jawaban = temp.getJawabanWaktu();
          final hour = jawaban['jam'];
          final minute = jawaban['menit'];

          if (hour != 99) {
            if (laporanUtama.getState()[temp.idSoal] != null) {
              laporanUtama.masukDataWaktu(
                  key, emailPenjawab, TimeOfDay(hour: hour!, minute: minute!));
            }
          }
        } else if (temp.tipeSoal == "Image Picker") {
          final jawaban = temp.getJawabanTeks();
          if (jawaban != "zxc") {
            if (laporanUtama.getState()[temp.idSoal] != null) {
              laporanUtama.masukkDataString(key,
                  (laporanUtama.getMapLength(key)).toString(), emailPenjawab);
            }
          }
        } else if (temp.tipeSoal == "pembatas") {
          print(
              "daapt pembatas di respon=================XXXXXXXXXXXXXXXXXXX==============================");
        } else {
          if (laporanUtama.getState()[temp.idSoal] != null) {
            laporanUtama.masukkDataString(key,
                (laporanUtama.getMapLength(key)).toString(), emailPenjawab);
          }
          //tabel, image picker
          // ini masih percobaan, datanya nanti hanya nomor dan emailPenjawab
        }
        return temp;
      }),
    );
  }
  factory ResponSurvei.fromMapCabang(
      Map<String, dynamic> map, DataKumpulanJawabanController laporanUtama) {
    final tgl = map['tglPengisian'] as Timestamp;
    String emailPenjawab = map['emailPenjawab'] as String;
    List<dynamic> listTemp = map['daftarJawabanCabang'] as List<dynamic>;
    return ResponSurvei(
      tglPengisian: DateTime.fromMillisecondsSinceEpoch(tgl.seconds * 1000),
      emailPenjawab: emailPenjawab,

      //--kau hanya tambahkan proses penyimpanan jawaban saja
      daftarJawaban: List.generate(listTemp.length, (index) {
        final temp = JawabanPertanyaan.fromJson(json.encode(listTemp[index]));
        final key =
            temp.idSoal; // ini IdSoal === nanti dibawah idJawaban pilihan
        //jika butuh simpan data soal yg dihapus juga, cabgnkan dibawah if tipe soal
        // print(emailPenjawab);
        if (temp.tipeSoal == "Pilihan Ganda") {
          final jawaban = temp.getJawabanPilgan()['idPilihan'] as String;

          // print(jawaban);
          if (jawaban != "zxc") {
            if (laporanUtama.getState()[temp.idSoal] != null) {
              if (laporanUtama.getState()[temp.idSoal]!.dataJawaban[jawaban] !=
                  null) {
                int nilai =
                    (laporanUtama.getNilaiMapInt(key, jawaban) as int) + 1;
                laporanUtama.gantiNilaiMapInt(key, jawaban, nilai);
              } else {
                laporanUtama.tambahKeyBaru(key, jawaban);
              }
            }
          }

          //ini template untuk misalnya perlu tampilkan jawaban terhapus
        } else if (temp.tipeSoal == "Kotak Centang") {
          // print("kotakCentang");
          final jawaban = temp.getJawabanKotakCentangX();
          if (laporanUtama.getState()[temp.idSoal] != null) {
            for (var element in jawaban) {
              if (laporanUtama
                      .getState()[temp.idSoal]!
                      .dataJawaban[element['idPilihan']!] !=
                  null) {
                int nilai =
                    (laporanUtama.getNilaiMapInt(key, element['idPilihan']!)) +
                        1;
                laporanUtama.gantiNilaiMapInt(
                    key, element['idPilihan']!, nilai);
              } else {
                laporanUtama.tambahKeyBaru(key, element['idPilihan']!);
              }
            }
          }
        } else if (temp.tipeSoal == "Gambar Ganda" ||
            temp.tipeSoal == "Carousel") {
          final jawaban = temp.getJawabanGGX()['idPilihan'];
          if (jawaban != "zxc") {
            if (laporanUtama.getState()[temp.idSoal] != null) {
              if (laporanUtama.getState()[temp.idSoal]!.dataJawaban[jawaban] !=
                  null) {
                int nilai =
                    (laporanUtama.getNilaiMapInt(key, jawaban!) as int) + 1;
                laporanUtama.gantiNilaiMapInt(key, jawaban, nilai);
              } else {
                laporanUtama.tambahKeyBaru(key, jawaban!);
              }
            }
          }
        } else if (temp.tipeSoal == "Urutan Pilihan") {
          //ingat yg dikasih ini ururtan dari pilihan yg ada
          //sepertinya ini perlu diubah supaya dia cmn ambil yg plg atas
          final jawaban = temp.getJawabanUrutanX();
          if (laporanUtama.getState()[temp.idSoal] != null) {
            if (laporanUtama.getState()[temp.idSoal]!.dataJawaban[jawaban] !=
                null) {
              int nilai =
                  (laporanUtama.getNilaiMapInt(key, jawaban) as int) + 1;
              laporanUtama.gantiNilaiMapInt(key, jawaban, nilai);
            } else {
              laporanUtama.tambahKeyBaru(key, jawaban);
            }
          }
        } else if (temp.tipeSoal == "Slider Angka") {
          final jawaban = temp.getJawabanAngka();
          if (jawaban != -99) {
            if (laporanUtama.getState()[temp.idSoal] != null) {
              if (laporanUtama
                      .getState()[temp.idSoal]!
                      .dataJawaban[jawaban.toString()] !=
                  null) {
                int nilai = (laporanUtama.getNilaiMapInt(
                        key, jawaban.toString()) as int) +
                    1;
                laporanUtama.gantiNilaiMapInt(key, jawaban.toString(), nilai);
              } else {
                laporanUtama.tambahKeyBaru(key, jawaban.toString());
              }
            }
          }
        } else if (temp.tipeSoal == "Teks" ||
            temp.tipeSoal == "Teks Paragraf") {
          final jawaban = temp.getJawabanTeks();
          if (jawaban != "") {
            if (laporanUtama.getState()[temp.idSoal] != null) {
              laporanUtama.masukkDataString(key, emailPenjawab, jawaban);
            }
          }
        } else if (temp.tipeSoal == "Angka" || temp.tipeSoal == "Tanggal") {
          final jawaban = temp.getJawabanAngka();
          if (jawaban != -99) {
            if (laporanUtama.getState()[temp.idSoal] != null) {
              laporanUtama.masukkDataInt(key, emailPenjawab, jawaban);
            }
          }
        } else if (temp.tipeSoal == "Waktu") {
          //untuk sekarang simpan saja dulu dalam bentuk time of day
          final jawaban = temp.getJawabanWaktu();
          final hour = jawaban['jam'];
          final minute = jawaban['menit'];

          if (hour != 99) {
            if (laporanUtama.getState()[temp.idSoal] != null) {
              laporanUtama.masukDataWaktu(
                  key, emailPenjawab, TimeOfDay(hour: hour!, minute: minute!));
            }
          }
        } else if (temp.tipeSoal == "Image Picker") {
          final jawaban = temp.getJawabanTeks();
          if (jawaban != "zxc") {
            if (laporanUtama.getState()[temp.idSoal] != null) {
              laporanUtama.masukkDataString(key,
                  (laporanUtama.getMapLength(key)).toString(), emailPenjawab);
            }
          }
        } else if (temp.tipeSoal == "pembatas") {
          print("daapt pembatas di respon");
        } else {
          if (laporanUtama.getState()[temp.idSoal] != null) {
            laporanUtama.masukkDataString(key,
                (laporanUtama.getMapLength(key)).toString(), emailPenjawab);
          }
          //tabel, image picker
          // ini masih percobaan, datanya nanti hanya nomor dan emailPenjawab
        }
        return temp;
      }),
    );
  }

  String toJson() => json.encode(toMap());

  factory ResponSurvei.fromJson(String source) =>
      ResponSurvei.fromMap(json.decode(source) as Map<String, dynamic>);

  // factory ResponSurvei.fromJson(String source) =>
  //     ResponSurvei.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() =>
      'ResponSurvei(tglPengisian: $tglPengisian, emailPenjawab: $emailPenjawab, daftarJawaban: $daftarJawaban)';
}

class JawabanPertanyaan {
  String tipeSoal;
  dynamic mapJawaban;
  String idSoal;
  JawabanPertanyaan({
    required this.tipeSoal,
    required this.mapJawaban,
    required this.idSoal,
  });

  Map<String, String> getJawabanPilgan() => Map.castFrom(mapJawaban);

  Map<String, int> getJawabanWaktu() => Map.castFrom(mapJawaban);

  // List<bool> getJawabanKotakCentang() {
  //   final list = mapJawaban as List<dynamic>;
  //   return List.generate(list.length, (index) => list[index] as bool);
  // }

  List<Map<String, String>> getJawabanKotakCentangX() {
    final list = mapJawaban as List<dynamic>;
    return List.generate(
        list.length,
        (index) => {
              'pilihan': list[index]['jawaban'],
              'idPilihan': list[index]['idJawaban']
            });
  }

  List<Map<String, String>> getJawabanUrutan() {
    final list = mapJawaban as List<dynamic>;
    return List.generate(
        list.length,
        (index) => {
              'pilihan': list[index]['pilihan'],
              'idPilihan': list[index]['idPilihan']
            });
  }

  // List<String> getJawabanUrutan() {
  //   final temp = mapJawaban as List<dynamic>;
  //   return List.generate(temp.length, (index) => temp[index] as String);
  // }

  String getJawabanUrutanX() {
    final temp = mapJawaban as List<dynamic>;
    return temp[0]['idPilihan'] as String;
  }

  // String getJawabanGG() => mapJawaban as String;

  Map<String, String> getJawabanGGX() => Map.castFrom(mapJawaban);

  int getJawabanTanggal() => mapJawaban;

  int getJawabanAngka() => mapJawaban;

  String getJawabanTeks() => mapJawaban as String;

  Map<int, List<String>> getJawabanTabel() {
    int ctr = 0;
    Map<int, List<String>> mapHasil = {};
    final temp = Map.castFrom(mapJawaban);
    for (final e in temp.values) {
      final listTemp = e as List<dynamic>;

      mapHasil[ctr] =
          List.generate(listTemp.length, (index) => listTemp[index] as String);
      ctr++;
    }
    return mapHasil;
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'tipeSoal': tipeSoal,
      'mapJawaban': mapJawaban,
      'idSoal': idSoal,
    };
  }

  factory JawabanPertanyaan.fromMap(Map<String, dynamic> map) {
    //disni bikin percabangan pembatas
    return JawabanPertanyaan(
      tipeSoal: map['tipeSoal'] as String,
      mapJawaban: map['jawaban'],
      idSoal: map['idSoal'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory JawabanPertanyaan.fromJson(String source) =>
      JawabanPertanyaan.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() =>
      'JawabanSoal(tipeSoal: $tipeSoal, mapJawaban: $mapJawaban, idSoal: $idSoal)';
}



//tabel,pilgan,urutan,kotak centang

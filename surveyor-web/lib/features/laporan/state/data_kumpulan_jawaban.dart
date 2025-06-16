import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hei_survei/features/laporan/models/data_kumpulan_jawaban.dart';

class DataKumpulanJawabanController
    extends StateNotifier<Map<String, DataKumpulanJawaban>> {
  DataKumpulanJawabanController() : super({});
  Map<String, DataKumpulanJawaban> getState() {
    return state;
  }

  getNilaiMapInt(String key, String idJawaban) {
    return state[key]!.dataJawaban[idJawaban];
  }

  masukDataWaktu(String key, String keyJawaban, TimeOfDay time) {
    state[key]!.dataJawaban[keyJawaban] = time;
  }

  masukkDataString(String key, String keyJawaban, String valueJawaban) {
    state[key]!.dataJawaban[keyJawaban] = valueJawaban;
  }

  masukkDataInt(String key, String keyJawaban, int valueJawaban) {
    state[key]!.dataJawaban[keyJawaban] = valueJawaban;
  }

  gantiNilaiMapInt(String key, String idJawaban, int nilai) {
    state[key]!.dataJawaban[idJawaban] = nilai;
    state = Map<String, DataKumpulanJawaban>.from(state);
  }

  tambahKeyBaru(String key, String idJawaban) {
    state[key]!.dataJawaban[idJawaban] = 1;
    state = Map<String, DataKumpulanJawaban>.from(state);
  }

  pushDataBaru(String key, DataKumpulanJawaban soalLaporanUtama) {
    state[key] = soalLaporanUtama;
    state = Map<String, DataKumpulanJawaban>.from(state);
  }

  int getMapLength(String key) {
    return state[key]!.dataJawaban.length;
  }

  tampilkan() {
    print(state);
  }
}

class PenghitungSoalController extends StateNotifier<int> {
  PenghitungSoalController() : super(0);

  int getNilai() => state;

  updateNilai(int nilai) {
    state = nilai;
  }
}

// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:aplikasi_admin/features/laporan/laporan_util.dart';
import 'package:aplikasi_admin/features/laporan/models/jawaban_survei.dart';
import 'package:aplikasi_admin/features/laporan/models/pertanyaan_survei.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class LaporanKartuController extends StateNotifier<LaporanKartuState> {
  LaporanKartuController({
    required String userPilihan,
    required List<ResponSurvei> listRespon,
    required List<PertanyaanKartu> listPertanyaanLaporan,
    required ResponSurvei responPilihan,
    required List<Widget> pertanyaanTampilan,
  }) : super(
          LaporanKartuState(
              userPilihan: userPilihan,
              listRespon: listRespon,
              pertanyaanLaporan: listPertanyaanLaporan,
              responPilihan: responPilihan,
              jawabanTampilan: pertanyaanTampilan),
        );
  List<PertanyaanKartu> getListPertanyaan() => state.pertanyaanLaporan;
  ResponSurvei getResponPilihan() => state.responPilihan;
  List<Widget> getListJawaban() => state.jawabanTampilan;
  List<String> getListPenjawab() {
    final temp = List.generate(state.listRespon.length,
        (index) => state.listRespon[index].emailPenjawab);
    return temp;
  }

  // List<String> getListPenjawab() {
  //   final temp = List.generate(state.dataLaporanSurvei.listRespon.length,
  //       (index) => state.dataLaporanSurvei.listRespon[index].emailPenjawab);
  //   return temp;
  // }

  String emailUserPilihan() => state.responPilihan.emailPenjawab;

  gantiJawaban(ResponSurvei respon) {
    state = state.copyWith(responPilihan: respon);
  }

  gantiJawabanbyEmail(String email, BuildContext context) {
    int indexPilihan = state.listRespon
        .indexWhere((element) => element.emailPenjawab == email);
    final listPertanyaan = state.pertanyaanLaporan;
    final responPilihan = state.listRespon[indexPilihan];
    List<Widget> listWidgetTampilanBaru = List.generate(
      state.pertanyaanLaporan.length,
      (index) => LaporanUtils().generateJawabanLaporan(
        listPertanyaan[index].dataSoal,
        responPilihan.daftarJawaban[index],
        context,
      ),
    );

    state = state.copyWith(
      responPilihan: state.listRespon[indexPilihan],
      jawabanTampilan: listWidgetTampilanBaru,
    );
    // int indexPilihan = state.dataLaporanSurvei.listRespon
    //     .indexWhere((element) => element.emailPenjawab == email);
    // final listPertanyaan = state.dataLaporanSurvei.daftarPertanyaanKartu;
    // final responPilihan = state.dataLaporanSurvei.listRespon[1];
    // List<Widget> listWidgetTampilanBaru = List.generate(
    //   state.dataLaporanSurvei.daftarPertanyaanKartu.length,
    //   (index) => LaporanUtils().generateJawabanLaporan(
    //     listPertanyaan[index].dataSoal,
    //     responPilihan.daftarJawaban[index],
    //     context,
    //   ),
    // );

    // state = state.copyWith(
    //   responPilihan: state.dataLaporanSurvei.listRespon[indexPilihan],
    //   jawabanTampilan: listWidgetTampilanBaru,
    // );
  }
}

class LaporanKartuState {
  String userPilihan;
  List<ResponSurvei> listRespon;
  List<PertanyaanKartu> pertanyaanLaporan;
  ResponSurvei responPilihan;
  List<Widget> jawabanTampilan;
  LaporanKartuState({
    required this.userPilihan,
    required this.listRespon,
    required this.pertanyaanLaporan,
    required this.responPilihan,
    required this.jawabanTampilan,
  });

  LaporanKartuState copyWith({
    String? userPilihan,
    List<ResponSurvei>? listRespon,
    List<PertanyaanKartu>? pertanyaanLaporan,
    ResponSurvei? responPilihan,
    List<Widget>? jawabanTampilan,
  }) {
    return LaporanKartuState(
      userPilihan: userPilihan ?? this.userPilihan,
      listRespon: listRespon ?? this.listRespon,
      pertanyaanLaporan: pertanyaanLaporan ?? this.pertanyaanLaporan,
      responPilihan: responPilihan ?? this.responPilihan,
      jawabanTampilan: jawabanTampilan ?? this.jawabanTampilan,
    );
  }
}

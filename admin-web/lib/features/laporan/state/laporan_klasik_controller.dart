// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:aplikasi_admin/features/laporan/laporan_util.dart';
import 'package:aplikasi_admin/features/laporan/models/jawaban_survei.dart';
import 'package:aplikasi_admin/features/laporan/models/pertanyaan_survei.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class LaporanKlasikController extends StateNotifier<LaporanKlasikState> {
  LaporanKlasikController({
    required String userPilihan,
    required List<ResponSurvei> listRespon,
    required List<PertanyaanKlasik> listPertanyaanLaporan,
    required ResponSurvei responPilihan,
    required List<Widget> pertanyaanTampilan,
  }) : super(LaporanKlasikState(
          userPilihan: userPilihan,
          listRespon: listRespon,
          pertanyaanLaporan: listPertanyaanLaporan,
          responPilihan: responPilihan,
          jawabanTampilan: pertanyaanTampilan,
        ));

  List<PertanyaanKlasik> getListPertanyaan() => state.pertanyaanLaporan;
  ResponSurvei getResponPilihan() => state.responPilihan;
  List<Widget> getListJawaban() => state.jawabanTampilan;

  List<String> getListResponden() {
    List<String> listResponden = List.generate(
      state.listRespon.length,
      (index) => state.listRespon[index].emailPenjawab,
    );
    return listResponden;
  }

  List<String> getListPenjawab() {
    final temp = List.generate(state.listRespon.length,
        (index) => state.listRespon[index].emailPenjawab);
    return temp;
  }

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
  }
}

class LaporanKlasikState {
  String userPilihan;
  List<ResponSurvei> listRespon;
  List<PertanyaanKlasik> pertanyaanLaporan; //data yg mau ditampilkan
  ResponSurvei responPilihan;
  List<Widget> jawabanTampilan;

  LaporanKlasikState({
    required this.userPilihan,
    required this.listRespon,
    required this.pertanyaanLaporan,
    required this.responPilihan,
    required this.jawabanTampilan,
  });

  LaporanKlasikState copyWith({
    List<PertanyaanKlasik>? pertanyaanLaporan,
    List<ResponSurvei>? listRespon,
    String? userPilihan,
    ResponSurvei? responPilihan,
    List<Widget>? jawabanTampilan,
  }) {
    return LaporanKlasikState(
        listRespon: listRespon ?? this.listRespon,
        pertanyaanLaporan: pertanyaanLaporan ?? this.pertanyaanLaporan,
        userPilihan: userPilihan ?? this.userPilihan,
        responPilihan: responPilihan ?? this.responPilihan,
        jawabanTampilan: jawabanTampilan ?? this.jawabanTampilan);
  }
}

// class LaporanKlasikController extends StateNotifier<LaporanKlasikState> {
//   LaporanKlasikController({
//     required String userPilihan,
//     required DataLaporanSurveiKlasik dataLaporanSurveiKlasik,
//     required List<PertanyaanKlasik> listPertanyaanLaporan,
//     required ResponSurvei responPilihan,
//     required List<Widget> pertanyaanTampilan,
//   }) : super(LaporanKlasikState(
//           userPilihan: userPilihan,
//           dataLaporanSurvei: dataLaporanSurveiKlasik,
//           pertanyaanLaporan: listPertanyaanLaporan,
//           responPilihan: responPilihan,
//           jawabanTampilan: pertanyaanTampilan,
//         ));

//   List<PertanyaanKlasik> getListPertanyaan() => state.pertanyaanLaporan;
//   ResponSurvei getResponPilihan() => state.responPilihan;
//   List<Widget> getListJawaban() => state.jawabanTampilan;

//   List<String> getListResponden() {
//     List<String> listResponden = List.generate(
//       state.dataLaporanSurvei.listRespon.length,
//       (index) => state.dataLaporanSurvei.listRespon[index].emailPenjawab,
//     );
//     return listResponden;
//   }

//   List<String> getListPenjawab() {
//     final temp = List.generate(state.dataLaporanSurvei.listRespon.length,
//         (index) => state.dataLaporanSurvei.listRespon[index].emailPenjawab);
//     return temp;
//   }

//   String emailUserPilihan() => state.responPilihan.emailPenjawab;

//   gantiJawaban(ResponSurvei respon) {
//     state = state.copyWith(responPilihan: respon);
//   }

//   gantiJawabanbyEmail(String email, BuildContext context) {
//     int indexPilihan = state.dataLaporanSurvei.listRespon
//         .indexWhere((element) => element.emailPenjawab == email);
//     final listPertanyaan = state.dataLaporanSurvei.daftarPertanyaanKlasik;
//     final responPilihan = state.dataLaporanSurvei.listRespon[indexPilihan];
//     List<Widget> listWidgetTampilanBaru = List.generate(
//       state.dataLaporanSurvei.daftarPertanyaanKlasik.length,
//       (index) => LaporanServices().generateJawabanLaporan(
//         listPertanyaan[index].dataSoal,
//         responPilihan.daftarJawaban[index],
//         context,
//       ),
//     );

//     state = state.copyWith(
//       responPilihan: state.dataLaporanSurvei.listRespon[indexPilihan],
//       jawabanTampilan: listWidgetTampilanBaru,
//     );
//   }
// }

// class LaporanKlasikState {
//   String userPilihan;
//   DataLaporanSurveiKlasik dataLaporanSurvei; //data dari db
//   List<PertanyaanKlasik> pertanyaanLaporan; //data yg mau ditampilkan
//   ResponSurvei responPilihan;
//   List<Widget> jawabanTampilan;
//   LaporanKlasikState({
//     required this.userPilihan,
//     required this.dataLaporanSurvei,
//     required this.pertanyaanLaporan,
//     required this.responPilihan,
//     required this.jawabanTampilan,
//   });

//   LaporanKlasikState copyWith({
//     DataLaporanSurveiKlasik? dataLaporanSurvei,
//     List<PertanyaanKlasik>? pertanyaanLaporan,
//     String? userPilihan,
//     ResponSurvei? responPilihan,
//     List<Widget>? jawabanTampilan,
//   }) {
//     return LaporanKlasikState(
//         dataLaporanSurvei: dataLaporanSurvei ?? this.dataLaporanSurvei,
//         pertanyaanLaporan: pertanyaanLaporan ?? this.pertanyaanLaporan,
//         userPilihan: userPilihan ?? this.userPilihan,
//         responPilihan: responPilihan ?? this.responPilihan,
//         jawabanTampilan: jawabanTampilan ?? this.jawabanTampilan);
//   }
// }

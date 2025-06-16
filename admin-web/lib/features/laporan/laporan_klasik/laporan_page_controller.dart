// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:aplikasi_admin/features/laporan/state/laporan_utama_controller_klasik.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

enum PagePilihan { halamanUtama, halamanSatuan }

class PageLaporanController extends StateNotifier<PageLaporan> {
  PageLaporanController()
      : super(PageLaporan(
          pilihan: PagePilihan.halamanUtama,
          emailPilihan: "",
          idSurvei: "",
          isResponEmpty: false,
        ));

  void setResponEmpty(bool logic) {
    state = state.copyWith(isResponEmpty: logic);
  }

  void gantiHalaman(int index) {
    if (index == 0) {
      state.pilihan = PagePilihan.halamanUtama;
    } else {
      state.pilihan = PagePilihan.halamanSatuan;
    }
    state = state.copyWith();
  }

  void gantiEmail(String email) {
    state.emailPilihan = email;
    state = state.copyWith(emailPilihan: email);
  }

  void setSoalUtama(SoalLaporanUtamaKlasik soalUtama) {
    state.soalPilihan = soalUtama;
    state = state.copyWith(soalPilihan: soalUtama);
  }

  void setIdSurvei(String idSurvei) {
    state = state.copyWith(idSurvei: idSurvei);
  }

  SoalLaporanUtamaKlasik? getSoalPilihan() => state.soalPilihan;
  String getIdSurvei() => state.idSurvei;
  PagePilihan getPage() => state.pilihan;
  bool getIsResponEmpty() => state.isResponEmpty;
}

class PageLaporan {
  PagePilihan pilihan;
  String emailPilihan;
  String idSurvei;
  SoalLaporanUtamaKlasik? soalPilihan;
  bool isResponEmpty;
  PageLaporan({
    required this.pilihan,
    required this.emailPilihan,
    required this.idSurvei,
    required this.isResponEmpty,
    this.soalPilihan,
  });

  PageLaporan copyWith({
    PagePilihan? pilihan,
    String? emailPilihan,
    String? idSurvei,
    SoalLaporanUtamaKlasik? soalPilihan,
    bool? isResponEmpty,
  }) {
    return PageLaporan(
      pilihan: pilihan ?? this.pilihan,
      emailPilihan: emailPilihan ?? this.emailPilihan,
      idSurvei: idSurvei ?? this.idSurvei,
      soalPilihan: soalPilihan ?? this.soalPilihan,
      isResponEmpty: isResponEmpty ?? this.isResponEmpty,
    );
  }
}

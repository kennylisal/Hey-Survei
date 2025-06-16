// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hei_survei/features/laporan/state/laporan_utama_controller_klasik.dart';

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
    state.soalPilihanCabang = null;
    state = state.copyWith(soalPilihan: soalUtama, soalPilihanCabang: null);
  }

  void setSoalCabang(SoalLaporanUtamaKlasik soalUtama) {
    state.soalPilihanCabang = soalUtama;
    state.soalPilihan = null;
    state = state.copyWith(soalPilihanCabang: soalUtama, soalPilihan: null);
  }

  void setIdSurvei(String idSurvei) {
    state = state.copyWith(idSurvei: idSurvei);
  }

  SoalLaporanUtamaKlasik? getSoalPilihan() {
    if (state.soalPilihan != null) {
      return state.soalPilihan;
    } else {
      return state.soalPilihanCabang;
    }
  }

  SoalLaporanUtamaKlasik? getSoalPilihanCabang() => state.soalPilihanCabang;
  String getIdSurvei() => state.idSurvei;
  PagePilihan getPage() => state.pilihan;
  bool getIsResponEmpty() => state.isResponEmpty;
}

class PageLaporan {
  PagePilihan pilihan;
  String emailPilihan;
  String idSurvei;
  SoalLaporanUtamaKlasik? soalPilihan;
  SoalLaporanUtamaKlasik? soalPilihanCabang;
  bool isResponEmpty;
  PageLaporan({
    required this.pilihan,
    required this.emailPilihan,
    required this.idSurvei,
    required this.isResponEmpty,
    this.soalPilihan,
    this.soalPilihanCabang,
  });

  PageLaporan copyWith({
    PagePilihan? pilihan,
    String? emailPilihan,
    String? idSurvei,
    SoalLaporanUtamaKlasik? soalPilihan,
    SoalLaporanUtamaKlasik? soalPilihanCabang,
    bool? isResponEmpty,
  }) {
    return PageLaporan(
      pilihan: pilihan ?? this.pilihan,
      emailPilihan: emailPilihan ?? this.emailPilihan,
      idSurvei: idSurvei ?? this.idSurvei,
      soalPilihan: soalPilihan ?? this.soalPilihan,
      isResponEmpty: isResponEmpty ?? this.isResponEmpty,
      soalPilihanCabang: soalPilihanCabang ?? this.soalPilihanCabang,
    );
  }
}

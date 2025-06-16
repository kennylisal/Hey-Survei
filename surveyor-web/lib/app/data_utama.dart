// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class DataUtama {
  String idSurvei; //ini untuk liat detail
  Color warnaBg;
  String idForm;
  String idFormPublish;
  String jenisFormPublish;
  DataUtama({
    required this.idSurvei,
    required this.warnaBg,
    required this.idForm,
    required this.idFormPublish,
    required this.jenisFormPublish,
  });

  DataUtama copyWith({
    String? idSurvei,
    Color? warnaBg,
    String? idForm,
    String? idFormPublish,
    String? jenisFormPublish,
  }) {
    return DataUtama(
      warnaBg: warnaBg ?? this.warnaBg,
      idSurvei: idSurvei ?? this.idSurvei,
      idForm: idForm ?? this.idForm,
      idFormPublish: idFormPublish ?? this.idFormPublish,
      jenisFormPublish: jenisFormPublish ?? this.jenisFormPublish,
    );
  }
}

class DataUtamaNotifier extends StateNotifier<DataUtama> {
  DataUtamaNotifier()
      : super(DataUtama(
          idSurvei: "",
          warnaBg: Colors.white,
          idForm: "",
          idFormPublish: "",
          jenisFormPublish: "",
        ));

  String getIdSurvei() => state.idSurvei;

  gantiWarnaBg(Color color) {
    state = state.copyWith(warnaBg: color);
  }

  gantiIdSurvei(String id) {
    state = state.copyWith(idSurvei: id);
  }

  gantiIdFormDraft(String id) {
    state = state.copyWith(idForm: id);
  }

  siapkanDataPublish(String idForm, String tipe) {
    state = state.copyWith(idFormPublish: idForm, jenisFormPublish: tipe);
  }

  bersihkanDataPublish() {
    state = state.copyWith(idFormPublish: "", jenisFormPublish: "");
  }
}

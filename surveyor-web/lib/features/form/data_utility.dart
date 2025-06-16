import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:hei_survei/features/form/constant.dart';
import 'package:hei_survei/features/form/model/data_soal.dart';
import 'package:hei_survei/features/form/state/form_controller.dart';
import 'package:hei_survei/features/form/state/pertanyaan_controller.dart';
import 'package:hei_survei/features/form/widget_jawaban/opsi_gambar.dart';
import 'package:hei_survei/features/form/widget_jawaban/opsi_jawaban.dart';

class DataUtility {
  Map<Tipesoal, Widget> mapIcon = {
    Tipesoal.pilihanGanda: const Icon(Icons.circle_outlined),
    Tipesoal.kotakCentang: const Icon(Icons.crop_square_sharp),
    Tipesoal.urutanPilihan: const Icon(Icons.circle),
    Tipesoal.gambarGanda: const Icon(Icons.circle_sharp),
    Tipesoal.carousel: const SizedBox(),
  };

  QuillController makeQuillController(Delta delta) {
    Document doc;
    if (delta.isEmpty) {
      doc = Document()..insert(0, '');
    } else {
      doc = Document.fromDelta(delta);
    }
    return QuillController(
      document: doc,
      selection: const TextSelection.collapsed(offset: 0),
    );
  }

  List<OpsiJawaban> generateOpsiJawaban(
    List<DataOpsi> listData,
    PertanyaanController controller,
    FormController formController,
  ) {
    List<OpsiJawaban> tempJawaban = [];
    for (var i = 0; i < listData.length; i++) {
      tempJawaban.add(
        OpsiJawaban(
          controller: controller,
          formController: formController,
          hint: "opsi ${i + 1}",
          textEditingController: listData[i].textController,
          idOpsi: listData[i].idData,
        ),
      );
    }
    return tempJawaban;
  }

  List<OpsiGambar> generateOpsiGambar(
    List<DataOpsi> listData,
    PertanyaanController controller,
    FormController formController,
  ) {
    List<OpsiGambar> tempJawaban = [];
    for (var i = 0; i < listData.length; i++) {
      tempJawaban.add(OpsiGambar(
        controller: controller,
        urlGambar: listData[i].text,
        idJawaban: listData[i].idData,
        formController: formController,
      ));
    }
    return tempJawaban;
  }
}

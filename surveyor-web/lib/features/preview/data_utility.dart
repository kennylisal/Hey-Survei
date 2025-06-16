import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:hei_survei/features/form/model/data_soal.dart';
import 'package:hei_survei/features/form/state/pertanyaan_controller.dart';
import 'package:hei_survei/features/preview/widget_jawaban.dart/preview_opsi_gambar.dart';
import 'package:hei_survei/features/preview/widget_jawaban.dart/preview_opsi_jawaban.dart';

class PreviewDataUtility {
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

  List<PreviewOpsiJawaban> generateOpsiJawaban(
    List<DataOpsi> listData,
    PertanyaanController controller,
  ) {
    List<PreviewOpsiJawaban> tempJawaban = [];
    for (var i = 0; i < listData.length; i++) {
      tempJawaban.add(
        PreviewOpsiJawaban(
          controller: controller,
          hint: "opsi ${i + 1}",
          textEditingController: listData[i].textController,
        ),
      );
    }
    return tempJawaban;
  }

  List<PreviewOpsiGambar> generateOpsiGambar(
    List<DataOpsi> listData,
    PertanyaanController controller,
  ) {
    List<PreviewOpsiGambar> tempJawaban = [];
    for (var i = 0; i < listData.length; i++) {
      tempJawaban.add(PreviewOpsiGambar(
        controller: controller,
        urlGambar: listData[i].text,
      ));
    }
    return tempJawaban;
  }
}

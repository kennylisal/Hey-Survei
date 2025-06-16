import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';

class DataUtility {
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
}

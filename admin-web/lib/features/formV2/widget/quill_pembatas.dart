import 'package:aplikasi_admin/features/formV2/widget/quill_soal.dart';
import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';

class QuillPembatas extends StatelessWidget {
  QuillPembatas({
    super.key,
    required this.quillController,
  });
  QuillController quillController;
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          margin: const EdgeInsets.only(top: 3),
          child: DocumentPage(
            quillDoc: quillController.document,
            quillController: quillController,
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Toolbar(
            quillController: quillController,
            quillDoc: quillController.document,
          ),
        ),
      ],
    );
  }
}

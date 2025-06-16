import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:hei_survei/features/form/widget/quill_soal.dart';

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

class Toolbar extends StatelessWidget {
  const Toolbar({
    super.key,
    required this.quillController,
    required this.quillDoc,
  });
  final Document quillDoc;
  final QuillController quillController;
  @override
  Widget build(BuildContext context) {
    return QuillToolbar.basic(
      showColorButton: false,
      showHeaderStyle: false,
      showLeftAlignment: false,
      showRightAlignment: false,
      showCenterAlignment: false,
      showJustifyAlignment: false,
      showSearchButton: false,
      showListCheck: false,
      showCodeBlock: false,
      showQuote: false,
      showIndent: false,
      showFontFamily: false,
      showInlineCode: false,
      showBackgroundColorButton: false,
      showStrikeThrough: false,
      //bisa atur font dan size awal
      controller: quillController,
      iconTheme: const QuillIconTheme(
        iconSelectedFillColor: AppColors.secondary,
      ),
      multiRowsDisplay: false,
      showAlignmentButtons: true,
    );
  }
}

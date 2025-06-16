import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart' hide Text;
import 'package:flutter_riverpod/flutter_riverpod.dart';

class QuilSoal extends StatelessWidget {
  QuilSoal({
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
          margin: const EdgeInsets.only(top: 16),
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

class DocumentPage extends ConsumerStatefulWidget {
  const DocumentPage({
    super.key,
    required this.quillController,
    required this.quillDoc,
  });
  final Document quillDoc;
  final QuillController quillController;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _DocumentPageState();
}

class _DocumentPageState extends ConsumerState<DocumentPage> {
  final FocusNode _focusNode = FocusNode();
  final ScrollController _scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _focusNode.requestFocus(),
      child: RawKeyboardListener(
        focusNode: FocusNode(),
        onKey: (event) {
          if (event.data.isControlPressed && event.character == 'b' ||
              event.data.isMetaPressed && event.character == 'b') {
            if (widget.quillController
                .getSelectionStyle()
                .attributes
                .keys
                .contains('bold')) {
              widget.quillController
                  .formatSelection(Attribute.clone(Attribute.bold, null));
            } else {
              widget.quillController.formatSelection(Attribute.bold);
            }
          } else if (event.data.isControlPressed && event.character == 'h') {}
        },
        child: Container(
          padding: const EdgeInsets.symmetric(
            horizontal: 20,
            vertical: 14,
          ),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: Colors.black,
              width: 2,
            ),
          ),
          child: QuillEditor(
            controller: widget.quillController,
            scrollController: _scrollController,
            scrollable: true,
            focusNode: _focusNode,
            autoFocus: false,
            readOnly: false,
            expands: false,
            padding: EdgeInsets.zero,
          ),
        ),
      ),
    );
  }
}

abstract class AppColors {
  static const secondary = Color(0xFF216BDD);
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

import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart' hide Text;
import 'package:flutter_riverpod/flutter_riverpod.dart';

// ignore: must_be_immutable
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
        DocumentPage(
          quillDoc: quillController.document,
          quillController: quillController,
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
            horizontal: 14,
            vertical: 8,
          ),
          child: QuillEditor(
            controller: widget.quillController,
            scrollController: _scrollController,
            scrollable: true,
            focusNode: _focusNode,
            autoFocus: false,
            readOnly: true,
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

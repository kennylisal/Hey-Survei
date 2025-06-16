// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/widgets.dart';
import 'package:flutter_quill/flutter_quill.dart';

class PertanyaanQuill extends StatelessWidget {
  const PertanyaanQuill({
    Key? key,
    required this.quillController,
  }) : super(key: key);
  final QuillController quillController;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(16),
      child: DocumentPage(
        quillDoc: quillController.document,
        quillController: quillController,
      ),
    );
  }
}

class DocumentPage extends StatefulWidget {
  const DocumentPage({
    super.key,
    required this.quillController,
    required this.quillDoc,
  });
  final Document quillDoc;
  final QuillController quillController;

  @override
  State<DocumentPage> createState() => _DocumentPageState();
}

class _DocumentPageState extends State<DocumentPage> {
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

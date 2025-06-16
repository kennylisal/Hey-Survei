import 'package:flutter/material.dart';
import 'package:survei_aplikasi/features/form_klasik/state/state_pertanyaan.dart';
import 'package:survei_aplikasi/features/form_klasik/widgets/quill_soal.dart';

class PembatasPolos extends StatefulWidget {
  PembatasPolos({
    super.key,
    required this.judulSoal,
    required this.state,
    required this.width,
  });
  PembatasState state;
  Widget judulSoal;
  double width;
  @override
  State<PembatasPolos> createState() => _PembatasPolosState();
}

class _PembatasPolosState extends State<PembatasPolos> {
  bool isDetail = false;
  lengtMultiplier() {
    if (widget.width > 352) {
      return 0.425;
    } else {
      return 0.365;
    }
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        setState(() {
          isDetail = !isDetail;
        });
      },
      child: Container(
        width: widget.width * 0.7,
        height: 200,
        margin: const EdgeInsets.symmetric(vertical: 14),
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (isDetail) widget.judulSoal,
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 40,
                    child: Text(
                      "Bagian :",
                      style: Theme.of(context)
                          .textTheme
                          .displaySmall!
                          .copyWith(fontSize: 16, color: Colors.black),
                    ),
                  ),
                  const SizedBox(width: 5),
                  Container(
                    // color: Colors.black,
                    width: widget.width * lengtMultiplier(),
                    height: 40,
                    child: Text(
                      // "Tontonan olagharga untuk megnetahui bagaiaman efek samping kepada nda blabla",
                      widget.state.textPembatas,
                      style: Theme.of(context).textTheme.displaySmall!.copyWith(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: Colors.black),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 2,
                    ),
                  ),
                  // const SizedBox(width: 3),
                  // Align(
                  //   alignment: Alignment.centerRight,
                  //   child: CircleAvatar(
                  //     radius: 15,
                  //     backgroundColor: Colors.blue.shade500,
                  //     child: IconButton(
                  //       icon: Icon(
                  //         Icons.arrow_upward,
                  //         color: Colors.white,
                  //         size: 15,
                  //       ),
                  //       onPressed: () {
                  //         setState(() {
                  //           isDetail = !isDetail;
                  //         });
                  //       },
                  //     ),
                  //   ),
                  // ),
                ],
              ),
              QuilSoal(quillController: widget.state.documentQuill),
            ],
          ),
        ),
      ),
    );
  }
}

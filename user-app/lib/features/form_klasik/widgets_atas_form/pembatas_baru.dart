import 'package:flutter/material.dart';
import 'package:survei_aplikasi/features/form_klasik/state/state_pertanyaan.dart';
import 'package:survei_aplikasi/features/form_klasik/widgets/quill_soal.dart';

class PembatasSoalBaru extends StatefulWidget {
  PembatasSoalBaru({
    super.key,
    required this.judulSoal,
    required this.state,
    required this.width,
  });
  PembatasState state;
  Widget judulSoal;
  double width;
  @override
  State<PembatasSoalBaru> createState() => _PembatasSoalBaruState();
}

class _PembatasSoalBaruState extends State<PembatasSoalBaru> {
  bool isDetail = false;
  lengtMultiplier() {
    if (widget.width > 352) {
      return 0.475;
    } else {
      return 0.40;
    }
  }

  double generatePanjang() {
    if (widget.state.documentQuill.document.toDelta().toString().length > 70) {
      return 200;
    } else {
      return 125;
    }
  }

  @override
  Widget build(BuildContext context) {
    // print(
    //     "ini panjang quill ${widget.state.documentQuill.document.toDelta().toString().length}");
    // setState(() {
    //       isDetail = !isDetail;
    //     });
    return Container(
      width: widget.width,
      margin: const EdgeInsets.symmetric(vertical: 14, horizontal: 12),
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(
            color: Color.fromARGB(255, 13, 171, 250),
            width: 10,
          ),
        ),
        color: Colors.white,
      ),
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
                const Spacer(),
                InkWell(
                  onTap: () {
                    setState(() {
                      isDetail = !isDetail;
                    });
                  },
                  child: Container(
                    height: 40,
                    decoration: BoxDecoration(shape: BoxShape.circle),
                    child: (!isDetail)
                        ? Icon(
                            Icons.arrow_circle_up_sharp,
                            color: Colors.blue,
                            size: 30,
                          )
                        : Icon(
                            Icons.arrow_circle_down_sharp,
                            color: Colors.blue,
                            size: 30,
                          ),
                  ),
                ),
                const SizedBox(width: 5),
              ],
            ),
            QuilSoal(quillController: widget.state.documentQuill),
          ],
        ),
      ),
    );
  }
}


// return InkWell(
//       onTap: () {
//         setState(() {
//           isDetail = !isDetail;
//         });
//       },
//       child: Container(
//         width: widget.width,
//         height: generatePanjang(),
//         margin: const EdgeInsets.symmetric(vertical: 14),
//         padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
//         decoration: BoxDecoration(
//           // border: Border.all(width: 2),
//           border: Border(
//             top: BorderSide(
//               color: Color.fromARGB(255, 13, 171, 250),
//               width: 5,
//             ),
//             bottom: BorderSide(
//               color: Color.fromARGB(255, 13, 171, 250),
//               width: 5,
//             ),
//           ),
//           // borderRadius: BorderRadius.circular(16),
//           color: Colors.white,
//         ),
//         child: SingleChildScrollView(
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.start,
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               if (isDetail) widget.judulSoal,
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.start,
//                 children: [
//                   SizedBox(
//                     height: 40,
//                     child: Text(
//                       "Bagian :",
//                       style: Theme.of(context)
//                           .textTheme
//                           .displaySmall!
//                           .copyWith(fontSize: 16, color: Colors.black),
//                     ),
//                   ),
//                   const SizedBox(width: 5),
//                   Container(
//                     // color: Colors.black,
//                     width: widget.width * lengtMultiplier(),
//                     height: 40,
//                     child: Text(
//                       // "Tontonan olagharga untuk megnetahui bagaiaman efek samping kepada nda blabla",
//                       widget.state.textPembatas,
//                       style: Theme.of(context).textTheme.displaySmall!.copyWith(
//                           fontWeight: FontWeight.bold,
//                           fontSize: 16,
//                           color: Colors.black),
//                       overflow: TextOverflow.ellipsis,
//                       maxLines: 2,
//                     ),
//                   ),
//                 ],
//               ),
//               QuilSoal(quillController: widget.state.documentQuill),
//             ],
//           ),
//         ),
//       ),
//     );
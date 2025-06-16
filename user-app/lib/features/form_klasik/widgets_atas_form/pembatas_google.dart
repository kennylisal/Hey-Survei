// import 'package:flutter/material.dart';
// import 'package:survei_aplikasi/features/form_klasik/state/state_pertanyaan.dart';
// import 'package:survei_aplikasi/features/form_klasik/widgets/quill_soal.dart';

// class PembatasGoogle extends StatelessWidget {
//   PembatasGoogle({
//     super.key,
//     required this.judulSoal,
//     required this.state,
//     required this.width,
//   });
//   PembatasState state;
//   Widget judulSoal;
//   double width;
//   lengtMultiplier() {
//     if (width > 352) {
//       return 0.425;
//     } else {
//       return 0.365;
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       width: width,
//       margin: const EdgeInsets.symmetric(vertical: 14, horizontal: 12),
//       padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
//       decoration: BoxDecoration(
//         // border: Border.all(width: 2),
//         border: Border(
//           top: BorderSide(
//             color: Color.fromARGB(255, 13, 171, 250),
//             width: 10,
//           ),
//         ),
//         // borderRadius: BorderRadius.circular(16),
//         color: Colors.white,
//       ),
//       child: SingleChildScrollView(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.start,
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             judulSoal,
//             Row(
//               mainAxisAlignment: MainAxisAlignment.start,
//               children: [
//                 SizedBox(
//                   height: 40,
//                   child: Text(
//                     "Bagian :",
//                     style: Theme.of(context)
//                         .textTheme
//                         .displaySmall!
//                         .copyWith(fontSize: 16, color: Colors.black),
//                   ),
//                 ),
//                 const SizedBox(width: 5),
//                 Container(
//                   // color: Colors.black,
//                   width: width * lengtMultiplier(),
//                   height: 40,
//                   child: Text(
//                     // "Tontonan olagharga untuk megnetahui bagaiaman efek samping kepada nda blabla",
//                     state.textPembatas,
//                     style: Theme.of(context).textTheme.displaySmall!.copyWith(
//                         fontWeight: FontWeight.bold,
//                         fontSize: 16,
//                         color: Colors.black),
//                     overflow: TextOverflow.ellipsis,
//                     maxLines: 2,
//                   ),
//                 ),
//               ],
//             ),
//             QuilSoal(quillController: state.documentQuill),
//           ],
//         ),
//       ),
//     );
//   }
// }

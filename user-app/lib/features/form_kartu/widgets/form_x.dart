import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:survei_aplikasi/features/form_klasik/state/controller_pertanyaan.dart';
import 'package:survei_aplikasi/features/form_klasik/widgets/quill_soal.dart';

class FormKartuX extends StatelessWidget {
  FormKartuX({
    super.key,
    required this.controller,
    required this.index,
    required this.isCabang,
    required this.totalSoal,
  });
  PertanyaanController controller;
  int index;
  int totalSoal;
  bool isCabang;
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 14, horizontal: 10),
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 12.5),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: Colors.white,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              if (controller.isWajib())
                Text("*Wajib",
                    style: Theme.of(context).textTheme.titleSmall!.copyWith(
                          fontWeight: FontWeight.bold,
                          color: Colors.red,
                        )),
              if (!isCabang)
                Text(
                  "${index + 1} / $totalSoal",
                  style: Theme.of(context).textTheme.displaySmall!.copyWith(
                        fontSize: 16,
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                ),
            ],
          ),
          QuilSoal(
            quillController: controller.getQuillController(),
          ),
          const SizedBox(height: 7),
          Center(
            child: Container(
              width: 272,
              height: 153,
              margin: const EdgeInsets.only(bottom: 16),
              decoration: BoxDecoration(border: Border.all(width: 0.75)),
              child: CachedNetworkImage(
                filterQuality: FilterQuality.medium,
                imageUrl: controller.getUrlGambarKartu(),
                imageBuilder: (context, imageProvider) {
                  return Container(
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: imageProvider,
                        fit: BoxFit.cover,
                      ),
                    ),
                  );
                },
                progressIndicatorBuilder: (context, url, downloadProgress) =>
                    CircularProgressIndicator(value: downloadProgress.progress),
                errorWidget: (context, url, error) {
                  return const Icon(
                    Icons.error,
                    size: 48,
                    color: Colors.red,
                  );
                },
              ),
            ),
          ),
          controller.generateWidgetJawaban()
        ],
      ),
    );
  }
}

// import 'package:cached_network_image/cached_network_image.dart';
// import 'package:flutter/material.dart';
// import 'package:survei_aplikasi/features/form_klasik/state/controller_pertanyaan.dart';
// import 'package:survei_aplikasi/features/form_klasik/widgets/quill_soal.dart';

// class FormKartuX extends StatelessWidget {
//   FormKartuX({
//     super.key,
//     required this.controller,
//     required this.index,
//     required this.isCabang,
//     required this.totalSoal,
//   });
//   PertanyaanController controller;
//   int index;
//   int totalSoal;
//   bool isCabang;
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       margin: const EdgeInsets.symmetric(vertical: 12),
//       padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
//       decoration: BoxDecoration(
//           border: Border.all(width: 2),
//           borderRadius: BorderRadius.circular(16),
//           color: Colors.white),
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.start,
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Row(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text("Pertanyaan",
//                       style: Theme.of(context).textTheme.titleMedium!.copyWith(
//                             fontWeight: FontWeight.bold,
//                           )),
//                   if (controller.isWajib())
//                     Text("*Wajib",
//                         style: Theme.of(context).textTheme.titleSmall!.copyWith(
//                               fontWeight: FontWeight.bold,
//                               color: Colors.red,
//                             )),
//                 ],
//               ),
//               if (!isCabang)
//                 Text(
//                   "${index + 1} / $totalSoal",
//                   style: Theme.of(context).textTheme.displaySmall!.copyWith(
//                         fontSize: 16,
//                         color: Colors.black,
//                         fontWeight: FontWeight.bold,
//                       ),
//                 ),
//             ],
//           ),
//           QuilSoal(
//             quillController: controller.getQuillController(),
//           ),
//           const SizedBox(height: 7),
//           Center(
//             child: Container(
//               width: 272,
//               height: 153,
//               margin: const EdgeInsets.only(bottom: 16),
//               decoration: BoxDecoration(border: Border.all(width: 0.75)),
//               child: CachedNetworkImage(
//                 filterQuality: FilterQuality.medium,
//                 imageUrl: controller.getUrlGambarKartu(),
//                 imageBuilder: (context, imageProvider) {
//                   return Container(
//                     decoration: BoxDecoration(
//                       image: DecorationImage(
//                         image: imageProvider,
//                         fit: BoxFit.cover,
//                       ),
//                     ),
//                   );
//                 },
//                 progressIndicatorBuilder: (context, url, downloadProgress) =>
//                     CircularProgressIndicator(value: downloadProgress.progress),
//                 errorWidget: (context, url, error) {
//                   return const Icon(
//                     Icons.error,
//                     size: 48,
//                     color: Colors.red,
//                   );
//                 },
//               ),
//             ),
//           ),
//           controller.generateWidgetJawaban()
//         ],
//       ),
//     );
//   }
// }

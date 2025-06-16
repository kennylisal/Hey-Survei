import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:survei_aplikasi/features/form_klasik/state/controller_pertanyaan.dart';
import 'package:survei_aplikasi/features/form_klasik/widgets/quill_soal.dart';

class FormKartuZ extends StatelessWidget {
  FormKartuZ({
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
        child: LayoutBuilder(
          builder: (context, constraints) {
            return Row(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (controller.isWajib())
                      Text("*Wajib",
                          style:
                              Theme.of(context).textTheme.titleSmall!.copyWith(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.red,
                                  )),
                    const SizedBox(height: 12),
                    Container(
                      width: constraints.maxWidth * 0.325,
                      child: Container(
                        height: 256,
                        width: 144,
                        decoration: BoxDecoration(border: Border.all(width: 1)),
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
                          progressIndicatorBuilder:
                              (context, url, downloadProgress) =>
                                  CircularProgressIndicator(
                                      value: downloadProgress.progress),
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
                  ],
                ),
                Container(
                  width: constraints.maxWidth * 0.675,
                  child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: SingleChildScrollView(
                        scrollDirection: Axis.vertical,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Container(
                              margin: const EdgeInsets.symmetric(vertical: 6),
                              padding: const EdgeInsets.symmetric(
                                  vertical: 8, horizontal: 8),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  if (!isCabang)
                                    Align(
                                      alignment: Alignment.topRight,
                                      child: Text(
                                        "${index + 1} / $totalSoal",
                                        style: Theme.of(context)
                                            .textTheme
                                            .displaySmall!
                                            .copyWith(
                                              fontSize: 16,
                                              color: Colors.black,
                                              fontWeight: FontWeight.bold,
                                            ),
                                      ),
                                    ),
                                  QuilSoal(
                                    quillController:
                                        controller.getQuillController(),
                                  ),
                                ],
                              ),
                            ),
                            controller.generateWidgetJawaban()
                          ],
                        ),
                      )),
                ),
              ],
            );
          },
        ));
  }
}



// class FormKartuZ extends StatelessWidget {
//   FormKartuZ({
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
//         margin: const EdgeInsets.symmetric(vertical: 14, horizontal: 10),
//         padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 12.5),
//         decoration: BoxDecoration(
//           borderRadius: BorderRadius.circular(16),
//           color: Colors.white,
//         ),
//         child: LayoutBuilder(
//           builder: (context, constraints) {
//             return Row(
//               children: [
//                 Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Text("Pertanyaan",
//                             style: Theme.of(context)
//                                 .textTheme
//                                 .titleMedium!
//                                 .copyWith(
//                                   fontWeight: FontWeight.bold,
//                                 )),
//                         if (controller.isWajib())
//                           Text("*Wajib",
//                               style: Theme.of(context)
//                                   .textTheme
//                                   .titleSmall!
//                                   .copyWith(
//                                     fontWeight: FontWeight.bold,
//                                     color: Colors.red,
//                                   )),
//                       ],
//                     ),
//                     const SizedBox(height: 12),
//                     Container(
//                       width: constraints.maxWidth * 0.325,
//                       child: Container(
//                         height: 256,
//                         width: 144,
//                         decoration: BoxDecoration(border: Border.all(width: 1)),
//                         child: CachedNetworkImage(
//                           filterQuality: FilterQuality.medium,
//                           imageUrl: controller.getUrlGambarKartu(),
//                           imageBuilder: (context, imageProvider) {
//                             return Container(
//                               decoration: BoxDecoration(
//                                 image: DecorationImage(
//                                   image: imageProvider,
//                                   fit: BoxFit.cover,
//                                 ),
//                               ),
//                             );
//                           },
//                           progressIndicatorBuilder:
//                               (context, url, downloadProgress) =>
//                                   CircularProgressIndicator(
//                                       value: downloadProgress.progress),
//                           errorWidget: (context, url, error) {
//                             return const Icon(
//                               Icons.error,
//                               size: 48,
//                               color: Colors.red,
//                             );
//                           },
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//                 Container(
//                   width: constraints.maxWidth * 0.675,
//                   child: Container(
//                       padding: const EdgeInsets.symmetric(horizontal: 10),
//                       child: SingleChildScrollView(
//                         scrollDirection: Axis.vertical,
//                         child: Column(
//                           mainAxisAlignment: MainAxisAlignment.start,
//                           children: [
//                             Container(
//                               margin: const EdgeInsets.symmetric(vertical: 6),
//                               padding: const EdgeInsets.symmetric(
//                                   vertical: 8, horizontal: 8),
//                               child: Column(
//                                 mainAxisAlignment: MainAxisAlignment.start,
//                                 crossAxisAlignment: CrossAxisAlignment.start,
//                                 children: [
//                                   if (!isCabang)
//                                     Align(
//                                       alignment: Alignment.topRight,
//                                       child: Text(
//                                         "${index + 1} / $totalSoal",
//                                         style: Theme.of(context)
//                                             .textTheme
//                                             .displaySmall!
//                                             .copyWith(
//                                               fontSize: 16,
//                                               color: Colors.black,
//                                               fontWeight: FontWeight.bold,
//                                             ),
//                                       ),
//                                     ),
//                                   QuilSoal(
//                                     quillController:
//                                         controller.getQuillController(),
//                                   ),
//                                 ],
//                               ),
//                             ),
//                             controller.generateWidgetJawaban()
//                           ],
//                         ),
//                       )),
//                 ),
//               ],
//             );
//           },
//         ));
//   }
// }

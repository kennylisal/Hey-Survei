import 'package:aplikasi_admin/features/formV2/state/form_controller.dart';
import 'package:aplikasi_admin/features/formV2/state/pertanyaan_controller.dart';
import 'package:aplikasi_admin/features/formV2/widget_jawaban/opsi_jawaban.dart';
import 'package:flutter/material.dart';

class ContainerUrutanPilihan extends StatelessWidget {
  ContainerUrutanPilihan({
    super.key,
    required this.listOpsi,
    required this.controller,
    required this.formController,
  });
  final PertanyaanController controller;
  final List<OpsiJawaban> listOpsi;
  final FormController formController;
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ...listOpsi,
          ],
        ),
        const SizedBox(height: 12),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            ElevatedButton.icon(
              icon: const Icon(Icons.add),
              label: const Text("opsi jawaban"),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.lightGreenAccent,
              ),
              onPressed: () {
                controller.tambahOpsiUrutan();
                if (formController.isCabangShown() ||
                    controller.isPertanyaanKartu()) {
                  formController.refreshUI();
                }
              },
            ),
          ],
        )
      ],
    );
  }
}

// class ContainerUrutanPilihan extends StatefulWidget {
//   ContainerUrutanPilihan({
//     super.key,
//     required this.listOpsi,
//     required this.controller,
//     this.formController,
//   });
//   final PertanyaanController controller;
//   final List<OpsiJawaban> listOpsi;
//   FormController? formController;
//   @override
//   State<ContainerUrutanPilihan> createState() => _ContainerUrutanPilihanState();
// }

// class _ContainerUrutanPilihanState extends State<ContainerUrutanPilihan> {
//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       mainAxisAlignment: MainAxisAlignment.start,
//       children: [
//         Column(
//           mainAxisAlignment: MainAxisAlignment.start,
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             ...widget.listOpsi,
//           ],
//         ),
//         const SizedBox(height: 12),
//         Row(
//           mainAxisAlignment: MainAxisAlignment.start,
//           children: [
//             ElevatedButton.icon(
//               icon: const Icon(Icons.add),
//               label: const Text("opsi jawaban"),
//               style: ElevatedButton.styleFrom(
//                 backgroundColor: Colors.lightGreenAccent,
//               ),
//               onPressed: () => setState(() {
//                 widget.controller.tambahOpsiUrutan();

//                 setState(() {});
//               }),
//             ),
//           ],
//         )
//       ],
//     );
//   }
// }

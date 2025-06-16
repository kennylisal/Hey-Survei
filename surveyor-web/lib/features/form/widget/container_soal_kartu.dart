import 'package:flutter/material.dart';
import 'package:hei_survei/features/form/constant.dart';
import 'package:hei_survei/features/form/state/form_controller.dart';
import 'package:hei_survei/features/form/state/pertanyaan_controller.dart';
import 'package:hei_survei/features/form/widget/soal_x.dart';
import 'package:hei_survei/features/form/widget/soal_y.dart';
import 'package:hei_survei/features/form/widget/soal_z.dart';

class ContainerSoalKartu extends StatelessWidget {
  ContainerSoalKartu(
      {super.key, required this.controller, required this.formController});
  PertanyaanController controller;
  FormController formController;

  Widget generateWidgetSoal() {
    if (controller.getModelSoal() == ModelSoal.modelY) {
      return SoalModelY(
        controller: controller,
        formController: formController,
      );
    } else if (controller.getModelSoal() == ModelSoal.modelZ) {
      return SoalModelZ(
        controller: controller,
        formController: formController,
      );
    } else {
      return SoalModelX(
        controller: controller,
        formController: formController,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return generateWidgetSoal();
  }
}

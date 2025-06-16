import 'package:flutter/material.dart';
import 'package:hei_survei/features/form/state/form_controller.dart';
import 'package:hei_survei/features/form/state/pertanyaan_controller.dart';
import 'package:hei_survei/features/form/widget/quill_pembatas.dart';

class PembatasForm extends StatelessWidget {
  PembatasForm({
    super.key,
    required this.controller,
    required this.formController,
  });
  PertanyaanController controller;
  FormController formController;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 12, bottom: 16),
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 4),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        children: [
          Row(
            children: <Widget>[
              const SizedBox(width: 60),
              Text(
                "Bagian Form : ",
                style: Theme.of(context)
                    .textTheme
                    .titleLarge!
                    .copyWith(fontSize: 18, color: Colors.black),
              ),
              SizedBox(
                  width: 230,
                  child: TextField(
                    controller: controller.getPembatasController(),
                    decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: "Masukkan Nama Bagian"),
                    style: Theme.of(context)
                        .textTheme
                        .titleLarge!
                        .copyWith(fontSize: 18, color: Colors.black),
                  )),
              const Spacer(),
              CircleAvatar(
                radius: 20,
                backgroundColor: Colors.red,
                child: IconButton(
                    onPressed: () =>
                        formController.hapusPembatas(controller.getIdSoal()),
                    icon: Icon(
                      Icons.delete,
                      size: 20,
                      color: Colors.white,
                    )),
              ),
              const SizedBox(width: 10),
            ],
          ),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 60),
            child: QuillPembatas(quillController: controller.getQController()),
          )
        ],
      ),
    );
  }
}

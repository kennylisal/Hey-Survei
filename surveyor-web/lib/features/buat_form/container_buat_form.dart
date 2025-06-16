import 'package:flutter/material.dart';
import 'package:hei_survei/features/buat_form/buat_survei.dart';
import 'package:hei_survei/features/buat_form/template_kartu.dart';
import 'package:hei_survei/features/buat_form/template_klasik.dart';

enum HalamanPilihan { buatForm, templateKlasik, templateKartu }

class ContainerBuatForm extends StatefulWidget {
  ContainerBuatForm({
    super.key,
    required this.constraints,
  });
  BoxConstraints constraints;
  @override
  State<ContainerBuatForm> createState() => _ContainerBuatFormState();
}

class _ContainerBuatFormState extends State<ContainerBuatForm> {
  HalamanPilihan halPilihan = HalamanPilihan.buatForm;

  Widget generateKonten() {
    if (halPilihan == HalamanPilihan.buatForm) {
      return BuatSurvei(
        constraints: widget.constraints,
        ontapKartu: () {
          setState(() {
            print("ganti ke kartu");
            halPilihan = HalamanPilihan.templateKartu;
          });
        },
        ontapKlasik: () {
          setState(() {
            halPilihan = HalamanPilihan.templateKlasik;
          });
        },
      );
    } else if (halPilihan == HalamanPilihan.templateKartu) {
      return HalamanTemplateKartu(
        constraints: widget.constraints,
        onTapKembali: () {
          setState(() {
            halPilihan = HalamanPilihan.buatForm;
          });
        },
      );
    } else {
      return HalamanTemplateKlasik(
        constraints: widget.constraints,
        onTapKembali: () {
          setState(() {
            halPilihan = HalamanPilihan.buatForm;
          });
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return generateKonten();
  }
}

import 'package:flutter/material.dart';
import 'package:hei_survei/features/buat_form/controller.dart';

class PercobaanTemplate extends StatefulWidget {
  const PercobaanTemplate({super.key});

  @override
  State<PercobaanTemplate> createState() => _PercobaanTemplateState();
}

class _PercobaanTemplateState extends State<PercobaanTemplate> {
  initData() async {
    String hasil = await BuatFormController()
        .buatFormKlasikDariTemplate(idForm: '183451fe', context: context);
  }

  @override
  void initState() {
    initData();
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          children: [
            Text("Sukses"),
          ],
        ),
      ),
    );
  }
}

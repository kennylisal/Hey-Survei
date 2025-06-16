import 'package:flutter/material.dart';
import 'package:survei_aplikasi/features/form_klasik/models/data_pertanyaan.dart';
import 'package:survei_aplikasi/features/form_klasik/state/controller_pertanyaan.dart';

class JawabanUrutan extends StatefulWidget {
  JawabanUrutan({
    super.key,
    required this.controller,
    required this.dataUrutan,
  });
  PertanyaanController controller;
  DataUrutan dataUrutan;

  @override
  State<JawabanUrutan> createState() => _JawabanUrutanState();
}

class _JawabanUrutanState extends State<JawabanUrutan> {
  double generateHeight() {
    if (widget.dataUrutan.listPilihan.length > 2) {
      return 190;
    } else {
      return 130;
    }
  }

  @override
  Widget build(BuildContext context) {
    final ColorScheme colorScheme = Theme.of(context).colorScheme;
    final Color evenItemColor = colorScheme.primary.withOpacity(0.15);
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const SizedBox(height: 8),
        Text(
          "Urutkan Pilihan Berikut ",
          style: Theme.of(context)
              .textTheme
              .headlineSmall!
              .copyWith(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        const SizedBox(height: 12),
        Center(
          child: Container(
            width: 275,
            padding: const EdgeInsets.symmetric(vertical: 5.5, horizontal: 3),
            height: generateHeight(),
            decoration: BoxDecoration(border: Border.all(width: 1)),
            child: ReorderableListView(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              children: [
                for (int i = 0; i < widget.dataUrutan.listPilihan.length; i++)
                  Container(
                    key: Key(widget.dataUrutan.listPilihan[i].idPilihan),
                    padding: const EdgeInsets.fromLTRB(8, 8, 0, 8),
                    margin: const EdgeInsets.symmetric(vertical: 8),
                    width: double.infinity,
                    color: evenItemColor,
                    child: Text(
                      widget.dataUrutan.listPilihan[i].pilihan,
                      style: Theme.of(context)
                          .textTheme
                          .headlineSmall!
                          .copyWith(fontSize: 18.5),
                    ),
                  )
              ],
              onReorder: (oldIndex, newIndex) {
                setState(() {
                  if (oldIndex < newIndex) {
                    newIndex -= 1;
                  }
                  widget.controller.ubahOrderUrutan(newIndex, oldIndex);
                });
              },
            ),
          ),
        ),
        const SizedBox(height: 9),
        Text(
          "Drag dan Drop Urutan Diatas",
          style: Theme.of(context)
              .textTheme
              .headlineSmall!
              .copyWith(fontWeight: FontWeight.bold, fontSize: 15),
        ),
      ],
    );
  }
}

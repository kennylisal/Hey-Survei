import 'package:flutter/material.dart';
import 'package:survei_aplikasi/features/form_klasik/models/data_pertanyaan.dart';

class JawabanTabelZ extends StatefulWidget {
  const JawabanTabelZ({
    super.key,
    required this.dataTabel,
  });
  final DataTabel dataTabel;
  @override
  State<JawabanTabelZ> createState() => _JawabanTabelZState();
}

class _JawabanTabelZState extends State<JawabanTabelZ> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text("Tabel jawaban",
            style: Theme.of(context)
                .textTheme
                .titleMedium!
                .copyWith(fontWeight: FontWeight.bold)),
        const SizedBox(height: 6),
        Container(
          margin: const EdgeInsets.fromLTRB(16, 0, 16, 16),
          child: Table(
            border: TableBorder.all(
              width: 2,
            ),
            children: [
              if (widget.dataTabel.berjudul)
                TableRow(
                  children: [
                    for (var j = 0; j < widget.dataTabel.baris; j++)
                      Container(
                        height: 35,
                        color: Colors.blue,
                        child: Center(
                          child: Text(widget.dataTabel.listJudul[j],
                              style: Theme.of(context)
                                  .textTheme
                                  .titleMedium!
                                  .copyWith(fontWeight: FontWeight.bold)),
                        ),
                      ),
                  ],
                ),
              for (var i = 0; i < widget.dataTabel.kolom; i++)
                TableRow(
                  children: [
                    for (var j = 0; j < widget.dataTabel.baris; j++)
                      Container(
                        height: 50,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 15, vertical: 7),
                        child: TextField(
                          controller: widget.dataTabel.mapController[j]![i],
                        ),
                      )
                  ],
                ),
            ],
          ),
        ),
      ],
    );
  }
}

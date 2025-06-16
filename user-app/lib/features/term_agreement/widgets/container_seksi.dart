import 'package:flutter/material.dart';

class ContainerSeksi extends StatefulWidget {
  ContainerSeksi({super.key, required this.konten, required this.teksJudul});
  String teksJudul;
  List<Widget> konten;
  @override
  State<ContainerSeksi> createState() => _ContainerSeksiState();
}

class _ContainerSeksiState extends State<ContainerSeksi> {
  bool isDetail = false;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        InkWell(
          onTap: () => setState(() {
            isDetail = !isDetail;
          }),
          child: Container(
            width: double.infinity,
            color: Colors.grey.shade800,
            padding: EdgeInsets.symmetric(vertical: 9, horizontal: 10),
            child: Text(
              widget.teksJudul,
              style: Theme.of(context).textTheme.displaySmall!.copyWith(
                    fontSize: 18,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
              textAlign: TextAlign.justify,
            ),
          ),
        ),
        if (isDetail)
          Container(
            padding: const EdgeInsets.only(right: 14),
            margin: const EdgeInsets.only(left: 32, top: 12),
            child: Column(children: widget.konten),
          ),
        const SizedBox(height: 7),
      ],
    );
  }
}

import 'package:flutter/material.dart';

class ContainerSeksiV2 extends StatefulWidget {
  ContainerSeksiV2({
    super.key,
    required this.konten,
    required this.teksJudul,
    required this.kontenBiasa,
  });
  String teksJudul;
  List<Widget> konten;
  List<Widget> kontenBiasa;
  @override
  State<ContainerSeksiV2> createState() => _ContainerSeksiV2State();
}

class _ContainerSeksiV2State extends State<ContainerSeksiV2> {
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
            child: Column(children: widget.kontenBiasa),
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

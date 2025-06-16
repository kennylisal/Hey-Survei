import 'package:flutter/material.dart';

class TabelLaporanUtama extends StatefulWidget {
  TabelLaporanUtama({
    super.key,
    required this.mapData,
    required this.judul1,
    required this.judul2,
    required this.isModeAngka,
  });
  Map<String, String> mapData;
  String judul1;
  String judul2;
  bool isModeAngka;
  @override
  State<TabelLaporanUtama> createState() => _TabelLaporanUtamaState();
}

class _TabelLaporanUtamaState extends State<TabelLaporanUtama> {
  Map<String, String> mapTampilan = {};
  final mapFractionAngka = const {
    0: FractionColumnWidth(0.2),
    1: FractionColumnWidth(0.8),
  };

  final mapFractionString = const {
    0: FractionColumnWidth(0.5),
    1: FractionColumnWidth(0.5),
  };

  searchData(String search) {
    print("Ter-search $search");
    mapTampilan = {};
    for (var element in widget.mapData.entries) {
      if (element.value.toLowerCase().contains(search.toLowerCase())) {
        print("ini yang di cek ${element.value.toLowerCase()}");
        mapTampilan[element.key] = element.value;
      }
    }
    setState(() {});
  }

  List<TableRow> generateTableModeAngka() {
    List<TableRow> list = [];
    for (var element in mapTampilan.entries) {
      list.add(
        TableRow(children: [
          Container(
            height: 40,
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 7),
            child: Text(
              element.key,
              style: Theme.of(context).textTheme.titleMedium!.copyWith(
                  fontSize: 15,
                  color: Colors.black,
                  wordSpacing: 1.2,
                  fontWeight: FontWeight.w400),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          Container(
            height: 40,
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 7),
            child: InkWell(
              mouseCursor: SystemMouseCursors.click,
              child: Text(
                element.value,
                style: Theme.of(context).textTheme.titleMedium!.copyWith(
                    fontSize: 15,
                    color: Colors.black,
                    wordSpacing: 1.2,
                    fontWeight: FontWeight.w400),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ),
        ]),
      );
    }
    return list;
  }

  List<TableRow> generateTableModeString() {
    List<TableRow> list = [];
    for (var element in mapTampilan.entries) {
      list.add(
        TableRow(children: [
          Container(
            height: 40,
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 7),
            child: InkWell(
              mouseCursor: SystemMouseCursors.click,
              child: Text(
                element.key,
                style: Theme.of(context).textTheme.titleMedium!.copyWith(
                    fontSize: 15,
                    color: Colors.black,
                    wordSpacing: 1.2,
                    fontWeight: FontWeight.w400),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ),
          Container(
            height: 40,
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 7),
            child: Text(
              element.value,
              style: Theme.of(context).textTheme.titleMedium!.copyWith(
                  fontSize: 15,
                  color: Colors.black,
                  wordSpacing: 1.2,
                  fontWeight: FontWeight.w400),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ]),
      );
    }
    return list;
  }

  @override
  void initState() {
    setState(() {
      mapTampilan = widget.mapData;
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 318,
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 2),
            margin: const EdgeInsets.symmetric(vertical: 12, horizontal: 80),
            decoration: BoxDecoration(
                border: Border.all(width: 2),
                borderRadius: BorderRadius.circular(16)),
            child: TextField(
              onSubmitted: (value) => searchData(value),
              decoration: InputDecoration(
                  border: InputBorder.none, hintText: "Cari Jawaban"),
            ),
          ),
          Container(
            margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 50),
            child: Text(
              "Tabel Jawaban",
              style: Theme.of(context).textTheme.titleMedium!.copyWith(
                  fontSize: 17,
                  color: Colors.black,
                  fontWeight: FontWeight.bold),
            ),
          ),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 50),
            height: 200,
            child: SingleChildScrollView(
              child: Table(
                border: TableBorder.all(width: 2),
                columnWidths:
                    (widget.isModeAngka) ? mapFractionAngka : mapFractionString,
                children: [
                  TableRow(
                    children: [
                      Container(
                        height: 35,
                        color: Colors.lightGreen.shade400,
                        child: Center(
                          child: Text(
                            widget.judul1,
                            style: Theme.of(context)
                                .textTheme
                                .titleMedium!
                                .copyWith(fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                      Container(
                        height: 35,
                        color: Colors.lightGreen.shade400,
                        child: Center(
                          child: Text(
                            widget.judul2,
                            style: Theme.of(context)
                                .textTheme
                                .titleMedium!
                                .copyWith(fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                    ],
                  ),
                  ...generateTableModeString(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

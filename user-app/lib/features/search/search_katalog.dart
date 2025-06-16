import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:survei_aplikasi/constants.dart';
import 'package:survei_aplikasi/features/home/widgets/kartu_baru.dart';
import 'package:survei_aplikasi/features/search/model/h_survei.dart';
import 'package:survei_aplikasi/features/search/search_controller.dart';
import 'package:survei_aplikasi/utils/loading_biasa.dart';
import 'package:survei_aplikasi/utils/web_pagination.dart';

class SearchKatalog extends StatefulWidget {
  SearchKatalog({super.key, required this.doCarikan});
  bool doCarikan;
  @override
  State<SearchKatalog> createState() => _SearchKatalogState();
}

class _SearchKatalogState extends State<SearchKatalog> {
  int jumlahItemPerhalaman = 4;
  int jumlahHalaman = 0;
  int ctrPagination = 1;
  List<HSurvei> widgetTampilan = [];
  //pagination
  List<HSurvei> listSearch = [];
  List<String> daftarIdPengecualian = [];
  bool isLoading = true;
  String nilaiDrop = "1";
  final controller = TextEditingController();

  setPagination() {
    if (listSearch.isEmpty) {
      jumlahHalaman = 0;
      ctrPagination = 0;
      isiHasilDitampilkan(0);
    } else {
      jumlahHalaman = (listSearch.length ~/ jumlahItemPerhalaman) +
          ((listSearch.length % jumlahItemPerhalaman > 0) ? 1 : 0);
      print(
          "isi hasil ditampilkan ->  lbh 1 || jumlah halaman -> $jumlahHalaman");
      isiHasilDitampilkan(1);
      ctrPagination = 1;
    }
  }

  isiHasilDitampilkan(int nomorHalaman) {
    if (nomorHalaman != 0) {
      int index = nomorHalaman - 1;
      int awal = index * jumlahItemPerhalaman;
      int jumlah = 0;
      if ((awal + jumlahItemPerhalaman) >= listSearch.length) {
        jumlah = listSearch.length;
      } else {
        jumlah = nomorHalaman * jumlahItemPerhalaman;
      }

      print("ini awal -> $awal || ini jumlah -> $jumlah");
      List<HSurvei> temp = listSearch.sublist(awal, jumlah);
      widgetTampilan = temp;
    }
  }

  prosesPengisianDefault() async {
    daftarIdPengecualian = await SearchControllerX().getSurveiPengecualian();
    if (widget.doCarikan) {
      // daftarIdPengecualian = [];

      listSearch = await SearchControllerX().getSurveiTerbaruDefault();
      for (var i = 0; i < daftarIdPengecualian.length; i++) {
        listSearch.removeWhere(
            (element) => element.id_survei == daftarIdPengecualian[i]);
      }
    }
    setPagination();

    setState(() {
      isLoading = false;
    });
  }

  cariSurvei(String value) async {
    setState(() {
      isLoading = true;
    });
    await prosesPengisianData(value);
    sortData();
    setPagination();
    setState(() {
      isLoading = false;
    });
  }

  sortData() {
    if (nilaiDrop == "1") {
      listSearch.sort(
        (a, b) => b.insentif.compareTo(a.insentif),
      );
    } else if (nilaiDrop == "2") {
      listSearch.sort(
        (a, b) => b.tanggalPenerbitan.compareTo(a.tanggalPenerbitan),
      );
    } else if (nilaiDrop == "3") {
      listSearch.sort(
        (a, b) => a.tanggalPenerbitan.compareTo(b.tanggalPenerbitan),
      );
    } else if (nilaiDrop == "4") {
      listSearch.sort(
        (a, b) => a.durasi.compareTo(b.durasi),
      );
    }
    setState(() {});
  }

  prosesPengisianData(String value) async {
    listSearch = await SearchControllerX().searchHSurvei(search: value);

    for (var i = 0; i < daftarIdPengecualian.length; i++) {
      listSearch.removeWhere((element) {
        print("${element.id_survei} || ${daftarIdPengecualian[i]}");
        return element.id_survei == daftarIdPengecualian[i];
      });
    }
  }

  Widget contentGenerator(BoxConstraints constraints) {
    if (isLoading) {
      return Center(
        child: LoadingBiasa(
          textLoading: "Memuat Survei",
        ),
      );
    } else if (listSearch.isNotEmpty) {
      return Column(
          children: List.generate(
              listSearch.length,
              (index) => KartuKatalog(
                    dataKatalog: listSearch[index],
                    constraints: constraints,
                  )));
    } else {
      return const NoResult();
    }
  }

  @override
  void initState() {
    prosesPengisianDefault();
    super.initState();
  }

  Widget contentGeneratorV2(BoxConstraints constraints) {
    if (isLoading) {
      return Center(
        child: LoadingBiasa(
          textLoading: "Mencari Survei",
        ),
      );
    } else if (listSearch.isNotEmpty) {
      return Column(children: [
        ...List.generate(
            widgetTampilan.length,
            (index) => KartuKatalog(
                  dataKatalog: widgetTampilan[index],
                  constraints: constraints,
                )),
        const SizedBox(height: 10),
        WebPagination(
          onPageChanged: (value) {
            setState(() {
              ctrPagination = value;
              isiHasilDitampilkan(ctrPagination);
            });
          },
          currentPage: ctrPagination,
          totalPage: jumlahHalaman,
          displayItemCount: 5,
        ),
        const SizedBox(height: 14),
      ]);
    } else {
      return NoResult();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
          child: LayoutBuilder(builder: (context, constraints) {
        print(constraints.maxWidth);
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: double.infinity,
              height: 12.5,
              color: Colors.blueAccent.shade700,
            ),
            Container(
              height: 172,
              child: Stack(
                children: [
                  Container(
                      height: 163,
                      padding: const EdgeInsets.only(
                        left: 20,
                        right: 24,
                        bottom: 40,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.blueAccent.shade700,
                        borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(36),
                          bottomRight: Radius.circular(36),
                        ),
                      ),
                      child: Row(
                        children: [
                          IconButton(
                              onPressed: () => context.pop(),
                              icon: const Icon(
                                Icons.arrow_back,
                                color: Colors.black,
                                size: 26,
                              )),
                          Text(
                            'Pencarian Survei',
                            style: Theme.of(context)
                                .textTheme
                                .displayMedium!
                                .copyWith(
                                  fontSize: 22.5,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                          ),
                          const Spacer(),
                          if (constraints.maxWidth > 344)
                            Container(
                              padding: EdgeInsets.all(8),
                              decoration: const BoxDecoration(
                                color: Colors.white,
                                shape: BoxShape.circle,
                              ),
                              child: Image.asset(
                                'assets/logo-app.png',
                                height: 50,
                              ),
                            ),
                        ],
                      )),
                  Positioned(
                    bottom: 18,
                    left: 0,
                    right: 0,
                    child: Container(
                      alignment: Alignment.center,
                      margin: EdgeInsets.symmetric(horizontal: kDefaultPadding),
                      padding: EdgeInsets.only(left: 20),
                      height: 54,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            offset: Offset(0, 10),
                            blurRadius: 50,
                            color: kPrimaryColor.withOpacity(0.4),
                          ),
                        ],
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: TextField(
                              controller: controller,
                              onSubmitted: (value) {
                                cariSurvei(value);
                              },
                              decoration: InputDecoration.collapsed(
                                hintText: "Cari Survei",
                                hintStyle: Theme.of(context)
                                    .textTheme
                                    .displayMedium!
                                    .copyWith(
                                      fontSize: 18,
                                      color: Colors.blue.withOpacity(0.5),
                                    ),
                              ),
                            ),
                          ),
                          InkWell(
                            onTap: () {
                              cariSurvei(controller.text);
                            },
                            child: Container(
                              height: 54,
                              width: 60,
                              decoration: BoxDecoration(
                                  color: Colors.blue,
                                  borderRadius: BorderRadius.only(
                                      topRight: Radius.circular(20),
                                      bottomRight: Radius.circular(20))),
                              child: Icon(
                                Icons.search,
                                color: Colors.white,
                                size: 36,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),
            Container(
              width: 200,
              margin: const EdgeInsets.only(left: 17, bottom: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Urutkan : "),
                  Container(
                    color: Colors.grey.shade100,
                    child: InputDecorator(
                      decoration: InputDecoration(
                          border: OutlineInputBorder(
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(4.0))),
                          contentPadding: EdgeInsets.all(10)),
                      child: DropdownButtonHideUnderline(
                          child: DropdownButton(
                        value: nilaiDrop,
                        isDense: true,
                        isExpanded: true,
                        items: [
                          DropdownMenuItem(
                              child: Text("Insentif Tertinggi"), value: "1"),
                          DropdownMenuItem(
                              child: Text("Terbit Terbaru"), value: "2"),
                          DropdownMenuItem(
                              child: Text("Terbit Terlama"), value: "3"),
                          DropdownMenuItem(
                              child: Text("Pengerjaan Tercepat"), value: "4"),
                        ],
                        onChanged: (value) {
                          setState(() {
                            print(value);
                            nilaiDrop = value!;
                          });
                          sortData();
                          setPagination();
                        },
                      )),
                    ),
                  )
                ],
              ),
            ),
            HeaderPencarian(judul: "Hasil Pencarian"),
            contentGeneratorV2(constraints)
          ],
        );
      })),
    );
  }
}

class HeaderPencarian extends StatelessWidget {
  const HeaderPencarian({
    super.key,
    required this.judul,
  });
  final String judul;
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(left: 20, bottom: 0),
      child: Text(
        judul,
        style: Theme.of(context).textTheme.displayMedium!.copyWith(
              fontSize: 20,
              color: Colors.black,
              fontWeight: FontWeight.bold,
            ),
      ),
    );
  }
}

class NoResult extends StatelessWidget {
  const NoResult({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 30),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Image.asset(
            'assets/no-data-katalog.png',
            height: 180,
            fit: BoxFit.contain,
          ),
        )
      ],
    );
  }
}

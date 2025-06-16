import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hei_survei/app/app.dart';
import 'package:hei_survei/features/main/main_page.dart';
import 'package:hei_survei/constants.dart';
import 'package:hei_survei/features/katalog/katalog_controller.dart';
import 'package:hei_survei/features/katalog/model/survei_data.dart';
import 'package:hei_survei/features/katalog/widgets/kartu_survei.dart';
import 'package:hei_survei/utils/loading_biasa.dart';
import 'package:hei_survei/utils/web_pagination.dart';

class HalamanKatalog extends ConsumerStatefulWidget {
  HalamanKatalog({
    super.key,
    required this.constraints,
  });
  BoxConstraints constraints;
  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _HalamanKatalogState();
}

class _HalamanKatalogState extends ConsumerState<HalamanKatalog>
    with AutomaticKeepAliveClientMixin<HalamanKatalog> {
  //variable pagination
  int jumlahHalaman = 0;
  int jumlahItemPerhalaman = 4;
  int ctrPagination = 1;
  List<Widget> widgetTampilan = []; //ini yg menentukan apa yg ditampilkan
  //
  //variabel search
  String pilihanOrder = 'Termahal';
  List<SurveiData> listSurvei = [];
  List<String> daftarIdPengecualian = [];
  //
  //variabel filter kategori
  Map<String, bool>? mapCheck;
  bool isFilterExpanded = false;
  List<String> listKategori = [];
  List<String> arrFilter = [];
  //
  bool isLoading = false;
  final controllerSearch = TextEditingController();
  @override
  void initState() {
    initData();
    super.initState();
  }

  initData() async {
    daftarIdPengecualian = await KatalogController().getSurveiPengecualian();
    listKategori = await KatalogController().getAllKategori();
    mapCheck = Map.fromIterables(listKategori,
        List.from(List.generate(listKategori.length, (index) => false)));
    setState(() {});
  }

  eliminasiSurvei() {
    for (var i = 0; i < daftarIdPengecualian.length; i++) {
      listSurvei.removeWhere(
          (element) => element.id_survei == daftarIdPengecualian[i]);
    }
  }

  resetFilter() {
    mapCheck!.forEach((key, value) {
      mapCheck![key] = false;
      setState(() {});
    });
  }

  siapkanFilter() {
    arrFilter.clear();
    mapCheck!.forEach((key, value) {
      if (value) arrFilter.add(key);
    });
  }

  List<Widget> rowGeneratorFilter(int angka, BuildContext context) {
    int pembagi = angka;
    int indexInduk = -1;
    List<Widget> hasil = List.generate(
      listKategori.length ~/ pembagi + 1,
      (index) => Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: List.generate(pembagi, (index) {
          if (indexInduk < listKategori.length - 1) {
            indexInduk++;
            String keyNow = listKategori[indexInduk];
            //print(indexInduk);
            return Expanded(
                child: Container(
              padding: const EdgeInsets.symmetric(vertical: 4),
              child: Row(
                children: [
                  Checkbox(
                    fillColor: MaterialStateColor.resolveWith(
                        (states) => Colors.grey.shade300),
                    checkColor: Colors.black,
                    value: mapCheck![listKategori[indexInduk]],
                    onChanged: (value) {
                      setState(() {
                        mapCheck![keyNow] = value!;
                      });
                    },
                  ),
                  Container(
                    child: Text(
                      listKategori[indexInduk],
                      overflow: TextOverflow.fade,
                      style: Theme.of(context).textTheme.displaySmall!.copyWith(
                            fontSize: 16,
                            color: Colors.grey.shade100,
                          ),
                    ),
                  ),
                ],
              ),
            ));
          } else {
            return Expanded(child: SizedBox());
          }
        }),
      ),
    );
    return hasil;
  }

  Widget kategoriGenerator(BoxConstraints constraints) {
    if (mapCheck != null) {
      if (isFilterExpanded) {
        return Container(
          margin: EdgeInsets.symmetric(
              horizontal: (constraints.maxWidth > 550) ? 120 : 96,
              vertical: 20),
          padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 6),
          decoration: BoxDecoration(
            color: Colors.blueGrey.shade700,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            children: [
              Row(
                children: [
                  Text(
                    "Filter",
                    style: Theme.of(context).textTheme.displaySmall!.copyWith(
                          fontSize: 27,
                          color: Colors.white,
                        ),
                  ),
                  const Spacer(),
                  IconButton.filled(
                      onPressed: () {
                        setState(() {
                          isFilterExpanded = false;
                        });
                      },
                      icon: Icon(
                        Icons.arrow_upward,
                        size: 30,
                      ))
                ],
              ),
              Divider(
                color: Colors.black.withOpacity(0.6),
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: rowGeneratorFilter(
                    (constraints.maxWidth > 1700)
                        ? 4
                        : (constraints.maxWidth > 1080)
                            ? 3
                            : (constraints.maxWidth > 780)
                                ? 2
                                : 1,
                    context),
              ),
              Divider(
                color: Colors.black.withOpacity(0.6),
              ),
              Container(
                padding:
                    const EdgeInsets.symmetric(vertical: 4, horizontal: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        searchSurvei(controllerSearch.text);
                        print(arrFilter);
                      },
                      child: Text(
                        "Cari",
                        style:
                            Theme.of(context).textTheme.displaySmall!.copyWith(
                                  fontSize: 16,
                                  color: Colors.grey.shade200,
                                ),
                      ),
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green.shade600),
                    ),
                    const SizedBox(width: 12),
                    ElevatedButton(
                      onPressed: () {
                        resetFilter();
                      },
                      child: Text(
                        "Ulang",
                        style:
                            Theme.of(context).textTheme.displaySmall!.copyWith(
                                  fontSize: 16,
                                  color: Colors.grey.shade200,
                                ),
                      ),
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red.shade600),
                    ),
                    const SizedBox(height: 3),
                  ],
                ),
              )
            ],
          ),
        );
      } else {
        return Container(
          margin: const EdgeInsets.symmetric(horizontal: 120, vertical: 20),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
          height: 60,
          decoration: BoxDecoration(
            color: Colors.blueGrey.shade600,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Row(
            children: [
              Text(
                "Filter Kategori",
                style: Theme.of(context).textTheme.displaySmall!.copyWith(
                      fontSize: 27,
                      color: Colors.white,
                    ),
              ),
              const Spacer(),
              IconButton.filled(
                  onPressed: () {
                    setState(() {
                      isFilterExpanded = true;
                    });
                  },
                  icon: Icon(
                    Icons.arrow_downward,
                    size: 30,
                  ))
            ],
          ),
        );
      }
    } else {
      return const Center(
        child: SizedBox(
          height: 60,
          width: 60,
          child: CircularProgressIndicator(strokeWidth: 16),
        ),
      );
    }
  }

  isiHasilDitampilkan(int nomorHalaman) {
    if (nomorHalaman != 0) {
      int index = nomorHalaman - 1;
      int awal = index * jumlahItemPerhalaman;
      int jumlah = 0;
      if ((awal + jumlahItemPerhalaman) >= listSurvei.length) {
        jumlah = listSurvei.length;
      } else {
        jumlah = nomorHalaman * jumlahItemPerhalaman;
      }

      print("ini awal -> $awal || ini jumlah -> $jumlah");
      List<SurveiData> temp = listSurvei.sublist(awal, jumlah);
      widgetTampilan = List.generate(
          temp.length,
          (index) => KartuSurvei(
                surveiData: temp[index],
                onTap: () {
                  ref
                      .read(dataUtamaProvider.notifier)
                      .gantiIdSurvei(temp[index].id_survei);

                  ref.read(indexUtamaProvider.notifier).update((state) => 6);
                },
              ));
    }
    setState(() {});
  }

  List<Widget> rowGenerator(BuildContext context, int pembagi) {
    int indexInduk = -1;

    List<Widget> listWidget = widgetTampilan;
    List<Widget> hasil =
        List.generate(listWidget.length ~/ pembagi + 1, (index) {
      return Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: List.generate(pembagi, (index) {
            if (indexInduk < listWidget.length - 1) {
              indexInduk++;
              return listWidget[indexInduk];
            } else
              return SizedBox(
                width: 275,
              );
          }));
    });

    return hasil;
  }

  setPagination() {
    if (listSurvei.isEmpty) {
      jumlahHalaman = 0;
      ctrPagination = 0;
      isiHasilDitampilkan(0);
    } else {
      jumlahHalaman = (listSurvei.length ~/ jumlahItemPerhalaman) +
          ((listSurvei.length % jumlahItemPerhalaman > 0) ? 1 : 0);
      print(
          "isi hasil ditampilkan ->  lbh 1 || jumlah halaman -> $jumlahHalaman");
      isiHasilDitampilkan(1);
      ctrPagination = 1;
    }
  }

  searchSurvei(String search) async {
    if (!isLoading) {
      setState(() {
        isLoading = true;
      });
      siapkanFilter(); //ini untuk cari yg mana sja filter yg mau
      listSurvei = await KatalogController()
          .searchHSurvei(search: search, kategori: arrFilter);
      eliminasiSurvei();
      sortDataSurvei(pilihanOrder);
      setPagination();
      // print(listSurvei);
      setState(() {
        isLoading = false;
      });
    }
  }

  sortDataSurvei(String order) {
    setState(() {
      pilihanOrder = order;
      if (order == "Terbaru") {
        listSurvei
            .sort((b, a) => a.tanggalPenerbitan.compareTo(b.tanggalPenerbitan));
      } else if (order == "Terlama") {
        listSurvei
            .sort((a, b) => a.tanggalPenerbitan.compareTo(b.tanggalPenerbitan));
      } else if (order == "Termurah") {
        listSurvei.sort((a, b) => a.harga.compareTo(b.harga));
      } else if (order == "Termahal") {
        listSurvei.sort((b, a) => a.harga.compareTo(b.harga));
      } else {
        listSurvei.sort(
          (b, a) => a.jumlahPartisipan.compareTo(b.jumlahPartisipan),
        );
      }
      // setPagination();
      print(listSurvei);
    });
    setPagination();
  }

  Widget generateBody() {
    if (isLoading) {
      return Column(
        children: [
          const SizedBox(height: 14),
          LoadingBiasa(text: "Memuat data pencarian", pakaiKembali: false),
        ],
      );
    } else {
      if (listSurvei.isEmpty) {
        return const TidakAdaData();
      } else {
        return Column(
          children: [
            ...rowGenerator(
                context,
                (widget.constraints.maxWidth > 1600)
                    ? 3
                    : (widget.constraints.maxWidth > 1200)
                        ? 2
                        : 1),
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
            const SizedBox(height: 12),
          ],
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    double widhtMultiplier =
        (widget.constraints.maxWidth > 1325) ? 0.16 : 0.088;
    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(
              horizontal: widget.constraints.maxWidth * widhtMultiplier,
            ),
            decoration: BoxDecoration(
                color: Colors.blue.shade200,
                borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(20),
                    bottomRight: Radius.circular(20))),
            child: Column(
              children: [
                const SizedBox(height: 10),
                Text(
                  "Pencarian Katalog Survei",
                  style: Theme.of(context).textTheme.displaySmall!.copyWith(
                      fontWeight: FontWeight.bold,
                      fontSize: 48,
                      color: Colors.black),
                ),
                const SizedBox(height: 14),
                Container(
                  width: double.infinity,
                  height: 80,
                  child: Row(
                    children: [
                      Expanded(
                          flex: 3,
                          child: Container(
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(12),
                                    bottomLeft: Radius.circular(12)),
                                color: Colors.grey.shade50,
                              ),
                              padding: const EdgeInsets.fromLTRB(24, 4, 24, 4),
                              child: TextField(
                                controller: controllerSearch,
                                decoration: InputDecoration(
                                  hintText: "Nama Survei",
                                  border: InputBorder.none,
                                ),
                                style: Theme.of(context)
                                    .textTheme
                                    .displaySmall!
                                    .copyWith(
                                      fontSize: 17,
                                      color: Colors.black,
                                    ),
                                onSubmitted: (value) => searchSurvei(value),
                              ),
                            ),
                          )),
                      Container(
                        child: Container(
                          height: 59,
                          width: 70,
                          decoration: BoxDecoration(
                              color: Colors.blue,
                              borderRadius: BorderRadius.only(
                                  topRight: Radius.circular(15),
                                  bottomRight: Radius.circular(15))),
                          child: IconButton(
                              onPressed: () =>
                                  searchSurvei(controllerSearch.text),
                              icon: Icon(
                                Icons.search,
                                color: Colors.white,
                                size: 36,
                              )),
                        ),
                      ),
                      SizedBox(
                        width: 20,
                      ),
                      Container(
                        width: 190,
                        decoration: BoxDecoration(
                            color: Colors.grey.shade50,
                            border: Border.all(width: 2, color: Colors.black),
                            borderRadius: BorderRadius.circular(16)),
                        child: DropdownButton(
                          underline: SizedBox(),
                          isExpanded: true,
                          borderRadius: BorderRadius.circular(16),
                          iconSize: 36,
                          padding:
                              EdgeInsets.symmetric(vertical: 6, horizontal: 16),
                          value: pilihanOrder,
                          style: Theme.of(context)
                              .textTheme
                              .displaySmall!
                              .copyWith(
                                fontSize: 16,
                                color: Colors.black,
                              ),
                          items: [
                            DropdownMenuItem(
                              child: Text("Terbaru"),
                              value: "Terbaru",
                            ),
                            DropdownMenuItem(
                              child: Text("Terlama"),
                              value: "Terlama",
                            ),
                            DropdownMenuItem(
                              child: Text("Termahal"),
                              value: "Termahal",
                            ),
                            DropdownMenuItem(
                              child: Text("Termurah"),
                              value: "Termurah",
                            ),
                            DropdownMenuItem(
                              child: Text("Partisipan Terbanyak"),
                              value: "Partisipan Terbanyak",
                            ),
                          ],
                          onChanged: (value) {
                            sortDataSurvei(value!);
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          kategoriGenerator(widget.constraints),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.only(top: 25, left: 20, right: 20),
            child: generateBody(),
          ),
        ],
      ),
    );
  }

  @override
  bool get wantKeepAlive => (baseUri == Uri.base.toString());
}

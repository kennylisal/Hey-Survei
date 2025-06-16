import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:survei_aplikasi/features/app/router/router_constant.dart';
import 'package:survei_aplikasi/features/home/home_controller.dart';
import 'package:survei_aplikasi/features/home/widgets/kartu_baru.dart';
import 'package:survei_aplikasi/features/search/model/h_survei.dart';
import 'package:survei_aplikasi/features/search/search_controller.dart';

class KolomRekomendasi extends StatefulWidget {
  KolomRekomendasi({super.key, required this.constraints});
  BoxConstraints constraints;
  @override
  State<KolomRekomendasi> createState() => _KolomRekomendasiState();
}

class _KolomRekomendasiState extends State<KolomRekomendasi> {
  List<HSurvei> listSurvei = [];
  List<String> daftarIdPengecualian = [];
  bool isSelesaiLoading = false;
  initData() async {
    daftarIdPengecualian = await SearchControllerX().getSurveiPengecualian();
    print("ini survei dikucilkan" + daftarIdPengecualian.toString());
    listSurvei = await HomeController().getSurveiTerbaru();
    setState(() {
      isSelesaiLoading = true;
    });
  }

  eliminasiSurvei() async {
    for (var i = 0; i < daftarIdPengecualian.length; i++) {
      listSurvei.removeWhere(
          (element) => element.id_survei == daftarIdPengecualian[i]);
    }
  }

  @override
  void initState() {
    initData();
    super.initState();
  }

  Widget contentGenerator() {
    if (!isSelesaiLoading) {
      return Center(
        child: SizedBox(
          height: 90,
          width: 90,
          child: CircularProgressIndicator(
            color: Colors.blue,
            strokeWidth: 9,
          ),
        ),
      );
    } else {
      eliminasiSurvei();
      List<Widget> hasil = List.generate(
          listSurvei.length,
          (index) => KartuKatalog(
                dataKatalog: listSurvei[index],
                constraints: widget.constraints,
              ));
      return Column(children: [
        ...hasil,
        Center(
          child: Container(
            margin: const EdgeInsets.only(top: 8),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
              onPressed: () => context.pushNamed(RouteConstant.search,
                  pathParameters: {'doCarikan': 'true'}),
              child: Text(
                "Lihat Katalog Lengkap",
                style: Theme.of(context).textTheme.displayMedium!.copyWith(
                      fontSize: 16,
                      color: Colors.white,
                    ),
              ),
            ),
          ),
        ),
      ]);
    }
  }

  @override
  Widget build(BuildContext context) {
    return contentGenerator();
  }
}

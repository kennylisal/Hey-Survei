import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:survei_aplikasi/features/app/router/router_constant.dart';
import 'package:survei_aplikasi/features/profile/data_sejarah.dart';
import 'package:survei_aplikasi/features/profile/profile_controller.dart';
import 'package:survei_aplikasi/features/profile/widget/kartu_sejarah.dart';
import 'package:survei_aplikasi/utils/loading_biasa.dart';

class HeaderSejarah extends StatelessWidget {
  const HeaderSejarah({
    super.key,
    required this.judul,
  });
  final String judul;
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(left: 20, bottom: 4),
      child: Text(
        judul,
        style: Theme.of(context).textTheme.displayMedium!.copyWith(
              fontSize: 18,
              color: Colors.black,
              fontWeight: FontWeight.bold,
            ),
      ),
    );
  }
}

class TampilanHistory extends StatefulWidget {
  TampilanHistory({
    super.key,
    required this.constraints,
  });
  BoxConstraints constraints;
  @override
  State<TampilanHistory> createState() => _TampilanHistoryState();
}

class _TampilanHistoryState extends State<TampilanHistory> {
  List<DataSejarah> listSejarah = [];
  bool selesaiLoading = false;
  @override
  void initState() {
    intiData();
    super.initState();
  }

  intiData() async {
    listSejarah = await ProfileController().getAllSejarah();
    setState(() {
      selesaiLoading = true;
    });
  }

  Widget contentGenerator() {
    if (selesaiLoading) {
      return Column(
        children: [
          SizedBox(height: 10),
          Text(
            "Riwayat Pengisian Survei",
            style: Theme.of(context).textTheme.displayMedium!.copyWith(
                fontSize: 22,
                color: Colors.black,
                fontWeight: FontWeight.bold,
                letterSpacing: 1),
          ),
          if (listSejarah.isNotEmpty)
            for (var e in listSejarah)
              InkWell(
                onTap: () {
                  context.goNamed(RouteConstant.detailSejarah, pathParameters: {
                    'idSurvei': e.idSurvei,
                    'tglPengisian':
                        DateFormat('dd-MMMM-yyyy').format(e.tglPengisian),
                  });
                },
                child: KartuSejarahSurvei(
                  dataKatalog: e,
                  constraints: widget.constraints,
                ),
              )
          else
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
    } else {
      return Center(child: LoadingBiasa());
    }
  }

  @override
  Widget build(BuildContext context) {
    return contentGenerator();
  }
}

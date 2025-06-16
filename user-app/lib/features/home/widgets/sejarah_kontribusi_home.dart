import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:survei_aplikasi/features/app/router/router_constant.dart';
import 'package:survei_aplikasi/features/profile/data_sejarah.dart';
import 'package:survei_aplikasi/features/profile/profile_controller.dart';
import 'package:survei_aplikasi/features/profile/widget/kartu_sejarah.dart';
import 'package:survei_aplikasi/utils/currency_formatter.dart';
import 'package:survei_aplikasi/utils/loading_biasa.dart';

class SejarahKontribusiHome extends StatefulWidget {
  SejarahKontribusiHome({
    super.key,
    required this.emailUser,
    required this.pointUser,
  });
  String emailUser;
  int pointUser;
  @override
  State<SejarahKontribusiHome> createState() => _SejarahKontribusiHomeState();
}

class _SejarahKontribusiHomeState extends State<SejarahKontribusiHome> {
  List<DataSejarah> listSejarah = [];
  bool selesaiLoading = false;
  initData() async {
    listSejarah = await ProfileController().getAllSejarah();
    setState(() {
      selesaiLoading = true;
    });
  }

  @override
  void initState() {
    initData();
    super.initState();
  }

  contentGenerator(BoxConstraints constraints) {
    if (selesaiLoading) {
      return Column(
        children: [
          const SizedBox(height: 20),
          Container(
            margin: EdgeInsets.only(bottom: 16, left: 24, right: 24),
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
            width: double.infinity,
            decoration: BoxDecoration(
                color: Colors.blue.shade400,
                borderRadius: BorderRadius.circular(24)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      width: (constraints.maxWidth / 2) + 33.5,
                      child: Text(
                        widget.emailUser,
                        style:
                            Theme.of(context).textTheme.displayMedium!.copyWith(
                                  fontSize: 17,
                                  color: Colors.white,
                                ),
                        textAlign: TextAlign.start,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 2,
                      ),
                    ),
                    Icon(
                      Icons.monetization_on_rounded,
                      size: 30,
                      color: Colors.white,
                    )
                  ],
                ),
                const SizedBox(height: 9),
                Text(
                  "Poin Anda",
                  style: Theme.of(context).textTheme.displayMedium!.copyWith(
                        fontSize: 12.5,
                        color: Colors.white,
                      ),
                ),
                const SizedBox(height: 3.5),
                Text(
                  CurrencyFormat.convertToIdr(widget.pointUser, 2),
                  style: Theme.of(context).textTheme.displayMedium!.copyWith(
                      fontSize: 24.5,
                      color: Colors.white,
                      fontWeight: FontWeight.bold),
                )
              ],
            ),
          ),
          const SizedBox(height: 10),
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
              KartuSejarahSurvei(
                dataKatalog: e,
                constraints: constraints,
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
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Riwayat Kontribusi",
          style: Theme.of(context).textTheme.displayMedium!.copyWith(
                fontSize: 18,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
        ),
        backgroundColor: Colors.blue.shade400,
        iconTheme: IconThemeData(color: Colors.white),
        leading: IconButton(
            onPressed: () => context.pop(),
            icon: Icon(
              Icons.keyboard_arrow_left,
              color: Colors.black,
            )),
      ),
      backgroundColor: Colors.blue.shade100,
      body: LayoutBuilder(
        builder: (context, constraints) => contentGenerator(constraints),
      ),
    );
  }
}

// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:expansion_tile_card/expansion_tile_card.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:survei_aplikasi/features/FAQ/faq_controller.dart';
import 'package:survei_aplikasi/utils/loading_biasa.dart';

class HalamanFAQ extends StatefulWidget {
  const HalamanFAQ({super.key});

  @override
  State<HalamanFAQ> createState() => _HalamanFAQState();
}

class _HalamanFAQState extends State<HalamanFAQ> {
  List<FAQ> listfaq = [];
  List<DataFAQ> listData = [];
  @override
  void initState() {
    print("Masuk FAQ");
    Future(() async {
      //Future.delayed(Duration(seconds: 2));
      listfaq = await FAQController().getAllFAQ();
      listData = FAQController().processData(listfaq);
      print("hasil data -> $listData");
      setState(() {});
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Pertanyaan Sering Ditanya",
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
      body: ListView(
        children: (listData.isEmpty)
            ? [LoadingBiasa()]
            : listData
                .map(
                  (e) => Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12.0),
                    child: ExpansionTileCard(
                      baseColor: Colors.grey.shade200,
                      key: e.gKey,
                      //key: cardA,
                      leading: CircleAvatar(child: Text(e.angka.toString())),
                      title: Text(
                        e.faq.pertanyaan,
                        style:
                            Theme.of(context).textTheme.displayMedium!.copyWith(
                                  fontSize: 20,
                                  color: Colors.black,
                                ),
                      ),
                      //subtitle: const Text('I expand!'),
                      children: <Widget>[
                        const Divider(
                          thickness: 1.0,
                          height: 1.0,
                        ),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16.0,
                              vertical: 8.0,
                            ),
                            child: Text(
                              e.faq.jawaban,
                              style: Theme.of(context)
                                  .textTheme
                                  .displayMedium!
                                  .copyWith(
                                    fontSize: 18,
                                    color: Colors.black,
                                  ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                )
                .toList(),
      ),
    );
  }
}

class Item {
  String angka;
  String headerText;
  String expandedText;
  GlobalKey gKey;
  Item({
    required this.headerText,
    required this.expandedText,
    required this.angka,
    required this.gKey,
  });
}

        // ...data
        //     .map(
        //       (e) => Padding(
        //         padding: const EdgeInsets.symmetric(horizontal: 12.0),
        //         child: ExpansionTileCard(
        //           baseColor: Colors.grey.shade200,
        //           key: e.gKey,
        //           //key: cardA,
        //           leading: CircleAvatar(child: Text(e.angka)),
        //           title: Text(
        //             e.headerText,
        //             style: Theme.of(context).textTheme.displayMedium!.copyWith(
        //                   fontSize: 14,
        //                   color: Colors.black,
        //                 ),
        //           ),
        //           //subtitle: const Text('I expand!'),
        //           children: <Widget>[
        //             const Divider(
        //               thickness: 1.0,
        //               height: 1.0,
        //             ),
        //             Align(
        //               alignment: Alignment.centerLeft,
        //               child: Padding(
        //                 padding: const EdgeInsets.symmetric(
        //                   horizontal: 16.0,
        //                   vertical: 8.0,
        //                 ),
        //                 child: Text(
        //                   e.expandedText,
        //                   style: Theme.of(context)
        //                       .textTheme
        //                       .displayMedium!
        //                       .copyWith(
        //                         fontSize: 14,
        //                         color: Colors.black,
        //                       ),
        //                 ),
        //               ),
        //             ),
        //           ],
        //         ),
        //       ),
        //     )
        //     .toList(),
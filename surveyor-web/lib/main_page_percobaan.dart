import 'package:flutter/material.dart';
import 'package:hei_survei/features/order_penerbitan/order_midtrans.dart';
import 'package:hei_survei/features/profile/profile.dart';

class HalamanUtamaPercobaan extends StatelessWidget {
  const HalamanUtamaPercobaan({super.key});

  @override
  Widget build(BuildContext context) {
    PageView generateKontenView(BoxConstraints constraints) {
      PageController _pageController = PageController(initialPage: 1);
      List<Widget> _pages = [
        OrderMidTrans(constraints: constraints),
        HalamanProfile(constraints: constraints)
      ];
      return PageView(
        controller: _pageController,
        physics: const NeverScrollableScrollPhysics(),
        children: _pages,
        scrollDirection: Axis.vertical,
      );
    }

    return Scaffold(
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(75),
          child: Container(
            color: Color.fromARGB(255, 27, 110, 179),
            padding: const EdgeInsets.symmetric(horizontal: 50),
            width: double.infinity,
            height: 66,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  "Hei Survei",
                  style: Theme.of(context).textTheme.displayLarge!.copyWith(
                        color: Colors.white,
                        fontSize: 35,
                        fontWeight: FontWeight.bold,
                      ),
                ),
                Spacer(),
              ],
            ),
          ),
        ),
        body: LayoutBuilder(
          builder: (context, constraints) {
            return Row(
              children: [
                Container(
                    padding: const EdgeInsets.only(bottom: 20),
                    decoration: BoxDecoration(
                      color: Color.fromARGB(255, 224, 244, 255),
                      border: Border(
                        right:
                            BorderSide(color: Colors.grey.shade700, width: 2),
                      ),
                    ),
                    width: 310,
                    child: CustomScrollView(
                      slivers: [
                        SliverFillRemaining(
                          child: Column(
                            children: [
                              Container(
                                  width: double.infinity,
                                  height: 50,
                                  margin: const EdgeInsets.symmetric(
                                      horizontal: 12, vertical: 8),
                                  child: ElevatedButton(
                                      onPressed: () {},
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.amber.shade700,
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                        ),
                                      ),
                                      child: Text(
                                        "Buat Form",
                                        style: Theme.of(context)
                                            .textTheme
                                            .displayLarge!
                                            .copyWith(
                                              color: Colors.white,
                                              fontSize: 21,
                                              fontWeight: FontWeight.bold,
                                              letterSpacing: 2,
                                            ),
                                      ))),
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 8),
                                child: Divider(
                                  color: Colors.black,
                                  height: 4,
                                ),
                              ),
                              // TileSamping(
                              //   iconHeight: 35,
                              //   onTap: () => gantiHalaman(1),
                              //   resourceIcon: 'assets/report.png',
                              //   textJudul: 'Laporan',
                              // ),

                              const Spacer(),
                              Image.asset(
                                'assets/logo-app.png',
                                height: 110,
                              ),
                            ],
                          ),
                        )
                      ],
                    )),
                Expanded(
                  child: Container(
                    height: double.infinity,
                    color: Colors.grey.shade50.withOpacity(0.9),
                    width: double.infinity,
                    child: generateKontenView(constraints),
                  ),
                )
              ],
            );
          },
        ));
  }
}

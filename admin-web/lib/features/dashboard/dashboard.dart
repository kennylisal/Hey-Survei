// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:aplikasi_admin/features/dashboard/components/konten_dashboard.dart';
import 'package:aplikasi_admin/features/dashboard/components/navigasi.dart';
import 'package:aplikasi_admin/features/draft/draft_form.dart';
import 'package:aplikasi_admin/features/halaman_pesan/barrel_pesan.dart';
import 'package:aplikasi_admin/features/laporan_survei/laporan_utama.dart';
import 'package:aplikasi_admin/features/master_barrel/masters.dart';
import 'package:aplikasi_admin/features/master_component/container_laporang_singkat.dart';
import 'package:aplikasi_admin/features/survei/screens/buat_survei.dart';
import 'package:aplikasi_admin/features/survei_aktif/surveiku.dart';
import 'package:badges/badges.dart' as badges;
import 'package:flutter/material.dart';
import 'package:sidebarx/sidebarx.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  Widget getPageByIndex(int index, BoxConstraints constraints) {
    if (index == 0) {
      return DashboardKonten(constraints: constraints);
    } else if (index == 1) {
      // return HalamanFAQ(constraints: constraints);
      return BarrelMaster(constraints: constraints);
    } else if (index == 2) {
      return BarrelLaporan(constraints: constraints);
      // return HalamanReportSurvei(constraints: constraints);
    } else if (index == 3) {
      return BuatSurvei(constraints: constraints);
    } else if (index == 4) {
      return DraftForm(constraints: constraints);
    } else if (index == 5) {
      return SurveiAktif(constraints: constraints);
    } else if (index == 6) {
      return BarrelPesan(constraints: constraints);
      // return HalamanPesan(constraints: constraints);
    } else
      return SizedBox();
  }

  gantiHalaman(int index) {
    try {
      setState(() {
        indexHalaman = index;
      });
    } catch (e) {}
  }

  final _controller = SidebarXController(selectedIndex: 0, extended: true);
  final List<ChartData> chartData = [
    ChartData(DateTime(2015, 2, 1), 21),
    ChartData(DateTime(2015, 2, 2), 34),
    ChartData(DateTime(2015, 3, 5), 30),
    ChartData(DateTime(2015, 10, 3), 42),
    //ChartData(DateTime(2015, 12, 8), 35),
  ];
  final List<DataLaporanSingkat> listDataLaporanSingkat = [
    DataLaporanSingkat(
      bgColor: Colors.pink.shade100.withOpacity(0.6),
      borderColor: Colors.pinkAccent.shade400,
      lokasiFoto: 'assets/s-aktif.png',
    ),
    DataLaporanSingkat(
      bgColor: Colors.amber.shade100.withOpacity(0.6),
      borderColor: Colors.amberAccent.shade400,
      lokasiFoto: 'assets/users.png',
    ),
    DataLaporanSingkat(
      bgColor: Colors.cyan.shade100.withOpacity(0.6),
      borderColor: Colors.cyanAccent.shade400,
      lokasiFoto: 'assets/checkout.png',
    ),
    DataLaporanSingkat(
      bgColor: Colors.purple.shade100.withOpacity(0.6),
      borderColor: Colors.purpleAccent.shade400,
      lokasiFoto: 'assets/list.png',
    ),
  ];
  int indexHalaman = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(235, 243, 243, 243),
      body: LayoutBuilder(
        builder: (context, constraints) {
          return Row(
            children: [
              SideNavigation(
                controller: _controller,
                items: [
                  SidebarXItem(
                    icon: Icons.home,
                    label: 'Home',
                    onTap: () {
                      gantiHalaman(0);
                    },
                  ),
                  SidebarXItem(
                    icon: Icons.settings,
                    label: 'Master',
                    onTap: () {
                      gantiHalaman(1);
                    },
                  ),
                  SidebarXItem(
                    icon: Icons.receipt_long,
                    label: 'Laporan',
                    onTap: () {
                      gantiHalaman(2);
                    },
                  ),
                  SidebarXItem(
                    icon: Icons.book,
                    label: 'Buat Form',
                    onTap: () {
                      gantiHalaman(3);
                    },
                  ),
                  SidebarXItem(
                    icon: Icons.drive_file_rename_outline,
                    label: 'Draft Form',
                    onTap: () {
                      gantiHalaman(4);
                    },
                  ),
                  SidebarXItem(
                    icon: Icons.check,
                    label: 'Survei Aktif',
                    onTap: () {
                      gantiHalaman(5);
                    },
                  ),
                ],
              ),
              Expanded(
                  child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                            vertical: 14, horizontal: 25),
                        decoration: BoxDecoration(
                            border: Border(
                                bottom: BorderSide(
                                    width: 3, color: Colors.grey.shade800))),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 18, vertical: 12),
                              decoration: BoxDecoration(
                                  color: Colors.blue,
                                  borderRadius: BorderRadius.circular(16)),
                              child: Text(
                                "Administrasi Hei-Survei",
                                style: Theme.of(context)
                                    .textTheme
                                    .displayLarge!
                                    .copyWith(
                                      color: Colors.white,
                                      fontSize: (constraints.maxWidth) > 1090
                                          ? 40
                                          : 24,
                                      fontWeight: FontWeight.bold,
                                    ),
                              ),
                            ),
                            const Spacer(),
                            badges.Badge(
                              badgeStyle: badges.BadgeStyle(
                                  padding: const EdgeInsets.all(7)),
                              badgeContent: Text("2",
                                  style: Theme.of(context)
                                      .textTheme
                                      .displayLarge!
                                      .copyWith(
                                          color: Colors.white, fontSize: 20)),
                              child: InkWell(
                                onTap: () {
                                  gantiHalaman(6);
                                },
                                child: const Icon(Icons.email, size: 44),
                              ),
                            ),
                            const SizedBox(width: 34),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 4),
                              decoration: BoxDecoration(
                                  color: Colors.blue.shade50,
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(
                                      width: 2, color: Colors.black)),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Text(
                                    "Admin-1",
                                    style: Theme.of(context)
                                        .textTheme
                                        .displayLarge!
                                        .copyWith(
                                            color: Colors.black, fontSize: 28),
                                  ),
                                  SizedBox(width: 12),
                                  IconButton(
                                      onPressed: () {},
                                      icon: Icon(
                                        Icons.logout,
                                        size: 30,
                                        color: Colors.red,
                                      ))
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 8),
                      getPageByIndex(indexHalaman, constraints)
                    ],
                  ),
                ),
              ))
            ],
          );
        },
      ),
    );
  }
}

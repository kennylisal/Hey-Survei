import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:survei_aplikasi/features/app/app.dart';
import 'package:survei_aplikasi/features/dynamic_link/dynamic_link_baru.dart';
import 'package:survei_aplikasi/features/home/main_page.dart';
import 'package:survei_aplikasi/features/profile/profile.dart';
import 'package:survei_aplikasi/features/search/search.dart';

class HomePageBaru extends ConsumerStatefulWidget {
  const HomePageBaru({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _HomePageBaruState();
}

class _HomePageBaruState extends ConsumerState<HomePageBaru> {
  late int currentIndex;

  @override
  void initState() {
    currentIndex = ref.read(indexUtamaProvider);
    DynamicLinkBaru().initDynamicLinks(context);
    super.initState();
  }

  gantiHalaman(int value) {
    try {
      ref.read(indexUtamaProvider.notifier).update((state) => value);
      setState(() {});
    } catch (e) {}
  }

  List<Widget> listHalaman = [
    const HalamanUtama(),
    HalamanSearch(),
    HalamanProfile(),
  ];

  @override
  Widget build(BuildContext context) {
    ref.listen<int>(
      indexUtamaProvider,
      (previous, next) {
        try {
          if (previous != next) {
            currentIndex = next;
          }
        } catch (e) {}
      },
    );
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(15),
        child: AppBar(
          backgroundColor: Colors.blueAccent.shade700,
          leading: const SizedBox(),
        ),
      ),
      body: listHalaman[currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.grey.shade300,
        type: BottomNavigationBarType.fixed,
        showSelectedLabels: false,
        showUnselectedLabels: false,
        currentIndex: currentIndex,
        selectedItemColor: Colors.blue.shade900,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            label: "Beranda",
          ),
          BottomNavigationBarItem(
              icon: Icon(Icons.search_outlined), label: "Pencarian"),
          BottomNavigationBarItem(
              icon: Icon(Icons.person_outline), label: 'Pengguna')
        ],
        onTap: (value) => gantiHalaman(value),
      ),
    );
  }
}

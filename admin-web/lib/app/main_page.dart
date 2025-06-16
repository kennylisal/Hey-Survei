import 'package:flutter/material.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  var selectedIndex = 0;
  bool isLogin = true;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.primaryContainer,
      body: LayoutBuilder(
        builder: (context, constraints) {
          return Scaffold(
            key: _scaffoldKey,
            appBar: PreferredSize(
              preferredSize: const Size.fromHeight(80.0),
              child: Container(
                height: 55,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: <Color>[
                      Colors.blueAccent.shade400,
                      Colors.blue.shade300,
                    ],
                  ),
                ),
                child: Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 20.0),
                      child: Text(
                        "Administrasi",
                        style: Theme.of(context).textTheme.titleLarge!.copyWith(
                              color: Colors.grey.shade300,
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                    )
                  ],
                ),
              ),
            ),
            body: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SafeArea(
                  child: SingleChildScrollView(
                    scrollDirection: Axis.vertical,
                    child: IntrinsicHeight(
                      child: NavigationRail(
                        extended: constraints.maxWidth >= 900,
                        destinations: navRailDestinations,
                        selectedIndex: selectedIndex,
                        selectedLabelTextStyle: Theme.of(context)
                            .textTheme
                            .titleMedium!
                            .copyWith(fontWeight: FontWeight.bold),
                        unselectedLabelTextStyle:
                            Theme.of(context).textTheme.titleMedium,
                        onDestinationSelected: (value) {
                          setState(() {
                            selectedIndex = value;
                          });
                        },
                      ),
                    ),
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Flex(
                      direction: constraints.maxWidth >= 900
                          ? Axis.horizontal
                          : Axis.vertical,
                      children: [
                        Expanded(
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              color: Colors.black,
                            ),
                          ),
                        ),
                        const SizedBox(
                          width: 10,
                          height: 10,
                        ),
                        Expanded(
                          child: Container(
                            color: Theme.of(context)
                                .colorScheme
                                .secondaryContainer,
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              ],
            ),
          );
        },
      ),
    );
  }
}

class ButtonFooter extends StatelessWidget {
  const ButtonFooter({
    super.key,
    required this.text,
    required this.icon,
    required this.onPressed,
  });
  final String text;
  final IconData icon;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return IconButton.filled(
      onPressed: onPressed,
      icon: Row(
        children: [
          Icon(icon),
          Text(
            text,
            style: Theme.of(context)
                .textTheme
                .titleSmall!
                .copyWith(fontWeight: FontWeight.bold, color: Colors.white),
          ),
        ],
      ),
      tooltip: 'Billing Information',
    );
  }
}

class TombolKeluar extends StatelessWidget {
  const TombolKeluar({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 150,
      height: 50,
      child: ElevatedButton(
        onPressed: () {},
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.blue,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: Text(
          "Keluar",
          style: Theme.of(context)
              .textTheme
              .titleLarge!
              .copyWith(color: Colors.white),
        ),
      ),
    );
  }
}

const List<NavigationDestination> appBarDestinations = [
  NavigationDestination(
    icon: Icon(Icons.document_scanner),
    label: 'Buat Survei',
    selectedIcon: Icon(Icons.edit_document),
  ),
  NavigationDestination(
    icon: Icon(Icons.report),
    label: 'Master Report',
    selectedIcon: Icon(Icons.report_outlined),
  ),
  NavigationDestination(
    icon: Icon(Icons.abc_outlined),
    label: 'Master Kategori',
    selectedIcon: Icon(Icons.abc),
  ),
  NavigationDestination(
    icon: Icon(Icons.question_mark_outlined),
    label: 'Master FAQ',
    selectedIcon: Icon(Icons.question_mark),
  ),
  NavigationDestination(
    icon: Icon(Icons.query_stats_outlined),
    label: 'Laporan Survei',
    selectedIcon: Icon(Icons.query_stats),
  ),
  NavigationDestination(
    icon: Icon(Icons.monetization_on_outlined),
    label: 'laporan Keuangan',
    selectedIcon: Icon(Icons.monetization_on),
  ),
];

final List<NavigationRailDestination> navRailDestinations = appBarDestinations
    .map(
      (destination) => NavigationRailDestination(
        icon: Tooltip(
          message: destination.label,
          child: destination.icon,
        ),
        selectedIcon: Tooltip(
          message: destination.label,
          child: destination.selectedIcon,
        ),
        label: Text(destination.label),
      ),
    )
    .toList();

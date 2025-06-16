import 'package:flutter/material.dart';
import 'package:sidebarx/sidebarx.dart';

class SideNavigation extends StatelessWidget {
  SideNavigation({
    super.key,
    required this.controller,
    required this.items,
  });
  SidebarXController controller;
  List<SidebarXItem> items;
  @override
  Widget build(BuildContext context) {
    return SidebarX(
      controller: controller,
      theme: SidebarXTheme(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        width: 175,
        margin: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Colors.blueGrey.shade900,
          borderRadius: BorderRadius.circular(20),
        ),
        hoverColor: Colors.grey.withOpacity(0.1),
        textStyle: TextStyle(color: Colors.white.withOpacity(0.7)),
        selectedTextStyle: const TextStyle(color: Colors.white),
        itemTextPadding: const EdgeInsets.only(left: 30),
        selectedItemTextPadding: const EdgeInsets.only(left: 30),
        itemDecoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: Colors.blueGrey.shade900),
        ),
        selectedItemDecoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: Colors.blue,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.28),
              blurRadius: 30,
            )
          ],
        ),
        iconTheme: IconThemeData(
          color: Colors.white.withOpacity(0.7),
          size: 20,
        ),
        selectedIconTheme: const IconThemeData(
          color: Colors.white,
          size: 20,
        ),
      ),
      extendedTheme: SidebarXTheme(
        width: 200,
        decoration: BoxDecoration(
          color: Colors.blueGrey.shade900,
        ),
      ),
      footerDivider: SizedBox(),
      headerBuilder: (context, extended) {
        //ini untuk headermu
        return Container(
          margin: const EdgeInsets.symmetric(vertical: 60),

          height: 95,
          width: 95,
          //color: Colors.white,
          child: Image.asset('assets/admin.png'),
        );
      },
      items: items,
    );
  }
}

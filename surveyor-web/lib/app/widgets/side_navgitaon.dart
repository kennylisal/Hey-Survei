import 'package:easy_sidemenu/easy_sidemenu.dart';
import 'package:flutter/material.dart';

class SideNavigation extends StatelessWidget {
  SideNavigation({
    super.key,
    required this.items,
    required this.controller,
    required this.ontapBuatForm,
  });
  List<SideMenuItem> items;
  SideMenuController controller;
  Function() ontapBuatForm;
  @override
  Widget build(BuildContext context) {
    return SideMenu(
      title: Column(
        children: [
          Container(
              width: double.infinity,
              height: 50,
              margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              child: ElevatedButton(
                  onPressed: ontapBuatForm,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.amber.shade700,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: Text(
                    "Buat Form",
                    style: Theme.of(context).textTheme.displayLarge!.copyWith(
                          color: Colors.white,
                          fontSize: 17,
                          fontWeight: FontWeight.bold,
                        ),
                  ))),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Divider(
              color: Colors.black,
              height: 4,
            ),
          )
        ],
      ),
      footer: Padding(
        padding: const EdgeInsets.only(bottom: 65),
        child: Image.asset(
          'assets/logo-app.png',
          height: 110,
        ),
      ),
      style: SideMenuStyle(
          selectedColor: Colors.transparent,
          decoration: BoxDecoration(
              border: Border(
                  right: BorderSide(color: Colors.grey.shade700, width: 2))),
          displayMode: SideMenuDisplayMode.open,
          openSideMenuWidth: 300,
          hoverColor: Colors.grey.shade100,
          backgroundColor: Color.fromARGB(255, 224, 244, 255),
          unselectedIconColor: Colors.blue.shade600.withOpacity(0.8),
          unselectedTitleTextStyle: Theme.of(context)
              .textTheme
              .displayLarge!
              .copyWith(color: Colors.blue.shade600, fontSize: 20),
          selectedTitleTextStyle: Theme.of(context)
              .textTheme
              .displayLarge!
              .copyWith(
                  color: Colors.blue.shade600,
                  fontSize: 21,
                  fontWeight: FontWeight.bold),
          selectedIconColor: Colors.blue.shade600,
          iconSize: 30,
          itemInnerSpacing: 36,
          itemOuterPadding:
              const EdgeInsets.symmetric(horizontal: 10, vertical: 6)),
      items: items,
      controller: controller,
    );
  }
}

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hei_survei/app/routing/route_constant.dart';
import 'package:hei_survei/utils/hover_builder.dart';

class NavigasiAtas extends StatelessWidget {
  NavigasiAtas({
    super.key,
    required this.isSmall,
  });
  bool isSmall;
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        isSmall ? SizedBox() : Judul(),
        Spacer(),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            KotakNavigasi(
              textJudul: "History",
              iconPilihan: Icons.sticky_note_2,
              bgColor: Color.fromARGB(255, 255, 84, 17),
              borderColor: Color.fromARGB(178, 139, 63, 0),
              onTap: () {},
            ),
            SizedBox(width: 16),
            KotakNavigasi(
              textJudul: "Buat",
              iconPilihan: Icons.document_scanner,
              bgColor: Color.fromARGB(225, 0, 184, 0),
              borderColor: Color.fromARGB(255, 0, 121, 30),
              onTap: () => context.pushNamed(RouteConstant.buatForm),
            ),
            SizedBox(width: 16),
            KotakNavigasi(
              textJudul: "Katalog",
              iconPilihan: Icons.search,
              bgColor: Color.fromARGB(143, 176, 0, 192),
              borderColor: Color.fromARGB(192, 150, 0, 163),
              onTap: () => context.pushNamed(RouteConstant.katalog),
            ),
            SizedBox(width: 16),
            KotakNavigasi(
              textJudul: "Surveiku",
              iconPilihan: Icons.check_box,
              bgColor: Color.fromARGB(255, 236, 232, 0),
              borderColor: Color.fromARGB(207, 141, 139, 0),
              onTap: () => context.pushNamed(RouteConstant.surveiKu),
            ),
          ],
        )
      ],
    );
  }
}

class KotakNavigasi extends StatelessWidget {
  KotakNavigasi({
    super.key,
    required this.textJudul,
    required this.iconPilihan,
    required this.bgColor,
    required this.borderColor,
    required this.onTap,
  });
  String textJudul;
  IconData iconPilihan;
  Color bgColor;
  Color borderColor;
  Function() onTap;
  @override
  Widget build(BuildContext context) {
    return HoverBuilder(
      builder: (isHovered) => InkWell(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          height: 100,
          width: 102,
          padding: const EdgeInsets.all(6),
          decoration: BoxDecoration(
            color: bgColor,
            border: Border.all(
              color: (isHovered) ? Colors.blue.shade300 : borderColor,
              width: 4,
            ),
            borderRadius: BorderRadius.circular(22.0),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                iconPilihan,
                color: Colors.white,
                size: 46,
              ),
              const SizedBox(height: 6),
              Text(
                textJudul,
                style: Theme.of(context).textTheme.displaySmall!.copyWith(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                    overflow: TextOverflow.ellipsis),
                textAlign: TextAlign.center,
              )
            ],
          ),
        ),
      ),
    );
  }
}

class Judul extends StatelessWidget {
  const Judul({super.key});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => context.pushNamed(RouteConstant.home),
      child: Row(
        children: [
          Container(
            width: 112,
            height: 84,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(18),
                gradient: LinearGradient(colors: [
                  Color.fromARGB(255, 57, 141, 236),
                  Color.fromARGB(255, 46, 139, 245),
                ], begin: Alignment.bottomRight, end: Alignment.topLeft)),
            child: Center(
              child: Text("Hei",
                  style: Theme.of(context).textTheme.displaySmall!.copyWith(
                      fontWeight: FontWeight.bold,
                      fontSize: 55,
                      color: Colors.white)),
            ),
          ),
          const SizedBox(width: 10),
          Text(
            "Survei",
            style: Theme.of(context).textTheme.displaySmall!.copyWith(
                fontWeight: FontWeight.bold, fontSize: 55, color: Colors.black),
          ),
        ],
      ),
    );
  }
}

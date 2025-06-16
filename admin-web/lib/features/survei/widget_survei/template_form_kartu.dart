import 'package:aplikasi_admin/utils/hover_builder.dart';
import 'package:flutter/material.dart';

class TemplateFormKartu extends StatelessWidget {
  const TemplateFormKartu({super.key});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        print("ayo");
      },
      child: HoverBuilder(
        builder: (isHovered) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Stack(
                children: [
                  Container(
                    margin: const EdgeInsets.symmetric(vertical: 10),
                    padding: const EdgeInsets.only(top: 6),
                    width: 275,
                    height: 206,
                    decoration: BoxDecoration(
                      border: Border.all(
                          width: 3,
                          color: (isHovered) ? Colors.blue : Colors.black),
                      color: Colors.redAccent,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey,
                          spreadRadius: 5,
                          blurRadius: 2,
                          offset: Offset(2, 2), // changes position of shadow
                        ),
                      ],
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(20)),
                          //////Disni tempel Gambar ------------------
                          child: Image.asset(
                            'assets/logo-kartu.png',
                            scale: 1.25,
                          ),
                        ),
                        Container(
                          height: 50,
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.only(
                                  bottomLeft: Radius.circular(18),
                                  bottomRight: Radius.circular(18))),
                          child: Center(
                            child: Text("Template Form Kartu",
                                style: Theme.of(context)
                                    .textTheme
                                    .displaySmall!
                                    .copyWith(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 22,
                                        color: Colors.black)),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Positioned(
                    bottom: 53,
                    child: Container(
                      height: 10,
                      width: 273,
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Text("Buat Form Kartu",
                  style: Theme.of(context).textTheme.displaySmall!.copyWith(
                      fontSize: 19,
                      color: (isHovered)
                          ? Colors.blue
                          : Colors.blueGrey.shade800)),
              Text("Menggunakan Template",
                  style: Theme.of(context).textTheme.displaySmall!.copyWith(
                      fontSize: 19,
                      color: (isHovered)
                          ? Colors.blue
                          : Colors.blueGrey.shade800)),
            ],
          );
        },
      ),
    );
  }
}

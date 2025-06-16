import 'package:aplikasi_admin/utils/hover_builder.dart';
import 'package:flutter/material.dart';

class KotakFormKartuBaru extends StatelessWidget {
  KotakFormKartuBaru({
    super.key,
    required this.onTap,
  });
  Function() onTap;
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
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
                            child: Text("Form Kartu",
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
                  Positioned(
                    bottom: 22,
                    right: 8,
                    child: CircleAvatar(
                      radius: 24,
                      backgroundColor: Colors.blue,
                      child: Icon(
                        Icons.add,
                        color: Colors.white,
                        size: 35,
                      ),
                    ),
                  )
                ],
              ),
              const SizedBox(height: 16),
              Text("Buat Form Kartu Baru",
                  style: Theme.of(context).textTheme.displaySmall!.copyWith(
                      fontSize: 19,
                      color: (isHovered)
                          ? Colors.blue
                          : Colors.blueGrey.shade800)),
              Text("Baru",
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

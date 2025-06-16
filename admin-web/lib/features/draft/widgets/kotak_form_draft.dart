import 'package:aplikasi_admin/features/survei/models/data_form.dart';
import 'package:aplikasi_admin/utils/hover_builder.dart';
import 'package:flutter/material.dart';

import 'package:intl/intl.dart';

class KotakFormDraft extends StatelessWidget {
  KotakFormDraft({
    super.key,
    required this.dataForm,
    required this.onTap,
  });
  DataForm dataForm;
  Function() onTap;
  @override
  Widget build(BuildContext context) {
    return HoverBuilder(
      builder: (isHovered) => InkWell(
        //onTap: onTap,
        onTap: onTap,
        child: Stack(
          children: [
            AnimatedContainer(
              margin: const EdgeInsets.only(top: 12, bottom: 30),
              duration: const Duration(milliseconds: 350),
              decoration: BoxDecoration(
                border: Border.all(
                    width: 4,
                    color: (isHovered) ? Colors.lightBlueAccent : Colors.black),
                borderRadius: BorderRadius.circular(24),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey,
                    spreadRadius: 5,
                    blurRadius: 2,
                    offset: Offset(0, 4), // changes position of shadow
                  ),
                ],
              ),
              child: Container(
                padding: const EdgeInsets.only(top: 6),
                width: 275,
                decoration: BoxDecoration(
                    color: (dataForm.isKlasik)
                        ? Colors.greenAccent
                        : Colors.redAccent,
                    borderRadius: BorderRadius.circular(20)),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20)),
                      child: (dataForm.isKlasik)
                          ? Image.asset(
                              'assets/logo-klasik.png',
                              scale: 1.25,
                            )
                          : Image.asset(
                              'assets/logo-kartu.png',
                              scale: 1.25,
                            ),
                    ),
                    Container(
                      padding: const EdgeInsets.only(
                          top: 10, left: 14, right: 14, bottom: 7),
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.only(
                              bottomLeft: Radius.circular(20),
                              bottomRight: Radius.circular(20))),
                      child: Column(
                        children: [
                          Text(
                            dataForm.judul,
                            style: Theme.of(context)
                                .textTheme
                                .displaySmall!
                                .copyWith(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18,
                                    color: Colors.black),
                            textAlign: TextAlign.justify,
                          ),
                          const SizedBox(height: 6),
                          Align(
                            alignment: Alignment.centerRight,
                            child: Text(
                              DateFormat('dd-MMMM-yyyy')
                                  .format(dataForm.tanggal),
                              style: Theme.of(context)
                                  .textTheme
                                  .displaySmall!
                                  .copyWith(fontSize: 15, color: Colors.black),
                            ),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Positioned(
              top: 160,
              child: Container(
                height: 10,
                width: 279,
                color: Colors.black,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

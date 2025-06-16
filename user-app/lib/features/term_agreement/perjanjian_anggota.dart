import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:survei_aplikasi/features/app/router/router_constant.dart';
import 'package:survei_aplikasi/features/term_agreement/konten_perjanjian_anggota.dart';
import 'package:survei_aplikasi/features/term_agreement/widgets/container_seksi.dart';
import 'package:survei_aplikasi/features/term_agreement/widgets/container_teks_biasa.dart';

class PerjanjianAnggota extends StatelessWidget {
  PerjanjianAnggota({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Syarat Dan Ketentuan",
          style: Theme.of(context).textTheme.displayMedium!.copyWith(
                fontSize: 18,
                color: Colors.black,
                fontWeight: FontWeight.bold,
              ),
        ),
        backgroundColor: Colors.grey.shade600,
      ),
      body: Container(
        color: Colors.white,
        width: double.infinity,
        padding: const EdgeInsets.all(12),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 6),
              Text(
                "Perjanjian Anggota",
                style: Theme.of(context).textTheme.displaySmall!.copyWith(
                      fontSize: 24,
                      color: Colors.blue.shade800,
                      fontWeight: FontWeight.bold,
                    ),
              ),
              const SizedBox(height: 12),
              ContainerTeksBiasa(text: KontenPerjanjianAnggota.line1),
              ContainerTeksBiasa(text: KontenPerjanjianAnggota.line2),
              ContainerTeksBiasa(text: KontenPerjanjianAnggota.line3),
              ContainerSeksi(
                konten: [
                  for (var e in KontenPerjanjianAnggota.kontenJudul1)
                    ContainerTeksBiasa(text: e)
                ],
                teksJudul: KontenPerjanjianAnggota.judul1,
              ),
              ContainerSeksi(
                konten: [
                  for (var e in KontenPerjanjianAnggota.kontenJudul2)
                    ContainerTeksBiasa(text: e)
                ],
                teksJudul: KontenPerjanjianAnggota.judul2,
              ),
              ContainerSeksi(
                konten: [
                  for (var e in KontenPerjanjianAnggota.kontenJudul3)
                    ContainerTeksBiasa(text: e)
                ],
                teksJudul: KontenPerjanjianAnggota.judul3,
              ),
              ContainerSeksi(
                konten: [
                  for (var e in KontenPerjanjianAnggota.kontenJudul4)
                    ContainerTeksBiasa(text: e)
                ],
                teksJudul: KontenPerjanjianAnggota.judul4,
              ),
              ContainerSeksi(
                konten: [
                  for (var e in KontenPerjanjianAnggota.kontenJudul5)
                    ContainerTeksBiasa(text: e)
                ],
                teksJudul: KontenPerjanjianAnggota.judul5,
              ),
              ContainerSeksi(
                konten: [
                  for (var e in KontenPerjanjianAnggota.kontenJudul6)
                    ContainerTeksBiasa(text: e)
                ],
                teksJudul: KontenPerjanjianAnggota.judul6,
              ),
              ContainerSeksi(
                konten: [
                  for (var e in KontenPerjanjianAnggota.kontenJudul7)
                    ContainerTeksBiasa(text: e)
                ],
                teksJudul: KontenPerjanjianAnggota.judul7,
              ),
              // ContainerSeksi(
              //   konten: [
              //     for (var i = 1;
              //         i < KontenPerjanjianAnggota.kontenJudul7.length + 1;
              //         i++)
              //       ContainerTeksBiasa(
              //           text:
              //               "($i) ${KontenPerjanjianAnggota.kontenJudul7[i - 1]}")
              //   ],
              //   teksJudul: KontenPerjanjianAnggota.judul7,
              // ),
              const SizedBox(height: 8),
              Text(
                KontenPerjanjianAnggota.perbaruan,
                style: Theme.of(context).textTheme.displaySmall!.copyWith(
                      fontSize: 18,
                      color: Colors.blue.shade800,
                    ),
              ),
              const SizedBox(height: 12),
              Container(
                height: 55,
                width: double.infinity,
                margin: const EdgeInsets.symmetric(horizontal: 40),
                decoration: BoxDecoration(
                  border: Border.all(width: 1, color: Colors.black),
                  borderRadius: BorderRadius.circular(8),
                  color: Colors.blue.shade800,
                ),
                child: TextButton(
                    onPressed: () async {
                      context.pushNamed(RouteConstant.ketentuanSyarat);
                    },
                    child: Text(
                      "Saya Mengerti",
                      style: Theme.of(context)
                          .textTheme
                          .displayMedium!
                          .copyWith(
                              fontSize: 19,
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 1),
                    )),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

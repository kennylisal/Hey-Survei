import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:survei_aplikasi/features/app/router/router_constant.dart';
import 'package:survei_aplikasi/features/term_agreement/konten_perjanjian_anggota.dart';
import 'package:survei_aplikasi/features/term_agreement/konten_perjanjian_privasi.dart';
import 'package:survei_aplikasi/features/term_agreement/widgets/container_seksi_v2.dart';
import 'package:survei_aplikasi/features/term_agreement/widgets/container_teks_biasa.dart';

class KebijakanPrivasi extends StatelessWidget {
  const KebijakanPrivasi({super.key});

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
                "Kebijakan privasi",
                style: Theme.of(context).textTheme.displaySmall!.copyWith(
                      fontSize: 24,
                      color: Colors.blue.shade800,
                      fontWeight: FontWeight.bold,
                    ),
              ),
              const SizedBox(height: 12),
              ContainerTeksBiasa(text: KontenKebijakanPrivasi.line1),
              ContainerTeksBiasa(text: KontenKebijakanPrivasi.line2),
              ContainerTeksBiasa(text: KontenKebijakanPrivasi.line3),
              ContainerSeksiV2(
                  konten: [
                    for (var i = 1;
                        i < KontenKebijakanPrivasi.kontenJudul1.length + 1;
                        i++)
                      ContainerTeksBiasa(
                          text:
                              "($i) ${KontenKebijakanPrivasi.kontenJudul1[i - 1]}")
                  ],
                  teksJudul: KontenKebijakanPrivasi.judul1,
                  kontenBiasa: [
                    for (var e in KontenKebijakanPrivasi.kontenBiasa1)
                      ContainerTeksBiasa(text: e)
                  ]),
              ContainerSeksiV2(
                  konten: [
                    for (var i = 1;
                        i < KontenKebijakanPrivasi.kontenJudul2.length + 1;
                        i++)
                      ContainerTeksBiasa(
                          text:
                              "($i) ${KontenKebijakanPrivasi.kontenJudul2[i - 1]}")
                  ],
                  teksJudul: KontenKebijakanPrivasi.judul2,
                  kontenBiasa: [
                    for (var e in KontenKebijakanPrivasi.kontenBiasa2)
                      ContainerTeksBiasa(text: e)
                  ]),
              const SizedBox(height: 6),
              ContainerSeksiV2(
                  konten: [],
                  teksJudul: KontenKebijakanPrivasi.judul5,
                  kontenBiasa: [
                    for (var e in KontenKebijakanPrivasi.kontenBiasa5)
                      ContainerTeksBiasa(text: e)
                  ]),
              ContainerSeksiV2(
                  konten: [],
                  teksJudul: KontenKebijakanPrivasi.judul9,
                  kontenBiasa: [
                    for (var e in KontenKebijakanPrivasi.kontenBiasa9)
                      ContainerTeksBiasa(text: e)
                  ]),
              ContainerSeksiV2(
                  konten: [],
                  teksJudul: KontenKebijakanPrivasi.judul10,
                  kontenBiasa: [
                    for (var e in KontenKebijakanPrivasi.kontenBiasa10)
                      ContainerTeksBiasa(text: e)
                  ]),
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

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:survei_aplikasi/features/app/router/router_constant.dart';
import 'package:survei_aplikasi/features/term_agreement/konten_persetujuan.dart';
import 'package:survei_aplikasi/features/term_agreement/widgets/container_teks_biasa.dart';

class KebijakanUtama extends StatelessWidget {
  const KebijakanUtama({super.key});

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
        padding: const EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 10),
              Center(child: Image.asset('assets/logo-app.png', height: 85)),
              const SizedBox(height: 16),
              Text(
                "Terima kasih telah menggunakan aplikasi ini",
                style: Theme.of(context).textTheme.displaySmall!.copyWith(
                      fontSize: 20,
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
              ),
              const SizedBox(height: 12),
              Text(
                "Silahkan klik tombol di bawah untuk Melanjutkan Pendaftaran",
                style: Theme.of(context).textTheme.displaySmall!.copyWith(
                      fontSize: 17,
                      color: Colors.black,
                    ),
              ),
              const SizedBox(height: 20),
              RichText(
                text: TextSpan(
                  text:
                      'Keanggotaan Hey Survei sesuai dengan ketentuan dan kondisi dari ',
                  style: Theme.of(context).textTheme.displaySmall!.copyWith(
                        fontSize: 15,
                        color: Colors.black,
                        height: 1.5,
                      ),
                  children: <TextSpan>[
                    TextSpan(
                        text: 'Perjanjian Anggota',
                        style:
                            Theme.of(context).textTheme.displaySmall!.copyWith(
                                  fontSize: 15,
                                  color: Colors.blue,
                                  height: 1.5,
                                ),
                        recognizer: TapGestureRecognizer()
                          ..onTap = () {
                            context.pushNamed(RouteConstant.perjanjianAnggota);
                          }),
                    TextSpan(
                      text: ' dan ',
                      style: Theme.of(context).textTheme.displaySmall!.copyWith(
                            fontSize: 15,
                            color: Colors.black,
                            height: 1.5,
                          ),
                    ),
                    TextSpan(
                        text: 'Kebijakan Privasi',
                        style:
                            Theme.of(context).textTheme.displaySmall!.copyWith(
                                  fontSize: 15,
                                  color: Colors.blue,
                                  height: 1.5,
                                ),
                        recognizer: TapGestureRecognizer()
                          ..onTap = () {
                            context.pushNamed(RouteConstant.kebijakanPrivasi);
                          }),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              Text(
                "Mengenai Penipuan dan/atau Perilaku Tidak Pantas:",
                style: Theme.of(context).textTheme.displaySmall!.copyWith(
                      fontSize: 16,
                      color: Colors.red,
                      fontWeight: FontWeight.bold,
                    ),
              ),
              const SizedBox(height: 10),
              Text(
                "Untuk Mereka yang terlibat dalam penipuan dan/atau perlilaku tidak pantas berikut ini bisa dikecualikan dari perolehan poin.",
                style: Theme.of(context).textTheme.displaySmall!.copyWith(
                      fontSize: 16,
                      color: Colors.black,
                    ),
              ),
              const SizedBox(height: 28),
              ContainerTeksBiasa(text: KontenPersetujuan.konten1),
              for (var i = 0; i < KontenPersetujuan.listAturan.length; i++)
                ContainerTeksBiasa(
                    text: "(${i + 1}) ${KontenPersetujuan.listAturan[i]}"),
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
                      context.pushNamed(RouteConstant.login);
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

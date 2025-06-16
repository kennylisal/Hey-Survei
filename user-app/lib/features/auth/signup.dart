import 'package:email_validator/email_validator.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:survei_aplikasi/features/app/app.dart';
import 'package:survei_aplikasi/features/app/router/router_constant.dart';

class HalamanSignUp extends ConsumerStatefulWidget {
  const HalamanSignUp({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _HalamanSignUpState();
}

class _HalamanSignUpState extends ConsumerState<HalamanSignUp> {
  final _signUpKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passController = TextEditingController();
  final cPassController = TextEditingController();
  bool isPassVisibile = true;
  bool isCPassVisibile = true;

  bool isCentangPersyaratan = false;
  bool isCentangUmur = false;

  bool pengecekanCentang() {
    if (!isCentangPersyaratan) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text("Centang dahulu Checkbox ketentuan dan persyaratam"),
        duration: Duration(seconds: 1),
      ));
      return false;
    }
    if (!isCentangUmur) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text("Centang dahulu Checkbox kepastian umur"),
        duration: Duration(seconds: 1),
      ));
    }
    return (isCentangPersyaratan && isCentangUmur);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: LayoutBuilder(
      builder: (context, constraints) {
        return SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(height: constraints.maxHeight * 0.04),
              Container(
                width: double.infinity,
                height: 200,
                child: Stack(
                  children: [
                    Positioned(
                      top: 60,
                      left: 20,
                      child: Text(
                        "Daftarkan",
                        style:
                            Theme.of(context).textTheme.displayMedium!.copyWith(
                                  fontSize: 35,
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                ),
                      ),
                    ),
                    if (constraints.maxWidth > 349)
                      Positioned(
                        top: 0,
                        right: 35,
                        child: Container(
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                          ),
                          child: Image.asset(
                            'assets/foto-daftar.png',
                            height: 150,
                          ),
                        ),
                      ),
                    Positioned(
                      top: 120,
                      left: 20,
                      child: Text(
                        "Akun Baru Anda",
                        style:
                            Theme.of(context).textTheme.displayMedium!.copyWith(
                                  fontSize: 35,
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                ),
                      ),
                    ),
                    //Positioned(child: child)
                  ],
                ),
              ),
              const SizedBox(height: 18),
              Form(
                  key: _signUpKey,
                  child: Column(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        margin: const EdgeInsets.symmetric(horizontal: 16),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          color: Colors.blue.shade800.withOpacity(.3),
                        ),
                        child: TextFormField(
                          controller: emailController,
                          decoration: InputDecoration(
                            icon: Icon(Icons.email),
                            border: InputBorder.none,
                            label: Text("Email"),
                          ),
                          validator: (value) {
                            if (value!.isEmpty) {
                              return "Masukkan Email Anda";
                            } else if (!EmailValidator.validate(value)) {
                              return "Masukkan Email yang valid";
                            } else
                              return null;
                          },
                        ),
                      ),
                      const SizedBox(height: 16),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        margin: const EdgeInsets.symmetric(horizontal: 16),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            color: Colors.blue.shade800.withOpacity(.3)),
                        child: TextFormField(
                          controller: passController,
                          obscureText: isPassVisibile,
                          decoration: InputDecoration(
                            icon: Icon(Icons.lock),
                            border: InputBorder.none,
                            label: Text("Sandi"),
                            suffixIcon: IconButton(
                              onPressed: () {
                                //toggle
                                setState(() {
                                  isPassVisibile = !isPassVisibile;
                                });
                              },
                              icon: (isPassVisibile)
                                  ? Icon(Icons.visibility)
                                  : Icon(Icons.visibility_off),
                            ),
                          ),
                          validator: (value) {
                            if (value!.isEmpty) {
                              return "Masukkan Sandi";
                            } else if (passController.text.length < 7) {
                              return "Sandi harus lebih dari 7 karakter";
                            } else
                              return null;
                          },
                        ),
                      ),
                      const SizedBox(height: 16),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        margin: const EdgeInsets.symmetric(horizontal: 16),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            color: Colors.blue.shade800.withOpacity(.3)),
                        child: TextFormField(
                          controller: cPassController,
                          obscureText: isCPassVisibile,
                          decoration: InputDecoration(
                            icon: Icon(Icons.lock),
                            border: InputBorder.none,
                            label: Text("Konfirmasi Sandi"),
                            suffixIcon: IconButton(
                              onPressed: () {
                                setState(() {
                                  isCPassVisibile = !isCPassVisibile;
                                });
                              },
                              icon: (isCPassVisibile)
                                  ? Icon(Icons.visibility)
                                  : Icon(Icons.visibility_off),
                            ),
                          ),
                          validator: (value) {
                            if (value!.isEmpty) {
                              return "Masukkan Konfirmasi Sandi";
                            } else if (passController.text !=
                                cPassController.text) {
                              return "Konfirmasi Sandi Tidak Sesuai";
                            } else
                              return null;
                          },
                        ),
                      ),
                      const SizedBox(height: 16),
                      Container(
                        width: double.infinity,
                        margin: const EdgeInsets.symmetric(horizontal: 16),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Transform.scale(
                              scale: 1.15,
                              child: Checkbox(
                                value: isCentangPersyaratan,
                                onChanged: (value) {
                                  setState(() {
                                    isCentangPersyaratan =
                                        !isCentangPersyaratan;
                                  });
                                },
                              ),
                            ),
                            SizedBox(
                              width: constraints.maxWidth * 0.71,
                              child: RichText(
                                text: TextSpan(
                                  text: 'Saya Setuju dan telah membaca ',
                                  style: Theme.of(context)
                                      .textTheme
                                      .displaySmall!
                                      .copyWith(
                                        fontSize: 13,
                                        color: Colors.black,
                                      ),
                                  children: <TextSpan>[
                                    TextSpan(
                                        text: 'Syarat & Ketentuan',
                                        style: Theme.of(context)
                                            .textTheme
                                            .displaySmall!
                                            .copyWith(
                                              fontSize: 13,
                                              color: Colors.blue,
                                            ),
                                        recognizer: TapGestureRecognizer()
                                          ..onTap = () {
                                            context.pushNamed(
                                                RouteConstant.ketentuanSyarat);
                                          }),
                                  ],
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                      const SizedBox(height: 8),
                      Container(
                        width: double.infinity,
                        margin: const EdgeInsets.symmetric(horizontal: 16),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Transform.scale(
                              scale: 1.15,
                              child: Checkbox(
                                value: isCentangUmur,
                                onChanged: (value) {
                                  setState(() {
                                    isCentangUmur = !isCentangUmur;
                                  });
                                },
                              ),
                            ),
                            SizedBox(
                              width: constraints.maxWidth * 0.71,
                              child: RichText(
                                text: TextSpan(
                                  text:
                                      'Saya telah berumur diatas 16 tahun atau telah diberi persetujuan orang tua / wali',
                                  style: Theme.of(context)
                                      .textTheme
                                      .displaySmall!
                                      .copyWith(
                                        fontSize: 13,
                                        color: Colors.black,
                                      ),
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),
                      Container(
                        height: 55,
                        width: double.infinity,
                        margin: const EdgeInsets.symmetric(horizontal: 40),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          color: Colors.blue.shade800,
                        ),
                        child: TextButton(
                            onPressed: () async {
                              final isValidForm =
                                  _signUpKey.currentState!.validate();
                              if (isValidForm) {
                                bool pengecekan = pengecekanCentang();
                                if (pengecekan) {
                                  await ref
                                      .read(authProvider.notifier)
                                      .daftarUser(
                                        email: emailController.text,
                                        password: passController.text,
                                        context: context,
                                      );
                                }
                              }
                            },
                            child:
                                (ref.watch(authProvider).statusSup == "normal")
                                    ? Text(
                                        "DAFTAR",
                                        style: Theme.of(context)
                                            .textTheme
                                            .displayMedium!
                                            .copyWith(
                                                fontSize: 18,
                                                color: Colors.white,
                                                fontWeight: FontWeight.bold,
                                                letterSpacing: 1),
                                      )
                                    : const CircularProgressIndicator(
                                        color: Colors.white,
                                      )),
                      ),
                    ],
                  )),

              const SizedBox(height: 8),
              Text(
                ref.watch(authProvider).pesanSup,
                style: Theme.of(context).textTheme.displayMedium!.copyWith(
                    fontSize: 16,
                    color: Colors.red,
                    fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 4),
              //coba bikin kotak
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Sudah punya akun?",
                    style: Theme.of(context).textTheme.displayMedium!.copyWith(
                        fontSize: 14, color: Colors.black, wordSpacing: 1),
                  ),
                  TextButton(
                      onPressed: () {
                        context.pushNamed(RouteConstant.login);
                      },
                      child: Text("Masuk"))
                ],
              ),
            ],
          ),
        );
      },
    ));
  }
}

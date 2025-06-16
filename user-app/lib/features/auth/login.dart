import 'dart:developer';

import 'package:email_validator/email_validator.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:survei_aplikasi/features/app/app.dart';
import 'package:survei_aplikasi/features/app/router/router_constant.dart';

class HalamanLogin extends ConsumerStatefulWidget {
  const HalamanLogin({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _HalamanLoginState();
}

class _HalamanLoginState extends ConsumerState<HalamanLogin> {
  final _loginKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passController = TextEditingController();
  bool isPassVisibile = true;
  bool isCentangPersyaratan = false;
  bool isCentangUmur = false;

  bool isLoadingG = false;

  bool isLoadingN = false;

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

  // @override
  // void initState() {
  //   print("Masuk login");
  //   super.initState();
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue.shade50,
      body: LayoutBuilder(
        builder: (context, constraints) {
          return SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(height: constraints.maxHeight * 0.090),
                Image.asset('assets/logo-app.png', height: 180),
                const SizedBox(height: 16),
                Form(
                    key: _loginKey,
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
                              color: Colors.blue.shade800.withOpacity(.3)
                              //color: Colors.deepPurple.withOpacity(.3),
                              ),
                          child: TextFormField(
                            controller: passController,
                            obscureText: isPassVisibile,
                            decoration: InputDecoration(
                              icon: Icon(Icons.lock),
                              border: InputBorder.none,
                              label: Text("Password"),
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
                              } else
                                return null;
                            },
                          ),
                        ),
                        const SizedBox(height: 20),
                        Container(
                          height: 55,
                          width: constraints.maxWidth,
                          margin: const EdgeInsets.symmetric(horizontal: 40),
                          decoration: BoxDecoration(
                            border: Border.all(width: 1, color: Colors.black),
                            borderRadius: BorderRadius.circular(8),
                            color: Colors.blue.shade800,
                          ),
                          child: TextButton(
                              onPressed: () async {
                                try {
                                  if (!isLoadingN) {
                                    setState(() {
                                      isLoadingN = true;
                                    });
                                    final isValidForm =
                                        _loginKey.currentState!.validate();
                                    if (isValidForm) {
                                      await ref
                                          .read(authProvider.notifier)
                                          .masukUser(
                                            email: emailController.text,
                                            password: passController.text,
                                            context: context,
                                          );
                                    }
                                    setState(() {
                                      isLoadingN = false;
                                    });
                                  }
                                } catch (e) {
                                  log(e.toString());
                                }
                              },
                              child: (ref.watch(authProvider).statusSin ==
                                      "normal")
                                  ? Text(
                                      "Masuk",
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
                const SizedBox(height: 12),
                Text(
                  "Atau",
                  style: Theme.of(context).textTheme.displayMedium!.copyWith(
                      fontSize: 14, color: Colors.black, wordSpacing: 1),
                ),
                const SizedBox(height: 12),
                InkWell(
                  onTap: () async {
                    if (!isLoadingG) {
                      log("Bikin loading google");
                      setState(() {
                        isLoadingG = true;
                      });
                      final pengecekan = pengecekanCentang();
                      // await Future.delayed(Duration(seconds: 2));
                      if (pengecekan) {
                        await ref
                            .read(authProvider.notifier)
                            .loginWithGoogle(context);
                      } else {
                        ref
                            .read(authProvider.notifier)
                            .tampilkanPesan("Centang Dahulu Persyaratan");
                        setState(() {
                          isLoadingG = false;
                        });
                      }
                    }
                  },
                  child: Container(
                    height: 55,
                    width: constraints.maxWidth,
                    padding: EdgeInsets.symmetric(
                        horizontal: constraints.maxWidth * 0.001),
                    margin: const EdgeInsets.symmetric(horizontal: 40),
                    decoration: BoxDecoration(
                      border: Border.all(width: 1, color: Colors.black),
                      borderRadius: BorderRadius.circular(8),
                      color: Colors.grey.shade400,
                    ),
                    child: (isLoadingG)
                        ? Center(
                            child: CircularProgressIndicator(
                              color: Colors.black,
                            ),
                          )
                        : Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              if (constraints.maxWidth > 350)
                                Image.asset('assets/google.png', height: 52),
                              Text(
                                "Masuk Dengan Google",
                                style: Theme.of(context)
                                    .textTheme
                                    .displayMedium!
                                    .copyWith(
                                        fontSize: 16.5,
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        letterSpacing: 1),
                              ),
                            ],
                          ),
                  ),
                ),
                const SizedBox(height: 16),
                Container(
                  width: constraints.maxWidth,
                  margin: const EdgeInsets.symmetric(horizontal: 40),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Transform.scale(
                        scale: 1.15,
                        child: Checkbox(
                          value: isCentangPersyaratan,
                          onChanged: (value) {
                            setState(() {
                              isCentangPersyaratan = !isCentangPersyaratan;
                            });
                          },
                        ),
                      ),
                      SizedBox(
                        width: constraints.maxWidth * 0.62,
                        child: RichText(
                          text: TextSpan(
                            text:
                                'Dengan menggunakan akun Google, saya Setuju dan telah membaca ',
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
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 8),
                Container(
                  width: constraints.maxWidth,
                  margin: const EdgeInsets.symmetric(horizontal: 40),
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
                        width: constraints.maxWidth * 0.62,
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
                const SizedBox(height: 8),
                Container(
                  child: Text(
                    ref.watch(authProvider).pesanSin,
                    style: Theme.of(context).textTheme.displayMedium!.copyWith(
                        fontSize: 16,
                        color: Colors.red,
                        fontWeight: FontWeight.bold),
                  ),
                ),
                const SizedBox(height: 7),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Belum punya akun?",
                      style: Theme.of(context)
                          .textTheme
                          .displayMedium!
                          .copyWith(
                              fontSize: 14,
                              color: Colors.black,
                              wordSpacing: 1),
                    ),
                    TextButton(
                        onPressed: () {
                          context.goNamed(RouteConstant.signup);
                        },
                        child: Text(
                          "Daftar",
                          style: Theme.of(context)
                              .textTheme
                              .displayMedium!
                              .copyWith(
                                  fontSize: 17,
                                  color: Colors.blue,
                                  wordSpacing: 1),
                        ))
                  ],
                ),
                // Container(
                //   width: double.infinity,
                //   padding: const EdgeInsets.symmetric(horizontal: 16),
                //   margin: const EdgeInsets.symmetric(horizontal: 40),
                //   child: Row(
                //     mainAxisAlignment: MainAxisAlignment.center,
                //     children: [
                //       Text(
                //         "Belum punya akun?",
                //         style: Theme.of(context)
                //             .textTheme
                //             .displayMedium!
                //             .copyWith(
                //                 fontSize: 14,
                //                 color: Colors.black,
                //                 wordSpacing: 1),
                //       ),
                //       TextButton(
                //           onPressed: () {
                //             context.goNamed(RouteConstant.signup);
                //           },
                //           child: Text(
                //             "Daftar",
                //             style: Theme.of(context)
                //                 .textTheme
                //                 .displayMedium!
                //                 .copyWith(
                //                     fontSize: 17,
                //                     color: Colors.blue,
                //                     wordSpacing: 1),
                //           ))
                //     ],
                //   ),
                // ),
              ],
            ),
          );
        },
      ),
    );
  }
}

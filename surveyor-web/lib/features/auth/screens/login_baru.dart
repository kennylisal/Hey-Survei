import 'dart:developer';

import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:hei_survei/app/app.dart';
import 'package:hei_survei/app/routing/route_constant.dart';
import 'package:hei_survei/features/auth/components/field_container.dart';
import 'package:hei_survei/features/auth/components/password_container.dart';
import 'package:hei_survei/features/auth/controller/google_controller.dart';

class LoginBaru extends ConsumerStatefulWidget {
  const LoginBaru({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _LoginBaruState();
}

class _LoginBaruState extends ConsumerState<LoginBaru> {
  String pesan = "";
  @override
  Widget build(BuildContext context) {
    final controllerEmail = TextEditingController();
    final controllerPassword = TextEditingController();

    final _logInKey = GlobalKey<FormState>();

    Widget generateTombolLogin() {
      if (ref.watch(authProvider).statusSin != "loading") {
        return Column(
          children: [
            Text(
              "Halaman Autentikasi",
              style: Theme.of(context).textTheme.displayLarge!.copyWith(
                  color: Colors.black,
                  fontSize: 40,
                  fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 50),
            FieldContainer(
              iconData: Icons.email,
              controller: controllerEmail,
              hint: "Budi@gmail.com",
              judul: "Email",
              validator: (value) {
                if (value != null && !EmailValidator.validate(value)) {
                  return "Masukkan email yang valid";
                } else {
                  return null;
                }
              },
            ),
            const SizedBox(height: 16),
            PasswordContainer(
              controller: controllerPassword,
              hint: "Rahasia",
              judul: "Sandi",
              validator: (value) => null,
            ),
            const SizedBox(height: 16),
            Container(
                padding: const EdgeInsets.symmetric(horizontal: 30),
                height: 60,
                width: double.infinity,
                child: ElevatedButton(
                    onPressed: () async {
                      try {
                        final isValidForm = _logInKey.currentState!.validate();

                        if (isValidForm) {
                          bool hasil =
                              await ref.read(authProvider.notifier).masukUser(
                                    email: controllerEmail.text,
                                    password: controllerPassword.text,
                                  );
                          if (!context.mounted) return;
                          if (hasil) {
                            context.pushNamed(RouteConstant.home);
                          }
                        }
                      } catch (e) {
                        log(e.toString());
                      }
                    },
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue.shade400),
                    child: Text(
                      "Masuk",
                      style: Theme.of(context).textTheme.displayLarge!.copyWith(
                          color: Colors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.bold),
                    ))),
            const SizedBox(height: 14),
            Text(
              "Atau",
              style: Theme.of(context).textTheme.displayLarge!.copyWith(
                    color: Colors.black,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 14),
            InkWell(
              onTap: () async {
                final userGoogle = await GoogleController().signInWithGoogle();
                if (userGoogle != null) {
                  bool hasil =
                      await ref.read(authProvider.notifier).masukUserGoogle(
                            email: userGoogle.email!,
                            urlGambar: userGoogle.photoURL!,
                            username: userGoogle.displayName!,
                          );
                  if (!context.mounted) return;
                  if (hasil) {
                    // print("pindah home");
                    context.pushNamed(RouteConstant.home);
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text("Terjadi kesalahan program")));
                  }
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text("Gagal Google sign-in")));
                }
              },
              child: Container(
                height: 60,
                width: double.infinity,
                padding: const EdgeInsets.symmetric(horizontal: 10),
                margin: const EdgeInsets.symmetric(horizontal: 40),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(28),
                  color: Colors.grey.shade500,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Image.asset('assets/google.png', height: 52),
                    Text(
                      "Masuk Dengan Google",
                      style: Theme.of(context)
                          .textTheme
                          .displayMedium!
                          .copyWith(
                              fontSize: 19,
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 1),
                    ),
                  ],
                ),
              ),
            ),
          ],
        );
      } else {
        return const Center(
          child: SizedBox(
            height: 100,
            width: 100,
            child: CircularProgressIndicator(
              strokeWidth: 8,
            ),
          ),
        );
      }
    }

    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 243, 250, 255),
      body: LayoutBuilder(
        builder: (context, constraints) {
          return Row(
            children: [
              if (constraints.maxWidth > 895)
                Expanded(
                    flex: 3,
                    child: Container(
                      padding: EdgeInsets.symmetric(
                          vertical: 50,
                          horizontal: constraints.maxWidth * 0.015),
                      child: SingleChildScrollView(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 16),

                            Text(
                              "Selamat Datang",
                              style: Theme.of(context)
                                  .textTheme
                                  .displayLarge!
                                  .copyWith(
                                      color: Colors.black,
                                      fontSize: 52,
                                      fontWeight: FontWeight.bold),
                            ),
                            //const SizedBox(height: 12),
                            Text(
                              "Di ",
                              style: Theme.of(context)
                                  .textTheme
                                  .displayLarge!
                                  .copyWith(
                                      color: Colors.black,
                                      fontSize: 52,
                                      fontWeight: FontWeight.bold),
                            ),
                            Text(
                              "Hei - Survei ",
                              style: Theme.of(context)
                                  .textTheme
                                  .displayLarge!
                                  .copyWith(
                                      color: Colors.black,
                                      fontSize: 52,
                                      fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 40),
                            Container(
                                width: 335,
                                height: 335,
                                decoration: BoxDecoration(
                                    image: DecorationImage(
                                        image:
                                            AssetImage('assets/login2.png')))),
                            const SizedBox(height: 60),
                            Center(
                              child: Text(
                                "Belum punya akun? ",
                                style: Theme.of(context)
                                    .textTheme
                                    .displayLarge!
                                    .copyWith(
                                      color: Colors.black,
                                      fontSize: 20,
                                    ),
                              ),
                            ),
                            Center(
                              child: TextButton(
                                  onPressed: () {
                                    print("Pindah ke register");
                                    context.goNamed(RouteConstant.register);
                                  },
                                  child: Text(
                                    "Daftar Disini",
                                    style: Theme.of(context)
                                        .textTheme
                                        .displayLarge!
                                        .copyWith(
                                          color: Colors.blue,
                                          fontSize: 28,
                                          fontWeight: FontWeight.bold,
                                        ),
                                  )),
                            ),
                          ],
                        ),
                      ),
                    )),
              if (constraints.maxWidth > 1215)
                Expanded(
                    flex: 3,
                    child: Container(
                      padding: const EdgeInsets.only(bottom: 50),
                      child: Column(
                        children: [
                          Expanded(child: Image.asset("assets/login4.png")),
                          Center(
                            child: Text(
                              "Kustomisasi Surveimu ",
                              style: Theme.of(context)
                                  .textTheme
                                  .displayLarge!
                                  .copyWith(
                                      color: Colors.black,
                                      fontSize: 40,
                                      fontWeight: FontWeight.bold),
                            ),
                          ),
                        ],
                      ),
                    )),
              Expanded(
                  flex: 4,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 45),
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          const SizedBox(height: 20),
                          Center(
                            child: Container(
                              width: 130,
                              height: 130,
                              decoration: BoxDecoration(
                                  image: DecorationImage(
                                      image:
                                          AssetImage('assets/logo-app.png'))),
                            ),
                          ),
                          const SizedBox(height: 20),
                          Form(
                            key: _logInKey,
                            child: generateTombolLogin(),
                          ),
                          const SizedBox(height: 15),
                          if (ref.watch(authProvider).pesanSin != "")
                            Text(
                              ref.watch(authProvider).pesanSin,
                              style: Theme.of(context)
                                  .textTheme
                                  .displayLarge!
                                  .copyWith(color: Colors.red, fontSize: 18),
                            ),
                          if (constraints.maxWidth < 895)
                            Column(
                              children: [
                                Center(
                                  child: Text(
                                    "Belum punya akun? ",
                                    style: Theme.of(context)
                                        .textTheme
                                        .displayLarge!
                                        .copyWith(
                                          color: Colors.black,
                                          fontSize: 20,
                                        ),
                                  ),
                                ),
                                Center(
                                  child: TextButton(
                                      onPressed: () {},
                                      child: Text(
                                        "Daftar Disini",
                                        style: Theme.of(context)
                                            .textTheme
                                            .displayLarge!
                                            .copyWith(
                                              color: Colors.blue,
                                              fontSize: 20,
                                              fontWeight: FontWeight.bold,
                                            ),
                                      )),
                                ),
                                const SizedBox(height: 50),
                              ],
                            ),
                          const SizedBox(height: 60),
                          Text(
                            "Kontak kami : kennylisal5@gmail.com",
                            style: Theme.of(context)
                                .textTheme
                                .displayLarge!
                                .copyWith(
                                    color: Colors.grey.withOpacity(0.7),
                                    fontSize: 14),
                          ),
                        ],
                      ),
                    ),
                  )),
            ],
          );
        },
      ),
    );
  }
}

//kolom tombol awal
// Column(
//                               children: [
//                                 Text(
//                                   "Halaman Autentikasi",
//                                   style: Theme.of(context)
//                                       .textTheme
//                                       .displayLarge!
//                                       .copyWith(
//                                           color: Colors.black,
//                                           fontSize: 40,
//                                           fontWeight: FontWeight.bold),
//                                 ),
//                                 const SizedBox(height: 50),
//                                 FieldContainer(
//                                   iconData: Icons.email,
//                                   controller: controllerEmail,
//                                   hint: "Budi@gmail.com",
//                                   judul: "Email",
//                                   validator: (value) {
//                                     if (value != null &&
//                                         !EmailValidator.validate(value)) {
//                                       return "Masukkan email yang valid";
//                                     } else {
//                                       return null;
//                                     }
//                                   },
//                                 ),
//                                 const SizedBox(height: 16),
//                                 PasswordContainer(
//                                   controller: controllerPassword,
//                                   hint: "Rahasia",
//                                   judul: "Sandi",
//                                   validator: (value) => null,
//                                 ),
//                                 const SizedBox(height: 16),
//                                 Container(
//                                     padding: const EdgeInsets.symmetric(
//                                         horizontal: 30),
//                                     height: 60,
//                                     width: double.infinity,
//                                     child: ElevatedButton(
//                                         onPressed: () async {
//                                           try {
//                                             final isValidForm = _logInKey
//                                                 .currentState!
//                                                 .validate();

//                                             if (isValidForm) {
//                                               bool hasil = await ref
//                                                   .read(authProvider.notifier)
//                                                   .masukUser(
//                                                     email: controllerEmail.text,
//                                                     password:
//                                                         controllerPassword.text,
//                                                   );

//                                               if (hasil) {
//                                                 print("berhasil masuk");
//                                                 context.pushNamed(
//                                                     RouteConstant.home);
//                                               }
//                                             }
//                                           } catch (e) {
//                                             log(e.toString());
//                                           }
//                                         },
//                                         style: ElevatedButton.styleFrom(
//                                             backgroundColor:
//                                                 Colors.blue.shade400),
//                                         child: (ref
//                                                     .watch(authProvider)
//                                                     .statusSin !=
//                                                 "loading")
//                                             ? Text(
//                                                 "Masuk",
//                                                 style: Theme.of(context)
//                                                     .textTheme
//                                                     .displayLarge!
//                                                     .copyWith(
//                                                         color: Colors.white,
//                                                         fontSize: 24,
//                                                         fontWeight:
//                                                             FontWeight.bold),
//                                               )
//                                             : CircularProgressIndicator(
//                                                 color: Colors.white,
//                                               ))),
//                                 const SizedBox(height: 14),
//                                 Text(
//                                   "Atau",
//                                   style: Theme.of(context)
//                                       .textTheme
//                                       .displayLarge!
//                                       .copyWith(
//                                         color: Colors.black,
//                                         fontSize: 18,
//                                         fontWeight: FontWeight.bold,
//                                       ),
//                                 ),
//                                 const SizedBox(height: 14),
//                                 InkWell(
//                                   onTap: () async {},
//                                   child: Container(
//                                     height: 60,
//                                     width: double.infinity,
//                                     padding: const EdgeInsets.symmetric(
//                                         horizontal: 10),
//                                     margin: const EdgeInsets.symmetric(
//                                         horizontal: 40),
//                                     decoration: BoxDecoration(
//                                       borderRadius: BorderRadius.circular(28),
//                                       color: Colors.grey.shade500,
//                                     ),
//                                     child: Row(
//                                       mainAxisAlignment:
//                                           MainAxisAlignment.spaceAround,
//                                       children: [
//                                         Image.asset('assets/google.png',
//                                             height: 52),
//                                         Text(
//                                           "Masuk Dengan Google",
//                                           style: Theme.of(context)
//                                               .textTheme
//                                               .displayMedium!
//                                               .copyWith(
//                                                   fontSize: 19,
//                                                   color: Colors.white,
//                                                   fontWeight: FontWeight.bold,
//                                                   letterSpacing: 1),
//                                         ),
//                                       ],
//                                     ),
//                                   ),
//                                 ),
//                               ],
//                             ),
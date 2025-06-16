import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:hei_survei/app/app.dart';
import 'package:hei_survei/app/routing/route_constant.dart';
import 'package:hei_survei/features/auth/components/field_container.dart';
import 'package:hei_survei/features/auth/components/password_container.dart';

class RegisBaru extends ConsumerStatefulWidget {
  const RegisBaru({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _RegisBaruState();
}

class _RegisBaruState extends ConsumerState<RegisBaru> {
  @override
  Widget build(BuildContext context) {
    final pesan = "";
    final controllerEmail = TextEditingController();
    final controllerUser = TextEditingController(text: "");
    final controllerPassword = TextEditingController();
    final controllerPasswordC = TextEditingController();
    final _daftarKey = GlobalKey<FormState>();
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 243, 250, 255),
      body: LayoutBuilder(
        builder: (context, constraints) {
          return Row(
            children: [
              Expanded(
                  flex: 4,
                  child: Container(
                    padding:
                        const EdgeInsets.only(top: 120, left: 45, right: 45),
                    child: SingleChildScrollView(
                      child: Form(
                        key: _daftarKey,
                        child: Column(
                          children: [
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
                            Text(
                              "Halaman Pendaftaran",
                              style: Theme.of(context)
                                  .textTheme
                                  .displayLarge!
                                  .copyWith(
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
                                if (value != null &&
                                    !EmailValidator.validate(value)) {
                                  return "Masukkan email yang valid";
                                } else {
                                  return null;
                                }
                              },
                            ),
                            // const SizedBox(height: 16),
                            // FieldContainer(
                            //   iconData: Icons.person,
                            //   controller: controllerUser,
                            //   hint: "Budi_1",
                            //   judul: "Username",
                            //   validator: (value) {
                            //     if (value!.isEmpty) {
                            //       return "Masukkan Username";
                            //     } else if (controllerUser.text.length < 5) {
                            //       return "Username harus lebih dari 5 karakter";
                            //     } else {
                            //       return null;
                            //     }
                            //   },
                            // ),
                            const SizedBox(height: 16),
                            PasswordContainer(
                              controller: controllerPassword,
                              hint: "******",
                              judul: "Sandi",
                              validator: (value) {
                                if (controllerPassword.text.length < 7) {
                                  return "Password minimal 7 karakter";
                                } else
                                  return null;
                              },
                            ),
                            const SizedBox(height: 16),
                            PasswordContainer(
                              controller: controllerPasswordC,
                              hint: "******",
                              judul: "Konfirmasi Sandi",
                              validator: (value) {
                                if (controllerPassword.text !=
                                    controllerPasswordC.text) {
                                  return "Konfirmasi sandi tidak sesuai";
                                } else
                                  return null;
                              },
                            ),
                            const SizedBox(height: 16),
                            Container(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 30),
                              height: 60,
                              width: double.infinity,
                              child: ElevatedButton(
                                onPressed: () {
                                  final isValidForm =
                                      _daftarKey.currentState!.validate();
                                  if (isValidForm) {
                                    ref.read(authProvider.notifier).signUpUser(
                                          email: controllerEmail.text,
                                          password: controllerPassword.text,
                                          username: controllerUser.text,
                                        );
                                  }
                                },
                                style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.blue.shade400),
                                child: (ref.watch(authProvider).statusSup !=
                                        "loading")
                                    ? Text(
                                        "Daftar",
                                        style: Theme.of(context)
                                            .textTheme
                                            .displayLarge!
                                            .copyWith(
                                                color: Colors.white,
                                                fontSize: 24,
                                                fontWeight: FontWeight.bold),
                                      )
                                    : CircularProgressIndicator(
                                        color: Colors.white,
                                      ),
                              ),
                            ),
                            const SizedBox(height: 20),
                            if (ref.watch(authProvider).pesanSup != "")
                              Text(
                                ref.watch(authProvider).pesanSup,
                                style: Theme.of(context)
                                    .textTheme
                                    .displayLarge!
                                    .copyWith(color: Colors.red, fontSize: 18),
                              ),
                            const SizedBox(height: 23),
                            if (constraints.maxWidth < 895)
                              Column(
                                children: [
                                  Text(
                                    "Sudah Punya Akun ? ",
                                    style: Theme.of(context)
                                        .textTheme
                                        .displayLarge!
                                        .copyWith(
                                          color: Colors.black,
                                          fontSize: 20,
                                        ),
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        "Masuk  ",
                                        style: Theme.of(context)
                                            .textTheme
                                            .displayLarge!
                                            .copyWith(
                                              color: Colors.black,
                                              fontSize: 20,
                                            ),
                                      ),
                                      TextButton(
                                          onPressed: () {
                                            print("masuk lewat sini");
                                            context
                                                .goNamed(RouteConstant.login);
                                          },
                                          child: Text(
                                            "Lewat Sini ",
                                            style: Theme.of(context)
                                                .textTheme
                                                .displayLarge!
                                                .copyWith(
                                                  color: Colors.blue,
                                                  fontSize: 28,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                          )),
                                    ],
                                  ),
                                  const SizedBox(height: 50),
                                ],
                              ),
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
                    ),
                  )),
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
                              "Ayo Daftarkan",
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
                              "Akunmu Disini ",
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
                                width: 450,
                                height: 450,
                                decoration: BoxDecoration(
                                    image: DecorationImage(
                                        image: AssetImage('assets/signup1.png'),
                                        fit: BoxFit.cover))),
                            const SizedBox(height: 60),
                            Center(
                              child: Text(
                                "Sudah Punya Akun ? ",
                                style: Theme.of(context)
                                    .textTheme
                                    .displayLarge!
                                    .copyWith(
                                      color: Colors.black,
                                      fontSize: 20,
                                    ),
                              ),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  "Masuk  ",
                                  style: Theme.of(context)
                                      .textTheme
                                      .displayLarge!
                                      .copyWith(
                                        color: Colors.black,
                                        fontSize: 20,
                                      ),
                                ),
                                TextButton(
                                    onPressed: () {
                                      print("masuk lewat sini");
                                      context.goNamed(RouteConstant.login);
                                    },
                                    child: Text(
                                      "Lewat Sini ",
                                      style: Theme.of(context)
                                          .textTheme
                                          .displayLarge!
                                          .copyWith(
                                            color: Colors.blue,
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold,
                                          ),
                                    )),
                              ],
                            ),
                          ],
                        ),
                      ),
                    )),
              if (constraints.maxWidth > 1215)
                Expanded(
                    flex: 3,
                    child: Container(
                      padding: const EdgeInsets.only(top: 120),
                      child: Column(
                        children: [
                          SizedBox(
                            width: double.infinity,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Ayo Daftar Untuk",
                                  style: Theme.of(context)
                                      .textTheme
                                      .displayLarge!
                                      .copyWith(
                                        color: Colors.black,
                                        fontSize: 36,
                                        fontWeight: FontWeight.bold,
                                      ),
                                ),
                                const SizedBox(height: 9),
                                Text(
                                  "Mulai Menggunakan",
                                  style: Theme.of(context)
                                      .textTheme
                                      .displayLarge!
                                      .copyWith(
                                        color: Colors.black,
                                        fontSize: 36,
                                        fontWeight: FontWeight.bold,
                                      ),
                                ),
                                const SizedBox(height: 9),
                                Text(
                                  "Fitur-Fitur",
                                  style: Theme.of(context)
                                      .textTheme
                                      .displayLarge!
                                      .copyWith(
                                        color: Colors.black,
                                        fontSize: 36,
                                        fontWeight: FontWeight.bold,
                                      ),
                                ),
                                const SizedBox(height: 9),
                                Text(
                                  "Hei-Survei",
                                  style: Theme.of(context)
                                      .textTheme
                                      .displayLarge!
                                      .copyWith(
                                        color: Colors.blue,
                                        fontSize: 36,
                                        fontWeight: FontWeight.bold,
                                      ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 60),
                          Image.asset(
                            "assets/signup2.png",
                            width: 500,
                          ),
                        ],
                      ),
                    )),
            ],
          );
        },
      ),
    );
  }
}

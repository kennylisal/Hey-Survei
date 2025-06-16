import 'package:flutter/material.dart';

class LoginAdmin extends StatelessWidget {
  const LoginAdmin({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
          width: double.infinity,
          height: double.infinity,
          decoration: BoxDecoration(
              image: DecorationImage(
                  image: AssetImage('assets/bg-admin.jpg'), fit: BoxFit.cover)),
          child: LayoutBuilder(
            builder: (context, constraints) {
              return Row(
                children: [
                  Expanded(
                      child: Container(
                    color: Colors.blue.shade400,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Selamat Datang di ",
                          style: Theme.of(context)
                              .textTheme
                              .displayLarge!
                              .copyWith(
                                color: Colors.white,
                                fontSize: 40,
                                fontWeight: FontWeight.bold,
                              ),
                        ),
                        SizedBox(height: 8),
                        Text(
                          "Administrasi Hei-Survei",
                          style: Theme.of(context)
                              .textTheme
                              .displayLarge!
                              .copyWith(
                                color: Colors.white,
                                fontSize: 40,
                                fontWeight: FontWeight.bold,
                              ),
                        ),
                      ],
                    ),
                  )),
                  Container(
                    height: double.infinity,
                    width: 900,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Autentikasi Data",
                          style: Theme.of(context)
                              .textTheme
                              .displayLarge!
                              .copyWith(
                                color: Colors.black,
                                fontSize: 40,
                                fontWeight: FontWeight.bold,
                              ),
                        ),
                        const SizedBox(height: 16),
                        Container(
                          width: 550,
                          height: 450,
                          decoration: BoxDecoration(
                              color: Colors.grey.shade100.withOpacity(0.45),
                              border: Border.all(
                                width: 2,
                                color: Colors.grey.shade600.withOpacity(0.65),
                              ),
                              borderRadius: BorderRadius.circular(20)),
                          child: Container(
                              padding: const EdgeInsets.all(24),
                              width: double.infinity,
                              height: double.infinity,
                              child: Column(
                                children: [
                                  Container(
                                    width: double.infinity,
                                    height: 65,
                                    decoration: BoxDecoration(
                                        color: const Color.fromARGB(
                                            255, 235, 235, 235),
                                        border: Border.all(
                                            width: 1,
                                            color:
                                                Colors.grey.withOpacity(0.8)),
                                        borderRadius:
                                            BorderRadius.circular(22)),
                                  ),
                                  SizedBox(height: 20),
                                  Container(
                                    width: double.infinity,
                                    height: 65,
                                    decoration: BoxDecoration(
                                        color: const Color.fromARGB(
                                            255, 235, 235, 235),
                                        border: Border.all(
                                            width: 1,
                                            color:
                                                Colors.grey.withOpacity(0.8)),
                                        borderRadius:
                                            BorderRadius.circular(22)),
                                  ),
                                  SizedBox(height: 24),
                                  Align(
                                    alignment: Alignment.centerLeft,
                                    child: Container(
                                      width: 200,
                                      height: 65,
                                      decoration: BoxDecoration(
                                          color: Colors.indigoAccent.shade400,
                                          border: Border.all(
                                              width: 1, color: Colors.white),
                                          borderRadius:
                                              BorderRadius.circular(6)),
                                    ),
                                  ),
                                  SizedBox(height: 18),
                                  Divider(
                                    color: Colors.black,
                                    thickness: 4,
                                  ),
                                  SizedBox(height: 6),
                                  Align(
                                      alignment: Alignment.centerLeft,
                                      child: Text("Pindah Ke : ")),
                                  CircleAvatar(
                                    radius: 49,
                                    backgroundColor: Colors.white,
                                  )
                                ],
                              )),
                        ),
                      ],
                    ),
                  )
                ],
              );
            },
          )),
    );
  }
}

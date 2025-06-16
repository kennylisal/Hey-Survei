import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:survei_aplikasi/features/app/router/router_constant.dart';
import 'package:survei_aplikasi/features/profile/profile_controller.dart';

class HalamanOTP extends StatefulWidget {
  const HalamanOTP({super.key});

  @override
  State<HalamanOTP> createState() => _HalamanOTPState();
}

class _HalamanOTPState extends State<HalamanOTP> {
  TextEditingController nomorHpController = TextEditingController();
  TextEditingController otpController = TextEditingController();
  DaftarHalaman stateNow = DaftarHalaman.nomorHP;
  late Widget halamanOTP;
  late Widget halamanNomorHP;
  //status loading
  bool loadingHP = false;
  bool loadingOtp = false;
  //
  @override
  void initState() {
    // halamanOTP = HalamanKodeOTP(
    //   isLoadingHP: loadingHP,
    //   isLoading: loadingOtp,
    //   controllerOTP: otpController,
    //   onPressedKembali: () {
    //     setState(() {
    //       stateNow = DaftarHalaman.nomorHP;
    //     });
    //   },
    //   onPressedVerifikasi: () async {
    //     if (otpController.text.length == 6 && !loadingOtp) {
    //       final hasil = await ProfileController()
    //           .autentikasiOTP("08b7674", otpController.text);
    //       if (hasil) {
    //         if (!context.mounted) return;
    //         context.pushNamed(RouteConstant.profile);
    //         //ganti ke halaman profile
    //       } else {
    //         ScaffoldMessenger.of(context).showSnackBar(
    //             SnackBar(content: Text("Kode autentikasi salah")));
    //       }
    //     } else {
    //       ScaffoldMessenger.of(context).showSnackBar(
    //           SnackBar(content: Text("Masukkan Nomor HP yang valid")));
    //     }
    //     //verifikasi akhir
    //   },
    //   onPressedKirimOTP: () async {
    //     //kirim ulang OTP
    //     if (!loadingHP) {
    //       setState(() {
    //         loadingHP = true;
    //       });
    //       final hasil = await ProfileController()
    //           .kirimOTP("06393e2", nomorHpController.text);
    //       if (hasil) {
    //         ScaffoldMessenger.of(context)
    //             .showSnackBar(SnackBar(content: Text("OTP telah terkirim")));
    //       } else {
    //         ScaffoldMessenger.of(context)
    //             .showSnackBar(SnackBar(content: Text("Gagal Mengirimkan OTP")));
    //       }
    //       setState(() {
    //         loadingHP = false;
    //       });
    //     }
    //   },
    // );
    // halamanNomorHP = HalamanNomorHP(
    //   isLoading: loadingHP,
    //   nomorController: nomorHpController,
    //   onPressed: () async {
    //     if (nomorHpController.text.length > 9 && !loadingHP) {
    //       setState(() {
    //         loadingHP = true;
    //       });
    //       final hasil = await ProfileController()
    //           .kirimOTP("08b7674", nomorHpController.text);
    //       // final hasil = true;
    //       if (hasil) {
    //         setState(() {
    //           setState(() {
    //             loadingHP = false;
    //           });
    //           stateNow = DaftarHalaman.otp;
    //         });
    //       } else {
    //         setState(() {
    //           loadingHP = false;
    //         });
    //         ScaffoldMessenger.of(context).showSnackBar(
    //             SnackBar(content: Text("Nomor HP tidak ditemukan")));
    //       }
    //     } else {
    //       setState(() {
    //         loadingHP = false;
    //       });
    //       ScaffoldMessenger.of(context).showSnackBar(
    //           SnackBar(content: Text("Masukkan Nomor HP yang valid")));
    //     }
    //   },
    // );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        backgroundColor: Colors.lightBlue.shade600,
        title: Text(
          "Halaman Verifikasi OTP",
          style: Theme.of(context).textTheme.displaySmall!.copyWith(
                fontSize: 20,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
        ),
        leading: IconButton(
            onPressed: () {
              context.pop();
            },
            icon: Icon(
              Icons.keyboard_arrow_left,
              color: Colors.white,
              size: 30,
            )),
      ),
      body: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 31),
        child:
            // (stateNow == DaftarHalaman.nomorHP) ? halamanNomorHP : halamanOTP,
            (stateNow == DaftarHalaman.nomorHP)
                ? HalamanNomorHP(
                    isLoading: loadingHP,
                    nomorController: nomorHpController,
                    onPressed: () async {
                      if (nomorHpController.text.length > 9 && !loadingHP) {
                        setState(() {
                          loadingHP = true;
                        });
                        final hasil = await ProfileController()
                            .kirimOTP(nomorHpController.text);
                        // final hasil = true;
                        // await Future.delayed(Duration(seconds: 3));
                        if (hasil) {
                          setState(() {
                            setState(() {
                              loadingHP = false;
                            });
                            stateNow = DaftarHalaman.otp;
                          });
                        } else {
                          setState(() {
                            loadingHP = false;
                          });
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              content: Text("Nomor HP tidak ditemukan")));
                        }
                      } else {
                        setState(() {
                          loadingHP = false;
                        });
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            content: Text("Masukkan Nomor HP yang valid")));
                      }
                    },
                  )
                : HalamanKodeOTP(
                    isLoadingHP: loadingHP,
                    isLoading: loadingOtp,
                    controllerOTP: otpController,
                    onPressedKembali: () {
                      setState(() {
                        stateNow = DaftarHalaman.nomorHP;
                      });
                    },
                    onPressedVerifikasi: () async {
                      if (otpController.text.length == 6 && !loadingOtp) {
                        setState(() {
                          loadingOtp = true;
                        });
                        // var hasil = true;
                        // await Future.delayed(Duration(seconds: 3));
                        final hasil = await ProfileController()
                            .autentikasiOTP(otpController.text);
                        if (hasil) {
                          setState(() {
                            loadingOtp = false;
                          });
                          if (!context.mounted) return;
                          // context.pop();
                          context.goNamed(RouteConstant.auth);
                          //ganti ke halaman profile
                        } else {
                          setState(() {
                            loadingOtp = false;
                          });
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              content: Text("Kode autentikasi salah")));
                        }
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text("Masukkan 6 digit OTP")));
                      }
                      //verifikasi akhir
                    },
                    onPressedKirimOTP: () async {
                      //kirim ulang OTP
                      if (!loadingHP) {
                        setState(() {
                          loadingHP = true;
                        });
                        final isHpAman = await ProfileController()
                            .cekNoHp(nomorHpController.text);
                        if (isHpAman) {
                          final hasil = await ProfileController()
                              .kirimOTP(nomorHpController.text);
                          if (hasil) {
                            ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text("OTP telah terkirim")));
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                content: Text("Gagal Mengirimkan OTP")));
                          }
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              content: Text("Nomor Handphone telah terpakai")));
                        }

                        setState(() {
                          loadingHP = false;
                        });
                      }
                    },
                  ),
      ),
    );
  }
}

class HalamanKodeOTP extends StatelessWidget {
  HalamanKodeOTP({
    super.key,
    required this.controllerOTP,
    required this.onPressedKembali,
    required this.onPressedVerifikasi,
    required this.onPressedKirimOTP,
    required this.isLoading,
    required this.isLoadingHP,
  });
  TextEditingController controllerOTP;
  Function()? onPressedVerifikasi;
  Function()? onPressedKembali;
  Function()? onPressedKirimOTP;
  bool isLoading;
  bool isLoadingHP;
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          'Masukkan Kode OTP',
          style: Theme.of(context).textTheme.displayMedium!.copyWith(
                fontSize: 37,
                color: Colors.black,
                fontWeight: FontWeight.bold,
              ),
        ),
        SizedBox(height: 25),
        Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Color.fromARGB(255, 103, 131, 255),
          ),
          child: Image.asset(
            'assets/logo-otp.png',
            height: 215.0,
          ),
        ),
        SizedBox(height: 25),
        Container(
          width: 300,
          padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 12),
          margin: const EdgeInsets.symmetric(horizontal: 5),
          decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(width: 2),
              borderRadius: BorderRadius.circular(20)),
          child: Row(
            children: [
              Expanded(
                  child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: TextField(
                  keyboardType: TextInputType.number,
                  inputFormatters: <TextInputFormatter>[
                    FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                    FilteringTextInputFormatter.digitsOnly,
                    LengthLimitingTextInputFormatter(6),
                  ],
                  controller: controllerOTP,
                  style: Theme.of(context).textTheme.labelLarge!.copyWith(
                        color: Colors.black,
                        fontSize: 50,
                        letterSpacing: 9,
                      ),
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: '123456',
                  ),
                ),
              ))
            ],
          ),
        ),
        const SizedBox(height: 6),
        (isLoadingHP)
            ? SizedBox(
                width: 30,
                height: 30,
                child: CircularProgressIndicator(
                  color: Colors.white,
                ),
              )
            : TextButton(
                onPressed: onPressedKirimOTP,
                child: Text(
                  "Kirim ulang OTP",
                  style: Theme.of(context).textTheme.displayMedium!.copyWith(
                      fontSize: 14,
                      color: Colors.blue,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1),
                ),
              ),
        const Spacer(),
        Container(
          height: 67,
          width: 280,
          margin: const EdgeInsets.symmetric(horizontal: 80),
          decoration: BoxDecoration(
            border: Border.all(width: 2, color: Colors.black),
            borderRadius: BorderRadius.circular(8),
            color: Colors.blue.shade600,
          ),
          child: TextButton(
              onPressed: onPressedVerifikasi,
              child: (isLoading)
                  ? const Center(
                      child: CircularProgressIndicator(
                        color: Colors.white,
                      ),
                    )
                  : Text(
                      "Kirim Kode OTP",
                      style: Theme.of(context)
                          .textTheme
                          .displayMedium!
                          .copyWith(
                              fontSize: 23,
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 1),
                    )),
        ),
        SizedBox(height: 4),
        TextButton(
          onPressed: onPressedKembali,
          child: Text(
            "Ganti Nomor HP",
            style: Theme.of(context).textTheme.displayMedium!.copyWith(
                fontSize: 14,
                color: Colors.blue,
                fontWeight: FontWeight.bold,
                letterSpacing: 1),
          ),
        ),
      ],
    );
  }
}

class HalamanNomorHP extends StatelessWidget {
  HalamanNomorHP({
    super.key,
    required this.nomorController,
    required this.onPressed,
    required this.isLoading,
  });
  final TextEditingController nomorController;
  Function() onPressed;
  bool isLoading;
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          'Masukkan Nomor HP Anda',
          style: Theme.of(context).textTheme.displayMedium!.copyWith(
                fontSize: 25,
                color: Colors.black,
                fontWeight: FontWeight.bold,
              ),
        ),
        SizedBox(height: 45),
        Container(
          padding: const EdgeInsets.all(34),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Color.fromARGB(255, 103, 131, 255),
          ),
          child: Image.asset(
            'assets/no-hp.png',
            height: 190.0,
          ),
        ),
        const SizedBox(height: 40),
        Container(
          width: 340,
          padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 12),
          margin: const EdgeInsets.symmetric(horizontal: 5),
          decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(width: 2),
              borderRadius: BorderRadius.circular(20)),
          child: Row(
            children: [
              Text(
                "+62",
                style: Theme.of(context).textTheme.displaySmall!.copyWith(
                      fontSize: 25,
                      color: Colors.black,
                    ),
              ),
              const SizedBox(width: 16),
              Expanded(
                  child: Container(
                padding: const EdgeInsets.only(bottom: 1.8),
                child: TextField(
                  keyboardType: TextInputType.number,
                  inputFormatters: <TextInputFormatter>[
                    FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                    FilteringTextInputFormatter.digitsOnly,
                    LengthLimitingTextInputFormatter(11),
                  ],
                  controller: nomorController,
                  style: Theme.of(context).textTheme.labelLarge!.copyWith(
                        color: Colors.black,
                        fontSize: 26,
                        letterSpacing: 2,
                      ),
                  decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: '81234567890',
                      suffixIcon: Icon(Icons.phone)),
                ),
              ))
            ],
          ),
        ),
        SizedBox(height: 5),
        Text(
          '*Satu nomor HP berlaku untuk satu akun',
          style: Theme.of(context).textTheme.displayMedium!.copyWith(
                fontSize: 14,
                color: Colors.black,
                fontWeight: FontWeight.bold,
              ),
        ),
        const Spacer(),
        Container(
          // height: 67,
          // width: 280,
          margin: const EdgeInsets.symmetric(horizontal: 50),
          padding: EdgeInsets.symmetric(vertical: 14, horizontal: 12),
          decoration: BoxDecoration(
            border: Border.all(width: 2, color: Colors.black),
            borderRadius: BorderRadius.circular(8),
            color: Colors.blue.shade600,
          ),
          child: (isLoading)
              ? const Center(
                  child: CircularProgressIndicator(
                    color: Colors.white,
                  ),
                )
              : TextButton(
                  onPressed: onPressed,
                  child: Text(
                    "Kirim OTP",
                    style: Theme.of(context).textTheme.displayMedium!.copyWith(
                        fontSize: 24.5,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1),
                  )),
        ),
      ],
    );
  }
}

enum DaftarHalaman { nomorHP, otp }

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:survei_aplikasi/features/profile/user_data.dart';
import 'package:survei_aplikasi/features/profile/widget/container_teks_general.dart';
import 'package:survei_aplikasi/features/profile/widget/halaman_ganti_pass.dart';
import 'package:survei_aplikasi/features/profile/widget/tampilan_demografi.dart';

class TampilanAwal extends StatelessWidget {
  TampilanAwal({
    super.key,
    required this.isEditMode,
    required this.onPressedVerifikasiHP,
    required this.onPressedUpdatePass,
    required this.onPressedEditProfile,
    required this.passBaru,
    required this.passLama,
    required this.onPressedModeNormal,
    required this.user,
    required this.containerUpdateDemo,
  });
  bool isEditMode;
  Function()? onPressedVerifikasiHP;
  Function()? onPressedUpdatePass;
  Function()? onPressedEditProfile;
  Function()? onPressedModeNormal;
  TextEditingController passLama;
  TextEditingController passBaru;
  Widget containerUpdateDemo;
  UserData user;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ContainerTeks(
          judul: "Email",
          text: user.email,
          iconData: Icons.email,
          warnaTeks: Colors.black,
        ),
        (!isEditMode)
            ? Column(
                children: [
                  ContainerTeks(
                    judul: "Tanggal Bergabung",
                    text: DateFormat('dd / MMMM / yyyy')
                        .format(user.waktu_pendaftaran),
                    iconData: Icons.calendar_today,
                    warnaTeks: Colors.black,
                  ),
                  ContainerTeks(
                    judul: "Verifikasi Nomor HP",
                    text: (user.isAuthenticated) ? "Sudah" : "Belum",
                    iconData: Icons.phone_android,
                    warnaTeks:
                        (user.isAuthenticated) ? Colors.blue : Colors.red,
                  ),
                  TampilanDemografi(user: user),
                  ElevatedButton(
                      onPressed: onPressedEditProfile,
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue,
                          padding: const EdgeInsets.symmetric(
                              vertical: 15, horizontal: 26)),
                      child: Text(
                        "Edit Profile",
                        style:
                            Theme.of(context).textTheme.displayMedium!.copyWith(
                                  fontSize: 20,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                      )),
                  SizedBox(height: 20),
                  if (!user.isAuthenticated)
                    ElevatedButton(
                        onPressed: onPressedVerifikasiHP,
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.lightGreen,
                            padding: const EdgeInsets.symmetric(
                                vertical: 15, horizontal: 26)),
                        child: Text(
                          "Verifikasi No Hp",
                          style: Theme.of(context)
                              .textTheme
                              .displayMedium!
                              .copyWith(
                                fontSize: 20,
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                        )),
                  const SizedBox(height: 20),
                ],
              )
            : Column(
                children: [
                  ContainerUpdatePassword(
                    passBaru: passBaru,
                    passLama: passLama,
                    onPressed: onPressedUpdatePass,
                  ),
                  const SizedBox(height: 20),
                  //
                  if (user.kota == "") containerUpdateDemo,
                  const SizedBox(height: 20),
                  ElevatedButton(
                      onPressed: onPressedModeNormal,
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.indigo.shade600,
                          padding: const EdgeInsets.symmetric(
                              vertical: 22, horizontal: 26)),
                      child: Text(
                        "Mode Normal",
                        style:
                            Theme.of(context).textTheme.displayMedium!.copyWith(
                                  fontSize: 20,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                      )),
                  SizedBox(height: 15),
                ],
              )
      ],
    );
  }
}

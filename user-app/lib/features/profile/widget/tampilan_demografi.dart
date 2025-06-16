import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:survei_aplikasi/features/profile/user_data.dart';
import 'package:survei_aplikasi/features/profile/widget/container_teks_general.dart';

class TampilanDemografi extends StatelessWidget {
  TampilanDemografi({
    super.key,
    required this.user,
  });
  UserData user;
  @override
  Widget build(BuildContext context) {
    return (user.kota == "")
        ? ContainerTeks(
            judul: "Data Demografi",
            text: "Belum Terisi",
            iconData: Icons.library_add_check_sharp,
            warnaTeks: Colors.red,
          )
        : Column(
            children: [
              ContainerTeks(
                judul: "Kota Tempat Tinggal",
                text: user.kota,
                iconData: Icons.location_on,
                warnaTeks: Colors.black,
              ),
              ContainerTeks(
                judul: "Tanggal Lahir",
                text: DateFormat('dd / MMMM / yyyy').format(user.tglLahir),
                iconData: Icons.calendar_today,
                warnaTeks: Colors.black,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 34),
                    child: Text(
                      "Interest",
                      style:
                          Theme.of(context).textTheme.displayMedium!.copyWith(
                                fontSize: 18,
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                              ),
                    ),
                  ),
                  const SizedBox(height: 5),
                  Container(
                    width: double.infinity,
                    margin:
                        const EdgeInsets.only(left: 32, right: 32, bottom: 20),
                    padding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(width: 2, color: Colors.black),
                        color: Colors.blueGrey.shade50),
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: [
                          Icon(Icons.face_unlock_sharp),
                          const SizedBox(width: 20),
                          Text(
                            overflow: TextOverflow.ellipsis,
                            user.interest.toString(),
                            style: Theme.of(context)
                                .textTheme
                                .displayMedium!
                                .copyWith(
                                  fontSize: 19,
                                  color: Colors.black,
                                ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ],
          );
  }
}

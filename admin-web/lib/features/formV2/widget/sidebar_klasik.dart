import 'package:aplikasi_admin/app/app.dart';
import 'package:aplikasi_admin/app/routing/route_constant.dart';
import 'package:aplikasi_admin/features/formV2/constant.dart';
import 'package:aplikasi_admin/features/formV2/state/form_controller.dart';
import 'package:aplikasi_admin/features/formV2/state/form_state.dart';
import 'package:aplikasi_admin/features/formV2/widget/kolom_tipe_soal.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class SidebarKlasik extends ConsumerStatefulWidget {
  SidebarKlasik({
    super.key,
    required this.formController,
    required this.scrollController,
  });
  FormController formController;
  ScrollController scrollController;
  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _SidebarKlasikState();
}

class _SidebarKlasikState extends ConsumerState<SidebarKlasik> {
  TextEditingController controllerKategori = TextEditingController();
  bool isLoading = false;
  bool isLoadingPublish = false;
  bool isLoadingTemplate = false;

  updateForm() async {
    setState(() {
      isLoading = true;
    });
    await widget.formController.updateFormFlutter(context);
    setState(() {
      isLoading = false;
    });
  }

  buatTemplate() async {
    setState(() {
      isLoadingTemplate = true;
    });
    bool hasil = await widget.formController
        .buatTemplateKlasik(context, controllerKategori.text);
    if (hasil) {
      widget.formController.gantiHalaman(HalamanForm.halamanBerhasilTemplate);
    }
    setState(() {
      isLoadingTemplate = false;
    });
  }

  Widget generateTombolUpdate() {
    if (!isLoading) {
      return Center(
        child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 16),
            width: 250,
            height: 50,
            child: ElevatedButton.icon(
              onPressed: () async {
                await updateForm();
              },
              icon: const Icon(
                Icons.save,
                color: Colors.white,
                size: 27,
              ),
              label: Text(
                "Simpan Form",
                style: Theme.of(context)
                    .textTheme
                    .titleLarge!
                    .copyWith(fontSize: 20),
                overflow: TextOverflow.ellipsis,
              ),
              style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.greenAccent.shade700),
            )),
      );
    } else {
      return Container(
        margin: const EdgeInsets.symmetric(vertical: 6),
        height: 45,
        width: 45,
        child: FittedBox(
          child: CircularProgressIndicator(
            strokeWidth: 5,
            color: Colors.blue.shade600,
          ),
        ),
      );
    }
  }

  Widget generateTombolPublish() {
    if (!isLoadingPublish) {
      return Column(
        children: [
          Center(
            child: Text(
              "Kontrol Form",
              style: Theme.of(context)
                  .textTheme
                  .titleMedium!
                  .copyWith(fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(height: 8),
          Center(
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 16),
              width: 250,
              height: 50,
              child: ElevatedButton.icon(
                onPressed: () {
                  setState(() {
                    isLoadingPublish = true;
                  });
                  final cekUrutan =
                      widget.formController.isUrutanKlasikOke(context);
                  if (cekUrutan) {
                    final pengecekan =
                        widget.formController.isSeluruhSoalUtamaOke(context);
                    final pengecekan2 =
                        widget.formController.isSeluruhSoalCabangOke(context);
                    if (pengecekan && pengecekan2) {
                      showAlertPublish(context);
                    }
                  }
                  setState(() {
                    isLoadingPublish = false;
                  });
                },
                icon: const Icon(
                  Icons.publish,
                  color: Colors.white,
                  size: 27,
                ),
                label: Text(
                  "Publish Survei",
                  style: Theme.of(context)
                      .textTheme
                      .titleLarge!
                      .copyWith(fontSize: 20),
                  overflow: TextOverflow.ellipsis,
                ),
                style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue.shade600),
              ),
            ),
          ),
        ],
      );
    } else {
      return Container(
        margin: const EdgeInsets.symmetric(vertical: 6),
        height: 45,
        width: 45,
        child: FittedBox(
          child: CircularProgressIndicator(
            strokeWidth: 5,
            color: Colors.blue.shade600,
          ),
        ),
      );
    }
  }

  Widget generateTombolTemplate() {
    if (!isLoadingTemplate) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Publikasi Template",
                style: Theme.of(context)
                    .textTheme
                    .titleMedium!
                    .copyWith(fontWeight: FontWeight.bold, fontSize: 17),
              ),
              const SizedBox(width: 16),
            ],
          ),
          const SizedBox(height: 10),
          Column(
            children: [
              Text(
                "Nama Kategori",
                style: Theme.of(context)
                    .textTheme
                    .titleMedium!
                    .copyWith(fontWeight: FontWeight.bold, fontSize: 17),
              ),
              Center(
                child: Container(
                  width: 240,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  margin: const EdgeInsets.symmetric(vertical: 6),
                  child: TextField(
                    controller: controllerKategori,
                    decoration: InputDecoration(
                      hintStyle: Theme.of(context)
                          .textTheme
                          .titleLarge!
                          .copyWith(fontSize: 15.5),
                      hintText: "Kategori",
                      border: const OutlineInputBorder(),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 8),
              Center(
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 16),
                  width: 250,
                  height: 50,
                  child: ElevatedButton.icon(
                    onPressed: () async {
                      await buatTemplate();
                      // widget.formController
                      //     .gantiHalaman(HalamanForm.halamanBerhasilTemplate);
                    },
                    icon: const Icon(
                      Icons.data_saver_on_outlined,
                      color: Colors.white,
                      size: 32,
                    ),
                    label: Text(
                      "Buat Template",
                      style: Theme.of(context)
                          .textTheme
                          .titleLarge!
                          .copyWith(fontSize: 19),
                      overflow: TextOverflow.ellipsis,
                    ),
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.brown.shade400),
                  ),
                ),
              ),
              const SizedBox(height: 12),
            ],
          )
        ],
      );
    } else {
      return Container(
        margin: const EdgeInsets.symmetric(vertical: 6),
        height: 45,
        width: 45,
        child: FittedBox(
          child: CircularProgressIndicator(
            strokeWidth: 5,
            color: Colors.blue.shade600,
          ),
        ),
      );
    }
  }

  showAlertKembali(BuildContext context) {
    Widget cancelButton = TextButton(
      child: Text(
        "Batal",
        style: Theme.of(context).textTheme.titleLarge!.copyWith(
              fontSize: 17,
              fontWeight: FontWeight.bold,
            ),
      ),
      onPressed: () {
        Navigator.pop(context, 'Cancel');
      },
    );
    Widget continueButton = TextButton(
      child: Text(
        "Kembali",
        style: Theme.of(context).textTheme.titleLarge!.copyWith(
              fontSize: 17,
              fontWeight: FontWeight.bold,
            ),
      ),
      onPressed: () {
        Navigator.pop(context);
        context.goNamed(RouterConstant.home);
      },
    );

    AlertDialog alert = AlertDialog(
      title: Text(
        "Peringatan",
        style: Theme.of(context)
            .textTheme
            .titleLarge!
            .copyWith(fontSize: 32, fontWeight: FontWeight.bold),
      ),
      content: Text(
        "Pastikan anda sudah menyimpan data form",
        style: Theme.of(context).textTheme.titleLarge!.copyWith(fontSize: 20),
      ),
      actions: [cancelButton, continueButton],
    );

    showDialog(
        context: context,
        builder: (context) {
          return alert;
        });
  }

  showAlertPublish(BuildContext context) async {
    bool hasil = false;

    if (!context.mounted) return false;
    Widget cancelButton = TextButton(
      child: Text(
        "Batal",
        style: Theme.of(context).textTheme.titleLarge!.copyWith(
              fontSize: 17,
              fontWeight: FontWeight.bold,
            ),
      ),
      onPressed: () {
        Navigator.pop(context, 'Cancel');
        setState(() {
          isLoadingPublish = false;
        });
      },
    );
    Widget continueButton = TextButton(
      child: Text(
        "Lanjut",
        style: Theme.of(context).textTheme.titleLarge!.copyWith(
              fontSize: 17,
              fontWeight: FontWeight.bold,
            ),
      ),
      onPressed: () async {
        Navigator.pop(context, 'Continue');
        final updateTerakhir =
            await widget.formController.updateFormFlutterTerakhir(context);
        if (updateTerakhir) {
          ref
              .read(dataUtamaProvider.notifier)
              .siapkanDataPublish(widget.formController.getId(), "klasik");
          if (!context.mounted) return;
          context.goNamed(RouterConstant.publishSurvei);
        } else {
          print("publish gagal");
          setState(() {
            isLoadingPublish = false;
          });
        }
      },
    );

    AlertDialog alert = AlertDialog(
      title: Text(
        "Notifikasi",
        style: Theme.of(context)
            .textTheme
            .titleLarge!
            .copyWith(fontSize: 32, fontWeight: FontWeight.bold),
      ),
      content: Text(
        "Pastikan konten Form sudah sesuai, Lanjut ke bagian publikasi?",
        style: Theme.of(context).textTheme.titleLarge!.copyWith(fontSize: 20),
      ),
      actions: [cancelButton, continueButton],
    );

    showDialog(
      context: context,
      builder: (context) => alert,
    );
    return hasil;
  }

  scrollKebawah() {
    widget.scrollController.animateTo(
      widget.scrollController.position.maxScrollExtent,
      duration: const Duration(milliseconds: 1500),
      curve: Curves.fastOutSlowIn,
    );
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return Column(
          children: [
            Expanded(
              child: ListView(
                children: [
                  Container(
                    margin:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 9),
                    child: Center(
                      child: InkWell(
                        onTap: () => showAlertKembali(context),
                        child: Row(
                          children: [
                            CircleAvatar(
                              backgroundColor: Colors.blue.shade700,
                              child: Icon(
                                Icons.chevron_left,
                                color: Colors.white,
                                size: 35,
                              ),
                            ),
                            const SizedBox(width: 16),
                            (constraints.maxWidth > 225)
                                ? Text(
                                    "Kembali",
                                    style: Theme.of(context)
                                        .textTheme
                                        .titleLarge!
                                        .copyWith(fontSize: 18),
                                    overflow: TextOverflow.ellipsis,
                                  )
                                : const SizedBox(),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Center(
                    child: Text(
                      "Kontrol Form",
                      style: Theme.of(context)
                          .textTheme
                          .titleMedium!
                          .copyWith(fontWeight: FontWeight.bold),
                    ),
                  ),
                  SizedBox(height: 8),
                  Center(
                    child: Container(
                      margin: const EdgeInsets.symmetric(horizontal: 16),
                      width: 250,
                      height: 50,
                      child: ElevatedButton.icon(
                        onPressed: () {
                          widget.formController.tambahSoal();
                          scrollKebawah();
                        },
                        icon: const Icon(
                          Icons.add,
                          color: Colors.white,
                          size: 27,
                        ),
                        label: Text(
                          "Soal",
                          style: Theme.of(context)
                              .textTheme
                              .titleLarge!
                              .copyWith(fontSize: 20),
                          overflow: TextOverflow.ellipsis,
                        ),
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue.shade600),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Center(
                    child: Container(
                      margin: const EdgeInsets.symmetric(horizontal: 16),
                      width: 250,
                      height: 50,
                      child: ElevatedButton.icon(
                        onPressed: () {
                          widget.formController.tambahPembatas();
                          scrollKebawah();
                        },
                        icon: const Icon(
                          Icons.add,
                          color: Colors.white,
                          size: 27,
                        ),
                        label: Text(
                          "Pembatas",
                          style: Theme.of(context)
                              .textTheme
                              .titleLarge!
                              .copyWith(fontSize: 20),
                          overflow: TextOverflow.ellipsis,
                        ),
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue.shade600),
                      ),
                    ),
                  ),
                  Center(
                    child: Container(
                        margin: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 16),
                        width: 250,
                        height: 50,
                        child: ElevatedButton.icon(
                          onPressed: () {
                            setState(() {
                              widget.formController.pasteSoal(context);
                            });
                          },
                          icon: const Icon(
                            Icons.paste,
                            color: Colors.white,
                            size: 27,
                          ),
                          label: Text(
                            "Paste Soal",
                            style: Theme.of(context)
                                .textTheme
                                .titleLarge!
                                .copyWith(fontSize: 20),
                            overflow: TextOverflow.ellipsis,
                          ),
                          style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.lightBlueAccent.shade700),
                        )),
                  ),
                  const SizedBox(height: 16),
                  generateTombolUpdate(),
                  Center(
                    child: Container(
                        margin: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 16),
                        width: 250,
                        height: 50,
                        child: ElevatedButton.icon(
                          onPressed: () {
                            setState(() {
                              widget.formController.gantiListDitampilkan();
                            });
                          },
                          icon: const Icon(
                            Icons.save,
                            color: Colors.white,
                            size: 27,
                          ),
                          label: Text(
                            "Ganti View",
                            style: Theme.of(context)
                                .textTheme
                                .titleLarge!
                                .copyWith(fontSize: 20),
                            overflow: TextOverflow.ellipsis,
                          ),
                          style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.indigoAccent),
                        )),
                  ),
                  const SizedBox(height: 12),
                  const KolomTipeSoalDrag(),
                  const SizedBox(height: 16),
                  generateTombolPublish(),
                  const SizedBox(height: 8),
                  const Divider(),
                  const SizedBox(height: 8),
                  generateTombolTemplate(),
                ],
              ),
            )
          ],
        );
      },
    );
  }
}



// class SidebarKlasik extends StatefulWidget {
//   SidebarKlasik({
//     super.key,
//     required this.formController,
//   });
//   FormController formController;

//   @override
//   State<SidebarKlasik> createState() => _SidebarKlasikState();
// }

// class _SidebarKlasikState extends State<SidebarKlasik> {
//   showAlertKembali(BuildContext context) {
//     Widget cancelButton = TextButton(
//       child: Text(
//         "Batal",
//         style: Theme.of(context).textTheme.titleLarge!.copyWith(
//               fontSize: 17,
//               fontWeight: FontWeight.bold,
//             ),
//       ),
//       onPressed: () {
//         Navigator.pop(context, 'Cancel');
//       },
//     );
//     Widget continueButton = TextButton(
//       child: Text(
//         "Kembali",
//         style: Theme.of(context).textTheme.titleLarge!.copyWith(
//               fontSize: 17,
//               fontWeight: FontWeight.bold,
//             ),
//       ),
//       onPressed: () {
//         Navigator.pop(context);
//         // context.goNamed(RouteConstant.halamanAuth);
//       },
//     );

//     AlertDialog alert = AlertDialog(
//       title: Text(
//         "Peringatan",
//         style: Theme.of(context)
//             .textTheme
//             .titleLarge!
//             .copyWith(fontSize: 32, fontWeight: FontWeight.bold),
//       ),
//       content: Text(
//         "Pastikan anda sudah menyimpan data form",
//         style: Theme.of(context).textTheme.titleLarge!.copyWith(fontSize: 20),
//       ),
//       actions: [cancelButton, continueButton],
//     );

//     showDialog(
//         context: context,
//         builder: (context) {
//           return alert;
//         });
//   }

//   showAlertPublish(BuildContext context) async {
//     bool hasil = false;

//     if (!context.mounted) return false;
//     Widget cancelButton = TextButton(
//       child: Text(
//         "Batal",
//         style: Theme.of(context).textTheme.titleLarge!.copyWith(
//               fontSize: 17,
//               fontWeight: FontWeight.bold,
//             ),
//       ),
//       onPressed: () {
//         Navigator.pop(context, 'Cancel');
//       },
//     );
//     Widget continueButton = TextButton(
//       child: Text(
//         "Lanjut",
//         style: Theme.of(context).textTheme.titleLarge!.copyWith(
//               fontSize: 17,
//               fontWeight: FontWeight.bold,
//             ),
//       ),
//       onPressed: () {
//         Navigator.pop(context, 'Continue');
//         print("oke");
//       },
//     );

//     AlertDialog alert = AlertDialog(
//       title: Text(
//         "Notifikasi",
//         style: Theme.of(context)
//             .textTheme
//             .titleLarge!
//             .copyWith(fontSize: 32, fontWeight: FontWeight.bold),
//       ),
//       content: Text(
//         "Pastikan konten Form sudah sesuai, Lanjut ke bagian publikasi?",
//         style: Theme.of(context).textTheme.titleLarge!.copyWith(fontSize: 20),
//       ),
//       actions: [cancelButton, continueButton],
//     );

//     showDialog(
//       context: context,
//       builder: (context) => alert,
//     );
//     return hasil;
//   }

//   bool isLoading = false;

//   @override
//   Widget build(BuildContext context) {
//     return LayoutBuilder(
//       builder: (context, constraints) {
//         return Column(
//           children: [
//             Expanded(
//               child: ListView(
//                 children: [
//                   Container(
//                     margin:
//                         const EdgeInsets.symmetric(horizontal: 16, vertical: 9),
//                     child: Center(
//                       child: InkWell(
//                         onTap: () {},
//                         child: Row(
//                           children: [
//                             CircleAvatar(
//                               backgroundColor: Colors.blue.shade700,
//                               child: Icon(
//                                 Icons.chevron_left,
//                                 color: Colors.white,
//                                 size: 35,
//                               ),
//                             ),
//                             const SizedBox(width: 16),
//                             (constraints.maxWidth > 225)
//                                 ? Text(
//                                     "Kembali",
//                                     style: Theme.of(context)
//                                         .textTheme
//                                         .titleLarge!
//                                         .copyWith(fontSize: 18),
//                                     overflow: TextOverflow.ellipsis,
//                                   )
//                                 : const SizedBox(),
//                           ],
//                         ),
//                       ),
//                     ),
//                   ),
//                   Center(
//                     child: Text(
//                       "Kontrol Form",
//                       style: Theme.of(context)
//                           .textTheme
//                           .titleMedium!
//                           .copyWith(fontWeight: FontWeight.bold),
//                     ),
//                   ),
//                   SizedBox(height: 8),
//                   Center(
//                     child: Container(
//                       margin: const EdgeInsets.symmetric(horizontal: 16),
//                       width: 250,
//                       height: 50,
//                       child: ElevatedButton.icon(
//                         onPressed: () {
//                           widget.formController.tambahSoal();
//                         },
//                         icon: const Icon(
//                           Icons.add,
//                           color: Colors.white,
//                           size: 27,
//                         ),
//                         label: Text(
//                           "Tambah Soal",
//                           style: Theme.of(context)
//                               .textTheme
//                               .titleLarge!
//                               .copyWith(fontSize: 20),
//                           overflow: TextOverflow.ellipsis,
//                         ),
//                         style: ElevatedButton.styleFrom(
//                             backgroundColor: Colors.blue.shade600),
//                       ),
//                     ),
//                   ),
//                   const SizedBox(height: 16),
//                   Center(
//                     child: Container(
//                         margin: const EdgeInsets.symmetric(horizontal: 16),
//                         width: 250,
//                         height: 50,
//                         child: ElevatedButton.icon(
//                           onPressed: () async {
//                             setState(() {
//                               isLoading = true;
//                             });
//                             await widget.formController
//                                 .updateFormFlutter(context);
//                             setState(() {
//                               isLoading = false;
//                             });
//                           },
//                           icon: const Icon(
//                             Icons.save,
//                             color: Colors.white,
//                             size: 27,
//                           ),
//                           label: Text(
//                             "Simpan Form",
//                             style: Theme.of(context)
//                                 .textTheme
//                                 .titleLarge!
//                                 .copyWith(fontSize: 20),
//                             overflow: TextOverflow.ellipsis,
//                           ),
//                           style: ElevatedButton.styleFrom(
//                               backgroundColor: Colors.greenAccent.shade700),
//                         )),
//                   ),
//                   Center(
//                     child: Container(
//                         margin: const EdgeInsets.symmetric(
//                             horizontal: 16, vertical: 16),
//                         width: 250,
//                         height: 50,
//                         child: ElevatedButton.icon(
//                           onPressed: () {
//                             setState(() {
//                               widget.formController.pasteSoal(context);
//                             });
//                           },
//                           icon: const Icon(
//                             Icons.paste,
//                             color: Colors.white,
//                             size: 27,
//                           ),
//                           label: Text(
//                             "Paste Soal",
//                             style: Theme.of(context)
//                                 .textTheme
//                                 .titleLarge!
//                                 .copyWith(fontSize: 20),
//                             overflow: TextOverflow.ellipsis,
//                           ),
//                           style: ElevatedButton.styleFrom(
//                               backgroundColor: Colors.lightBlueAccent.shade700),
//                         )),
//                   ),
//                   Center(
//                     child: Container(
//                         margin: const EdgeInsets.symmetric(
//                             horizontal: 16, vertical: 16),
//                         width: 250,
//                         height: 50,
//                         child: ElevatedButton.icon(
//                           onPressed: () {
//                             setState(() {
//                               widget.formController.gantiListDitampilkan();
//                             });
//                           },
//                           icon: const Icon(
//                             Icons.save,
//                             color: Colors.white,
//                             size: 27,
//                           ),
//                           label: Text(
//                             "Ganti View",
//                             style: Theme.of(context)
//                                 .textTheme
//                                 .titleLarge!
//                                 .copyWith(fontSize: 20),
//                             overflow: TextOverflow.ellipsis,
//                           ),
//                           style: ElevatedButton.styleFrom(
//                               backgroundColor: Colors.indigoAccent),
//                         )),
//                   ),
//                   const SizedBox(height: 16),
//                   Center(
//                     child: Text(
//                       "Kontrol Form",
//                       style: Theme.of(context)
//                           .textTheme
//                           .titleMedium!
//                           .copyWith(fontWeight: FontWeight.bold),
//                     ),
//                   ),
//                   const SizedBox(height: 8),
//                   Center(
//                     child: Container(
//                       margin: const EdgeInsets.symmetric(horizontal: 16),
//                       width: 250,
//                       height: 50,
//                       child: ElevatedButton.icon(
//                         onPressed: () {
//                           showAlertPublish(context);
//                         },
//                         icon: const Icon(
//                           Icons.publish,
//                           color: Colors.white,
//                           size: 27,
//                         ),
//                         label: Text(
//                           "Publish Survei",
//                           style: Theme.of(context)
//                               .textTheme
//                               .titleLarge!
//                               .copyWith(fontSize: 20),
//                           overflow: TextOverflow.ellipsis,
//                         ),
//                         style: ElevatedButton.styleFrom(
//                             backgroundColor: Colors.blue.shade600),
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             )
//           ],
//         );
//       },
//     );
//   }
// }

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:hei_survei/app/app.dart';
import 'package:hei_survei/app/routing/route_constant.dart';
import 'package:hei_survei/constants.dart';
import 'package:hei_survei/features/form/constant.dart';
import 'package:hei_survei/features/form/state/form_controller.dart';
import 'package:hei_survei/features/form/widget/kolom_tipe_soal.dart';
import 'package:hei_survei/utils/shared_pref.dart';

class SideBarKartu extends ConsumerStatefulWidget {
  SideBarKartu({
    super.key,
    required this.formController,
    required this.tabController,
  });
  final TabController tabController;
  final FormController formController;
  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _SidebarKartuState();
}

class _SidebarKartuState extends ConsumerState<SideBarKartu> {
  TextEditingController editingGambarController = TextEditingController();
  TextEditingController controllerAngkaPindah = TextEditingController();
  bool isLoading = false;
  bool isLoadingPublish = false;

  updateForm() async {
    setState(() {
      isLoading = true;
    });
    await widget.formController.updateFormKartuFlutter(context);
    setState(() {
      isLoading = false;
    });
  }

  Widget generateTombolUpdate() {
    if (!isLoading) {
      return Column(
        children: [
          Center(
            child: Text(
              "Simpan Data",
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
                onPressed: () async {
                  await updateForm();
                },
                icon: const Icon(
                  Icons.save_rounded,
                  color: Colors.white,
                  size: 32,
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

  generateTombolPublish() {
    if (!isLoadingPublish) {
      return Column(
        children: [
          Center(
            child: Text(
              "Publish Survei",
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
                onPressed: () async {
                  setState(() {
                    isLoadingPublish = true;
                  });
                  final userId = SharedPrefs.getString(prefUserId) ?? "";
                  if (userId != "") {
                    DatabaseReference dbRef =
                        FirebaseDatabase.instance.ref('tagihan/$userId');
                    final snapshot = await dbRef.get();
                    if (snapshot.exists) {
                      ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text("Sudah ada transaksi aktif")));
                    } else {
                      if (!context.mounted) return;
                      final pengecekan =
                          widget.formController.isSeluruhSoalUtamaOke(context);
                      final pengecekan2 =
                          widget.formController.isSeluruhSoalCabangOke(context);
                      if (pengecekan && pengecekan2) {
                        showAlertPublish(context);
                      }
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
        context.goNamed(RouteConstant.home);
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
        // widget.formController.isLoading = true;
        final updateTerakhir =
            await widget.formController.updateFormKartuPublish(context);
        if (updateTerakhir) {
          print("sukses");
          ref
              .read(dataUtamaProvider.notifier)
              .siapkanDataPublish(widget.formController.getId(), "kartu");
          if (!context.mounted) return;
          context.goNamed(RouteConstant.publishSurvei);
        } else {
          setState(() {
            isLoadingPublish = false;
          });
          print("gagal");
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

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return Column(
          children: [
            Container(
              child: TabBar(
                controller: widget.tabController,
                tabs: [
                  Tab(
                    text: "Soal Utama",
                  ),
                  Tab(
                    text: "Soal Cabang",
                  ),
                ],
              ),
            ),
            Expanded(
                child: TabBarView(
              controller: widget.tabController,
              children: [
                ListView(
                  children: [
                    Container(
                      margin: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 9),
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
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 18),
                        margin: const EdgeInsets.only(top: 6, bottom: 15),
                        width: 256,
                        height: 45,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              shape: const RoundedRectangleBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(8))),
                              backgroundColor: Colors.blue),
                          onPressed: () {
                            setState(() {
                              widget.formController
                                  .gantiListDitampilkanKartu(false);
                            });
                          },
                          child: Text(
                            "Tampilkan Soal",
                            overflow: TextOverflow.ellipsis,
                            style: Theme.of(context)
                                .textTheme
                                .titleLarge!
                                .copyWith(color: Colors.white, fontSize: 15),
                          ),
                        ),
                      ),
                    ),
                    KolomKontrolSoal(
                      controllerAngkaPindah: controllerAngkaPindah,
                      formController: widget.formController,
                    ),
                    const SizedBox(height: 12),
                    KolomKontrolForm(
                      controllerAngkaPindah: controllerAngkaPindah,
                      formController: widget.formController,
                    ),
                    const SizedBox(height: 12),
                    const KolomTipeSoalDrag(),
                    const SizedBox(height: 4),
                    generateTombolUpdate(),
                    const SizedBox(height: 16),
                    generateTombolPublish(),
                  ],
                ),
                ListView(
                  children: [
                    Center(
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 28),
                        margin: const EdgeInsets.only(top: 24),
                        width: 256,
                        height: 45,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              shape: const RoundedRectangleBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(8))),
                              backgroundColor: Colors.blue),
                          onPressed: () {
                            widget.formController
                                .gantiListDitampilkanKartu(true);
                          },
                          child: Text(
                            "Tampilkan Cabang",
                            overflow: TextOverflow.ellipsis,
                            style: Theme.of(context)
                                .textTheme
                                .titleLarge!
                                .copyWith(color: Colors.white, fontSize: 15),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Center(
                      child: Text(
                        "Model Kartu",
                        style: Theme.of(context)
                            .textTheme
                            .titleMedium!
                            .copyWith(fontWeight: FontWeight.bold),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        IconButton.filled(
                          onPressed: () {
                            widget.formController
                                .gantiModelSoal(ModelSoal.modelX);
                          },
                          icon: const Icon(Icons.looks_two),
                        ),
                        IconButton.filled(
                          onPressed: () {
                            widget.formController
                                .gantiModelSoal(ModelSoal.modelY);
                          },
                          icon: const Icon(Icons.looks_two),
                        ),
                        IconButton.filled(
                          onPressed: () {
                            widget.formController
                                .gantiModelSoal(ModelSoal.modelZ);
                          },
                          icon: const Icon(Icons.looks_3),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
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
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          height: 36,
                          width: 36,
                          child: IconButton.filled(
                            icon: const Icon(
                              Icons.arrow_left,
                              size: 22,
                            ),
                            onPressed: () {
                              widget.formController.kurangIndexSoal();
                              setState(() {});
                            },
                          ),
                        ),
                        Text(
                          "${widget.formController.getIndexCabang() + 1} / ${widget.formController.getLengtCabang()}",
                          style: Theme.of(context).textTheme.titleLarge!,
                        ),
                        SizedBox(
                          height: 36,
                          width: 36,
                          child: IconButton.filled(
                            icon: const Icon(
                              Icons.arrow_right,
                              size: 22,
                            ),
                            onPressed: () {
                              widget.formController.tambahIndexSoal();

                              setState(() {});
                            },
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    Center(
                      child: Container(
                        margin: const EdgeInsets.symmetric(horizontal: 16),
                        width: 250,
                        height: 50,
                        child: ElevatedButton.icon(
                          onPressed: () {
                            widget.formController.hapusSoalKartu();
                          },
                          icon: const Icon(
                            Icons.remove_circle,
                            color: Colors.white,
                            size: 32,
                          ),
                          label: Text(
                            "Hapus Soal",
                            style: Theme.of(context)
                                .textTheme
                                .titleLarge!
                                .copyWith(fontSize: 20),
                            overflow: TextOverflow.ellipsis,
                          ),
                          style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.red),
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    Center(
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 32),
                        width: 230,
                        height: 38,
                        margin: const EdgeInsets.only(top: 14),
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              shape: const RoundedRectangleBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(8))),
                              backgroundColor: Colors.blue),
                          onPressed: () {
                            setState(() {
                              widget.formController
                                  .gantiGambarPertanyaanPilihan(context);
                            });
                          },
                          child: Text(
                            "Ganti Gambar",
                            overflow: TextOverflow.ellipsis,
                            style: Theme.of(context)
                                .textTheme
                                .titleLarge!
                                .copyWith(color: Colors.white, fontSize: 17),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    const KolomTipeSoalDrag(),
                  ],
                ),
              ],
            ))
          ],
        );
      },
    );
  }
}

class KolomKontrolSoal extends StatefulWidget {
  KolomKontrolSoal({
    super.key,
    required this.controllerAngkaPindah,
    required this.formController,
  });
  FormController formController;
  TextEditingController controllerAngkaPindah;
  @override
  State<KolomKontrolSoal> createState() => _KolomKontrolSoalState();
}

class _KolomKontrolSoalState extends State<KolomKontrolSoal> {
  bool isExpanded = true;
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Kontrol Soal",
              style: Theme.of(context)
                  .textTheme
                  .titleMedium!
                  .copyWith(fontWeight: FontWeight.bold, fontSize: 17),
            ),
            const SizedBox(width: 16),
            CircleAvatar(
              child: IconButton(
                  onPressed: () {
                    setState(() {
                      isExpanded = !isExpanded;
                    });
                  },
                  icon: (isExpanded)
                      ? Icon(
                          Icons.arrow_upward,
                          size: 24,
                        )
                      : Icon(
                          Icons.arrow_downward,
                          size: 24,
                        )),
            )
          ],
        ),
        const SizedBox(height: 10),
        if (isExpanded)
          Column(
            children: [
              Center(
                child: Text(
                  "Model Kartu",
                  style: Theme.of(context)
                      .textTheme
                      .titleMedium!
                      .copyWith(fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  IconButton.filled(
                    onPressed: () {
                      widget.formController.gantiModelSoal(ModelSoal.modelX);
                    },
                    icon: const Icon(Icons.looks_one),
                  ),
                  IconButton.filled(
                    onPressed: () {
                      widget.formController.gantiModelSoal(ModelSoal.modelY);
                    },
                    icon: const Icon(Icons.looks_two),
                  ),
                  IconButton.filled(
                    onPressed: () {
                      widget.formController.gantiModelSoal(ModelSoal.modelZ);
                    },
                    icon: const Icon(Icons.looks_3),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Center(
                child: Text(
                  "Kontrol Halaman",
                  style: Theme.of(context)
                      .textTheme
                      .titleMedium!
                      .copyWith(fontWeight: FontWeight.bold),
                ),
              ),
              SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 36,
                    width: 36,
                    child: IconButton.filled(
                      icon: const Icon(
                        Icons.arrow_left,
                        size: 22,
                      ),
                      onPressed: () {
                        widget.formController.kurangIndexSoal();
                        setState(() {});
                      },
                    ),
                  ),
                  Text(
                    "${widget.formController.getIndexUtama() + 1} / ${widget.formController.getLengtUtama()}",
                    style: Theme.of(context).textTheme.titleLarge!,
                  ),
                  SizedBox(
                    height: 36,
                    width: 36,
                    child: IconButton.filled(
                      icon: const Icon(
                        Icons.arrow_right,
                        size: 22,
                      ),
                      onPressed: () {
                        widget.formController.tambahIndexSoal();
                        setState(() {});
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Center(
                child: Container(
                  width: 240,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  margin: const EdgeInsets.symmetric(vertical: 16),
                  child: TextField(
                    controller: widget.controllerAngkaPindah,
                    decoration: InputDecoration(
                      hintStyle: Theme.of(context)
                          .textTheme
                          .titleLarge!
                          .copyWith(fontSize: 18),
                      hintText: "Pindah Nomor...",
                      border: const OutlineInputBorder(),
                      suffixIcon: Container(
                        margin: const EdgeInsets.only(right: 8),
                        child: IconButton.filled(
                          color: Colors.blue,
                          onPressed: () {
                            try {
                              widget.formController.pindahkanIndex(
                                  int.parse(widget.controllerAngkaPindah.text));
                              setState(() {});
                            } catch (e) {
                              print(e);
                            }
                          },
                          icon: const Icon(
                            Icons.chevron_right,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              Center(
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 32),
                  width: 230,
                  height: 38,
                  margin: const EdgeInsets.only(top: 2),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.all(Radius.circular(8))),
                        backgroundColor: Colors.blue),
                    onPressed: () {
                      setState(() {
                        widget.formController
                            .gantiGambarPertanyaanPilihan(context);
                        print("coba ganti gambar");
                      });
                    },
                    child: Text(
                      "Ganti Gambar",
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context)
                          .textTheme
                          .titleLarge!
                          .copyWith(color: Colors.white, fontSize: 17),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 8),
            ],
          )
      ],
    );
  }
}

class KolomKontrolForm extends StatefulWidget {
  KolomKontrolForm({
    super.key,
    required this.controllerAngkaPindah,
    required this.formController,
  });
  FormController formController;
  TextEditingController controllerAngkaPindah;
  @override
  State<KolomKontrolForm> createState() => _KolomKontrolFormState();
}

class _KolomKontrolFormState extends State<KolomKontrolForm> {
  bool isExpanded = true;
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Kontrol Soal",
              style: Theme.of(context)
                  .textTheme
                  .titleMedium!
                  .copyWith(fontWeight: FontWeight.bold, fontSize: 17),
            ),
            const SizedBox(width: 16),
            CircleAvatar(
              child: IconButton(
                  onPressed: () {
                    setState(() {
                      isExpanded = !isExpanded;
                    });
                  },
                  icon: (isExpanded)
                      ? Icon(
                          Icons.arrow_upward,
                          size: 24,
                        )
                      : Icon(
                          Icons.arrow_downward,
                          size: 24,
                        )),
            )
          ],
        ),
        const SizedBox(height: 10),
        if (isExpanded)
          Column(
            children: [
              const SizedBox(height: 8),
              Center(
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 16),
                  width: 250,
                  height: 50,
                  child: ElevatedButton.icon(
                    onPressed: () {
                      widget.formController.tambahSoalKartu();
                      setState(() {});
                    },
                    icon: const Icon(
                      Icons.add_circle,
                      color: Colors.white,
                      size: 32,
                    ),
                    label: Text(
                      "Tambah Soal",
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
                      widget.formController.hapusSoalKartu();
                    },
                    icon: const Icon(
                      Icons.remove_circle,
                      color: Colors.white,
                      size: 32,
                    ),
                    label: Text(
                      "Hapus Soal",
                      style: Theme.of(context)
                          .textTheme
                          .titleLarge!
                          .copyWith(fontSize: 20),
                      overflow: TextOverflow.ellipsis,
                    ),
                    style:
                        ElevatedButton.styleFrom(backgroundColor: Colors.red),
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
                      setState(() {
                        widget.formController.pasteSoalKartu(context);
                      });
                    },
                    icon: const Icon(
                      Icons.paste_rounded,
                      color: Colors.white,
                      size: 32,
                    ),
                    label: Text(
                      "Paste Soal",
                      style: Theme.of(context)
                          .textTheme
                          .titleLarge!
                          .copyWith(fontSize: 20),
                      overflow: TextOverflow.ellipsis,
                    ),
                    style:
                        ElevatedButton.styleFrom(backgroundColor: Colors.blue),
                  ),
                ),
              ),
            ],
          )
      ],
    );
  }
}

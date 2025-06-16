import 'package:aplikasi_admin/app/routing/route_constant.dart';
import 'package:aplikasi_admin/features/formV2/state/form_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class SidebarPreviewKartu extends ConsumerStatefulWidget {
  SidebarPreviewKartu({
    super.key,
    required this.formController,
    required this.tabController,
  });
  final TabController tabController;
  final FormController formController;
  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _SidebarPreviewKartuState();
}

class _SidebarPreviewKartuState extends ConsumerState<SidebarPreviewKartu> {
  TextEditingController editingGambarController = TextEditingController();
  TextEditingController controllerAngkaPindah = TextEditingController();

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
                        padding: const EdgeInsets.symmetric(horizontal: 28),
                        margin: const EdgeInsets.only(top: 16, bottom: 16),
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
                    const SizedBox(height: 16),
                    Center(
                      child: Container(
                        width: 240,
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        margin: const EdgeInsets.symmetric(vertical: 16),
                        child: TextField(
                          controller: controllerAngkaPindah,
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
                                        int.parse(controllerAngkaPindah.text));
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

import 'dart:typed_data';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:hei_survei/features/form/data_utility.dart';
import 'package:hei_survei/features/form/state/form_controller.dart';
import 'package:hei_survei/features/form/state/pertanyaan_controller.dart';
import 'package:uuid/uuid.dart';

class OpsiGambar extends StatefulWidget {
  OpsiGambar({
    super.key,
    required this.controller,
    required this.urlGambar,
    required this.idJawaban,
    required this.formController,
  });
  PertanyaanController controller;
  String urlGambar;
  String idJawaban;
  FormController formController;
  @override
  State<OpsiGambar> createState() => _OpsiGambarState();
}

class _OpsiGambarState extends State<OpsiGambar> {
  bool isError = false;
  String urlImage = "";
  // late CachedNetworkImage imageContainer;
  Uint8List? selectedImageBytes;
  bool isLoading = false;
  @override
  void initState() {
    urlImage = widget.urlGambar;
    super.initState();
  }

  pilihGambar() async {
    try {
      FilePickerResult? fileResult = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowMultiple: false,
        allowedExtensions: ['jpg', 'jpeg', 'png', 'heic', 'gif'],
      );
      if (fileResult != null) {
        setState(() {
          selectedImageBytes = fileResult.files.first.bytes;
        });
      } else {
        print("File tidak sesuai extension atau belum pilih");
      }
    } catch (e) {
      print(e);
    }
  }

  uploadGamabr() async {
    try {
      if (selectedImageBytes != null) {
        String namaBaru = const Uuid().v4().substring(0, 11);
        firebase_storage.UploadTask uploadTask;

        firebase_storage.Reference ref = firebase_storage
            .FirebaseStorage.instance
            .ref()
            .child('eksp')
            .child('/' + namaBaru);

        final metaData =
            firebase_storage.SettableMetadata(contentType: 'image/jpeg');

        uploadTask = ref.putData(selectedImageBytes!, metaData);

        await uploadTask.whenComplete(() => null);
        String imageUrl = await ref.getDownloadURL();
        setState(() {
          urlImage = imageUrl;
        });
      }
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return Container(
          margin: const EdgeInsets.symmetric(vertical: 6),
          padding: const EdgeInsets.only(bottom: 8),
          width: double.infinity,
          child: Row(
            children: [
              DataUtility().mapIcon[widget.controller.getTipeSoal()]!,
              const SizedBox(width: 6),
              (constraints.maxWidth > 300)
                  ? Container(
                      height: 81,
                      width: 144,
                      decoration: BoxDecoration(
                        border: Border.all(width: 1),
                        color: Colors.grey.shade300,
                      ),
                      child: CachedNetworkImage(
                        filterQuality: FilterQuality.medium,
                        imageUrl: widget.urlGambar,
                        imageBuilder: (context, imageProvider) {
                          return Container(
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                image: imageProvider,
                                fit: BoxFit.cover,
                              ),
                            ),
                          );
                        },
                        progressIndicatorBuilder:
                            (context, url, downloadProgress) =>
                                CircularProgressIndicator(
                                    value: downloadProgress.progress),
                        errorWidget: (context, url, error) {
                          return const Icon(
                            Icons.error,
                            size: 48,
                            color: Colors.red,
                          );
                        },
                      ),
                    )
                  : const SizedBox(),
              const SizedBox(width: 8),
              //tombol gambar
              Container(
                margin: const EdgeInsets.symmetric(vertical: 10),
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                child: (isLoading)
                    ? const CircularProgressIndicator(strokeWidth: 5)
                    : ElevatedButton.icon(
                        onPressed: () async {
                          print("ini id jawaban -> ${widget.idJawaban}");
                          setState(() {
                            isLoading = true;
                          });
                          await pilihGambar();
                          if (selectedImageBytes != null) {
                            await uploadGamabr();
                            print("ini url baru -> $urlImage");
                            widget.controller
                                .gantiUrlGambarGG(urlImage, widget.idJawaban);
                            if (widget.formController.isCabangShown() ||
                                widget.controller.isPertanyaanKartu()) {
                              widget.formController.refreshUI();
                            }
                            setState(() {
                              isLoading = false;
                            });
                          }
                        },
                        icon: Icon(
                          Icons.photo_size_select_actual_rounded,
                          color: Colors.white,
                          size: 24,
                        ),
                        label: Text("Pilih Gambar",
                            style: Theme.of(context)
                                .textTheme
                                .titleLarge!
                                .copyWith(fontSize: 16, color: Colors.white),
                            overflow: TextOverflow.ellipsis),
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blueAccent.shade700),
                      ),
              ),
              const SizedBox(width: 20),
              IconButton(
                disabledColor: Colors.grey.shade400,
                icon: const Icon(
                  Icons.remove_circle_outline,
                  size: 30,
                ),
                onPressed: () {
                  widget.controller.hapusOpsi(
                      widget.idJawaban, widget.controller.getTipeSoal());
                  widget.formController.refreshUI();
                  if (widget.formController.isCabangShown()) {
                    widget.formController.refreshUI();
                  }
                },
              )
            ],
          ),
        );
      },
    );
  }
}

import 'dart:io';
import 'dart:typed_data';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:flutter/material.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:image_picker/image_picker.dart';

import 'package:uuid/uuid.dart';

class PercobaanImagePicker extends StatefulWidget {
  const PercobaanImagePicker({super.key});

  @override
  State<PercobaanImagePicker> createState() => _PercobaanImagePickerState();
}

class _PercobaanImagePickerState extends State<PercobaanImagePicker> {
  String imageUrl = "";
  bool isLoading = false;

  uploadGambar(File imageFile) async {
    try {
      String namaBaru = Uuid().v4().substring(0, 11);
      firebase_storage.UploadTask uploadTask;

      firebase_storage.Reference ref = firebase_storage.FirebaseStorage.instance
          .ref()
          .child('eksp')
          .child('/' + namaBaru);

      final metaData =
          firebase_storage.SettableMetadata(contentType: 'image/jpeg');

      uploadTask = ref.putFile(imageFile, metaData);
      // uploadTask = ref.putFile(imageFile);

      await uploadTask.whenComplete(() {
        print("berhasil upload $namaBaru");
      });
      imageUrl = await ref.getDownloadURL();
      setState(() {});
      print('uploaded image URL : $imageUrl');
    } catch (e) {
      print(e);
    }
  }

  pilihGambar() async {
    final file = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (file != null) {
      final path = file.path;
      File imageFile = File(path);
      final bytes = await imageFile.readAsBytes();
      print("ini besar file ${bytes.length}");
      if (bytes.length < 2000001) {
        uploadGambar(imageFile);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Besar file gambar maksimal 2MB")));
      }
    } else {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("Belum ada gambar yg dipilih")));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          if (imageUrl != "")
            Column(
              children: [
                Text(
                  "Gambar Jawaban",
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.titleLarge!.copyWith(
                        color: Colors.black,
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                      ),
                ),
                Container(
                  margin: const EdgeInsets.only(top: 7, bottom: 4),
                  height: 180,
                  width: 320,
                  decoration: BoxDecoration(
                    border: Border.all(width: 2),
                  ),
                  child: CachedNetworkImage(
                    filterQuality: FilterQuality.medium,
                    imageUrl: imageUrl,
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
                ),
              ],
            ),
          const SizedBox(height: 16),
          Center(
            child: SizedBox(
              width: 205,
              child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    padding:
                        const EdgeInsets.symmetric(vertical: 8, horizontal: 11),
                  ),
                  onPressed: () async {
                    if (!isLoading) {
                      setState(() {
                        isLoading = true;
                      });
                      pilihGambar();
                      setState(() {
                        isLoading = false;
                      });
                    }
                  },
                  child: (isLoading)
                      ? const CircularProgressIndicator(
                          color: Colors.white,
                        )
                      : Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            const Icon(Icons.image,
                                size: 25, color: Colors.white),
                            Text("Pilih Gambar",
                                style: Theme.of(context)
                                    .textTheme
                                    .titleMedium!
                                    .copyWith(
                                        color: Colors.white, fontSize: 20)),
                          ],
                        )),
            ),
          ),
        ],
      ),
    );
  }
}

// uploadGambar() async {
  //   try {
  //     if (selectedImageBytes != null) {
  //       String namaBaru = Uuid().v4().substring(0, 11);
  //       firebase_storage.UploadTask uploadTask;

  //       firebase_storage.Reference ref = firebase_storage
  //           .FirebaseStorage.instance
  //           .ref()
  //           .child('eksp')
  //           .child('/' + namaBaru);

  //       final metaData =
  //           firebase_storage.SettableMetadata(contentType: 'image/jpeg');

  //       uploadTask = ref.putData(selectedImageBytes!, metaData);

  //       await uploadTask.whenComplete(() => null);
  //       imageUrl = await ref.getDownloadURL();
  //       setState(() {});
  //       print('uploaded image URL : $imageUrl');
  //     }
  //   } catch (e) {
  //     print(e);
  //   }
  // }

  // pilihGambar() async {
  //   final file = await ImagePicker().pickImage(source: ImageSource.gallery);
  //   if (file != null) {
  //     final path = file.path;
  //     print(path);
  //     //ini uint8
  //     final bytes = await File(path).readAsBytes();
  //     //
  //     if (bytes.length > 1000001) {
  //       selectedImageBytes =
  //           await FlutterImageCompress.compressWithList(bytes, quality: 90);
  //     }
  //   } else {
  //     ScaffoldMessenger.of(context)
  //         .showSnackBar(SnackBar(content: Text("Belum ada gambar yg dipilih")));
  //   }
  // }
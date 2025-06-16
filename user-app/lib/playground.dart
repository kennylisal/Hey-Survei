import 'dart:io';
import 'dart:typed_data';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:flutter/material.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:image_picker/image_picker.dart';
import 'package:uuid/uuid.dart';

class Playground extends StatefulWidget {
  const Playground({super.key});

  @override
  State<Playground> createState() => _PlaygroundState();
}

class _PlaygroundState extends State<Playground> {
  XFile? file;
  File? imageFile;
  String imageUrl = "";
  Uint8List? selectedImageBytes;

  pilihGambarFilePicker() async {
    FilePickerResult? fileResult = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowMultiple: false,
      allowedExtensions: ['jpg', 'jpeg', 'png', 'heic', 'svg', 'gif'],
    );

    if (fileResult != null) {
      selectedImageBytes = fileResult.files.first.bytes;
      // print("cek ini ------------" + fileResult.files.first.size.toString());
      if (fileResult.files.first.size > 1000001) {
        selectedImageBytes = await FlutterImageCompress.compressWithList(
            selectedImageBytes!,
            quality: 90);
      }
    } else {
      print("Ekstensi gambar tidak diperbolehkan");
    }
  }

  uploadGambar() async {
    try {
      if (selectedImageBytes != null) {
        String namaBaru = Uuid().v4().substring(0, 11);
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
        imageUrl = await ref.getDownloadURL();
        setState(() {});
        print('uploaded image URL : $imageUrl');
      }
    } catch (e) {
      print(e);
    }
  }

  prosesUploadGamabr() async {
    try {
      await pilihGambarFilePicker();
      await uploadGambar();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text("Proses upload gagal, Mohon pilih ulang gambar")));
    }
  }

  @override
  Widget build(BuildContext context) {
    final controller = TextEditingController();
    return Scaffold(
      body: Container(
        width: double.infinity,
        child: Column(
          children: [
            SizedBox(
              width: double.infinity,
              child: TextField(
                controller: controller,
              ),
            ),
            const SizedBox(height: 20),
            IconButton(
                onPressed: () async {
                  // await pilihGambar();
                  await pilihGambarFilePicker();

                  // //langkah 1------------- pilih gambar dengan imagePicker
                  // ImagePicker imagePicker = ImagePicker();
                  // //Imagesource.galery disini ganti" darimana kau mau ambil itu gambar
                  // file =
                  //     await imagePicker.pickImage(source: ImageSource.gallery);
                  // print('Ini hasil gambar${file?.path}');

                  // if (file == null) {
                  //   return;
                  // } else {
                  //   setState(() {
                  //     imageFile = File(file!.path);
                  //   });
                  // }

                  // //penamaan file
                  // String uniqueFileName =
                  //     DateTime.now().millisecondsSinceEpoch.toString();

                  // //langkah 2 ------ Upload gambar ke firestore

                  // // disini referensi ke firebase
                  // Reference referenceRoot = FirebaseStorage.instance.ref();
                  // Reference referenceDirImages = referenceRoot.child('images');

                  // //Create a reference for the image to be stored -- nanti hasilnya images/<nama file>
                  // Reference referenceImageToUpload =
                  //     referenceDirImages.child("$uniqueFileName.jpg");
                  // try {
                  //   await referenceImageToUpload.putFile(File(file!.path));
                  //   //Success: get the download URL
                  //   imageUrl = await referenceImageToUpload.getDownloadURL();
                  //   print(imageUrl);
                  // } catch (e) {
                  //   print(e);
                  // }
                },
                icon: Icon(Icons.image)),
            const SizedBox(height: 20),
            ElevatedButton(
                onPressed: () async {
                  if (selectedImageBytes != null) uploadGambar();
                },
                child: Text("Submit")),
            (imageFile == null)
                ? SizedBox()
                : Container(
                    width: 150,
                    height: 150,
                    child: Image.file(
                      imageFile!,
                      fit: BoxFit.cover,
                    ),
                  ),
            if (imageUrl != "")
              Container(
                margin: const EdgeInsets.only(top: 12, bottom: 4),
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
                  progressIndicatorBuilder: (context, url, downloadProgress) =>
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
      ),
    );
  }
}

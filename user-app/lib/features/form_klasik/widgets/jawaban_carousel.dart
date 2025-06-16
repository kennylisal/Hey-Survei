import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_controller.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:survei_aplikasi/features/form_klasik/models/data_pertanyaan.dart';
import 'package:survei_aplikasi/features/form_klasik/state/controller_pertanyaan.dart';

class JawabanCarouselZ extends StatefulWidget {
  JawabanCarouselZ({
    super.key,
    required this.dataCarousel,
    required this.controller,
  });
  DataGambarGanda dataCarousel;
  PertanyaanController controller;
  @override
  State<JawabanCarouselZ> createState() => _JawabanCarouselZState();
}

class _JawabanCarouselZState extends State<JawabanCarouselZ> {
  int _current = 0;
  int indexPilihan = -1;
  final CarouselController _controller = CarouselController();
  late List<Widget> imageSliders;
  late List<String> imgList;

  @override
  void initState() {
    imgList = List.generate(widget.dataCarousel.listUrlGambar.length,
        (index) => widget.dataCarousel.listUrlGambar[index].pilihan);
    // imgList = widget.dataCarousel.listUrlGambar;
    imageSliders = imgList
        .map((item) => Container(
              width: 386,
              height: 201,
              decoration: BoxDecoration(border: Border.all(width: 2)),
              margin: const EdgeInsets.all(5.0),
              child: Stack(
                children: <Widget>[
                  CachedNetworkImage(
                    filterQuality: FilterQuality.medium,
                    //item
                    imageUrl: (item == "") ? urlCadangan : item,
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
                  //Image.network(item, fit: BoxFit.cover, width: 1000.0),
                  Positioned(
                    bottom: 4.0,
                    left: 4.0,
                    child: CircleAvatar(
                      backgroundColor: Colors.blue,
                      child: Text(
                        '${imgList.indexOf(item) + 1}',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 18.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ))
        .toList();
    super.initState();
  }

  String urlCadangan =
      "https://firebasestorage.googleapis.com/v0/b/hei-survei-v1.appspot.com/o/eksp%2F065908a0-7e?alt=media&token=7c910ea2-982a-4772-a65a-edb639f94cb9";

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 500,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text("Pilih Satu",
              style: Theme.of(context)
                  .textTheme
                  .titleMedium!
                  .copyWith(fontWeight: FontWeight.bold)),
          CarouselSlider(
            items: imageSliders,
            carouselController: _controller,
            options: CarouselOptions(onPageChanged: (index, reason) {
              setState(() {
                _current = index;
              });
            }),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: imgList.asMap().entries.map((entry) {
              return GestureDetector(
                onTap: () => _controller.animateToPage(entry.key),
                child: Container(
                  width: 12.0,
                  height: 12.0,
                  margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 4.0),
                  decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: (Theme.of(context).brightness == Brightness.dark
                              ? Colors.white
                              : Colors.black)
                          .withOpacity(_current == entry.key ? 0.9 : 0.4)),
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: 8),
          ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
              onPressed: () {
                setState(() {
                  indexPilihan = _current;
                  widget.controller.pilihJawabanCarousel(
                      widget.dataCarousel.listUrlGambar[indexPilihan]);
                });
              },
              child: Text(
                "Pilih Jawaban",
                style: Theme.of(context)
                    .textTheme
                    .titleLarge!
                    .copyWith(fontSize: 16, color: Colors.white),
              )),
          SizedBox(height: 6),
          if (indexPilihan != -1)
            Text("Pilihan : Gambar ${indexPilihan + 1}",
                style: Theme.of(context)
                    .textTheme
                    .titleMedium!
                    .copyWith(fontWeight: FontWeight.bold))
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:hei_survei/features/buat_form/models/template_form.dart';
import 'package:hei_survei/features/surveiku/widget/komponen_kartu_surveiku.dart';

class KartuTemplate extends StatefulWidget {
  KartuTemplate({
    super.key,
    required this.templateForm,
    required this.onTapBuat,
    required this.onTapPreview,
  });
  TemplateForm templateForm;
  Function() onTapPreview;
  Function() onTapBuat;
  @override
  State<KartuTemplate> createState() => _KartuTemplateState();
}

class _KartuTemplateState extends State<KartuTemplate> {
  bool modeDetail = false;
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 380,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            decoration: BoxDecoration(
                color: Color.fromARGB(255, 115, 136, 255),
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(12),
                    topRight: Radius.circular(12))),
            margin: const EdgeInsets.only(left: 18),
            padding: const EdgeInsets.symmetric(horizontal: 9.5, vertical: 6),
            child: Text(
              "Template",
              style: Theme.of(context)
                  .textTheme
                  .displaySmall!
                  .copyWith(fontSize: 19, color: Colors.black),
            ),
          ),
          InkWell(
            onTap: () {
              setState(() {
                modeDetail = !modeDetail;
              });
            },
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 500),
              width: 406,
              margin: const EdgeInsets.only(bottom: 16),
              padding: EdgeInsets.only(
                top: 9,
              ),
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(21),
                border: Border.all(width: 3, color: Colors.black),
                boxShadow: [
                  BoxShadow(
                    color: Colors.transparent,
                    spreadRadius: 6,
                    blurRadius: 3,
                    offset: Offset(0, 6), // changes position of shadow
                  ),
                ],
              ),
              child: Column(
                children: [
                  const SizedBox(height: 2),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Text(
                      widget.templateForm.judul,
                      style: Theme.of(context).textTheme.displaySmall!.copyWith(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                          color: Colors.black),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.category),
                        const SizedBox(width: 5),
                        Text(
                          widget.templateForm.kategori,
                          style: Theme.of(context)
                              .textTheme
                              .displaySmall!
                              .copyWith(
                                fontSize: 17.5,
                                color: Colors.black,
                              ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 3),
                  Divider(color: Colors.grey.shade800, height: 12),
                  Container(
                    height: 125,
                    child: Row(
                      children: [
                        (widget.templateForm.isKlasik)
                            ? const FotoKlasik()
                            : const FotoKartu(),
                        SingleChildScrollView(
                          child: Container(
                            padding: const EdgeInsets.only(right: 0),
                            width: 215,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                SizedBox(height: 4),
                                Text(
                                  widget.templateForm.petunjuk,
                                  style: Theme.of(context)
                                      .textTheme
                                      .displaySmall!
                                      .copyWith(
                                          fontSize: 13,
                                          color: Colors.black,
                                          letterSpacing: 1.25,
                                          height: 1.6),
                                )
                              ],
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                  const SizedBox(height: 6),
                ],
              ),
            ),
          ),
          if (modeDetail)
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  child: ElevatedButton(
                      onPressed: widget.onTapPreview,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blueAccent.shade400,
                        padding: const EdgeInsets.symmetric(
                            vertical: 8, horizontal: 18),
                        side: const BorderSide(width: 1.5, color: Colors.black),
                      ),
                      child: Text(
                        "Preview Form",
                        style: Theme.of(context)
                            .textTheme
                            .displaySmall!
                            .copyWith(fontSize: 17, color: Colors.black),
                      )),
                ),
                const SizedBox(width: 25),
                ElevatedButton(
                    onPressed: widget.onTapBuat,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromARGB(255, 0, 228, 118),
                      padding: const EdgeInsets.symmetric(
                          vertical: 8, horizontal: 18),
                      side: const BorderSide(width: 1.5, color: Colors.black),
                    ),
                    child: Text(
                      "Gunakan Template",
                      style: Theme.of(context)
                          .textTheme
                          .displaySmall!
                          .copyWith(fontSize: 17, color: Colors.black),
                    )),
              ],
            )
        ],
      ),
    );
  }
}

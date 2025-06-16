import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:hei_survei/features/form/constant.dart';

class KolomTipeSoalDrag extends StatefulWidget {
  const KolomTipeSoalDrag({super.key});

  @override
  State<KolomTipeSoalDrag> createState() => _KolomTipeSoalDragState();
}

class _KolomTipeSoalDragState extends State<KolomTipeSoalDrag> {
  bool isExpanded = false;
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Pilihan Tipe Soal",
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
          Container(
            decoration: BoxDecoration(border: Border.all(width: 1.5)),
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            width: 240,
            height: 400,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  for (var item in listMode)
                    ContainerDragTipeSoal(
                      tipesoal: item.tipeSoal,
                      icon: item.icon,
                    )
                ],
              ),
            ),
          ),
      ],
    );
  }
}

class ContainerDragTipeSoal extends StatelessWidget {
  ContainerDragTipeSoal({
    super.key,
    required this.tipesoal,
    required this.icon,
  });
  Tipesoal tipesoal;
  Icon icon;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
      width: 208,
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
          border: Border.all(width: 1.5),
          borderRadius: BorderRadius.circular(16),
          color: Colors.white),
      child: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              tipesoal.value,
              style: Theme.of(context)
                  .textTheme
                  .titleMedium!
                  .copyWith(fontWeight: FontWeight.bold, fontSize: 17),
            ),
            DottedBorder(
              padding: EdgeInsets.all(3),
              borderType: BorderType.RRect,
              strokeWidth: 2,
              child: Draggable<Tipesoal>(
                data: tipesoal,
                child: Container(
                  height: 35,
                  width: 35,
                  color: Colors.lightBlue.shade100,
                  child: icon,
                ),
                feedback: Container(
                  height: 35,
                  width: 35,
                  color: Colors.lightBlue.shade100,
                  child: icon,
                ),
                childWhenDragging: Container(
                  height: 35,
                  width: 35,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

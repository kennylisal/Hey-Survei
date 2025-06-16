import 'package:flutter/material.dart';
import 'package:hei_survei/utils/hover_builder.dart';
import 'package:badges/badges.dart' as badges;

class ItemNavigasiAtas extends StatelessWidget {
  ItemNavigasiAtas({
    super.key,
    required this.onTap,
    required this.text,
  });
  Function() onTap;
  String text;
  @override
  Widget build(BuildContext context) {
    return HoverBuilder(
      builder: (isHovered) => TextButton(
        onPressed: onTap,
        child: Text(
          text,
          style: Theme.of(context).textTheme.displayLarge!.copyWith(
                color: (isHovered) ? Colors.lightBlue.shade200 : Colors.white,
                fontSize: 20,
              ),
        ),
      ),
    );
  }
}

class ItemNavigasiAtasBadges extends StatelessWidget {
  ItemNavigasiAtasBadges(
      {super.key,
      required this.onTap,
      required this.text,
      required this.kontenBadge,
      required this.badgeColor,
      required this.showBadge,
      required this.padding});
  Function() onTap;
  String text;
  String kontenBadge;
  Color badgeColor;
  bool showBadge;
  double padding;
  @override
  Widget build(BuildContext context) {
    print(showBadge);
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        HoverBuilder(
          builder: (isHovered) => TextButton(
            onPressed: onTap,
            child: Text(
              text,
              style: Theme.of(context).textTheme.displayLarge!.copyWith(
                    color:
                        (isHovered) ? Colors.lightBlue.shade200 : Colors.white,
                    fontSize: 20,
                  ),
            ),
          ),
        ),
        if (showBadge)
          badges.Badge(
            badgeAnimation: const badges.BadgeAnimation.slide(
              toAnimate: true,
              animationDuration: Duration(seconds: 2),
            ),
            badgeStyle: badges.BadgeStyle(
                padding: EdgeInsets.all(padding), badgeColor: badgeColor),
            badgeContent: Text(kontenBadge,
                style: Theme.of(context)
                    .textTheme
                    .displayLarge!
                    .copyWith(color: Colors.white, fontSize: 20)),
          ),
      ],
    );
  }
}

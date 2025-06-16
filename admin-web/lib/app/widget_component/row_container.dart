import 'package:flutter/material.dart';

class RowContainer extends StatelessWidget {
  const RowContainer({
    super.key,
    required this.text,
    required this.child,
  });

  final String text;
  final Widget child;
  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          flex: 3,
          child: Container(
              width: 150,
              padding: const EdgeInsets.only(top: 8),
              child: Text(
                text,
                style: Theme.of(context)
                    .textTheme
                    .labelSmall!
                    .copyWith(fontSize: 17),
              )),
        ),
        Expanded(
          child: SizedBox(),
        ),
        Expanded(
          flex: 11,
          child: child,
        ),
      ],
    );
  }
}

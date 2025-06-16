import 'package:flutter/material.dart';

class ContainerRespondenUser extends StatelessWidget {
  ContainerRespondenUser({
    super.key,
    required this.text,
    required this.onPressed,
  });
  String text;
  Function() onPressed;
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(vertical: 6),
      decoration: BoxDecoration(
          color: Colors.grey.shade100,
          border: Border.all(width: 1),
          borderRadius: BorderRadius.circular(14)),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(width: 6),
          CircleAvatar(
            backgroundColor: Colors.blue,
            child: Icon(Icons.person),
          ),
          Spacer(),
          Text(
            text,
            style:
                Theme.of(context).textTheme.titleMedium!.copyWith(fontSize: 15),
            overflow: TextOverflow.ellipsis,
          ),
          Spacer(),
          IconButton(
              onPressed: onPressed,
              icon: Icon(
                Icons.search,
                color: Colors.blue,
              ))
        ],
      ),
    );
  }
}

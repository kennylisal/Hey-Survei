import 'package:flutter/material.dart';

class ContainerPilihanResponden extends StatelessWidget {
  ContainerPilihanResponden({
    super.key,
    required this.email,
    required this.onPressed,
  });
  String email;
  Function() onPressed;
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 9),
      decoration: BoxDecoration(
          color: Colors.grey.shade100,
          border: Border.all(width: 1),
          borderRadius: BorderRadius.circular(14)),
      margin: const EdgeInsets.only(bottom: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            email,
            style:
                Theme.of(context).textTheme.titleMedium!.copyWith(fontSize: 15),
            overflow: TextOverflow.ellipsis,
          ),
          IconButton.filled(
              onPressed: onPressed,
              icon: const Icon(Icons.keyboard_arrow_right))
        ],
      ),
    );
  }
}

class ContainerPilihan extends StatelessWidget {
  ContainerPilihan({super.key, required this.email});
  String email;
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 16),
          child: Text(
            //"ID FAQ",
            "Responded Pilihan",
            style: Theme.of(context).textTheme.displayLarge!.copyWith(
                  color: Colors.black,
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                ),
          ),
        ),
        Container(
          width: double.infinity,
          margin: const EdgeInsets.symmetric(vertical: 3),
          padding: const EdgeInsets.symmetric(
            vertical: 10,
            horizontal: 18,
          ),
          decoration: BoxDecoration(
              color: Color.fromARGB(255, 250, 250, 250),
              border: Border.all(
                width: 1,
                color: Colors.grey,
              ),
              borderRadius: BorderRadius.circular(10)),
          child: Text(
            email,
            style:
                Theme.of(context).textTheme.titleMedium!.copyWith(fontSize: 16),
            overflow: TextOverflow.ellipsis,
          ),
        )
      ],
    );
  }
}

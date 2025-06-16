import 'package:flutter/material.dart';

class JudulFormKartuKotak extends StatefulWidget {
  JudulFormKartuKotak({
    super.key,
    required this.judul,
    required this.petunjuk,
  });
  String judul;
  String petunjuk;
  @override
  State<JudulFormKartuKotak> createState() => _JudulFormKartuKotakState();
}

class _JudulFormKartuKotakState extends State<JudulFormKartuKotak> {
  bool isDetail = true;
  Widget generateBawah() {
    if (isDetail) {
      return Column(
        children: [
          const SizedBox(height: 10),
          Align(
            alignment: Alignment.centerLeft,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Petunjuk ",
                  style: Theme.of(context)
                      .textTheme
                      .headlineMedium!
                      .copyWith(fontWeight: FontWeight.bold, fontSize: 18),
                ),
                const SizedBox(height: 4),
                Text(
                  widget.petunjuk,
                  style: Theme.of(context)
                      .textTheme
                      .displayMedium!
                      .copyWith(fontSize: 16, overflow: TextOverflow.ellipsis),
                  maxLines: 6,
                  textAlign: TextAlign.start,
                ),
              ],
            ),
          ),
          const SizedBox(height: 4),
          Align(
            alignment: Alignment.centerRight,
            child: CircleAvatar(
              radius: 15,
              backgroundColor: Colors.blue.shade500,
              child: IconButton(
                icon: Icon(
                  Icons.arrow_upward,
                  color: Colors.white,
                  size: 15,
                ),
                onPressed: () {
                  setState(() {
                    isDetail = !isDetail;
                  });
                },
              ),
            ),
          ),
        ],
      );
    } else {
      return Column(
        children: [
          const SizedBox(height: 8),
          Align(
            alignment: Alignment.centerRight,
            child: CircleAvatar(
              radius: 15,
              backgroundColor: Colors.blue.shade500,
              child: IconButton(
                icon: Icon(
                  Icons.arrow_downward,
                  color: Colors.white,
                  size: 15,
                ),
                onPressed: () {
                  setState(() {
                    isDetail = !isDetail;
                  });
                },
              ),
            ),
          ),
        ],
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(vertical: 13.5, horizontal: 12.5),
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 14),
      decoration: BoxDecoration(
          border: Border(
            top: BorderSide(
              color: Colors.lightBlueAccent.shade700,
              width: 10,
            ),
          ),
          color: Colors.white),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Center(
            child: Text(
              widget.judul,
              style: Theme.of(context).textTheme.displayMedium!.copyWith(
                    fontWeight: FontWeight.bold,
                    fontSize: 27,
                    overflow: TextOverflow.ellipsis,
                  ),
              textAlign: TextAlign.center,
              maxLines: 3,
            ),
          ),
          generateBawah(),
        ],
      ),
    );
  }
}

class JudulFormKartuKotakFalse extends StatefulWidget {
  JudulFormKartuKotakFalse({
    super.key,
    required this.judul,
    required this.petunjuk,
  });
  String judul;
  String petunjuk;
  @override
  State<JudulFormKartuKotakFalse> createState() =>
      _JudulFormKartuKotakFalseState();
}

class _JudulFormKartuKotakFalseState extends State<JudulFormKartuKotakFalse> {
  bool isDetail = false;
  Widget generateBawah() {
    if (isDetail) {
      return Column(
        children: [
          const SizedBox(height: 10.5),
          Align(
            alignment: Alignment.centerLeft,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Petunjuk ",
                  style: Theme.of(context)
                      .textTheme
                      .headlineMedium!
                      .copyWith(fontWeight: FontWeight.bold, fontSize: 18),
                ),
                const SizedBox(height: 4),
                Text(
                  widget.petunjuk,
                  style: Theme.of(context)
                      .textTheme
                      .displayMedium!
                      .copyWith(fontSize: 16, overflow: TextOverflow.ellipsis),
                  maxLines: 6,
                  textAlign: TextAlign.start,
                ),
              ],
            ),
          ),
          const SizedBox(height: 5),
          Align(
            alignment: Alignment.centerRight,
            child: CircleAvatar(
              radius: 15,
              backgroundColor: Colors.blue.shade500,
              child: IconButton(
                icon: Icon(
                  Icons.arrow_upward,
                  color: Colors.white,
                  size: 15,
                ),
                onPressed: () {
                  setState(() {
                    isDetail = !isDetail;
                  });
                },
              ),
            ),
          ),
        ],
      );
    } else {
      return Column(
        children: [
          const SizedBox(height: 10.5),
          Align(
            alignment: Alignment.centerRight,
            child: CircleAvatar(
              radius: 15,
              backgroundColor: Colors.blue.shade500,
              child: IconButton(
                icon: Icon(
                  Icons.arrow_downward,
                  color: Colors.white,
                  size: 15,
                ),
                onPressed: () {
                  setState(() {
                    isDetail = !isDetail;
                  });
                },
              ),
            ),
          ),
        ],
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(vertical: 13.5, horizontal: 12.5),
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 14),
      decoration: BoxDecoration(
          border: Border(
            top: BorderSide(
              color: Colors.lightBlueAccent.shade700,
              width: 10,
            ),
          ),
          color: Colors.white),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Center(
            child: Text(
              widget.judul,
              style: Theme.of(context).textTheme.displayMedium!.copyWith(
                    fontWeight: FontWeight.bold,
                    fontSize: 27.5,
                    overflow: TextOverflow.ellipsis,
                  ),
              textAlign: TextAlign.center,
              maxLines: 3,
            ),
          ),
          generateBawah(),
        ],
      ),
    );
  }
}

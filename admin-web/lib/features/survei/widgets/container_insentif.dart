import 'package:flutter/material.dart';

class KotakInsentif extends StatelessWidget {
  KotakInsentif({
    super.key,
    required this.harga,
    required this.kurang,
    required this.tambah,
  });
  String harga;
  Function() kurang;
  Function() tambah;
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Container(
          height: 130,
          width: 300,
          decoration: BoxDecoration(
              color: Color.fromARGB(255, 250, 250, 250),
              border: Border.all(
                color: Colors.black,
                width: 2,
              ),
              borderRadius: BorderRadius.circular(20)),
          child: Row(
            children: [
              Expanded(
                  flex: 4,
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 4, vertical: 18),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(
                          "Insentif Per Partisipan",
                          style: Theme.of(context)
                              .textTheme
                              .displayLarge!
                              .copyWith(
                                color: Colors.black,
                                fontSize: 20,
                              ),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          harga,
                          style: Theme.of(context)
                              .textTheme
                              .displayLarge!
                              .copyWith(
                                  color: Colors.black,
                                  fontSize: 38,
                                  fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  )),
              Expanded(
                  flex: 1,
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        IconButton.filled(
                          onPressed: tambah,
                          icon: Icon(Icons.add),
                        ),
                        IconButton.filled(
                          onPressed: kurang,
                          icon: Icon(Icons.remove),
                        )
                      ],
                    ),
                  )),
            ],
          ),
        ),
        const SizedBox(height: 4),
        Text("* Kelipatan insentif Rp.100,00"),
        Text("* Minimal Insentif adalah Rp.500,00"),
        Text(""),
      ]),
    );
  }
}

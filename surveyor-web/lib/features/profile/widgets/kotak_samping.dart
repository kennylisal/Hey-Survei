import 'package:flutter/material.dart';

class KotakSamping extends StatelessWidget {
  KotakSamping({
    super.key,
    required this.marginKiri,
    required this.onPressedTampilan,
    required this.onPressedPerbaruan,
    required this.onPressedKeluar,
  });
  double marginKiri;
  Function() onPressedTampilan;
  Function() onPressedPerbaruan;
  Function() onPressedKeluar;

  // List<Transaksi> listTrans;
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.blueGrey.shade100,
        borderRadius: BorderRadius.circular(20),
      ),
      margin: EdgeInsets.only(left: marginKiri),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            "Pilihan Aksi",
            style: Theme.of(context).textTheme.displayLarge!.copyWith(
                  color: Colors.black,
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: 10),
          Container(
              width: 280,
              height: 60,
              margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
              child: ElevatedButton(
                  onPressed: onPressedTampilan,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: Text(
                    "Mode Tampilan",
                    style: Theme.of(context).textTheme.displayLarge!.copyWith(
                          color: Colors.white,
                          fontSize: 23,
                          fontWeight: FontWeight.bold,
                        ),
                  ))),
          Container(
              width: 280,
              height: 60,
              margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
              child: ElevatedButton(
                  onPressed: onPressedPerbaruan,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue.shade900,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: Text(
                    "Mode perbaruan",
                    style: Theme.of(context).textTheme.displayLarge!.copyWith(
                          color: Colors.white,
                          fontSize: 23,
                          fontWeight: FontWeight.bold,
                        ),
                  ))),
          Container(
            width: 300,
            height: 10,
            color: Colors.black,
          ),
          Container(
              width: 280,
              height: 60,
              margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
              child: ElevatedButton(
                  onPressed: onPressedKeluar,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.redAccent.shade400,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: Text(
                    "Keluarkan Akun",
                    style: Theme.of(context).textTheme.displayLarge!.copyWith(
                          color: Colors.white,
                          fontSize: 23,
                          fontWeight: FontWeight.bold,
                        ),
                  ))),
        ],
      ),
    );
  }
}

class ButtonProfile extends StatelessWidget {
  ButtonProfile({
    super.key,
    required this.text,
    required this.onPressed,
    required this.isLoading,
  });
  Function()? onPressed;
  String text;
  bool isLoading;
  @override
  Widget build(BuildContext context) {
    return SizedBox(
        height: 48,
        child: ElevatedButton(
            onPressed: onPressed,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            child: (isLoading)
                ? CircularProgressIndicator(color: Colors.white)
                : Text(
                    text,
                    style: Theme.of(context).textTheme.displayLarge!.copyWith(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                  )));
  }
}

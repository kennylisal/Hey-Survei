import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class LoadingBiasa extends StatelessWidget {
  LoadingBiasa({super.key, this.textLoading = ""});
  String textLoading;
  @override
  Widget build(BuildContext context) {
    // final spinkit = SpinKitWave(color: Colors.blue,);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const SizedBox(height: 100),
        LoadingAnimationWidget.staggeredDotsWave(color: Colors.blue, size: 205),
        const SizedBox(height: 4),
        Text(
          "Loading",
          style: Theme.of(context).textTheme.displayMedium!.copyWith(
              fontSize: 42, color: Colors.blue, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 15),
        Text(
          textLoading,
          style: Theme.of(context).textTheme.displayMedium!.copyWith(
              fontSize: 16, color: Colors.black, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class LoadingTengah extends StatelessWidget {
  const LoadingTengah({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 820,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SpinKitFoldingCube(
            size: 100,
            color: Colors.blueAccent.shade400,
          ),
          const SizedBox(height: 40),
          Text("Loading",
              style: Theme.of(context)
                  .textTheme
                  .displayLarge!
                  .copyWith(color: Colors.blue, fontSize: 42))
        ],
      ),
    );
  }
}

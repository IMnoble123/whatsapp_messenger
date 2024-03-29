
import 'package:flutter/material.dart';

class LodingScreen extends StatelessWidget {
  const LodingScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        alignment: Alignment.center,
        margin: const EdgeInsets.only(top: 20),
        child: const CircularProgressIndicator(
          strokeWidth: 2.0,
          backgroundColor: Colors.white,
    ),
   );
  }
}

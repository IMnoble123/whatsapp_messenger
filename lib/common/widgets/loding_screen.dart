
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';

class LodingScreen extends StatelessWidget {
  const LodingScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        alignment: Alignment.bottomCenter,
        margin: const EdgeInsets.only(top: 20),
        child: const CircularProgressIndicator(
          backgroundColor: Colors.white,
    ),
   );
  }
}

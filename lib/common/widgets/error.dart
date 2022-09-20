import 'package:flutter/material.dart';

class Errorpage extends StatelessWidget {
  final String error;
  const Errorpage({Key? key, required this.error}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(error,
      style: const TextStyle(
        color: Colors.white
        ),
      ),
    );
  }
}

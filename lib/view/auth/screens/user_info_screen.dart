import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:whatsappmessenger/common/utls/utls.dart';

class Userinformation extends StatefulWidget {
  static const String routeName = '/user-information';
  const Userinformation({Key? key}) : super(key: key);

  @override
  State<Userinformation> createState() => _UserinformationState();
}

class _UserinformationState extends State<Userinformation> {
  final TextEditingController nameController = TextEditingController();
  File? image;

  @override
  void dispose() {
    nameController.dispose();
    super.dispose();
  }

  void selectImage() async {
    image = await pickImageFromGallery(context);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      body: SafeArea(
          child: Column(
        children: [
          Stack(
            children: [
              image == null 
           ? const CircleAvatar(
              backgroundImage: NetworkImage(
                  'https://www.google.com/imgres?imgurl=https%3A%2F%2Fi.pinimg.com%2Foriginals%2F2e%2F1e%2F00%2F2e1e004c0c7042c1777c2f9b6675a571.jpg&imgrefurl=https%3A%2F%2Fin.pinterest.com%2Fpin%2F843369467709396809%2F&tbnid=5aKIUVZd2r_gEM&vet=12ahUKEwjq5d6gx__4AhUjgmMGHU4nAcgQMygNegUIARDYAQ..i&docid=nBf4oNY58uJBbM&w=1200&h=1208&q=png%20image%20of%20whatsapp&ved=2ahUKEwjq5d6gx__4AhUjgmMGHU4nAcgQMygNegUIARDYAQ'),
              radius: 55,
            ):
            CircleAvatar(
              backgroundImage: FileImage(image!),
              radius: 55,
            ),
            Positioned(
              left: 80,
              bottom: -10,
              child: IconButton(
                  onPressed: selectImage,
                  icon: const Icon(Icons.add_a_photo_outlined)),
            )
          ]),
          Row(
            children: [
              Container(
                width: size.width * 0.85,
                padding: const EdgeInsets.all(20),
                child: TextField(
                  controller: nameController,
                  style: const TextStyle(color: Colors.white),
                  decoration: const InputDecoration(
                    labelStyle: TextStyle(color: Colors.grey),
                    hintText: 'Enter your Name',
                  ),
                ),
              ),
              IconButton(
                  onPressed: () {},
                  icon: const Icon(Icons.done, color: Colors.white)),
            ],
          )
        ],
      )),
    );
  }
}

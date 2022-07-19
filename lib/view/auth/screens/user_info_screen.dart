import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:whatsappmessenger/common/utls/utls.dart';
import 'package:whatsappmessenger/view/auth/controller/auth_controller.dart';

class Userinformation extends ConsumerStatefulWidget {
  static const String routeName = '/user-information';
  const Userinformation({Key? key}) : super(key: key);

  @override
  ConsumerState<Userinformation> createState() => _UserinformationState();
}

class _UserinformationState extends ConsumerState<Userinformation> {
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

  void storeUserData() {
    String name = nameController.text.trim();
    if (name.isNotEmpty) {
      ref
          .read(authControllerProvider)
          .saveUserDataToFirebase(context, name, image);
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        leading: IconButton(onPressed: (){},
         icon: const Icon(Icons.arrow_back_ios,
         color: Colors.white
          ),
         ),
      ),
      body: SafeArea(
          child: Column(
        children: [
         const  SizedBox(height: 30),
          Stack(
            children: [
            image == null
                ? const CircleAvatar(
                    backgroundImage:AssetImage('assets/defaltimg.png'),
                    radius: 50,
                  )
                : CircleAvatar(
                    backgroundImage: FileImage(image!),
                    radius: 50,
                  ),
            Positioned(
              left: 80,
              bottom: -10,
              child: IconButton(
                  onPressed: selectImage,
                  icon: const Icon(Icons.add_a_photo_outlined,
                  color: Colors.green
                  )
                ),
            )
          ]),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: size.width * 0.85,
                padding: const EdgeInsets.all(20),
                child:TextField(
                      style: const TextStyle(color: Colors.white),
                      controller:nameController,
                      decoration: const InputDecoration(
                        labelStyle: TextStyle(color: Colors.white38),
                        labelText: 'Name',
                        enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.grey)),
                        // focusedBorder: OutlineInputBorder(
                        //     borderSide: BorderSide(color: Colors.grey)),
                      ),
                    ),
              ),
              IconButton(
                  onPressed: storeUserData,
                  icon: const Icon(Icons.done,
                   color: Colors.white,size: 18
                   )
                  ),
            ],
          )
        ],
      )),
    );
  }
}

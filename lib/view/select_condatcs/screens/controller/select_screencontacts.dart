import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:whatsappmessenger/common/widgets/error.dart';
import 'package:whatsappmessenger/common/widgets/loding_screen.dart';
import 'package:whatsappmessenger/view/select_condatcs/screens/controller/select_contact_controller.dart';

class ContactScreen extends ConsumerWidget {
  static const String routeName = '/contact-screen';
  const ContactScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: const Color.fromARGB(255, 52, 51, 51),
        leading: IconButton(
          onPressed: () {},
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
        ),
        title: const Text(
          'Select contact',
          style: TextStyle(color: Colors.white),
        ),
        actions: [
          IconButton(
              onPressed: () {},
              icon: const Icon(
                Icons.search,
                color: Colors.white,
              )),
          IconButton(
              onPressed: () {},
              icon: const Icon(
                Icons.more_vert,
                color: Colors.white,
              ))
        ],
      ),
      body: ref.watch(getContactsProvider).when(
          data: (contactList) => ListView.builder(
              itemCount: contactList.length,
              itemBuilder: (context, index) {
                final contact = contactList[index];
                return ListTile(
                  title:Text(contact.displayName) ,
                  leading:contact.photo == null ? null :CircleAvatar(
                    backgroundColor: Colors.blueAccent,
                    backgroundImage: MemoryImage(contact.photo!),
                    radius: 30,
                  )
                );
              }),
          error: (err, trace) => Errorpage(error: err.toString()),
          loading: () => const LodingScreen()),
    );
  }
}

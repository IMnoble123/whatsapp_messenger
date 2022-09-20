import 'package:flutter/material.dart';
import 'package:flutter_contacts/contact.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:whatsappmessenger/common/widgets/error.dart';
import 'package:whatsappmessenger/common/widgets/loding_screen.dart';
import 'package:whatsappmessenger/view/chat/widgets/Bottom_chat_screen.dart';
import 'package:whatsappmessenger/view/chat/chat_contact.dart';
import 'package:whatsappmessenger/view/chat/mobile_chat_screen.dart';
import 'package:whatsappmessenger/view/select_condatcs/screens/controller/select_contact_controller.dart';

class ContactScreen extends ConsumerWidget {
  static const String routeName = '/contact-screen';
  const ContactScreen({Key? key}) : super(key: key);

  void selectContact(
      WidgetRef ref, Contact selectedContact, BuildContext context) {
    //here we use read not watch beause its an one time called function
    ref
        .read(selectContactControllerProvider)
        .selectContact(selectedContact, context);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        // backgroundColor: const Color.fromARGB(255, 8, 115, 63),
        backgroundColor: Colors.deepPurple[400],
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
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
          data: (contactList) => StreamBuilder<List<ChatContact>>(
              stream: ref.watch(chatControllerProvider).chatCondacts(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const LodingScreen();
                }
                return ListView.builder(
                    shrinkWrap: true,
                    itemCount: snapshot.data!.length,
                    itemBuilder: (context, index) {
                      // final contact = contactList[index];
                      var chatCondactData = snapshot.data![index];
                      return Column(
                        children: [
                          InkWell(
                            // onTap: (() => selectContact(ref, contact, context)),
                            onTap: () {
                              Navigator.pushNamed(
                                context,
                                MobileChatScreen.routeName,
                                arguments: {
                                  'name':chatCondactData.name,
                                   'uid': chatCondactData.contactId,
                                }
                              );
                            },
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: ListTile(
                                title: Text(
                                  chatCondactData.name,
                                  style: const TextStyle(
                                      fontWeight: FontWeight.w500),
                                ),
                                subtitle: Padding(
                                  padding: const EdgeInsets.only(top: 6.0),
                                  child: Text(
                                    chatCondactData.lastMessage,
                                    style: const TextStyle(fontSize: 15),
                                  ),
                                ),
                                leading: CircleAvatar(
                                  backgroundColor: Colors.blueAccent,
                                  backgroundImage:
                                      NetworkImage(chatCondactData.profilePic),
                                  radius: 30,
                                ),
                                trailing: Text(
                                  DateFormat.Hm()
                                      .format(chatCondactData.timeSent),
                                  style: const TextStyle(
                                      color: Colors.grey, fontSize: 13),
                                ),
                              ),
                            ),
                          ),
                        ],
                      );
                    });
              }),
          error: (err, trace) => Errorpage(error: err.toString()),
          loading: () => const LodingScreen()),
    );
  }
}

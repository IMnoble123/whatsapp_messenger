import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:whatsappmessenger/common/utls/utls.dart';
import 'package:whatsappmessenger/models/user_model.dart';
import 'package:whatsappmessenger/view/chat/mobile_chat_screen.dart';

final selectContactsRepositoryProvider = Provider(
    ((ref) => SelectContactRepository(firestore: FirebaseFirestore.instance)));

class SelectContactRepository {
  final FirebaseFirestore firestore;

  SelectContactRepository({required this.firestore});
// never leave the getcontact dynamic so,
  Future<List<Contact>> getContacts() async {
    List<Contact> contacts = [];
    try {
      if (await FlutterContacts.requestPermission()) {
        contacts = await FlutterContacts.getContacts(withProperties: true);
      }
    } catch (e) {
      debugPrint(e.toString());
    }
    return contacts;
  }

//valuvating the phone number
  void selectContacts(Contact selectedContact, BuildContext context) async {
    try {
      var userCollection = await firestore.collection('users').get();
      bool isFound = false;

      for (var document in userCollection.docs) {
        var userData = UserModel.fromMap(document.data());
        // print(selectedContact.phones[0].number);
        String selectedPhoneNumber =
            selectedContact.phones[0].number.replaceAll(' ', '');
        if (selectedPhoneNumber == userData.phoneNumber) {
          isFound = true;
          //here Naviation
          // ignore: use_build_context_synchronously
          Navigator.pushNamed(context, MobileChatScreen.routeName,arguments:{
            'name':userData.name,
            'uid':userData.uid

          } );
        }
        if (!isFound) {
          showsnackbr(context: context, content: 'this number Does not exist');
        }
      }
    } catch (e) {
      showsnackbr(context: context, content: (e).toString());
    }
  }
}

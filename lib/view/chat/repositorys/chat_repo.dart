import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import 'package:whatsappmessenger/common/enom/message_enam.dart';
import 'package:whatsappmessenger/common/utls/utls.dart';
import 'package:whatsappmessenger/models/message.dart';
import 'package:whatsappmessenger/models/user_model.dart';
import 'package:whatsappmessenger/view/chat/chat_contact.dart';

final chatRepositoryProvider = Provider(
  (ref) => ChatRepository(
      firestore: FirebaseFirestore.instance, auth: FirebaseAuth.instance),
);

class ChatRepository {
  final FirebaseFirestore firestore;
  final FirebaseAuth auth;

  ChatRepository({required this.firestore, required this.auth});

  void _saveDataToContactSubcollection(
    UserModel senderUserData,
    UserModel recieverUserData,
    String text,
    DateTime timeSent,
    String recieverUserId,
  ) async {
    var recieverChatContact = ChatContact(
        name: senderUserData.name,
        profilePic: senderUserData.profilePic,
        contactId: senderUserData.uid,
        timeSent: timeSent,
        lastMessage: text);
    await firestore
        .collection('users')
        .doc(recieverUserId)
        .collection('chats')
        .doc(auth.currentUser!.uid)
        .set(recieverChatContact.toMap());

    var senderChatContact = ChatContact(
        name: recieverUserData.name,
        profilePic: recieverUserData.profilePic,
        contactId: recieverUserData.uid,
        timeSent: timeSent,
        lastMessage: text);
    await firestore
        .collection('users')
        .doc(auth.currentUser!.uid)
        .collection('chats')
        .doc(recieverUserId)
        .set(senderChatContact.toMap());
  }

  var messageId = const Uuid().v1();
  //2nd way
  void _saveMessageToMessageSubcollection({
    required String recieverUserId,
    required String text,
    required DateTime timesent,
    required String messageId,
    required String username,
    required String recieverUsername,
    required MessageEnum messageType,
  }) async {
    final message = Message(
      senderId: auth.currentUser!.uid,
      recieverId: recieverUserId,
      text: text,
      type: messageType,
      timeSent: timesent,
      messageId: messageId,
      isSeen: false,
    );
    await firestore
        .collection('users')
        .doc(auth.currentUser!.uid)
        .collection('chats')
        .doc(recieverUserId)
        .collection('messages')
        .doc(messageId)
        .set(message.toMap());

    await firestore
        .collection('users')
        .doc(recieverUserId)
        .collection('chats')
        .doc(auth.currentUser!.uid)
        .collection('messages')
        .doc(messageId)
        .set(message.toMap());
  }

  void sendTextMessage({
    required BuildContext context,
    required String text,
    required String recieverUserId,
    required UserModel senderUser,
  }) async {
    try {
      var timeSent = DateTime.now();
      UserModel recieverUserData;
      var userDataMap =
          await firestore.collection('users').doc(recieverUserId).get();
      //we recived the data then we need to convert it into map
      recieverUserData = UserModel.fromMap(userDataMap.data()!);
      // saving the data to 2 collections
      _saveDataToContactSubcollection(
        //positional arguments
        senderUser,
        recieverUserData,
        text,
        timeSent,
        recieverUserId,
      );
      _saveMessageToMessageSubcollection(
        recieverUserId: recieverUserId,
        messageType: MessageEnum.text,
        text: text,
        timesent: timeSent,
        messageId: messageId,
        recieverUsername: recieverUserData.name,
        username: senderUser.name,
      );
    } catch (e) {
      showsnackbr(context: context, content: (e).toString());
    }
  }
}

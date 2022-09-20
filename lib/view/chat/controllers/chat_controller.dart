import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:whatsappmessenger/common/enom/message_enam.dart';
import 'package:whatsappmessenger/models/message.dart';
import 'package:whatsappmessenger/view/auth/controller/auth_controller.dart';
import 'package:whatsappmessenger/view/chat/chat_contact.dart';
import 'package:whatsappmessenger/view/chat/repositorys/chat_repo.dart';
import '../../../common/providers/message_replay_provider.dart';

class ChatController {
  final ChatRepository chatRepository;
  final ProviderRef ref;

  ChatController({required this.chatRepository, required this.ref});

  Stream<List<ChatContact>> chatCondacts() {
    return chatRepository.getChatContacts();
  }

  Stream<List<Message>> chatStream(String recieverUserId) {
    return chatRepository.getChatStream(recieverUserId);
  }

  void sendTextMessage(
    BuildContext context,
    String text,
    String recieverUserId,
    bool isGroupChat,
  ) {
    final messageReply = ref.read(messageReplayProvider);
    ref
        .read(userDataAuthProvider)
        .whenData((value) => chatRepository.sendTextMessage(
              context: context,
              text: text,
              recieverUserId: recieverUserId,
              senderUser: value!,
              messageReply: messageReply,
              isGroupChat: isGroupChat,
            ));
    ref.read(messageReplayProvider.state).update((state) => null);
    // chatRepository.sendTextMessage(context: context, text: text, recieverUserId: recieverUserId, senderUser: senderUser)
  }

  void sendFileMessage(BuildContext context, File file, String recieverUserId,
      MessageEnum messageEnum, bool isroupChat) {
    final messageReply = ref.read(messageReplayProvider);
    ref
        .read(userDataAuthProvider)
        .whenData((value) => chatRepository.sendFileMessage(
              context: context,
              file: file,
              recieverUserId: recieverUserId,
              senderUserData: value!,
              ref: ref,
              messageEnum: messageEnum,
              messageReply: messageReply,
              isGroupChat: isroupChat,
            ));
    ref.read(messageReplayProvider.state).update((state) => null);
  }

  void sendGIF(BuildContext context, String gifUrl, String recieverUserId,
      bool isGroupChat) {
    final messageReply = ref.read(messageReplayProvider);
    int gifUrlPartIndex = gifUrl.lastIndexOf('-') + 1;
    String gifUrlPart = gifUrl.substring(gifUrlPartIndex);
    String newgifUrl = 'https://i.giphy.com/media/$gifUrlPart/200.gif';
    ref
        .read(userDataAuthProvider)
        .whenData((value) => chatRepository.sendGIFMessage(
              context: context,
              gifUrl: newgifUrl,
              recieverUserId: recieverUserId,
              senderUser: value!,
              messageReply: messageReply,
              isGroupChat: isGroupChat,
            ));
  }

  void setChatMessageSceen(
    BuildContext context,
    String recieverUserId,
    String messageId,
  ) {
    chatRepository.setChatMessageSeen(
      context,
      recieverUserId,
      messageId,
    );
  }
}

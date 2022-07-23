import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:whatsappmessenger/view/auth/controller/auth_controller.dart';
import 'package:whatsappmessenger/view/chat/repositorys/chat_repo.dart';

class ChatController {
  final ChatRepository chatRepository;
  final ProviderRef ref;

  ChatController({required this.chatRepository, required this.ref});

  void sendTextMessage(
    BuildContext context,
    String text,
    String recieverUserId,
  ) {
    ref.read(userDataAuthProvider).whenData(
          (value) => chatRepository.sendTextMessage(
              context: context,
              text: text,
              recieverUserId: recieverUserId,
              senderUser: value!,
            ));
    // chatRepository.sendTextMessage(context: context, text: text, recieverUserId: recieverUserId, senderUser: senderUser)
  }
}

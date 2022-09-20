import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:whatsappmessenger/common/enom/message_enam.dart';
import 'package:whatsappmessenger/common/providers/message_replay_provider.dart';
import 'package:whatsappmessenger/common/widgets/loding_screen.dart';
import 'package:whatsappmessenger/models/message.dart';
import 'package:whatsappmessenger/view/chat/widgets/Bottom_chat_screen.dart';
import 'package:whatsappmessenger/view/chat/widgets/my_message_card.dart';
import 'package:whatsappmessenger/view/chat/widgets/sender_message_card.dart';

class Chatlist extends ConsumerStatefulWidget {
  final String recieverUserId;
  const Chatlist({Key? key, required this.recieverUserId}) : super(key: key);

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ChatlistState();
}

class _ChatlistState extends ConsumerState<Chatlist> {
  final ScrollController messageController = ScrollController();

  @override
  void dispose() {
    messageController.dispose();
    super.dispose();
  }

  void onMessageSwipe(String message, bool isMe, MessageEnum messageEnum) {
    ref.read(messageReplayProvider.state).update(
          (state) => MessageRelpay(
            message,
            isMe,
            messageEnum,
          ),
        );
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<Message>>(
        stream:
            ref.read(chatControllerProvider).chatStream(widget.recieverUserId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const LodingScreen();
          }
          SchedulerBinding.instance.addPersistentFrameCallback((_) {
            messageController
                .jumpTo(messageController.position.maxScrollExtent);
          });
          return ListView.builder(
              controller: messageController,
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                final messageData = snapshot.data![index];
                var timeSent = DateFormat.Hm().format(messageData.timeSent);
                if (!messageData.isSeen &&
                    messageData.recieverId ==
                        FirebaseAuth.instance.currentUser!.uid) {
                  ref.read(chatControllerProvider).setChatMessageSceen(
                        context,
                        widget.recieverUserId,
                        messageData.messageId,
                 );
                }
                if (messageData.senderId ==
                    FirebaseAuth.instance.currentUser!.uid) {
                  return MyMessageCard(
                    message: messageData.text,
                    date: timeSent,
                    isSeen:messageData.isSeen ,
                    onLeftSwipe: () => onMessageSwipe(
                        messageData.text, true, messageData.type),
                    repliedMessageType: messageData.repliedMessageType,
                    repliedText: messageData.repliedMessage,
                    type: messageData.type,
                    username: messageData.repliedTo,
                  );
                }
                return SenderMessageCard(
                    message: messageData.text,
                    date: timeSent,
                    type: messageData.type,
                    onRightSwipe: () => onMessageSwipe(
                        messageData.text, false, messageData.type),
                    repliedText: messageData.repliedMessage,
                    username: messageData.repliedTo,
                    repliedMessageType: messageData.repliedMessageType,
                    );
              });
        });
  }
}

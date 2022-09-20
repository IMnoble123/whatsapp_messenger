import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:whatsappmessenger/common/enom/message_enam.dart';

class MessageRelpay{
  final String message;
  final bool isMe;
  final MessageEnum messageEnum;

  MessageRelpay(this.message, this.isMe, this.messageEnum);
}

final messageReplayProvider = StateProvider<MessageRelpay?>((ref) => null);


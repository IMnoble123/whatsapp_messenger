import 'package:whatsappmessenger/common/enom/message_enam.dart';

class Message {
  final String senderId;
  final String recieverId;
  final String text;
  final MessageEnum type;
  final DateTime timeSent;
  final String messageId;
  final bool isSeen;

  Message(
      {required this.senderId,
      required this.recieverId,
      required this.text,
      required this.type,
      required this.timeSent,
      required this.messageId,
      required this.isSeen});


       Map<String, dynamic> toMap() {
    return {
      'senderId': senderId,
      'recieverid': recieverId,
      'text': text,
      'type': type.type,
      'timeSent': timeSent.millisecondsSinceEpoch,
      'messageId': messageId,
      'isSeen': isSeen,
     
    };
  }

  factory Message.fromMap(Map<String, dynamic> map) {
    return Message(
      senderId: map['senderId'] ?? '',
      recieverId: map['recieverid'] ?? '',
      text: map['text'] ?? '',
      type: (map['type'] as String).toEnam(),
      timeSent: DateTime.fromMillisecondsSinceEpoch(map['timeSent']),
      messageId: map['messageId'] ?? false,
       isSeen: map['isSeen'] ?? false,
    );
  }
}


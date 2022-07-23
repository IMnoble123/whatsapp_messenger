import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:whatsappmessenger/view/chat/controllers/chat_controller.dart';
import 'package:whatsappmessenger/view/chat/repositorys/chat_repo.dart';

final chatControllerProvider = Provider((ref) {
  final chatRepository = ref.watch(chatRepositoryProvider);
  return ChatController(
    chatRepository: chatRepository,
    ref: ref,
  );
});

class Bottomchatfield extends ConsumerStatefulWidget {
  final String recieverUserId;
  const Bottomchatfield({
    Key? key,
    required this.recieverUserId,
  }) : super(key: key);

  @override
  ConsumerState<Bottomchatfield> createState() => _BottomchatfieldState();
}

class _BottomchatfieldState extends ConsumerState<Bottomchatfield> {
  bool isSendButton = false;
  final TextEditingController _messageController = TextEditingController();

  void sendTextMessage() async {
    if (isSendButton) {
      ref.read(chatControllerProvider).sendTextMessage(
            context,
            _messageController.text.trim(),
            widget.recieverUserId,
          );
     
      setState(() {
         _messageController.text = '';
      });
    }
  }

  @override
  void dispose() {
    super.dispose();
    _messageController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // final size = MediaQuery.of(context).size;
    return Row(
      children: [
        Expanded(
          child: TextFormField(
            controller: _messageController,
            onChanged: (val) {
              if (val.isEmpty) {
                setState(() {
                  isSendButton = false;
                });
              } else {
                setState(() {
                  isSendButton = true;
                });
              }
            },
            decoration: InputDecoration(
              filled: true,
              fillColor: Colors.white,
              prefixIcon: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10.0),
                child: SizedBox(
                  width: 60,
                  child: Row(
                    children: [
                      IconButton(
                          onPressed: () {},
                          icon: const Icon(Icons.emoji_emotions,
                              color: Colors.grey)),
                    ],
                  ),
                ),
              ),
              suffixIcon: SizedBox(
                width: 100,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    IconButton(
                        onPressed: () {},
                        icon: const Icon(Icons.camera_alt, color: Colors.grey)),
                    IconButton(
                        onPressed: () {},
                        icon:
                            const Icon(Icons.attach_file, color: Colors.grey)),
                  ],
                ),
              ),
              hintText: 'Type a message',
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20.0),
                  borderSide: const BorderSide(
                    width: 0,
                    style: BorderStyle.none,
                  )),
              contentPadding: const EdgeInsets.all(10),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(right: 2, left: 2, bottom: 8),
          child: CircleAvatar(
            // backgroundColor: const Color(0xFF128C7E),
            backgroundColor: Colors.deepPurple[400],
            radius: 25,
            child: GestureDetector(
              onTap: sendTextMessage,
              child: Icon(
                isSendButton ? Icons.send : Icons.mic,
                color: Colors.white,
              ),
            ),
          ),
        )
      ],
    );
  }
}

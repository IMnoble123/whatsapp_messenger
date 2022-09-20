import 'dart:io';
import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_sound/public/flutter_sound_recorder.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:whatsappmessenger/common/enom/message_enam.dart';
import 'package:whatsappmessenger/common/providers/message_replay_provider.dart';
import 'package:whatsappmessenger/common/utls/utls.dart';
import 'package:whatsappmessenger/view/chat/controllers/chat_controller.dart';
import 'package:whatsappmessenger/view/chat/repositorys/chat_repo.dart';
import 'package:whatsappmessenger/view/chat/widgets/message_replay.dart';

final chatControllerProvider = Provider((ref) {
  final chatRepository = ref.watch(chatRepositoryProvider);
  return ChatController(
    chatRepository: chatRepository,
    ref: ref,
  );
});

class Bottomchatfield extends ConsumerStatefulWidget {
  final String recieverUserId;
  final bool isGroupChat;
  const Bottomchatfield({
    Key? key,
    required this.recieverUserId,
    required this.isGroupChat
  }) : super(key: key);

  @override
  ConsumerState<Bottomchatfield> createState() => _BottomchatfieldState();
}

class _BottomchatfieldState extends ConsumerState<Bottomchatfield> {
  bool isSendButton = false;
  final TextEditingController _messageController = TextEditingController();
  FlutterSoundRecorder? _soundRecorder;
  bool isShowEmojiContainer = false;
  bool isRecorderInit = false;
  bool isRecording = false;
  FocusNode focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _soundRecorder = FlutterSoundRecorder();
    openAudio();
  }

  void openAudio() async {
    final status = await Permission.microphone.request();
    if (status != PermissionStatus.granted) {
      throw RecordingPermissionException('Mic permission denied');
    }
    await _soundRecorder!.openRecorder();
    isRecorderInit = true;
  }

  void sendTextMessage() async {
    if (isSendButton) {
      ref.read(chatControllerProvider).sendTextMessage(
            context,
            _messageController.text.trim(),
            widget.recieverUserId,
            widget.isGroupChat,
          );

      setState(() {
        _messageController.text = '';
      });
    } else {
      var dir = await getTemporaryDirectory();
      var path = '${dir.path}/flutter_sound.aac';
      if (!isRecorderInit) {
        return;
      }
      if (isRecording) {
        await _soundRecorder!.stopRecorder();
        sentFileMessage(File(path), MessageEnum.audio);
      } else {
        await _soundRecorder!.startRecorder(
          toFile: path,
        );
      }

      setState(() {
        isRecording = !isRecording;
      });
    }
  }

  void sentFileMessage(
    File file,
    MessageEnum messageEnum,
  ) {
    ref.read(chatControllerProvider).sendFileMessage(
          context,
          file,
          widget.recieverUserId,
          messageEnum,
          widget.isGroupChat,
        );
  }

  void selectImage() async {
    File? image = await pickImageFromGallery(context);
    if (image != null) {
      sentFileMessage(image, MessageEnum.image);
    }
  }

  void selectVideo() async {
    File? video = await pickVideoFromGallery(context);
    if (video != null) {
      sentFileMessage(video, MessageEnum.video);
    }
  }

  void selectgif() async {
    final gif = await pickGIF(context);
    if (gif != null) {
      // ignore: use_build_context_synchronously
      ref
          .read(chatControllerProvider)
          .sendGIF(context, gif.url, widget.recieverUserId,widget.isGroupChat);
    }
  }

  void hideEmoji() {
    setState(() {
      isShowEmojiContainer = false;
    });
  }

  void showEmoji() {
    setState(() {
      isShowEmojiContainer = true;
    });
  }

  void showKeyboard() => focusNode.requestFocus();
  void hideKeyboard() => focusNode.unfocus();

  void toggleEmojiKeyboard() {
    if (isShowEmojiContainer) {
      showKeyboard();
      hideEmoji();
    } else {
      hideKeyboard();
      showEmoji();
    }
  }

  @override
  void dispose() {
    super.dispose();
    _messageController.dispose();
    _soundRecorder!.closeRecorder();
    isRecorderInit = false;
  }

  @override
  Widget build(BuildContext context) {
    final messageReplay = ref.watch(messageReplayProvider);
    final isShowMessageReplay = messageReplay != null;
    // final size = MediaQuery.of(context).size;
    return Column(
      children: [
        isShowMessageReplay ? const MessageReplayPreview() : const SizedBox(),
        Row(
          children: [
            Expanded(
              child: TextFormField(
                focusNode: focusNode,
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
                              onPressed: toggleEmojiKeyboard,
                              icon: const Icon(Icons.emoji_emotions,
                                  color: Colors.grey)),
                          IconButton(
                              onPressed: selectgif,
                              icon: const Icon(Icons.gif, color: Colors.grey)),
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
                            onPressed: selectImage,
                            icon: const Icon(Icons.camera_alt,
                                color: Colors.grey)),
                        IconButton(
                            onPressed: selectVideo,
                            icon: const Icon(Icons.attach_file,
                                color: Colors.grey)),
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
                    isSendButton
                        ? Icons.send
                        : isRecording
                            ? Icons.close
                            : Icons.mic,
                    color: Colors.white,
                  ),
                ),
              ),
            )
          ],
        ),
        isShowEmojiContainer
            ? SizedBox(
                height: 310,
                child: EmojiPicker(
                  onEmojiSelected: (category, emoji) {
                    setState(() {
                      _messageController.text =
                          _messageController.text + emoji.emoji;
                    });
                    if (!isSendButton) {
                      setState(() {
                        isSendButton = true;
                      });
                    }
                  },
                ),
              )
            : const SizedBox()
      ],
    );
  }
}

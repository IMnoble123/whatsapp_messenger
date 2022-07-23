import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:whatsappmessenger/common/widgets/loding_screen.dart';
import 'package:whatsappmessenger/models/user_model.dart';
import 'package:whatsappmessenger/view/auth/controller/auth_controller.dart';
import 'package:whatsappmessenger/view/chat/chat_list.dart';

import 'allwdgets/Bottom_chat_screen.dart';

class MobileChatScreen extends ConsumerWidget {
  static const String routeName = '/mobile-chatscreen';
  final String name;
  final String uid;
  const MobileChatScreen({
    Key? key,
    required this.name,
    required this.uid,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepPurple[400],
        leading: IconButton(
          onPressed: () {},
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
        ),
        elevation: 0,
        title: StreamBuilder<UserModel>(
            stream: ref.read(authControllerProvider).userDataById(uid),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const LodingScreen();
              }
              return Column(
                children: [
                  Text(name),
                  Text(
                    // snapshot.data!.isOnline ? 'online' : 'offline',
                    snapshot.data != null ? 'online' : "offline",
                    style: const TextStyle(
                        fontSize: 8,
                        color: Colors.white,
                        fontWeight: FontWeight.normal),
                  ),
                ],
              );
            }),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.video_call_outlined, color: Colors.white),
          ),
          IconButton(
              onPressed: () {},
              icon: const Icon(Icons.call, color: Colors.white)),
          PopupMenuButton(
              icon: const Icon(
                Icons.more_vert,
                color: Colors.white,
              ),
              itemBuilder: (context) => [
                    PopupMenuItem(
                        child: const Text('view contact'), onTap: () {}),
                    PopupMenuItem(
                        child: const Text('Media,links,and docs'),
                        onTap: () {}),
                    PopupMenuItem(child: const Text('Search'), onTap: () {}),
                    PopupMenuItem(
                        child: const Text('Mute notifications'), onTap: () {}),
                    PopupMenuItem(
                        child: const Text('Disappearing messages'),
                        onTap: () {}),
                    PopupMenuItem(child: const Text('Wallpaper'), onTap: () {}),
                    PopupMenuItem(
                        child: const Text('More'),
                        onTap: () {
                          // PopupMenuItem(
                          //     child: const Text('Report'), onTap: () {});
                          // PopupMenuItem(
                          //     child: const Text('Block'), onTap: () {});
                          // PopupMenuItem(
                          //     child: const Text('Clear chat'), onTap: () {});
                          // PopupMenuItem(
                          //     child: const Text('Export chat'), onTap: () {});
                          // PopupMenuItem(
                          //     child: const Text('Add shortcut'), onTap: () {});
                        }),
                  ])
        ],
      ),
      body: Column(
        children:   [
          const Expanded(
            child: Chatlist()),
           Bottomchatfield(
            recieverUserId: uid,
           )

        ],
      ),
    );
  }
}


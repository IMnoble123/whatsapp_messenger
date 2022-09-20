import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:whatsappmessenger/common/utls/utls.dart';
import 'package:whatsappmessenger/view/chat/widgets/select_screencontacts.dart';
import 'view/auth/controller/auth_controller.dart';

class MobileLayoutScreen extends ConsumerStatefulWidget {
  static const String routeName = '/mobile-layout';
  const MobileLayoutScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<MobileLayoutScreen> createState() => _MobileLayoutScreenState();
}

class _MobileLayoutScreenState extends ConsumerState<MobileLayoutScreen>
    with WidgetsBindingObserver, TickerProviderStateMixin {
  late TabController tabBarController;

  @override
  void initState() {
    super.initState();
    tabBarController = TabController(initialIndex: 0, length: 3, vsync: this);
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    super.dispose();
    WidgetsBinding.instance.removeObserver(this);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    switch (state) {
      case AppLifecycleState.resumed:
        ref.read(authControllerProvider).setUserState(true);
        break;
      case AppLifecycleState.inactive:
      case AppLifecycleState.detached:
      case AppLifecycleState.paused:
        ref.read(authControllerProvider).setUserState(false);
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.deepPurple[400],
          centerTitle: false,
          title: const Text(
            'WhatsApp',
            style: TextStyle(
              fontSize: 20,
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.search, color: Colors.white),
              onPressed: () {},
            ),
            PopupMenuButton(
              icon: const Icon(
                Icons.more_vert,
                color: Colors.white,
              ),
              itemBuilder: (context) => [
                PopupMenuItem(
                    child: const Text(
                      'New Group',
                    ),
                    onTap: () {}),
                PopupMenuItem(
                  child: const Text('New broadcast'),
                  onTap: () {},
                ),
                PopupMenuItem(
                  child: const Text('Linked devices'),
                  onTap: () {},
                ),
                PopupMenuItem(
                  child: const Text('Starred messeages'),
                  onTap: () {},
                ),
                PopupMenuItem(
                  child: const Text('Payments'),
                  onTap: () {},
                ),
                PopupMenuItem(
                  child: const Text('settings'),
                  onTap: () {},
                ),
              ],
            ),
          ],
          bottom: TabBar(
            controller: tabBarController,
            indicatorColor: Colors.white,
            indicatorWeight: 3,
            labelColor: Colors.white,
            unselectedLabelColor: Colors.grey,
            labelStyle: const TextStyle(
              fontWeight: FontWeight.bold,
            ),
            tabs: const [
              Tab(
                text: 'CHATS',
              ),
              Tab(
                text: 'STATUS',
              ),
              Tab(
                text: 'CALLS',
              ),
            ],
          ),
        ),
        body: TabBarView(
          controller: tabBarController,
          children: const [Text('Calls'), Text('status'), Text('chats')],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () async {
            if (tabBarController.index == 0) {
              Navigator.pushNamed(context, ContactScreen.routeName);
            } else {
              File? pickedImage = await pickImageFromGallery(context);
            }
          },
          // backgroundColor: const Color.fromARGB(255, 8, 115, 63),
          backgroundColor: Colors.deepPurple[400],
          child: const Icon(
            Icons.comment,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}

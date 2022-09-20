import 'package:flutter/material.dart';
import 'package:whatsappmessenger/common/widgets/error.dart';
import 'package:whatsappmessenger/mobile_screen.dart';
import 'package:whatsappmessenger/view/auth/screens/login_screen.dart';
import 'package:whatsappmessenger/view/auth/screens/otp_screen.dart';
import 'package:whatsappmessenger/view/auth/screens/user_info_screen.dart';
import 'package:whatsappmessenger/view/chat/mobile_chat_screen.dart';
import 'package:whatsappmessenger/view/chat/widgets/select_screencontacts.dart';

Route<dynamic> generateRoute(RouteSettings settings) {
  switch (settings.name) {
    case Loginscreen.routeName:
      return MaterialPageRoute(builder: (ctx) => const Loginscreen());
    case Otpscreen.routeName:
      final verificationId = settings.arguments as String;
      return MaterialPageRoute(
          builder: (ctx) => Otpscreen(
                verificationId: verificationId,
              ));
    case Userinformation.routeName:
      return MaterialPageRoute(builder: (ctx) => const Userinformation());
    case ContactScreen.routeName:
      return MaterialPageRoute(builder: (ctx) => const ContactScreen());
    case MobileLayoutScreen.routeName:
      return MaterialPageRoute(builder: (ctx) => const MobileLayoutScreen());
    case MobileChatScreen.routeName:
      final arguments = settings.arguments as Map<String, dynamic>;
      //here we sendin the map as argument and extractin the property named name and uid
      final name = arguments['name'];
      final uid = arguments['uid'];
      final isGroupChat = arguments['isGroupChat'];
      return MaterialPageRoute(builder: (ctx) =>  MobileChatScreen(
        name: name,
        uid: uid,
        isGroupChat: isGroupChat,

      ));

    default:
      return MaterialPageRoute(
          builder: (ctx) => const Scaffold(
                body: Errorpage(error: 'Opps no Pages found'),
              ));
  }
}

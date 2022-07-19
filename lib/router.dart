import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:whatsappmessenger/common/widgets/error.dart';
import 'package:whatsappmessenger/view/auth/screens/login_screen.dart';
import 'package:whatsappmessenger/view/auth/screens/otp_screen.dart';
import 'package:whatsappmessenger/view/auth/screens/user_info_screen.dart';
import 'package:whatsappmessenger/view/select_condatcs/screens/controller/select_screencontacts.dart';

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
      return MaterialPageRoute(builder: (ctx)=>const ContactScreen());

    default:
      return MaterialPageRoute(
          builder: (ctx) => const Scaffold(
                body: Errorpage(error: 'Opps no Pages found'),
              ));
  }
}

import 'package:flutter/material.dart';
import 'package:whatsappmessenger/common/widgets/custombutton.dart';
import 'package:whatsappmessenger/view/auth/screens/login_screen.dart';

class Openingscreen extends StatelessWidget {
  const Openingscreen({Key? key}) : super(key: key);
  
  void navigateToLoginScreen(BuildContext context) {
    Navigator.pushNamed(context, Loginscreen.routeName);
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(
              height: 60,
            ),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 55),
              child: Text(
                "Welcome to WhatsApp",
                style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w500,
                    color: Colors.white),
              ),
            ),
            SizedBox(height: size.height / 7),
            //  const CircleAvatar(
            //   backgroundImage:AssetImage('assets/b12.png'),
            //   radius: 100,
            //  )
            Image.asset(
              'assets/b12.png',
              height: 320,
              width: 320,
            ),
            const SizedBox(height: 8),
            const Padding(
              padding: EdgeInsets.all(18.0),
              child: Text(
                'Read our privacy policy. Tap "Agree and continew" to accept the Terms and Service',
                style: TextStyle(fontSize: 13, color: Colors.indigo),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 10),
            CustomButton(
              text: "AGREE AND CONTINUE",
              onpressed: () => navigateToLoginScreen(context),
            )
          ],
        ),
      ),
    );
  }
}

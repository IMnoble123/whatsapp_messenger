import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:whatsappmessenger/view/auth/controller/auth_controller.dart';

class Otpscreen extends ConsumerWidget {
  static const String routeName = '/otp-screen';
  final String verificationId;
  const Otpscreen({Key? key, required this.verificationId}) : super(key: key);

  void verifyOTP(
    WidgetRef ref, 
    BuildContext context, 
    String userOTP
    ) {
    ref.read(authControllerProvider).verifyOTP(
      context, 
      verificationId,
       userOTP
       );
      }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.black,
        leading: IconButton(
            onPressed: () {},
            icon: const Icon(
              Icons.arrow_back_ios,
              color: Colors.white,
            )),
        title: const Text(
          'Verifing phone number',
          style: TextStyle(fontSize: 16, color: Colors.white),
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(height: 20),
          const Text(
            'We have sent otp via sms.',
            style: TextStyle(fontSize: 15, color: Colors.indigo),
          ),
          SizedBox(
            width: size.width * 0.5,
            child: TextField(
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.white),
              decoration: const InputDecoration(
                  hintStyle: TextStyle(color: Colors.grey,fontSize: 15),
                  hintText: '- - - - - -'),
              keyboardType: TextInputType.number,
              onChanged: (val) {
                if (val.length == 6) {
                  verifyOTP(ref, context, val.trim()
                  );
                }
              },
            ),
          )
        ],
      ),
    );
  }
}

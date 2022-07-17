import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:whatsappmessenger/common/utls/utls.dart';
import 'package:whatsappmessenger/common/widgets/custombutton.dart';
import 'package:country_picker/country_picker.dart';
import 'package:whatsappmessenger/view/auth/controller/auth_controller.dart';

class Loginscreen extends ConsumerStatefulWidget {
  static const routeName = '/loginsreeen';
  const Loginscreen({
    Key? key,
  }) : super(key: key);

  @override
  ConsumerState<Loginscreen> createState() => _LoginscreenState();
}

class _LoginscreenState extends ConsumerState<Loginscreen> {
  final phonecontroller = TextEditingController();
  Country? country;
  @override
  void dispose() {
    phonecontroller.dispose();
    super.dispose();
  }

  void pickCountry() {
    showCountryPicker(
        context: context,
        onSelect: (Country _country) {
          setState(() {
            country = _country;
          });
        });
  }

  void sendPhoneNumber() {
    String phoneNumber = phonecontroller.text.trim();
    if (country != null && phoneNumber.isNotEmpty) {
      ref
          .read(authControllerProvider)
          .signInWithPhone(context, '+${country!.phoneCode}phoneNumber');
    } else {
    showsnackbr(context: context, content: 'Add country code');
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        leading: IconButton(
            onPressed: () {},
            icon: const Icon(
              Icons.arrow_back_ios,
              color: Colors.white,
            )),
        title: const Text(
          "Enter your phone Number",
          style: TextStyle(fontSize: 20, color: Colors.white),
        ),
      ),
      backgroundColor: Colors.black,
      body: Padding(
        padding: const EdgeInsets.all(18.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 12),
            const Text(
              'Whatsapp needs to verify your phone number',
              style: TextStyle(fontSize: 13, color: Colors.white),
            ),
            const SizedBox(height: 9),
            TextButton(
                onPressed: () => pickCountry(),
                child: const Text("Add country")),
            const SizedBox(height: 6),
            Row(
              children: [
                if (country != null)
                  Text(
                    '+${country!.phoneCode}',
                    style: const TextStyle(color: Colors.white),
                  ),
                const SizedBox(width: 10),
                SizedBox(
                  width: size.width * 0.7,
                  child: TextField(
                    style: const TextStyle(color: Colors.white),
                    controller: phonecontroller,
                    decoration: const InputDecoration(
                      labelStyle: TextStyle(color: Colors.white38),
                      labelText: ' phone number',
                      enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.grey)),
                      // focusedBorder: OutlineInputBorder(
                      //     borderSide: BorderSide(color: Colors.grey)),
                    ),
                  ),
                )
              ],
            ),
            const SizedBox(height: 100),
            SizedBox(
              width: 90,
              child: CustomButton(onpressed:sendPhoneNumber, text: 'NEXT'),
            )
          ],
        ),
      ),
    );
  }
}

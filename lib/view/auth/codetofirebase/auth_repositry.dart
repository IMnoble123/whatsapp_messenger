import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:whatsappmessenger/common/repositories/commom_firebase_storae_repo.dart';
import 'package:whatsappmessenger/common/utls/utls.dart';
import 'package:whatsappmessenger/mobile_screen.dart';
import 'package:whatsappmessenger/models/user_model.dart';
import 'package:whatsappmessenger/view/auth/screens/otp_screen.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:whatsappmessenger/view/auth/screens/user_info_screen.dart';

final authRepositoryProvider = Provider((ref) => AuthRepository(
    auth: FirebaseAuth.instance, firestore: FirebaseFirestore.instance));

class AuthRepository {
  final FirebaseAuth auth;
  final FirebaseFirestore firestore;

  AuthRepository({required this.auth, required this.firestore});

  Future<UserModel?> getCurrentUserData() async {
    var userData =
        await firestore.collection('users').doc(auth.currentUser?.uid).get();
    UserModel? user;
    if (userData.data() != null) {
      user = UserModel.fromMap(userData.data()!);
    }
    return user;
  }

  void signInwithphone(BuildContext context, String phoneNumber) async {
    try {
      await auth.verifyPhoneNumber(
          phoneNumber: phoneNumber,
          verificationCompleted: (PhoneAuthCredential credential) async {
            await auth.signInWithCredential(credential);
          },
          verificationFailed: (e) {
            throw Exception(e.message);
          },
          codeSent: ((String verificationId, int? resendToken) async {
            Navigator.pushNamed(context, Otpscreen.routeName,
                arguments: verificationId);
          }),
          codeAutoRetrievalTimeout: (String verification) {});
    } on FirebaseAuthException catch (e) {
      showsnackbr(context: context, content: e.message!);
    }
  }

  void verifyOtp({
    required BuildContext context,
    required String verificationId,
    required String userOTP,
  }) async {
    try {
      PhoneAuthCredential credential = PhoneAuthProvider.credential(
          verificationId: verificationId, smsCode: userOTP);
      Navigator.pushNamedAndRemoveUntil(
          context, Userinformation.routeName, (route) => false);
      await auth.signInWithCredential(credential);
    } on FirebaseAuthException catch (e) {
      showsnackbr(context: context, content: e.message!);
    }
  }

  void userDataToFirebase({
    required String name,
    required File? profilePic,
    required ProviderRef ref,
    required BuildContext context,
  }) async {
    try {
      String uid = auth.currentUser!.uid;
      String photoUrl =
          'https://www.google.com/imgres?imgurl=https%3A%2F%2Fi.pinimg.com%2Foriginals%2F2e%2F1e%2F00%2F2e1e004c0c7042c1777c2f9b6675a571.jpg&imgrefurl=https%3A%2F%2Fin.pinterest.com%2Fpin%2F843369467709396809%2F&tbnid=5aKIUVZd2r_gEM&vet=12ahUKEwjq5d6gx__4AhUjgmMGHU4nAcgQMygNegUIARDYAQ..i&docid=nBf4oNY58uJBbM&w=1200&h=1208&q=png%20image%20of%20whatsapp&ved=2ahUKEwjq5d6gx__4AhUjgmMGHU4nAcgQMygNegUIARDYAQ';
      //overriden the url to her
      if (profilePic != null) {
        photoUrl = await ref
            .read(commonFirebaseStoragerepositoryProvider)
            .storeFileToFirebase('profilePic/$uid', profilePic);
      }
      var user = UserModel(
          name: name,
          uid: uid,
          profilePic: photoUrl,
          isOnline: true,
          phoneNumber: auth.currentUser!.phoneNumber.toString(),
          groupId: []);
      await firestore.collection('users').doc(uid).set(user.toMap());

      // ignore: use_build_context_synchronously
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => const MobileLayoutScreen()),
          (route) => false);
    } catch (e) {
      showsnackbr(context: context, content: (e).toString());
    }
  }

//her map is userd  to convert userid  docement shapshot to  user model
  Stream<UserModel> userData(String userId) {
    return firestore
        .collection('users')
        .doc(userId)
        .snapshots()
        .map((event) => UserModel.fromMap(
              event.data()!,
            ));
  }
}

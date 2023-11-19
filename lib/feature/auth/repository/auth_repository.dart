// ignore_for_file: use_build_context_synchronously

import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:new_whatsapp_clone/common/repository/firebase_commom_storage_repository.dart';
import 'package:new_whatsapp_clone/common/utils/utils.dart';
import 'package:new_whatsapp_clone/feature/auth/screens/otp_Screen.dart';
import 'package:new_whatsapp_clone/feature/auth/screens/userInformationScreen.dart';
import 'package:new_whatsapp_clone/models/userModels.dart';
import 'package:new_whatsapp_clone/screens/mobile_layout_screen.dart';
import 'package:riverpod/riverpod.dart';

final authRepositoryProvider = Provider((ref) => AuthRepository(
    auth: FirebaseAuth.instance, firestore: FirebaseFirestore.instance));

class AuthRepository {
  final FirebaseAuth auth;
  final FirebaseFirestore firestore;
  AuthRepository({
    required this.auth,
    required this.firestore,
  });

  Future<UserModel?> getCurrentUserData() async {
    var userData =
        await firestore.collection('users').doc(auth.currentUser?.uid).get();

    UserModel? user;
    if (userData.data() != null) {
      user = UserModel.fromMap(userData.data()!);
    }
    return user;
  }

  void signInWithPhone(BuildContext context, String phoneNumber) async {
    try {
      await auth.verifyPhoneNumber(
          phoneNumber: phoneNumber,
          verificationCompleted: (PhoneAuthCredential credential) async {
            await auth.signInWithCredential(credential);
          },
          verificationFailed: (e) {
            throw Exception(e.message);
          },
          codeSent: ((String verificationID, int? resendToken) async {
            Navigator.pushNamed(context, OTPScreens.routeName,
                arguments: verificationID);
          }),
          codeAutoRetrievalTimeout: (String verificationId) {});
    } on FirebaseAuthException catch (e) {
      showSnackBar(context: context, content: e.message!);
      print("The Error is 1 ${e.message!}");
    }
  }

  void verifyOTP({
    required BuildContext context,
    required String verificationId,
    required String userOTP,
  }) async {
    try {
      PhoneAuthCredential credential = PhoneAuthProvider.credential(
          verificationId: verificationId, smsCode: userOTP);

      await auth.signInWithCredential(credential);
      Navigator.pushNamedAndRemoveUntil(
          context, UserInformationScreen.routeName, (route) => false);
    } on FirebaseAuthException catch (e) {
      showSnackBar(context: context, content: e.message!);
        print("The Error is 2 ${e.message!}");
    }
  }

  void saveUserDataToFirebase(
      {required String name,
      required File? profilePic,
      required ProviderRef ref,
      required BuildContext context}) async {
    try {
      String uid = auth.currentUser!.uid;
      String photoUrl =
          "https://cdn-icons-png.flaticon.com/512/1144/1144760.png";

      if (profilePic != null) {
        photoUrl = await ref
            .read(commomFirebaseStorageRepositoryProvider)
            .storeFileToFirebase(
              'profilePic/$uid',
              profilePic,
            );
      }
      var user = UserModel(
          name: name,
          uid: uid,
          profilePic: photoUrl,
          isOnline: true,
          phoneNumber: auth.currentUser!.phoneNumber!,
          groupId: []);

      await firestore.collection('users').doc(uid).set(user.toMap());

      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => const MobileLayoutScreen()),
          (route) => false);
    } catch (e) {
      showSnackBar(context: context, content: e.toString());
        print("The Error is 3 ${e.toString}");
    }
  }

  Stream<UserModel> userData(String userID) {
    return firestore
        .collection('users')
        .doc(userID)
        .snapshots()
        .map((event) => UserModel.fromMap(event.data()!));
  }
}

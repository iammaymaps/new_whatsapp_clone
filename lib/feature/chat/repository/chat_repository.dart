import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:new_whatsapp_clone/common/utils/utils.dart';
import 'package:new_whatsapp_clone/models/chat_Contact_models.dart';
import 'package:new_whatsapp_clone/models/userModels.dart';

class ChatRepository {
  final FirebaseFirestore firestore;
  final FirebaseAuth auth;
  ChatRepository({
    required this.firestore,
    required this.auth,
  });
  void _saveDataToContactsSubcollection(
    UserModel sendUserData,
    UserModel recieverUserData,
    String text,
    DateTime timeSent,
    String recieverUserID,
  ) async {
    var recieverChatContact = ChatContact(
        name: sendUserData.name,
        profilePic: sendUserData.profilePic,
        contactId: sendUserData.uid,
        timeSent: timeSent,
        lastMessage: text);
  }

  void sendTextMessage(
      {required BuildContext context,
      required String text,
      required String recieverID,
      required UserModel senderID}) async {
    try {
      var timeSent = DateTime.now();
      UserModel recieverUserData;

      var userDataMap =
          await firestore.collection('users').doc(recieverID).get();
      recieverUserData = UserModel.fromMap(userDataMap.data()!);
    } catch (e) {
      showSnackBar(context: context, content: e.toString());
    }
  }
}

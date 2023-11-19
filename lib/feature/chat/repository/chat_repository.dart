import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:new_whatsapp_clone/common/enum/message_enum.dart';
import 'package:new_whatsapp_clone/common/repository/firebase_commom_storage_repository.dart';
import 'package:new_whatsapp_clone/common/utils/utils.dart';
import 'package:new_whatsapp_clone/models/chat_Contact_models.dart';
import 'package:new_whatsapp_clone/models/message_model.dart';
import 'package:new_whatsapp_clone/models/userModels.dart';
import 'package:riverpod/riverpod.dart';
import 'package:uuid/uuid.dart';

final chatRepositoryProvider = Provider((ref) => ChatRepository(
    firestore: FirebaseFirestore.instance, auth: FirebaseAuth.instance));

class ChatRepository {
  final FirebaseFirestore firestore;
  final FirebaseAuth auth;
  ChatRepository({
    required this.firestore,
    required this.auth,
  });

  Stream<List<ChatContact>> getChatContact() {
    return firestore
        .collection('users')
        .doc(auth.currentUser!.uid)
        .collection('chats')
        .snapshots()
        .asyncMap((event) async {
      List<ChatContact> contacts = [];
      for (var document in event.docs) {
        var chatContact = ChatContact.fromMap(document.data());
        var userData = await firestore
            .collection('users')
            .doc(chatContact.contactId)
            .get();
        var user = UserModel.fromMap(userData.data()!);

        contacts.add(ChatContact(
            name: user.name,
            profilePic: user.profilePic,
            contactId: chatContact.contactId,
            timeSent: chatContact.timeSent,
            lastMessage: chatContact.lastMessage));
      }
      return contacts;
    });
  }

  void _saveDataToContactsSubcollection(
    UserModel sendUserData,
    UserModel recieverUserData,
    String text,
    DateTime timeSent,
    String recieverUserID,
  ) async {
    var recieverChatContact = ChatContact(
        name: recieverUserData.name,
        profilePic: recieverUserData.profilePic,
        contactId: recieverUserData.uid,
        timeSent: timeSent,
        lastMessage: text);

    await firestore
        .collection('users')
        .doc(recieverUserID)
        .collection('chats')
        .doc(auth.currentUser!.uid)
        .set(recieverChatContact.toMap());

    var senderChatContact = ChatContact(
        name: sendUserData.name,
        profilePic: sendUserData.profilePic,
        contactId: sendUserData.uid,
        timeSent: timeSent,
        lastMessage: text);

    await firestore
        .collection('users')
        .doc(recieverUserID)
        .collection('chats')
        .doc(auth.currentUser!.uid)
        .set(senderChatContact.toMap());
  }

  void _saveMessageToMessageSubcollection({
    required String recieverUserId,
    required String text,
    required DateTime timeSent,
    required String messageId,
    required String username,
    required recieverusername,
    required MessageEnum messageType,
  }) async {
    final message = Message(
        senderId: auth.currentUser!.uid,
        recieverId: recieverUserId,
        text: text,
        tyep: messageType,
        timeSent: timeSent,
        messageId: messageId,
        isSeen: false);

    await firestore
        .collection('users')
        .doc(auth.currentUser!.uid)
        .collection('chats')
        .doc(recieverUserId)
        .collection('messages')
        .doc(messageId)
        .set(message.toMap());

    await firestore
        .collection('users')
        .doc(recieverUserId)
        .collection('chats')
        .doc(auth.currentUser!.uid)
        .collection('messages')
        .doc(messageId)
        .set(message.toMap());
  }

  void sendTextMessage({
    required BuildContext context,
    required String text,
    required String recieverUserID,
    required UserModel senderID,
  }) async {
    try {
      var timeSent = DateTime.now();
      UserModel? recieverUserData;

      var userDataMap =
          await firestore.collection('users').doc(recieverUserID).get();
      recieverUserData = UserModel.fromMap(userDataMap.data()!);
      var messageId = const Uuid().v4();
      _saveDataToContactsSubcollection(
        senderID,
        recieverUserData,
        text,
        timeSent,
        recieverUserID,
      );
      _saveMessageToMessageSubcollection(
          recieverUserId: recieverUserID,
          text: text,
          timeSent: timeSent,
          messageId: messageId,
          username: senderID.name,
          recieverusername: recieverUserData?.name,
          messageType: MessageEnum.text);
      print("Scess");
    } catch (e, stackTrace) {
      showSnackBar(context: context, content: e.toString());
      print("The Error is 4 $e");
      print(stackTrace);
    }
  }
}

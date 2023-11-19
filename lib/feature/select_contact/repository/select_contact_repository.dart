import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_contacts/contact.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:new_whatsapp_clone/common/utils/utils.dart';
import 'package:new_whatsapp_clone/models/userModels.dart';
import 'package:new_whatsapp_clone/feature/chat/screens/mobile_chat_screen.dart';
import 'package:riverpod/riverpod.dart';

final selectContactRepositoryProvider = Provider(
    (ref) => SelectContactRepository(firestore: FirebaseFirestore.instance));

class SelectContactRepository {
  final FirebaseFirestore firestore;
  SelectContactRepository({
    required this.firestore,
  });

  Future<List<Contact>> getContact() async {
    List<Contact> contacts = [];

    try {
      if (await FlutterContacts.requestPermission()) {
        contacts = await FlutterContacts.getContacts(withProperties: true);
      }
    } catch (e) {
      debugPrint(e.toString());
    }
    return contacts;
  }

  void selectContact(Contact selectedContact, BuildContext context) async {
    try {
      var userCollection = await firestore.collection('users').get();
      bool isFound = false;
      for (var document in userCollection.docs) {
        var userData = UserModel.fromMap(document.data());

        String selectedPhoneNum = selectedContact.phones[0].number
            .replaceAll(
              '-',
              '',
            )
            .replaceAll(
              ' ',
              '',
            );

        if (selectedPhoneNum == userData.phoneNumber) {
          isFound = true;
          print(selectedPhoneNum);
          Navigator.pushNamed(context, MobileChatScreen.routeName, arguments: {
            'name': userData.name,
            'uid': userData.uid,
          });
        }
        if (!isFound) {
          showSnackBar(
              context: context,
              content: "This number does not exist on this app");
        }

        print(selectedPhoneNum);
      }
    } catch (e) {
      showSnackBar(context: context, content: e.toString());
       print("The Error is 5 ${e.toString}");
    }
  }
}

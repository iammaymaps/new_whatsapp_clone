import 'package:flutter/material.dart';
import 'package:new_whatsapp_clone/common/widgets/error.dart';
import 'package:new_whatsapp_clone/feature/auth/screens/loginScreen.dart';
import 'package:new_whatsapp_clone/feature/auth/screens/otp_Screen.dart';
import 'package:new_whatsapp_clone/feature/auth/screens/userInformationScreen.dart';
import 'package:new_whatsapp_clone/feature/select_contact/Select_Contact_Screens.dart';
import 'package:new_whatsapp_clone/feature/chat/screens/mobile_chat_screen.dart';

Route<dynamic> generateRoute(RouteSettings settings) {
  switch (settings.name) {
    case LoginScreen.routeName:
      return MaterialPageRoute(builder: (context) => const LoginScreen());

    case OTPScreens.routeName:
      final verificationId = settings.arguments as String;
      return MaterialPageRoute(
          builder: (context) => OTPScreens(
                verificationId: verificationId,
              ));

    case SelectContactScreen.routeName:
      return MaterialPageRoute(
          builder: (context) => const SelectContactScreen());
    case UserInformationScreen.routeName:
      return MaterialPageRoute(
          builder: (context) => const UserInformationScreen());
    case MobileChatScreen.routeName:
      final arguments = settings.arguments as Map<String, dynamic>;
      final name = arguments['name'];
      final uid = arguments['uid'];
      return MaterialPageRoute(
          builder: (context) => MobileChatScreen(
                name: name,
                uid: uid,
              ));
    default:
      return MaterialPageRoute(
          builder: (context) => const Scaffold(
                body: ErrorScreen(error: 'This page doesn\'t exist'),
              ));
  }
}

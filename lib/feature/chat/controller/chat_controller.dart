import 'package:flutter/widgets.dart';
import 'package:new_whatsapp_clone/feature/auth/controller/auth_controller.dart';
import 'package:riverpod/riverpod.dart';

import 'package:new_whatsapp_clone/feature/chat/repository/chat_repository.dart';

class ChatController {
  final ChatRepository chatRepository;
  final ProviderRef ref;
  ChatController({
    required this.chatRepository,
    required this.ref,
  });

  void sendTextMessage(
      BuildContext context, String text, String recieverUserId) {
    ref.read(userDataAuthProvider).whenData((value) =>
        chatRepository.sendTextMessage(
            context: context,
            text: text,
            recieverUserID: recieverUserId,
            senderID: value!));
  }
}

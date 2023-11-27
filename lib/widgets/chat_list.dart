import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:new_whatsapp_clone/feature/chat/controller/chat_controller.dart';
import 'package:new_whatsapp_clone/models/message_model.dart';
import 'package:new_whatsapp_clone/widgets/loader.dart';
import 'package:new_whatsapp_clone/widgets/my_message_card.dart';
import 'package:new_whatsapp_clone/widgets/sender_message_card.dart';

class ChatList extends ConsumerStatefulWidget {
  const ChatList({required this.recieverUserId, Key? key}) : super(key: key);
  final String recieverUserId;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ChatListState();
}

class _ChatListState extends ConsumerState<ChatList> {
  final ScrollController messageController = ScrollController();
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    messageController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<Message>>(
        stream:
            ref.read(chatControllerProvider).chatStream(widget.recieverUserId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Loader();
          }

          SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
            if (messageController.hasClients) {
              messageController
                  .jumpTo(messageController.position.maxScrollExtent);
            }
          });

          return ListView.builder(
            controller: messageController,
            itemCount: snapshot.data!.length,
            itemBuilder: (context, index) {
              final messageData = snapshot.data![index];
              var timeSent = DateFormat.Hm().format(messageData.timeSent);
              if (messageData.senderId ==
                  FirebaseAuth.instance.currentUser!.uid) {
                return MyMessageCard(
                  message: messageData.text,
                  date: timeSent,
                  type: messageData.tyep,
                );
              }
              return SenderMessageCard(
                message: messageData.text,
                date: timeSent,
                type: messageData.tyep,
              );
            },
          );
        });
  }
}

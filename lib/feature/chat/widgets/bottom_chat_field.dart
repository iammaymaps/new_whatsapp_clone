import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:new_whatsapp_clone/colors.dart';
import 'package:new_whatsapp_clone/common/enum/message_enum.dart';
import 'package:new_whatsapp_clone/common/utils/utils.dart';
import 'package:new_whatsapp_clone/feature/chat/controller/chat_controller.dart';

class BottomChatField extends ConsumerStatefulWidget {
  final String receviderId;

  const BottomChatField({
    required this.receviderId,
  });

  @override
  ConsumerState<BottomChatField> createState() => _BottomChatFieldState();
}

class _BottomChatFieldState extends ConsumerState<BottomChatField> {
  final TextEditingController _messageContrpller = TextEditingController();
  bool isShowSendButton = false;

  void sendToMessage() async {
    if (isShowSendButton) {
      ref.read(chatControllerProvider).sendTextMessage(
          context, _messageContrpller.text.trim(), widget.receviderId);
      print("The Error is ${widget.receviderId}");
      setState(() {
        _messageContrpller.text = '';
      });
    }
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _messageContrpller.dispose();
  }

  void sendFileMessage(File file, MessageEnum messageEnum) {
    ref
        .read(chatControllerProvider)
        .sendfileMessage(context, file, widget.receviderId, messageEnum);
  }

  void selectImage() async {
    File? image = await pickImageFromGallary(context);
    if (image != null) {
      sendFileMessage(image, MessageEnum.image);
    }
  }

  void selectVideo() async {
    File? Video = await pickVideoFromGallary(context);
    if (Video != null) {
      sendFileMessage(Video, MessageEnum.video);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: TextFormField(
            controller: _messageContrpller,
            onChanged: (val) {
              if (val.isNotEmpty) {
                setState(() {
                  isShowSendButton = true;
                });
              } else {
                setState(() {
                  isShowSendButton = false;
                });
              }
            },
            decoration: InputDecoration(
              filled: true,
              fillColor: mobileChatBoxColor,
              prefixIcon: SizedBox(
                width: 100,
                child: Row(
                  children: [
                    IconButton(
                        onPressed: () {},
                        icon: const Icon(
                          Icons.emoji_emotions,
                          color: Colors.grey,
                        )),
                    IconButton(
                        onPressed: () {},
                        icon: const Icon(
                          Icons.gif,
                          color: Colors.grey,
                        )),
                  ],
                ),
              ),
              suffixIcon: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: SizedBox(
                  width: 100,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      IconButton(
                          onPressed: selectImage,
                          icon: Icon(
                            Icons.camera_alt,
                            color: Colors.grey,
                          )),
                      IconButton(
                        onPressed: selectVideo,
                        icon: Icon(
                          Icons.attach_file,
                        ),
                        color: Colors.grey,
                      ),
                    ],
                  ),
                ),
              ),
              hintText: 'Type a message!',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(20.0),
                borderSide: const BorderSide(
                  width: 0,
                  style: BorderStyle.none,
                ),
              ),
              contentPadding: const EdgeInsets.all(10),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(bottom: 8, right: 2, left: 2),
          child: CircleAvatar(
            backgroundColor: const Color(0xFF128C7E),
            child: GestureDetector(
              onTap: sendToMessage,
              child: Icon(
                isShowSendButton ? Icons.send : Icons.mic,
                color: Colors.white,
              ),
            ),
          ),
        )
      ],
    );
  }
}

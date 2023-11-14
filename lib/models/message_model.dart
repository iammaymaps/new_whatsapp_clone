import 'dart:convert';

import 'package:new_whatsapp_clone/common/enum/message_enum.dart';

class Message {
  final String senderId;
  final String recieverId;
  final String text;
  final MessageEnum tyep;
  final DateTime timeSent;
  final String messageId;
  final bool isSeen;
  Message({
    required this.senderId,
    required this.recieverId,
    required this.text,
    required this.tyep,
    required this.timeSent,
    required this.messageId,
    required this.isSeen,
  });

  Message copyWith({
    String? senderId,
    String? recieverId,
    String? text,
    MessageEnum? tyep,
    DateTime? timeSent,
    String? messageId,
    bool? isSeen,
  }) {
    return Message(
      senderId: senderId ?? this.senderId,
      recieverId: recieverId ?? this.recieverId,
      text: text ?? this.text,
      tyep: tyep ?? this.tyep,
      timeSent: timeSent ?? this.timeSent,
      messageId: messageId ?? this.messageId,
      isSeen: isSeen ?? this.isSeen,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'senderId': senderId,
      'recieverId': recieverId,
      'text': text,
      'tyep': tyep.type,
      'timeSent': timeSent.millisecondsSinceEpoch,
      'messageId': messageId,
      'isSeen': isSeen,
    };
  }

  factory Message.fromMap(Map<String, dynamic> map) {
    return Message(
      senderId: map['senderId'] ?? '',
      recieverId: map['recieverId'] ?? '',
      text: map['text'] ?? '',
      tyep: (map['tyep'] as String).toEnum(),
      timeSent: DateTime.fromMillisecondsSinceEpoch(map['timeSent']),
      messageId: map['messageId'] ?? '',
      isSeen: map['isSeen'] ?? false,
    );
  }
}

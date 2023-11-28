import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/widgets.dart';

import 'package:new_whatsapp_clone/common/enum/message_enum.dart';
import 'package:new_whatsapp_clone/widgets/Video%20Player%20Widget.dart';

class DisplayTextGig extends StatelessWidget {
  const DisplayTextGig({
    Key? key,
    required this.message,
    required this.type,
  }) : super(key: key);
  final String message;
  final MessageEnum type;

  @override
  Widget build(BuildContext context) {
    return type == MessageEnum.text
        ? Text(
            message,
            style: const TextStyle(fontSize: 16),
          )
        : type == MessageEnum.video
            ? VideoPlayerItem(videoUrl: message)
            : CachedNetworkImage(imageUrl: message);
  }
}

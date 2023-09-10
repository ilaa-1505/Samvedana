import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'chat_message_type.dart';

import 'chat_message_type.dart';

class ChatMessageWidget extends StatelessWidget {

  final String text;
  final ChatMessageType chatMessageType;
  const ChatMessageWidget({super.key, required this.text, required this.chatMessageType});
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 1),
      padding: const EdgeInsets.all(16),
      color: chatMessageType == ChatMessageType.bot ? const Color(0xEAF392AE) : const Color(
          0xEAF56298),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          chatMessageType == ChatMessageType.bot ? Container(
            margin: const EdgeInsets.only(right: 16),
                child : const CircleAvatar(
                  backgroundColor: Color.fromRGBO(255, 193, 203, 1.0),
                  // child: Image.asset("assets/image/",
                  // color: Colors.white, scale: 1.5,),
            ),
          ) : Container(
            margin: const EdgeInsets.only(right: 16),
            child: const CircleAvatar(
              backgroundColor : Color(0xFFF1B2E5),
              child: Icon(
                CupertinoIcons.person_alt,
              ),
            ),
          ),

          Expanded(child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(text, style: Theme.of(context)
                    .textTheme
                    .bodyLarge
                    ?.copyWith(color: Colors.white),),
              ),
            ],
          )),
        ],
      ),
    );
  }
}

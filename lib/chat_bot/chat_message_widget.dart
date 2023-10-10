import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'chat_message_type.dart';

class ChatMessageWidget extends StatelessWidget {
  final String text;
  final ChatMessageType chatMessageType;
  const ChatMessageWidget(
      {super.key, required this.text, required this.chatMessageType});
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 1),
      padding: const EdgeInsets.only(top: 30, bottom: 30, left: 10, right: 10),
      color: chatMessageType == ChatMessageType.bot
          ? const Color.fromARGB(234, 255, 240, 228)
          : const Color.fromARGB(234, 255, 255, 255),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          chatMessageType == ChatMessageType.bot
              ? Container(
                  child: CircleAvatar(
                    radius:
                        25.0, // Set the radius according to your requirement
                    backgroundColor: const Color.fromARGB(234, 255, 240, 228),
                    child: Image.asset(
                      "assets/doctor1.png",
                      scale:
                          2.0, // Adjust the scale factor to make the image bigger
                    ),
                  ),
                )
              : Container(
                  margin: const EdgeInsets.only(right: 10),
                  child: CircleAvatar(
                    radius: 20.0,
                    backgroundColor: const Color.fromARGB(255, 255, 255, 255),
                    child: Image.asset(
                      "assets/user.png", // Replace with the correct image asset path
                      // Adjust the height to fit within the CircleAvatar
                    ),
                  ),
                ),
          Expanded(
              child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  text,
                  style: Theme.of(context)
                      .textTheme
                      .bodyLarge
                      ?.copyWith(color: Colors.black),
                ),
              ),
            ],
          )),
        ],
      ),
    );
  }
}

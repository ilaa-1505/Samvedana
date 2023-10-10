import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'chat_message_type.dart';
import 'chat_message_widget.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({Key? key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

Future<String> generateResponse(String prompt) async {
  const apiKey = "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";

  var url = Uri.https("api.openai.com", "/v1/completions");

  try {
    final response = await http.post(
      url,
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $apiKey"
      },
      body: json.encode(
        {
          "model": "text-davinci-003",
          "prompt":
              "Please act like a chatbot who helps people, dont mention you are an AI, you are Sakhi. Please answer this question and nothing else: $prompt",
          "temperature": 0.1,
          "max_tokens": 700,
        },
      ),
    );

    if (response.statusCode == 200) {
      Map<String, dynamic> newResponse = jsonDecode(response.body);
      if (newResponse.containsKey('choices') &&
          newResponse['choices'].isNotEmpty) {
        return newResponse['choices'][0]['text'];
      }
    }

    if (kDebugMode) {
      print("Error generating response: ${response.statusCode}");
    }
    return "";
  } catch (error) {
    if (kDebugMode) {
      print("Error generating response: $error");
    }
    return "";
  }
}

class _ChatScreenState extends State<ChatScreen> {
  final _textController = TextEditingController();
  final _scrollController = ScrollController();
  final List<ChatMessage> _messages = [];
  bool isLoading = false;

  void _scrollDown() {
    _scrollController.animateTo(
      _scrollController.position.maxScrollExtent,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Hi! This is Sakhi",
          style: GoogleFonts.poppins(
              textStyle: const TextStyle(
                  color: Colors.black,
                  fontSize: 24,
                  fontWeight: FontWeight.bold)),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          onPressed: () {
            Navigator.pushNamedAndRemoveUntil(
                context, 'home', (route) => false);
          },
          icon: const Icon(
            Icons.arrow_back_ios_rounded,
            color: Color.fromARGB(255, 0, 0, 0),
          ),
        ),
      ),
      backgroundColor: const Color.fromARGB(255, 255, 255, 255),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                controller: _scrollController,
                itemCount: _messages.length,
                itemBuilder: (context, index) {
                  var message = _messages[index];
                  return ChatMessageWidget(
                    text: message.text,
                    chatMessageType: message.chatMessageType,
                  );
                },
              ),
            ),
            Visibility(
              visible: isLoading,
              child: const Padding(
                padding: EdgeInsets.all(8),
                child: CircularProgressIndicator(
                  color: Color.fromARGB(255, 238, 166, 208),
                ),
              ),
            ),
            Padding(
              padding:
                  const EdgeInsets.only(top: 20, bottom: 15, left: 8, right: 8),
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        color: const Color.fromARGB(255, 234, 219, 165),
                        borderRadius: BorderRadius.circular(24),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: TextField(
                          textCapitalization: TextCapitalization.sentences,
                          style: const TextStyle(color: Colors.black),
                          controller: _textController,
                          decoration: const InputDecoration(
                            border: InputBorder.none,
                            hintText: 'Type a message...',
                          ),
                        ),
                      ),
                    ),
                  ),
                  Visibility(
                    visible: !isLoading,
                    child: Container(
                      decoration: const BoxDecoration(
                        color: Color(0xFFFFFFFF),
                        shape: BoxShape.circle,
                      ),
                      child: IconButton(
                        icon: const Icon(
                          Icons.send_rounded,
                          color: Color.fromRGBO(0, 0, 0, 1.0),
                        ),
                        onPressed: () async {
                          setState(() {
                            _messages.add(ChatMessage(
                              text: _textController.text,
                              chatMessageType: ChatMessageType.user,
                            ));
                            isLoading = true;
                          });
                          var input = _textController.text;
                          _textController.clear();
                          Future.delayed(const Duration(milliseconds: 1000))
                              .then((_) => _scrollDown());
                          generateResponse(input).then((value) {
                            setState(() {
                              isLoading = false;
                              _messages.add(
                                ChatMessage(
                                  text: value,
                                  chatMessageType: ChatMessageType.bot,
                                ),
                              );
                            });
                            _scrollDown();
                          });
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

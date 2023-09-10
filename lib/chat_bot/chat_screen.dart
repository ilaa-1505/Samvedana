import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../homescreen.dart';
import 'chat_message_type.dart';
import 'chat_message_widget.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

Future<String> generateResponse(String prompt) async {
  const apiKey = " ";

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
              "I am most probably in depression, please act like a chatbot who helps people with depression, dont mention you are an AI, you are Sakhi. Please answer this question and nothing else: $prompt",
          "temperature": 0.6,
          "max_tokens": 300,
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
        title: const Text("Hi! This is Sakhi"),
        backgroundColor: const Color.fromARGB(255, 244, 103, 202),
        leading: IconButton(
          onPressed: (){
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => const MyHomePage(
                  title: 'Samvedana',
                ),
              ),
            );
          },
          icon: const Icon(Icons.arrow_back_ios_rounded,
            color: Colors.black,),
        ),
        elevation: 0,
        centerTitle: true,
      ),
      backgroundColor: const Color.fromARGB(255, 244, 103, 202),
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
                  color: Color.fromARGB(255, 0, 0, 0),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      textCapitalization: TextCapitalization.sentences,
                      style: const TextStyle(color: Colors.white),
                      controller: _textController,
                      decoration: const InputDecoration(
                        fillColor: Color(0xFFEAB6DB),
                        filled: true,
                        border: InputBorder.none,
                        focusedBorder: InputBorder.none,
                        enabledBorder: InputBorder.none,
                        errorBorder: InputBorder.none,
                        disabledBorder: InputBorder.none,
                      ),
                    ),
                  ),
                  Visibility(
                    visible: !isLoading,
                    child: Container(
                      color: const Color(0xFFE777AA),
                      child: IconButton(
                        icon: const Icon(
                          Icons.send_rounded,
                          color: Color.fromRGBO(250, 249, 247, 1.0),
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

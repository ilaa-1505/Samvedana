import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:http/http.dart' as http;
import '../homescreen.dart';

const String apiUrl =
'https://asia-south1-melanoma-388416.cloudfunctions.net/predict';

class QuizScreen extends StatefulWidget {
  const QuizScreen({super.key});

  @override
  _QuizScreenState createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  List<String> quizQuestions = [];
  List<int> userSelections = [];
  int currentQuestionIndex = 0;
  bool isNextButtonEnabled = false; // Track button state

  // Define fixed options for all questions
  final List<Map<String, dynamic>> fixedOptions = [
    {'text': 'Did not apply to me at all', 'value': 1},
    {'text': 'Applied to me to some degree, or some of the time', 'value': 2},
    {
      'text': 'Applied to me to a considerable degree, or a good part of the time',
      'value': 3
    },
    {'text': 'Applied to me very much, or most of the time', 'value': 4},
  ];

  void endQuizAndSendData() async {
    if (userSelections.every((selection) => selection != -1)) {
      try {
        // Convert the userSelections list to a comma-separated string
        final userSelectionsString = "$userSelections";
        if (kDebugMode) {
          print(userSelectionsString);
        }

        final response = await http.post(
          Uri.parse(apiUrl),
          headers: {
            'Content-Type': 'application/json',
          },
          body: jsonEncode({'files': userSelectionsString}));

          // Use userSelectionsString

        if (response.statusCode == 200) {
          // Successfully sent data to the API
          if (kDebugMode) {
            print('Data sent to API: ${response.body}');
          }
        } else {
          // Handle error when API request fails
          if (kDebugMode) {
            print('API request failed with status code ${response.statusCode}');
          }
        }
      } catch (e) {
        // Handle exceptions during the HTTP request
        if (kDebugMode) {
          print('Error sending data to API: $e');
        }
      }
    } else {
      // Display an error message or handle the case where not all questions have been answered
    }
  }

  @override
  void initState() {
    super.initState();
    init();
  }

  void init() async {
    final data = await fetchQuizData();
    setState(() {
      quizQuestions = data;
      userSelections = List<int>.filled(quizQuestions.length, -1); // Initialize all to -1
      isNextButtonEnabled = false; // Initialize as disabled
    });
  }

  Future<List<String>> fetchQuizData() async {
    List<String> quizData = [];

    try {
      DocumentSnapshot documentSnapshot =
      await _firestore.collection('quiz').doc('questions').get();

      final data = documentSnapshot.data() as Map<String, dynamic>?;

      if (data != null) {
        for (int i = 1; i <= 60; i++) {
          final question = data[i.toString()] as String?;
            quizData.add(question!);
        }
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error fetching quiz data: $e');
      }
    }

    return quizData;
  }

  void setUserSelection(int selectedValue) {
    setState(() {
      if (quizQuestions.isNotEmpty &&
          currentQuestionIndex < quizQuestions.length) {
        userSelections[currentQuestionIndex] = selectedValue;
        isNextButtonEnabled =
        false; // Enable next button when an option is selected
      }
    });
  }

  void nextQuestion() {
    if (currentQuestionIndex < quizQuestions.length - 1) {
      if (userSelections[currentQuestionIndex] != -1) {
        setState(() {
          currentQuestionIndex++;
          isNextButtonEnabled = userSelections[currentQuestionIndex] != -1;
        });
      }
    } else if (currentQuestionIndex == quizQuestions.length - 1) {
      // Check if all questions have been answered before proceeding
      if (userSelections.every((selection) => selection != -1)) {
        if (kDebugMode) {
          print('$userSelections');
        }
      } else {
        // Display an error message or handle the case where not all questions have been answered
      }
    }
  }



  void previousQuestion() {
    if (currentQuestionIndex > 0) {
      setState(() {
        currentQuestionIndex--;
        isNextButtonEnabled = true;
        // Don't change the state of the next button when going back
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 101, 173, 227),
        title: const Text('Assessment Quiz'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => const MyHomePage(
                  title: 'Samvedana',
                ),
              ),
            );
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.only(top:60,right:16,bottom:16,left:16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            const SizedBox(height: 8.0),
            if (quizQuestions.isNotEmpty &&
                currentQuestionIndex >= 0 &&
                currentQuestionIndex < quizQuestions.length)
              Text(
                quizQuestions[currentQuestionIndex],
                style: const TextStyle(fontSize: 24.0),
              )
            else
              const Text(
                'Loading...',
                style: TextStyle(fontSize: 24.0),
              ),
            const SizedBox(height: 16.0),
            if (quizQuestions.isNotEmpty &&
                currentQuestionIndex >= 0 &&
                currentQuestionIndex < quizQuestions.length)
              Column(
                children: fixedOptions.map<Widget>((option) {
                  return RadioListTile<int>(
                    title: Text(option['text']),
                    value: option['value'],
                    groupValue: userSelections[currentQuestionIndex],
                    activeColor: const Color.fromARGB(255, 101, 173, 227),
                    onChanged: (int? selectedValue) {
                      setUserSelection(selectedValue!);
                    },
                  );
                }).toList(),
              )
            else
              const Text('Options loading...'), // Handle loading of options
          ],
        ),
      ),
      bottomNavigationBar: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Container(
            margin: const EdgeInsets.only(bottom: 8.0),
            child: ElevatedButton(
              onPressed: previousQuestion,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.transparent,
                elevation: 0
              ),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.arrow_back, size: 18.0,color: Colors.black,), // Add the back icon
                  SizedBox(width: 8.0), // Add some spacing between icon and text
                  Text(
                    'Previous',
                    style: TextStyle(fontSize: 18.0,color: Colors.black),
                  ),
                ],
              ),
            ),
          ),

          Container(
            margin: const EdgeInsets.only(bottom: 8.0),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.transparent,
                elevation: 0,
              ),
              onPressed: () {
                if (quizQuestions.isNotEmpty &&
                    currentQuestionIndex >= 0 &&
                    currentQuestionIndex < quizQuestions.length) {
                  if (currentQuestionIndex == quizQuestions.length - 1) {
                    if (kDebugMode) {
                      print('$userSelections');
                    }
                    endQuizAndSendData();
                  } else {
                    nextQuestion();
                  }
                }
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    quizQuestions.isNotEmpty &&
                        currentQuestionIndex >= 0 &&
                        currentQuestionIndex < quizQuestions.length
                        ? (currentQuestionIndex == quizQuestions.length - 1
                        ? 'End Quiz'
                        : 'Next Question')
                        : 'Loading...',
                    style: const TextStyle(fontSize: 18.0,color: Colors.black),
                  ),
                  const SizedBox(width: 8.0), // Add some spacing between text and icon
                  const Icon(Icons.arrow_forward, size: 18.0,color: Colors.black,), // Add the forward arrow icon
                ],
              ),
            ),
          ),

        ],
      ),
    );
  }
}

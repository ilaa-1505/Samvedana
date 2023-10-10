import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:cloud_firestore/cloud_firestore.dart';

const String apiUrl = 'https://asia-south1-melanoma-388416.cloudfunctions.net/predict';

class PQuizScreen extends StatefulWidget {
  const PQuizScreen({Key? key, required this.answersFromQuizScreen}) : super(key: key);

  final List<int> answersFromQuizScreen;

  @override
  _PQuizScreenState createState() => _PQuizScreenState();
}

class _PQuizScreenState extends State<PQuizScreen> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  List<String> pQuizQuestions = [];
  String combinedanswersString = " ";
  List<int> userSelections1 = [];
  int currentQuestionIndex = 0;
  bool isNextButtonEnabled = false;

  final List<Map<String, dynamic>> fixedOptions = [
    {'text': 'Disagree strongly', 'value': 1},
    {'text': 'Disagree moderately', 'value': 2},
    {
      'text': 'Disagree a little',
      'value': 3,
    },
    {'text': 'Neither agree nor disagree', 'value': 4},
    {'text': 'Agree a little', 'value': 5},
    {'text': 'Agree moderately', 'value': 6},
    {'text': 'Agree strongly', 'value': 7},
  ];

  @override
  void initState() {
    super.initState();
    init();
  }

  void init() async {
    final data = await fetchQuizData();
    setState(() {
      pQuizQuestions = data;
      userSelections1 = List<int>.filled(pQuizQuestions.length, 1);
      isNextButtonEnabled = false;
    });
  }

  Future<List<String>> fetchQuizData() async {
    List<String> quizData = [];

    try {
      DocumentSnapshot documentSnapshot = await _firestore.collection('personality').doc('question2').get();

      final data = documentSnapshot.data() as Map<String, dynamic>?;

      if (data != null) {
        for (int i = 1; i <= 18; i++) {
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
      if (pQuizQuestions.isNotEmpty &&
          currentQuestionIndex < pQuizQuestions.length) {
        userSelections1[currentQuestionIndex] = selectedValue;
        isNextButtonEnabled = false;
      }
    });
  }

  void navigateToResultScreen(BuildContext context, String result) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => ResultScreen(result: result)),
    );
  }

  void nextQuestion() {
    if (currentQuestionIndex < pQuizQuestions.length - 1) {
      if (userSelections1[currentQuestionIndex] != -1) {
        setState(() {
          currentQuestionIndex++;
          isNextButtonEnabled = userSelections1[currentQuestionIndex] != -1;
        });
      }
    } else if (currentQuestionIndex == pQuizQuestions.length - 1) {
      if (userSelections1.every((selection) => selection != -1)) {
        sendCombinedData();
      }
    }
  }

  void previousQuestion() {
    if (currentQuestionIndex > 0) {
      setState(() {
        currentQuestionIndex--;
        isNextButtonEnabled = true;
      });
    }
  }

  void sendCombinedData() async {
    if (kDebugMode) {
      print("widget.answersFromQuizScreen: ${widget.answersFromQuizScreen}");
    }
    if (kDebugMode) {
      print("userSelections1: $userSelections1");
    }
    final combinedAnswers = [...widget.answersFromQuizScreen, ...userSelections1];

    if (kDebugMode) {
      print("CombinedAnswers:");
      print(combinedAnswers);
    }

    combinedanswersString = combinedAnswers.join(',');

    if (kDebugMode) {
      print(combinedanswersString);
      print(combinedanswersString.runtimeType);
    }

    Uri uri = Uri.parse(apiUrl);

    try {
      final response = await http.post(
        uri,
        body: {
          'answers': combinedanswersString,
        },
      );

      if (response.statusCode == 200) {
        if (kDebugMode) {
          print('Data sent to API: ${response.body}');
        }
        navigateToResultScreen(context, response.body);
      } else {
        if (kDebugMode) {
          print('API request failed with status code ${response.statusCode}');
        }
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error sending data to API: $e');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromRGBO(246, 184, 96, 0.8),
        title: Text(
          'Personality Quiz',
          style: GoogleFonts.poppins(
            fontSize: 24.0,
            fontWeight: FontWeight.bold,
            color: const Color.fromARGB(255, 0, 0, 0),
          ),
        ),
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
            color: Color.fromARGB(255, 0, 0, 0),
          ),
          onPressed: () {
            // Handle back button press as needed
          },
        ),
      ),
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              'assets/bgr1.jpeg',
              fit: BoxFit.cover,
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(
                top: 60, right: 16, bottom: 16, left: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                const SizedBox(height: 8.0),
                if (pQuizQuestions.isNotEmpty &&
                    currentQuestionIndex >= 0 &&
                    currentQuestionIndex < pQuizQuestions.length)
                  Text(
                    pQuizQuestions[currentQuestionIndex],
                    style: const TextStyle(fontSize: 24.0),
                  )
                else
                  const Text(
                    'Loading...',
                    style: TextStyle(fontSize: 24.0),
                  ),
                const SizedBox(height: 16.0),
                if (pQuizQuestions.isNotEmpty &&
                    currentQuestionIndex >= 0 &&
                    currentQuestionIndex < pQuizQuestions.length)
                  Column(
                    children: fixedOptions.map<Widget>((option) {
                      return RadioListTile<int>(
                        title: Text(option['text']),
                        value: option['value'],
                        groupValue: userSelections1[currentQuestionIndex],
                        activeColor: const Color.fromARGB(255, 250, 195, 84),
                        onChanged: (int? selectedValue) {
                          setUserSelection(selectedValue!);
                        },
                      );
                    }).toList(),
                  )
                else
                  const Text('Options loading...'),
              ],
            ),
          ),
          Positioned(
            bottom: 16,
            right: 16,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.transparent,
                elevation: 0,
              ),
              onPressed: () {
                if (pQuizQuestions.isNotEmpty &&
                    currentQuestionIndex >= 0 &&
                    currentQuestionIndex < pQuizQuestions.length) {
                  if (currentQuestionIndex == pQuizQuestions.length - 1) {
                    sendCombinedData();
                  } else {
                    nextQuestion();
                  }
                }
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    pQuizQuestions.isNotEmpty &&
                        currentQuestionIndex >= 0 &&
                        currentQuestionIndex < pQuizQuestions.length
                        ? (currentQuestionIndex == pQuizQuestions.length - 1
                        ? 'End Quiz'
                        : 'Next Question')
                        : 'Loading...',
                    style: const TextStyle(fontSize: 18.0, color: Colors.black),
                  ),
                  const SizedBox(width: 8.0),
                  const Icon(
                    Icons.arrow_forward,
                    size: 18.0,
                    color: Colors.black,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class ResultScreen extends StatelessWidget {
  final String result;

  const ResultScreen({super.key, required this.result});

  String extractResult(String jsonResult) {
    try {
      final Map<String, dynamic> data = json.decode(jsonResult);
      final List<dynamic> predictions = data['predictions'];

      if (predictions.isNotEmpty) {
        return predictions[0].toString();
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error parsing result: $e');
      }
    }

    return 'No result';
  }

  @override
  Widget build(BuildContext context) {
    final extractedResult = extractResult(result);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Result'),
      ),
      body: Center(
        child: Text(
          extractedResult,
          style: const TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}


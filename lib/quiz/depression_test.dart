import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_fonts/google_fonts.dart';
import '../homescreen.dart';

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
  bool isNextButtonEnabled = false;

  final List<Map<String, dynamic>> fixedOptions = [
    {'text': 'Did not apply to me at all', 'value': 1},
    {'text': 'Applied to me to some degree, or some of the time', 'value': 2},
    {
      'text':
      'Applied to me to a considerable degree, or a good part of the time',
      'value': 3
    },
    {'text': 'Applied to me very much, or most of the time', 'value': 4},
  ];

  @override
  void initState() {
    super.initState();
    init();
  }

  void init() async {
    final data = await fetchQuizData();
    setState(() {
      quizQuestions = data;
      userSelections = List<int>.filled(quizQuestions.length, -1);
      isNextButtonEnabled = false;
    });
  }

  Future<List<String>> fetchQuizData() async {
    List<String> quizData = [];

    try {
      DocumentSnapshot documentSnapshot =
      await _firestore.collection('quiz').doc('questions').get();

      final data = documentSnapshot.data() as Map<String, dynamic>?;

      if (data != null) {
        for (int i = 1; i <= 42; i++) {
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
        isNextButtonEnabled = false;
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
      if (userSelections.every((selection) => selection != -1)) {
        // Handle completion of the quiz, e.g., navigate to the next screen
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromRGBO(246, 184, 96, 0.8),
        title: Text(
          'Assessment Quiz',
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
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              'assets/bgr1.jpeg', // Replace with your image path
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
            bottom: 0,
            left: 0,
            right: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Expanded(
                  child: Container(
                    margin: const EdgeInsets.only(bottom: 8.0),
                    child: ElevatedButton(
                      onPressed: previousQuestion,
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.transparent, elevation: 0),
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.arrow_back,
                            size: 18.0,
                            color: Colors.black,
                          ),
                          SizedBox(
                            width: 8.0,
                          ),
                          Text(
                            'Previous',
                            style: TextStyle(fontSize: 18.0, color: Colors.black),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: Container(
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
                            Navigator.pushNamed(
                              context,
                              'personality', // Use the correct route name defined in MaterialApp
                              arguments: {'answersFromQuizScreen': userSelections},
                            );
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
                                ? (currentQuestionIndex ==
                                quizQuestions.length - 1
                                ? 'Personality Quiz'
                                : 'Next Question')
                                : 'Loading...',
                            style: const TextStyle(
                                fontSize: 18.0, color: Colors.black),
                          ),
                          const SizedBox(
                            width: 8.0,
                          ),
                          const Icon(
                            Icons.arrow_forward,
                            size: 18.0,
                            color: Colors.black,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

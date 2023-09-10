import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class QuizScreen extends StatefulWidget {
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
        for (int i = 1; i <= 42; i++) {
          final question = data[i.toString()] as String?;
          if (question != null) {
            quizData.add(question);
          }
        }
      }
    } catch (e) {
      print('Error fetching quiz data: $e');
    }

    return quizData;
  }

  void setUserSelection(int selectedValue) {
    setState(() {
      if (quizQuestions.isNotEmpty &&
          currentQuestionIndex < quizQuestions.length) {
        userSelections[currentQuestionIndex] = selectedValue;
        isNextButtonEnabled =
        true; // Enable next button when an option is selected
      }
    });
  }

  void nextQuestion() {
    if (currentQuestionIndex < quizQuestions.length - 1) {
      setState(() {
        currentQuestionIndex++;
        if (userSelections[currentQuestionIndex] != -1) {
          isNextButtonEnabled = true;
        } else {
          isNextButtonEnabled = false;
        }
      });
    } else {
      print('$userSelections');
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
    int totalQuestions = quizQuestions.length; // Count the number of questions

    return Scaffold(
      appBar: AppBar(
        title: Text('Quiz App'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              'Question ${currentQuestionIndex + 1} of $totalQuestions:',
              // Display the question count
              style: TextStyle(fontSize: 18.0),
            ),
            SizedBox(height: 8.0),
            if (quizQuestions.isNotEmpty &&
                currentQuestionIndex >= 0 &&
                currentQuestionIndex < quizQuestions.length)
              Text(
                quizQuestions[currentQuestionIndex],
                style: TextStyle(fontSize: 24.0),
              )
            else
              Text(
                'Loading...',
                style: TextStyle(fontSize: 24.0),
              ),
            SizedBox(height: 16.0),
            if (quizQuestions.isNotEmpty &&
                currentQuestionIndex >= 0 &&
                currentQuestionIndex < quizQuestions.length)
              Column(
                children: fixedOptions.map<Widget>((option) {
                  return RadioListTile<int>(
                    title: Text(option['text']),
                    value: option['value'],
                    groupValue: userSelections[currentQuestionIndex],
                    onChanged: (int? selectedValue) {
                      setUserSelection(selectedValue!);
                    },
                  );
                }).toList(),
              )
            else
              Text('Options loading...'), // Handle loading of options
          ],
        ),
      ),
      bottomNavigationBar: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          ElevatedButton(
            onPressed: previousQuestion,
            child: Text(
              'Previous Question',
              style: TextStyle(fontSize: 18.0),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              if (quizQuestions.isNotEmpty &&
                  currentQuestionIndex >= 0 &&
                  currentQuestionIndex < quizQuestions.length) {
                if (currentQuestionIndex == quizQuestions.length - 1) {
                  print('$userSelections');
                } else {
                  nextQuestion();
                }
              }
            },
            child: Text(
              quizQuestions.isNotEmpty &&
                  currentQuestionIndex >= 0 &&
                  currentQuestionIndex < quizQuestions.length
                  ? (currentQuestionIndex == quizQuestions.length - 1
                  ? 'End Quiz'
                  : 'Next Question')
                  : 'Loading...',
              style: TextStyle(fontSize: 18.0),
            ),
          ),
        ],
      ),
    );
  }
}

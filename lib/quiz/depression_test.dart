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
    {'text': 'Applied to me to a considerable degree, or a good part of the time', 'value': 3},
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
        for (int i = 1; i <= 5; i++) {
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
      if (quizQuestions.isNotEmpty && currentQuestionIndex < quizQuestions.length) {
        userSelections[currentQuestionIndex] = selectedValue;
        isNextButtonEnabled = true; // Enable next button when an option is selected
      }
    });
  }

  void nextQuestion() {
    if (currentQuestionIndex < quizQuestions.length - 1) {
      setState(() {
        currentQuestionIndex++;
        if(userSelections[currentQuestionIndex] != -1)
          {
            isNextButtonEnabled = true;
          }
        else {
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
              'Question ${currentQuestionIndex + 1}:',
              style: TextStyle(fontSize: 18.0),
            ),
            SizedBox(height: 8.0),
            Text(
              quizQuestions.isNotEmpty && currentQuestionIndex < quizQuestions.length
                  ? quizQuestions[currentQuestionIndex]
                  : 'Loading...',
              style: TextStyle(fontSize: 24.0),
            ),
            SizedBox(height: 16.0),
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
            ),
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
              if (currentQuestionIndex == quizQuestions.length - 1) {
                // If it's the 42nd question, change behavior or perform an action (e.g., end quiz)
                // Replace this with the desired action when the quiz is ending
                print('$userSelections');
              } else {
                // For other questions, proceed to the next question
                nextQuestion();
              }
            },
            child: Text(
              currentQuestionIndex == quizQuestions.length - 1 ? 'End Quiz' : 'Next Question',
              style: TextStyle(fontSize: 18.0),
            ),
          ),
        ],
      ),
    );
  }
}

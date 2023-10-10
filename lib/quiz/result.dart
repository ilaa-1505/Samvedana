import 'dart:convert';

import 'package:flutter/material.dart';

class ResultScreen extends StatelessWidget {
  final String result;

  ResultScreen({required this.result});

  String extractResult(String jsonResult) {
    final Map<String, dynamic> data = json.decode(jsonResult);
    final List<String> predictions = data['predictions'];
    if (predictions.isNotEmpty) {
      return predictions[0];
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
          'Result: $extractedResult',
          style: const TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}

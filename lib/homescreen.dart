import 'package:flutter/material.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  bool isHovered = false;
  double buttonSize = 40.0;

  List<ButtonInfo> buttonsInfo = [
    ButtonInfo(Colors.pink.shade100, 'Profile'),
    ButtonInfo(Colors.pink.shade200, 'Personality Test'),
    ButtonInfo(Colors.pink.shade300, 'Assessment Test'),
    ButtonInfo(Colors.pink.shade400, 'Coping Mechanisms'),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.pink.shade500,
        toolbarHeight: 100, // Adjust the height as needed
        title: const Center( // Wrap the title in a Center widget
          child: Text(
            'Samvedana',
            style: TextStyle(
              fontSize: 28, // Adjust the font size as needed
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),

      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Column(
                  children: <Widget>[
                    buildLargeButton(buttonsInfo[0]),
                    const SizedBox(height: 20),
                    buildLargeButton(buttonsInfo[2]),
                  ],
                ),
                const SizedBox(width: 20),
                Column(
                  children: <Widget>[
                    buildLargeButton(buttonsInfo[1]),
                    const SizedBox(height: 20),
                    buildLargeButton(buttonsInfo[3]),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
      floatingActionButton: Transform.scale(
        scale: buttonSize / 40.0, // Scale factor based on buttonSize
        child: SizedBox(
          width: 180, // Adjust the width as needed
          child: FloatingActionButton(
            onPressed: () {
              // Add your action here when the button is pressed.
            },
            tooltip: 'Say Hi',
            materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
            heroTag: null,
            elevation: isHovered ? 8.0 : 6.0,
            backgroundColor: Colors.pinkAccent,// Change this color to your desired color
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.0), // Adjust the border radius as needed
            ),
            child: const Padding(
              padding: EdgeInsets.all(8.0),
              child: Text(
                '🙋‍♀️ Sakhi here',
                style: TextStyle(fontSize: 16),
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget buildLargeButton(ButtonInfo info) {
    return Center(
      child: Container(
        width: 180,
        height: 160,
        decoration: BoxDecoration(
          color: info.color,
          borderRadius: BorderRadius.circular(5), // Set 0 to remove rounded corners
        ),
        child: OutlinedButton(
          onPressed: () {
            // Add your action here when the button is pressed.
          },
          style: OutlinedButton.styleFrom(
            padding: EdgeInsets.zero,
            backgroundColor: Colors.transparent,
            side: BorderSide(color: info.color),
          ),
          child: Center(
            child: Text(
              info.text,
              style: const TextStyle(fontSize: 18, color: Colors.white),
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ),
    );
  }
}

class ButtonInfo {
  final Color color;
  final String text;

  ButtonInfo(this.color, this.text);
}

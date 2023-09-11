import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  bool isHovered = false;
  double buttonSize = 40.0;

  void _navigateToNamedRoute(BuildContext context, String routeName) {
    Navigator.of(context).pushReplacementNamed(routeName);
  }

  @override
  Widget build(BuildContext context) {
    List<ButtonInfo> buttonsInfo1 = [
      ButtonInfo(
        height: 10,
        color: Color.fromARGB(255, 101, 173, 227),
        text: 'Assessment Test',
        onPressed: () {
          _navigateToNamedRoute(context, 'quiz');
          // Add the onPressed logic for the Assessment Test button here
        },
      ),
      ButtonInfo(
        height: 20,
        color: Color.fromARGB(255, 123, 170, 239),
        text: 'Personality Test',
        onPressed: () {
          // Add the onPressed logic for the Personality Test button here
        },
      ),
    ];

    List<ButtonInfo> buttonsInfo2 = [
      ButtonInfo(
        height: 10,
        color: Color.fromARGB(255, 147, 194, 238),
        text: 'Coping Mechanisms',
        onPressed: () {
          _navigateToNamedRoute(context, 'journal');
        },
      ),
    ];

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.white,
        toolbarHeight: 100,
        elevation: 0.0,
        automaticallyImplyLeading: false, // Disable the default back arrow
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Hi user!',
              style: GoogleFonts.poppins(
                textStyle: TextStyle(
                  color: Colors.black,
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            IconButton(
              icon: Icon(
                Icons.person_3_sharp, // Replace with your profile icon
                color: Colors.black,
              ),
              onPressed: () {
                // Add your profile icon onPressed logic here
                _navigateToNamedRoute(context, 'profile');
              },
            ),
          ],
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const SizedBox(height: 20),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: buttonsInfo1
                    .map((info) => Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          child: buildLargeButton(info),
                        ))
                    .toList(),
              ),
            ),
            const SizedBox(height: 60), // Add some space between scroll views
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: buttonsInfo2
                    .map((info) => Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          child: buildLargeButton(info),
                        ))
                    .toList(),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: Transform.scale(
        scale: buttonSize / 40.0,
        child: SizedBox(
          width: 180,
          child: FloatingActionButton(
            onPressed: () {
              _navigateToNamedRoute(context, 'sakhi');
            },
            tooltip: 'Say Hi',
            materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
            heroTag: null,
            elevation: isHovered ? 8.0 : 6.0,
            backgroundColor: Color.fromARGB(255, 98, 181, 240),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(45.0),
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
          borderRadius: BorderRadius.circular(5),
        ),
        child: OutlinedButton(
          onPressed: info.onPressed,
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
  final VoidCallback onPressed;

  ButtonInfo({
    required this.color,
    required this.text,
    required this.onPressed,
    required int height,
  });
}

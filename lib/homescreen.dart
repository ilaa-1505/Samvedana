import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
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
  String _name = "";
  User? _user;

  @override
  void initState() {
    super.initState();
    _user = FirebaseAuth.instance.currentUser;
    if (_user != null) {
      _getUserData();
    }
  }

  Future<void> _getUserData() async {
    try {
      final userData = await FirebaseFirestore.instance
          .collection('users')
          .doc(_user!.uid)
          .get();

      if (userData.exists) {
        setState(() {
          _name = userData.data()?['name'] ?? "";
        });
      }
    } catch (e) {
      print("Error retrieving user data: $e");
    }
  }

  void _navigateToNamedRoute(BuildContext context, String routeName) {
    Navigator.of(context).pushReplacementNamed(routeName);
  }

  @override
  Widget build(BuildContext context) {
    List<ButtonInfo> buttonsInfo = [
      ButtonInfo(
        color: const Color.fromARGB(255, 246, 166, 54),
        text: 'Assessment Test',
        icon: Icons.assessment,
        onPressed: () {
          _navigateToNamedRoute(context, 'quiz');
        },
      ),
      ButtonInfo(
        color: const Color.fromARGB(255, 246, 166, 54),
        text: 'Personality Test',
        icon: Icons.person,
        onPressed: () {},
      ),
      ButtonInfo(
        color: const Color.fromARGB(255, 246, 166, 54),
        text: 'Coping Mechanisms',
        icon: Icons.lightbulb,
        onPressed: () {
          _navigateToNamedRoute(context, 'journal');
        },
      ),
    ];

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        centerTitle: true,
        toolbarHeight: 120,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Hi $_name!',
              style: GoogleFonts.poppins(
                textStyle: const TextStyle(
                  color: Colors.black,
                  fontSize: 36,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Container(
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Color.fromARGB(255, 248, 203, 134),
              ),
              child: IconButton(
                icon: const Icon(
                  Icons.person_rounded,
                  color: Colors.black,
                  size: 35,
                ),
                onPressed: () {
                  _navigateToNamedRoute(context, 'profile');
                },
                splashRadius: 10,
              ),
            )
          ],
        ),
      ),
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/bgr2.jpeg"),
            fit: BoxFit.cover,
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              const SizedBox(height: 30),
              Column(
                children: buttonsInfo
                    .map(
                      (info) => Padding(
                        padding: const EdgeInsets.symmetric(vertical: 13),
                        child: buildLargeButton(info),
                      ),
                    )
                    .toList(),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: MouseRegion(
        onEnter: (_) {
          setState(() {
            isHovered = true;
          });
        },
        onExit: (_) {
          setState(() {
            isHovered = false;
          });
        },
        child: GestureDetector(
          onTap: () {
            _navigateToNamedRoute(context, 'sakhi');
          },
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            width: isHovered ? 200 : 160,
            height: isHovered ? 200 : 50,
            decoration: BoxDecoration(
              // ignore: prefer_const_constructors
              color: Color.fromARGB(255, 248, 159, 34),
              borderRadius: BorderRadius.circular(40.0),
            ),
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.person,
                  color: Color.fromARGB(255, 0, 0, 0),
                ),
                SizedBox(width: 8),
                Text(
                  'Sakhi here',
                  style: TextStyle(
                    fontSize: 16,
                    color: Color.fromARGB(255, 0, 0, 0),
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget buildLargeButton(ButtonInfo info) {
    return Container(
      width: 250,
      height: 170,
      decoration: BoxDecoration(
        color: info.color,
        borderRadius: BorderRadius.circular(10),
      ),
      child: ElevatedButton(
        onPressed: info.onPressed,
        style: ElevatedButton.styleFrom(
          foregroundColor: Colors.transparent,
          backgroundColor: Colors.transparent,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(0),
          ),
          minimumSize: const Size(0, 0),
          visualDensity: VisualDensity.compact,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              info.icon,
              size: 100,
              color: const Color.fromARGB(255, 255, 255, 255),
            ),
            const SizedBox(height: 5),
            Text(
              info.text,
              style: GoogleFonts.titilliumWeb(
                fontSize: 20,
                color: const Color.fromARGB(255, 3, 3, 3),
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

class ButtonInfo {
  final String text;
  final IconData icon;
  final VoidCallback onPressed;
  final Color color;

  ButtonInfo({
    required this.text,
    required this.icon,
    required this.onPressed,
    required this.color,
  });
}

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Your App Title',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Your App Title'),
    );
  }
}

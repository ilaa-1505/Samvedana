import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
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
  String _email = "";
  int _phoneNum = 0;
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneNumController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  User? _user;

  @override
  void initState() {
    super.initState();
    _user = _auth.currentUser;
    if (_user != null) {
      _getUserData();
    }
  }

  Future<void> _getUserData() async {
    try {
      final userData =
      await _firestore.collection('users').doc(_user!.uid).get();

      if (userData.exists) {
        if (kDebugMode) {
          if (kDebugMode) {
            print("User data exists");
          }
        }
        String newName = userData.data()?['name'] ?? "";
        if (kDebugMode) {
          print("Retrieved name: $newName");
        }

        setState(() {
          _name = newName;
          _email = userData.data()?['email'] ?? "";
          _phoneNum = userData.data()?['phone_num'] ?? 0;
          _nameController.text = _name;
          _emailController.text = _email;
          _phoneNumController.text = _phoneNum.toString();
        });
      } else {
        if (kDebugMode) {
          print("User data does not exist");
        }
      }
    } catch (e) {
      if (kDebugMode) {
        print("Error retrieving user data: $e");
      }
    }
  }

  void _navigateToNamedRoute(BuildContext context, String routeName) {
    Navigator.of(context).pushReplacementNamed(routeName);
  }

  @override
  Widget build(BuildContext context) {
    const LinearGradient gradient = LinearGradient(
      begin: Alignment.bottomLeft,
      end: Alignment.topRight,
      colors: [
        // Color(0xFF025043),
        Color(0xED000000),
        Color(0xFFFFFFFF),
        // Color(0xFF048C7F),
        // Color(0xFF05998C),
        // Color(0xFF4FB9AF),// Replace with your desired start color
        // Replace with your desired end color
      ],
    );

    const SizedBox(
      height: 145,
    );

    List<ButtonInfo> buttonsInfo = [
      ButtonInfo(
        startColor: const Color(0xFFF241DA), // Replace with your desired start color
        endColor: const Color(0xFFF74FD9),
        text: 'Assessment Test',
        icon: Icons.assessment,
        onPressed: () {
          _navigateToNamedRoute(context, 'quiz');
        },
      ),
      ButtonInfo(
        startColor: const Color(0xFFF241DA), // Replace with your desired start color
        endColor: const Color(0xFFF74FD9),
        text: 'Personality Test',
        icon: Icons.person,
        onPressed: () {},
      ),
      ButtonInfo(
        startColor: const Color(0xFFF241DA), // Replace with your desired start color
        endColor: const Color(0xFFF74FD9),
        text: 'Coping Mechanisms',
        icon: Icons.lightbulb,
        onPressed: () {
          _navigateToNamedRoute(context, 'journal');
        },
      ),
    ];
    if (kDebugMode) {
      print(_name);
    }
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        toolbarHeight: 100,
        elevation: 0.0,
        automaticallyImplyLeading: false,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Hi $_name!',
              style: GoogleFonts.poppins(
                textStyle: const TextStyle(
                  color: Colors.black,
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            IconButton(
              icon: const Icon(
                Icons.person_3_sharp,
                color: Colors.black,
              ),
              onPressed: () {
                _navigateToNamedRoute(context, 'profile');
              },
            ),
          ],
        ),
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: gradient, // Apply the gradient here
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              const SizedBox(height: 30),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: buttonsInfo
                      .sublist(0, 2) // Display the first 2 buttons in the first row
                      .map(
                        (info) => Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: buildLargeButton(
                        info,
                        const Color(0xFFF241DA), // Specify the start color
                        const Color(0xFF3769E3), // Specify the end color
                      ),
                    ),
                  )
                      .toList(),
                ),
              ),
              const SizedBox(height: 50), // Add space between rows
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: buttonsInfo
                      .sublist(2) // Display the third button in the second row
                      .map(
                        (info) => Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: buildLargeButton(
                        info,
                        const Color(0xFFF241DA), // Specify the start color
                        const Color(0xFF3769E3), // Specify the end color
                      ),
                    ),
                  )
                      .toList(),
                ),
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
            width: isHovered ? 200 : 180,
            height: isHovered ? 60 : 40,
            decoration: BoxDecoration(
              color: const Color.fromARGB(255, 45, 127, 138),
              borderRadius: BorderRadius.circular(45.0),
            ),
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.person_outline,
                  color: Colors.white,
                ),
                SizedBox(width: 8),
                Text(
                  'Sakhi here',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.white,
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

  Widget buildLargeButton(ButtonInfo info, Color startColor, Color endColor) {
    return Center(
      child: Container(
        width: 180,
        height: 160,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [startColor, endColor], // Define your gradient colors
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(10),
        ),
        child: ElevatedButton(
          onPressed: info.onPressed,
          style: ElevatedButton.styleFrom(
            foregroundColor: Colors.transparent,
            backgroundColor: Colors.transparent,
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            minimumSize: const Size(0, 0),
            visualDensity: VisualDensity.compact,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                info.icon,
                size: 60,
                color: Colors.white,
              ),
              const SizedBox(height: 10),
              Text(
                info.text,
                style: const TextStyle(
                  fontSize: 18,
                  color: Colors.white,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ButtonInfo {
  final String text;
  final IconData icon;
  final VoidCallback onPressed;
  final Color startColor;
  final Color endColor;

  ButtonInfo({
    required this.text,
    required this.icon,
    required this.onPressed,
    required this.startColor,
    required this.endColor,
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

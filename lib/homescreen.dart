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
        print("User data exists");
        String newName = userData.data()?['name'] ?? "";
        print("Retrieved name: $newName");

        setState(() {
          _name = newName;
          _email = userData.data()?['email'] ?? "";
          _phoneNum = userData.data()?['phone_num'] ?? 0;
          _nameController.text = _name;
          _emailController.text = _email;
          _phoneNumController.text = _phoneNum.toString();
        });
      } else {
        print("User data does not exist");
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
        color: const Color.fromARGB(255, 0, 172, 193),
        text: 'Assessment Test',
        icon: Icons.assessment,
        onPressed: () {
          _navigateToNamedRoute(context, 'quiz');
        },
      ),
      ButtonInfo(
        color: const Color.fromARGB(255, 255, 87, 34),
        text: 'Personality Test',
        icon: Icons.person,
        onPressed: () {},
      ),
      ButtonInfo(
        color: const Color.fromARGB(255, 45, 127, 138),
        text: 'Coping Mechanisms',
        icon: Icons.lightbulb,
        onPressed: () {
          _navigateToNamedRoute(context, 'journal');
        },
      ),
    ];
    print(_name);
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
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const SizedBox(height: 20),
            Column(
              children: buttonsInfo
                  .map(
                    (info) => Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      child: buildLargeButton(info),
                    ),
                  )
                  .toList(),
            ),
          ],
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
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.person_outline,
                  color: Colors.white,
                ),
                const SizedBox(width: 8),
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

  Widget buildLargeButton(ButtonInfo info) {
    return Center(
      child: Container(
        width: 180,
        height: 160,
        decoration: BoxDecoration(
          color: info.color,
          borderRadius: BorderRadius.circular(10),
        ),
        child: ElevatedButton(
          onPressed: info.onPressed,
          style: ElevatedButton.styleFrom(
            backgroundColor: info.color,
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
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
  final Color color;
  final String text;
  final IconData icon;
  final VoidCallback onPressed;

  ButtonInfo({
    required this.color,
    required this.text,
    required this.icon,
    required this.onPressed,
  });
}

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Your App Title',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Your App Title'),
    );
  }
}

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
  late User user; // Declare user variable
  late String name = "User"; // Declare uid variable

  // Initialize user and uid in initState
  @override
  void initState() {
    super.initState();
    user = FirebaseAuth.instance.currentUser!;
    name = user.displayName ??
        "User"; // Use the user's displayName or provide a default value
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
        icon: Icons.assessment, // Add an icon
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
              'Hi $name!',
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
                info.icon, // Add the specified icon to the button
                size: 60, // Adjust icon size as needed
                color: Colors.white, // Icon color
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
  final IconData icon; // Add an icon property
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
      // ... (Other configurations/routes)
    );
  }
}

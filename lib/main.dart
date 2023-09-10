import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:samveadana/auth/login.dart';
import 'package:samveadana/auth/otp.dart';
import 'homescreen.dart';
import 'profile.dart';
import 'coping/journal.dart';
import 'quiz/depression_test.dart';
import 'package:samveadana/auth/user_provider.dart';
import 'chat_bot/chat_screen.dart';// Import the UserProvider class

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => UserProvider()), // Provide UserProvider
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);

    // Check if the user is logged in based on UserProvider's isLoggedIn property
    String initialRoute = userProvider.isLoggedIn ? 'home' : 'login';
    print('Initial route: $initialRoute'); // Add this line for debugging

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: 'home',
      routes: {
        'login': (context) => const Myphone(),
        'otp': (context) => const Myotp(),
        'home': (context) => const MyHomePage(title: ''),
        'profile': (context) => const ProfilePage(),
        'journal' : (context) => const JournalPage(),
        'quiz' : (context) => QuizScreen(),
        'sakhi' : (context) => const ChatScreen(),
      },
    );
  }
}

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:samveadana/auth/login.dart';
import 'package:samveadana/auth/otp.dart';
import 'homescreen.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    initialRoute: 'login',
    routes: {
      'login': (context) => const Myphone(), // Assuming MyLogin is your login page
      'otp': (context) => const Myotp(),
      'home': (context) => const MyHomePage(title: '',),// Assuming MyOtp is your OTP page
    },
  ));
}

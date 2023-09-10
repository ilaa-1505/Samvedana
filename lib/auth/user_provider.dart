import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserProvider with ChangeNotifier {
  final FirebaseAuth auth = FirebaseAuth.instance;
  User? _user;
  bool _isLoggedIn = false;

  User? get user => _user;

  bool get isLoggedIn => _isLoggedIn;

  UserProvider() {
    loadUserState();
    auth.authStateChanges().listen((User? user) {
      _user = user;
      saveUserState();
      notifyListeners();
    });
  }

  // Load user state from shared preferences or any other local storage method
  Future<void> loadUserState() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _isLoggedIn = prefs.getBool('isLoggedIn') ?? false;
  }

  // Save user state to shared preferences or any other local storage method
  Future<void> saveUserState() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool('isLoggedIn', _isLoggedIn);
  }

  Future<void> login() async {
    try {
      // Implement your login logic here using Firebase Authentication
      // For example, you can use Firebase Phone Authentication or Email/Password Authentication
      // Once the user is logged in successfully, Firebase will automatically persist the authentication state

      // Set isLoggedIn to true when the user is logged in
      _isLoggedIn = true;
      saveUserState();
    } catch (error) {
      // Handle login errors
    }
  }

  Future<void> logout() async {
    await auth.signOut();

    // Set isLoggedIn to false when the user logs out
    _isLoggedIn = false;
    saveUserState();
  }
}

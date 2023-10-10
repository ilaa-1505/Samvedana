import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_fonts/google_fonts.dart';

import 'auth/login.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  User? _user;
  String _name = "";
  String _email = "";
  int _phoneNum = 0;
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneNumController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  bool _isEditing = false;

  @override
  void initState() {
    super.initState();
    _user = _auth.currentUser;
    _getUserData();
  }

  Future<void> _getUserData() async {
    final userData = await _firestore.collection('users').doc(_user!.uid).get();
    setState(() {
      _name = userData.data()?['name'] ?? "";
      _email = userData.data()?['email'] ?? "";
      _phoneNum = userData.data()?['phone_num'] ?? 0;
      _nameController.text = _name;
      _emailController.text = _email;
      _phoneNumController.text = _phoneNum.toString();
    });
  }

  Future<void> _updateUserData(
      String newName, int newPhoneNum, String newEmail) async {
    try {
      final userDocRef = _firestore.collection('users').doc(_user!.uid);

      Map<String, dynamic> userData = {
        'name': newName,
        'phone_num': newPhoneNum,
        'email': newEmail,
      };

      await userDocRef.update(userData);

      setState(
        () {
          _name = newName;
          _phoneNum = newPhoneNum;
          _email = newEmail;
          _isEditing = false; // Exit editing mode after saving
        },
      );
    } catch (e) {
      print("ERROR");
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      return const Scaffold(
        body: Center(
          child: Text('Please log in to access this page.'),
        ),
      );
    }
    return Center(
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            "Profile",
            style: GoogleFonts.poppins(
              color: Colors.black,
              fontSize: 25,
              fontWeight: FontWeight.bold,
            ),
          ),
          backgroundColor: Colors.transparent,
          elevation: 0, // Remove the shadow
          leading: IconButton(
            onPressed: () {
              Navigator.pushNamedAndRemoveUntil(
                  context, 'home', (route) => false);
            },
            icon: const Icon(
              Icons.arrow_back_ios_rounded,
              color: Color.fromARGB(255, 0, 0, 0),
            ),
          ),
        ),
        body: Container(
          margin: const EdgeInsets.symmetric(horizontal: 40),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                const SizedBox(height: 30),
                const CircleAvatar(
                  radius: 90,
                  backgroundColor: Color.fromARGB(255, 247, 206, 135),
                  child: Icon(
                    Icons.person,
                    size: 100,
                    color: Color.fromARGB(255, 0, 0, 0),
                  ),
                ),
                const SizedBox(height: 20),
                _buildEditableField("Name", _nameController),
                _buildEditableField("Email", _emailController),
                _buildEditableField("Phone Number", _phoneNumController),
                const SizedBox(height: 15),
                ElevatedButton(
                  onPressed: () async {
                    if (_isEditing) {
                      String newName = _nameController.text;
                      int newPhoneNum =
                          int.tryParse(_phoneNumController.text) ?? 0;
                      String newEmail = _emailController.text;
                      await _updateUserData(newName, newPhoneNum, newEmail);

                      setState(() {
                        _isEditing = false; // Exit editing mode after saving
                      });
                    } else {
                      setState(() {
                        _isEditing = true;
                      });
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _isEditing
                        ? const Color.fromARGB(255, 249, 187, 55)
                        : const Color.fromARGB(255, 249, 187, 55),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    padding: const EdgeInsets.all(10),
                  ),
                  child: Text(_isEditing ? "Save" : "Edit"),
                ),
                const SizedBox(height: 15),
                ElevatedButton(
                  onPressed: () async {
                    await _auth.signOut();
                    Navigator.of(context).pushReplacement(
                      MaterialPageRoute(
                        builder: (context) => const Myphone(),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(255, 249, 187, 55),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: const Text("Log Out"),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildEditableField(String label, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
        ),
        readOnly: !_isEditing,
      ),
    );
  }
}

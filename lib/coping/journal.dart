import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:samveadana/coping/app_style.dart';
import 'package:samveadana/coping/note_card.dart';

class JournalPage extends StatefulWidget {
  const JournalPage({super.key});

  @override
  _JournalPageState createState() => _JournalPageState();
}

class _JournalPageState extends State<JournalPage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        backgroundColor: AppStyle.mainColor,
        appBar: AppBar(
          elevation: 0.0,
          title: Text(
            "Your Journals",
            style: GoogleFonts.poppins(color: Colors.white, fontSize: 25),
          ),
          centerTitle: true,
          backgroundColor: AppStyle.mainColor,
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Your recent notes",
                style: GoogleFonts.poppins(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 22.0),
              ),
              SizedBox(
                height: 20.0,
                child: ListView(
                  shrinkWrap: true,
                ),
              ),
              Expanded(
                child: StreamBuilder<QuerySnapshot>(
                    stream: FirebaseFirestore.instance
                        .collection("Notes")
                        .snapshots(),
                    builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Center(
                          child: CircularProgressIndicator(
                            color: Colors.white,
                          ),
                        );
                      }
                      if (snapshot.hasData) {
                        return GridView(
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 2),
                          children: snapshot.data!.docs
                              .map((note) => noteCard(() {}, note))
                              .toList(),
                        );
                      }
                      return Text(
                        "There are no notes",
                        style: GoogleFonts.poppins(color: Colors.white),
                      );
                    }),
              )
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton.extended(
          onPressed: () {},
          label: Text("Add note"),
          icon: Icon(Icons.add),
        ),
      ),
    );
  }
}

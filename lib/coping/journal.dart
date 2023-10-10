import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:samveadana/coping/app_style.dart';
import 'package:samveadana/coping/note_card.dart';
import 'package:samveadana/coping/note_editor.dart';
import 'package:samveadana/coping/note_reader.dart';
import 'package:samveadana/homescreen.dart';

class JournalPage extends StatefulWidget {
  const JournalPage({super.key});

  @override
  _JournalPageState createState() => _JournalPageState();
}

class _JournalPageState extends State<JournalPage> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        extendBodyBehindAppBar: true, // Extend body behind AppBar
        appBar: AppBar(
          elevation: 0.0,
          title: Text(
            "Your Journals",
            style: GoogleFonts.poppins(color: Colors.black, fontSize: 25),
          ),
          centerTitle: true,
          backgroundColor: Colors.transparent, // Make AppBar transparent
          leading: IconButton(
            icon: const Icon(
              Icons.arrow_back,
              color: Colors.black,
            ),
            onPressed: () {
              Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const MyHomePage(
                      title: 'Samvedana',
                    ),
                  ));
            },
          ),
        ),
        body: Stack(
          children: [
            // Padding(
            //   padding: const EdgeInsets.fromLTRB(16.0, 0, 16.0, 16.0),
            // ),
            // Background Image
            Image.asset(
              'assets/bgr3.jpeg', // Replace with your image path
              fit: BoxFit.cover, // You can change the fit mode as needed
              width: double.infinity,
              height: double.infinity,
            ),
            Positioned.fill(
              top: kToolbarHeight + 50, left: 16, right: 16,
              //Padding(
              // padding: const EdgeInsets.only(
              //     top: kToolbarHeight + 30.0, left: 16.0, right: 16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Your recent notes",
                    style: GoogleFonts.poppins(
                        color: Colors.black,
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
                        builder:
                            (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const Center(
                              child: CircularProgressIndicator(
                                color: Colors.black,
                              ),
                            );
                          }
                          if (snapshot.hasData) {
                            return GridView(
                              gridDelegate:
                                  const SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount: 2),
                              children: snapshot.data!.docs
                                  .map((note) => noteCard(() {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  NoteReaderScreen(note),
                                            ));
                                      }, note))
                                  .toList(),
                            );
                          }
                          return Text(
                            "There are no notes",
                            style: GoogleFonts.poppins(color: Colors.black),
                          );
                        }),
                  )
                ],
              ),
            ),
          ],
        ),
        floatingActionButton: FloatingActionButton.extended(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const NoteEditorScreen()),
            );
          },
          label: Text(
            "Add note",
            style:
                GoogleFonts.poppins(fontSize: 14, fontWeight: FontWeight.w400),
          ),
          icon: const Icon(Icons.add),
          backgroundColor: Colors.black,
        ),
      ),
    );
  }
}

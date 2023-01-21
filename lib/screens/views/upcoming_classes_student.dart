import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';

class UpcomingClassesStudent extends StatefulWidget {
  Map<dynamic, dynamic> classData;
  UpcomingClassesStudent(this.classData);

  @override
  _UpcomingClassesStudentState createState() => _UpcomingClassesStudentState();
}

class _UpcomingClassesStudentState extends State<UpcomingClassesStudent> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance
              .collection(widget.classData['code'])
              .doc('Upcoming classes')
              .collection('Upcoming classes')
              .snapshots(),
          builder: (context, AsyncSnapshot<QuerySnapshot> classSnapshot) {
            if (classSnapshot.hasError) {
              return const Text('Something went wrong');
            }
            if (classSnapshot.data?.docs.length == null) {
              return const Center(child: Text('No Up Coming Lectures Available'));
            }
            if (classSnapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation(Theme.of(context).primaryColor),
              ));
            }
            return ListView.builder(
                    itemCount: classSnapshot.data?.docs.length,
                    itemBuilder: (context, index) {
                      DocumentSnapshot lectureData =
                          classSnapshot.data!.docs[index];
                      print(lectureData.data());
                      final url = TextEditingController();
                      url.text = lectureData['url'];

                      return Card(
                        child: Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Topic: ${lectureData['topics']}',
                                style: GoogleFonts.montserrat(
                                    fontWeight: FontWeight.bold, fontSize: 20),
                              ),
                              Text(
                                'Date: ${(lectureData['date'].toString())
                                        .substring(0, 10)}',
                                style: GoogleFonts.montserrat(fontSize: 15),
                              ),
                              Text('Time: ${lectureData
                                      ['time']
                                      .toString()
                                      .substring(10, 15)}'),
                              TextFormField(
                                style: const TextStyle(color: Colors.blue),
                                controller: url,
                                readOnly: true,
                              ),
                              TextButton(
                                style: TextButton.styleFrom(
                                  backgroundColor: Colors.amber,
                                ),
                                onPressed: () async {
                                  if (await canLaunch(url.text)) {
                                    launch(url.text);
                                  } else {
                                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                                        backgroundColor:
                                            Color.fromRGBO(219, 22, 47, 1),
                                        content: Text(
                                            "Can't open the provided link",
                                            style: TextStyle(
                                                color: Colors.white))));
                                  }
                                },
                                child: const Text('Open url'),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
          }),
    );
  }
}

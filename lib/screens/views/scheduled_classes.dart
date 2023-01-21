import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tweetup_fyp/util/utils.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../services/loading.dart';

class ScheduledClasses extends StatefulWidget {
  Map<dynamic, dynamic> classData;
  var subCollName;
  ScheduledClasses(this.classData, this.subCollName, {Key? key}) : super(key: key);

  @override
  _ScheduledClassesState createState() => _ScheduledClassesState();
}

class _ScheduledClassesState extends State<ScheduledClasses> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.classData['subName'].toString(),
          style: TextStyle(color: Theme.of(context).accentColor),
        ),
        iconTheme: IconThemeData(color: Theme.of(context).accentColor),
        backgroundColor: Colors.white,
      ),
      body: widget.classData.isEmpty? const Center(
        child: Icon(Icons.hourglass_empty_outlined, size: 50,),
      ): StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection(widget.classData['code'])
              .doc('Upcoming classes')
              .collection('Upcoming classes')
              .snapshots(),
          builder: (context, AsyncSnapshot classSnapshot) {
            return classSnapshot.hasData
                ? ListView.builder(
                    itemCount: classSnapshot.data.docs.length,
                    itemBuilder: (context, index) {
                      DocumentSnapshot lectureData =
                          classSnapshot.data.docs[index];
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
                                style: TextStyle(color: Colors.blue),
                                controller: url,
                                readOnly: true,
                              ),
                              TextButton(
                                style: TextButton.styleFrom(
                                  backgroundColor: Colors.amber,
                                ),
                                child: const Text('Open url'),
                                onPressed: () async {
                                  if (await canLaunch(url.text))
                                    launch(url.text);
                                  else {
                                    Utils.snackBar(message: "Can't open the provided link", context: context);
                                  }
                                },
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  )
                : Center(child: Loader());
          }),
    );
  }
}

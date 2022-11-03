import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:tweetup_fyp/screens/views/subject_class_student.dart';
import '../../constants/constants.dart';
import '../../services/loading.dart';

class EnrolledClasses extends StatelessWidget {
  static const routeName = '/enrolled-classes';
  List<Color> colorList = [
    const Color.fromRGBO(136, 14, 79, .1),
    const Color.fromRGBO(136, 14, 79, .2),
    const Color.fromRGBO(136, 14, 79, .3),
    const Color.fromRGBO(136, 14, 79, .4),
    const Color.fromRGBO(136, 14, 79, .5),
    const Color.fromRGBO(136, 14, 79, .6),
    const Color.fromRGBO(136, 14, 79, .7),
    const Color.fromRGBO(136, 14, 79, .8),
    const Color.fromRGBO(136, 14, 79, .9),
    const Color.fromRGBO(136, 14, 79, .10),
  ];

  EnrolledClasses({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;

    var colorIndex = -1;
    final String collName =
        'student ' "${ModalRoute.of(context)?.settings.arguments}";
    return Scaffold(
        appBar: AppBar(
          title: const Text(
            'All your class',
            style: TextStyle(color: Colors.black),
          ),
          iconTheme: const IconThemeData(color: Colors.black),
          backgroundColor: Colors.white,
        ),
        body: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance.collection(collName).snapshots(),
          builder:
              (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.hasError) {
              return const Text('Something went wrong');
            }

            if (snapshot.connectionState == ConnectionState.waiting) {
              return Loader();
            }
            if (kDebugMode) {
              print(snapshot.data?.docs);
            }
            return ListView(
                children: snapshot.data!.docs.map((DocumentSnapshot document) {
              colorIndex += 1;
              return Stack(
                children: [
                  Padding(
                    padding:  const EdgeInsets.all(8),
                    child: Container(
                      height: 150,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: Colors.blueGrey,
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: Column(
                        children: [
                          Text(
                            '${document['Name']}',
                            style: kPageTitleStyleBlack,
                            textAlign: TextAlign.left,
                            textDirection: TextDirection.ltr,
                          ),
                          Padding(
                            padding:  const EdgeInsets.only(
                              left: 40,
                              right: 40,
                              top: 20,
                            ),
                            child: ElevatedButton(
                             style: ElevatedButton.styleFrom(
                                 primary: Colors.teal,
                                 onPrimary: Colors.white,
                               side: const BorderSide(color: Colors.tealAccent),
                             ),
                                onPressed: (){
                              Navigator.of(context).pushNamed(
                                  SubjectClassStudent.routeName,
                                  arguments: document.data());
                            },
                                child: const Center(
                              child: Text("View Class",
                              style: kLabelStyle,),
                            )),
                          )
                        ],
                      ),
                    ),
                  ),
                ],
              );
            }).toList());
          },
        ));
  }
}

class Arguments {
  final String collectionName;

  Arguments(this.collectionName);
}

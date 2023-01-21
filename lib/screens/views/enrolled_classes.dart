import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tweetup_fyp/screens/views/subject_class_student.dart';
import 'package:tweetup_fyp/util/utils.dart';
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
              return Card(
                elevation: 10,
                shape: RoundedRectangleBorder(
                  side: const BorderSide(color: Colors.white70, width: 1),
                  borderRadius: BorderRadius.circular(10),
                ),
                margin: const EdgeInsets.all(20),
                color: Colors.white,
                child: Column(
                  // crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        PopupMenuButton(
                            itemBuilder: (ctx)=>[
                              PopupMenuItem(
                                onTap: (){
                                  Future.delayed(
                                      const Duration(microseconds: 0),
                                          ()=>showDialog(
                                          barrierDismissible: true,
                                          useSafeArea: true,
                                          context: context,
                                          builder: (ctx)=>
                                              Container(
                                                width: 300,
                                                height: 100,
                                                decoration: const BoxDecoration(
                                                  borderRadius: BorderRadius.
                                                  all(Radius.circular(8)),
                                                ),
                                                child:  BackdropFilter(
                                                  filter: ImageFilter.blur(sigmaX: 6, sigmaY: 6),
                                                  child: CupertinoAlertDialog(
                                                    title:  const Text("Alert Box"),
                                                    content: Wrap(children:  [
                                                      const Text("Do You Want to Leave"),
                                                      Text(' ${document['Name']}',
                                                        style: TextStyle(
                                                          color: Theme.of(context).primaryColor,
                                                          fontWeight: FontWeight.bold,
                                                        ),),
                                                      const Text(" Class"),
                                                    ],),
                                                    actions: [
                                                      TextButton(
                                                        onPressed: (){
                                                          Navigator.of(context).pop();
                                                        },
                                                        child:  const Text("Cancel"),
                                                      ),
                                                      TextButton(
                                                          onPressed: (){
                                                            FirebaseFirestore.instance
                                                                .collection('student ${FirebaseAuth.instance.currentUser?.email}')
                                                                .doc(document.id).delete().then((value){
                                                                  Navigator.pop(context);
                                                                  Utils.snackBar(
                                                                      message: '${document['Name']} class leave successfully',
                                                                      context: context);
                                                            });
                                                          },
                                                          child: const Text("Leave")
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              )
                                      )
                                  );
                                },
                                value: 1,
                                child: const Text("Leave Class"),
                              )
                            ]),
                      ],
                    ),
                    Center(
                      child: Padding(
                        padding:  const EdgeInsets.symmetric(
                            vertical: 20, horizontal: 5),
                        child: Text(
                          document["Name"],
                          maxLines: 1,
                          textAlign: TextAlign.start,
                          style: kPageTitleStyleBlack,
                        ),
                      ),
                    ),
                    Column(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(10),
                          width: MediaQuery.of(context).size.width * 0.8,
                          child: Material(
                            borderRadius: BorderRadius.circular(20.0),
                            shadowColor: Theme.of(context).colorScheme.secondary,
                            color: colorList[colorIndex % colorList.length],
                            child: Builder(builder: (context) {
                              return TextButton(
                                onPressed: () {
                                  Navigator.of(context).pushNamed(
                                      SubjectClassStudent.routeName,
                                      arguments: document.data());
                                },
                                child: Center(
                                  child: Text(
                                    'View class',
                                    style: GoogleFonts.questrial(
                                      fontSize: 16.0,
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                ),
                              );
                            }),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
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

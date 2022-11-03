import 'dart:ui';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:tweetup_fyp/screens/views/subject_class.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../constants/constants.dart';
import '../../services/loading.dart';

class CreatedClasses extends StatefulWidget {
  static const routeName = '/my-classes';

  @override
  State<CreatedClasses> createState() => _CreatedClassesState();
}

class _CreatedClassesState extends State<CreatedClasses> {
  List<Color> colorList = [
    const Color.fromRGBO(255, 173, 173, 1),
    const Color.fromRGBO(238, 239, 32, 1),
    const Color.fromRGBO(200, 231, 255, 1),
    const Color.fromRGBO(242, 232, 207, 1),
    const Color.fromRGBO(155, 246, 255, 1),
    // Color.fromRGBO(160, 196, 255, 1),
    const Color.fromRGBO(189, 178, 255, 1),
    const Color.fromRGBO(255, 198, 255, 1),
  ];

  showAlertDialogBox(BuildContext context,){
    Widget cancelButton = TextButton(
        onPressed: (){},
        child:  const Text("Cancel")
    );
    Widget deleteButton = TextButton(onPressed: (){

    },
        child:  Text("Delete"),
    );
    AlertDialog alertDialog =  AlertDialog(
      title:  const Text("Alert Box"),
      content: const Text  ("Do You want to delete " ),
      actions: [
        cancelButton,
        deleteButton,
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    var colorIndex = -1;
    final String collName = "${ModalRoute.of(context)?.settings.arguments}";
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
          builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.hasError) {
              return const Text('Something went wrong');
            }

            if (snapshot.connectionState == ConnectionState.waiting) {
              return Loader();
            } if(snapshot.connectionState == ConnectionState.none){
             return  const Center(child: Text("No Class"));
            }
            return  ListView(
              children: snapshot.data!.docs.map((DocumentSnapshot document) {
                colorIndex++;
                return Card(
                  elevation: 10,
                  shape: RoundedRectangleBorder(
                    side: BorderSide(color: Colors.white70, width: 1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  margin: EdgeInsets.all(20),
                  color: Colors.white,
                  child: Column(
                    // crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Align(
                        alignment: Alignment.topRight,
                        child: PopupMenuButton(
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
                                            decoration: BoxDecoration(
                                              borderRadius: BorderRadius.
                                              all(Radius.circular(8)),
                                            ),
                                            child:  BackdropFilter(
                                              filter: ImageFilter.blur(sigmaX: 6, sigmaY: 6),
                                              child: AlertDialog(
                                                title:  const Text("Alert Box"),
                                                content: Wrap(children:  [
                                                  const Text("Do You Want to Delete"),
                                                  Text(document['subName'],
                                                    style:  TextStyle(
                                                    color: const Color(0xffFF6A83),
                                                      fontSize: 18,
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
                                                        Navigator.of(context).pop();
                                                        ScaffoldMessenger.of(context).showSnackBar(
                                                          SnackBar(
                                                            content: Wrap(
                                                                clipBehavior: Clip.antiAlias,
                                                                children: [
                                                                  Text('${document['subName']}',
                                                                    style: const TextStyle(color: Colors.blue),),
                                                                  const Text(" Class deleted successfully"),]
                                                            ),
                                                            backgroundColor: Colors.pinkAccent,
                                                            behavior: SnackBarBehavior.floating,
                                                          ),
                                                        );
                                                        debugPrint("class deleted");
                                                      },
                                                      child: const Text("Delete")
                                                  ),
                                                ],
                                              ),
                                            ),
                                          )
                                  )
                              );
                              // showAlertDialogBox(context);
                              if (kDebugMode) {
                                print('PopUp menu pressed');
                              }
                            },
                            value: 1,
                            child: const Text("Delete class"),
                          )
                        ]),
                      ),
                      Center(
                        child: Padding(
                          padding:  const EdgeInsets.symmetric(
                              vertical: 20, horizontal: 5),
                          child: Text(
                            document["subName"],
                            maxLines: 1,
                            textAlign: TextAlign.start,
                            style: kPageTitleStyleBlack,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Wrap(
                          children: [
                            Text(
                              'Batch/semester: ',
                              style: kSubtitleStyle,
                            ),
                            Text(
                              document['batch'],
                              style: kSubtitleStyle,
                            ),
                          ],
                        ),
                      ),
                      Column(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(10),
                            width: MediaQuery.of(context).size.width * 0.8,
                            child: Material(
                              borderRadius: BorderRadius.circular(20.0),
                              shadowColor: Theme.of(context).accentColor,
                              color: colorList[colorIndex % colorList.length],
                              child: Builder(builder: (context) {
                                return TextButton(
                                  onPressed: () {
                                    Navigator.of(context).pushNamed(
                                        SubjectClass.routeName,
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
                          Container(
                            padding: const EdgeInsets.all(10),
                            width: MediaQuery.of(context).size.width * 0.8,
                            child: Material(
                              borderRadius: BorderRadius.circular(20.0),
                              shadowColor: Theme.of(context).accentColor,
                              color: colorList[colorIndex % colorList.length],
                              child: Builder(builder: (context) {
                                return TextButton(
                                  onPressed: () async {
                                    ClipboardData data = ClipboardData(
                                        text: (document['code']));
                                    await Clipboard.setData(data);
                                    if (kDebugMode) {
                                      print(document['code']);
                                    }
                                    ScaffoldMessenger.of(context).showSnackBar(const
                                    SnackBar(
                                      behavior: SnackBarBehavior.floating,
                                        backgroundColor:
                                            Color.fromRGBO(219, 22, 47, 1),
                                        content: Text("Code copied😁",
                                            style: TextStyle(
                                                color: Colors.white))));
                                  },
                                  child: Center(
                                    child: Text(
                                      'Copy code',
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
              }).toList(),
            );
          },
        ));
  }
}

class Arguments {
  final String collectionName;

  Arguments(this.collectionName);
}
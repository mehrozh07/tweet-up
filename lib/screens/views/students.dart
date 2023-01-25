// ignore_for_file: use_build_context_synchronously

import 'dart:ui';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:mailto/mailto.dart';
import 'package:tweetup_fyp/util/utils.dart';
import 'package:url_launcher/url_launcher.dart';

class Students extends StatefulWidget {
  Map<dynamic, dynamic> classData;
  Students(this.classData, {super.key});

  @override
  State<Students> createState() => _StudentsState();
}
class _StudentsState extends State<Students> {
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User>(context);
    var imgURL;
    imgURL = FirebaseFirestore.instance.collection('usersData').doc('imageUrl').get();
    if (user == null) {
      'https://cdn3.iconfinder.com/data/icons/user-interface-web-1/550/web-circle-circular-round_54-512.png';
    } else {
      imgURL =  imgURL ?? 'https://cdn3.iconfinder.com/data/icons/user-interface-web-1/550/web-circle-circular-round_54-512.png';
    }
    return SingleChildScrollView(
      child: SizedBox(
        height: MediaQuery.of(context).size.height -
            kBottomNavigationBarHeight -
            AppBar().preferredSize.height,
        child: Column(
          children: [
            // UserInfo(imgURL: imgURL, user: user, classData: classData),
            const Padding(
              padding: EdgeInsets.only(
                bottom: 10,
                left: 10,
                right: 10,
              ),
              child: Divider(),
            ),
            Expanded(
              // height: 200,
              child: widget.classData['studentList'].length == 0
                  ? NoStudentsEnrolled(classData: widget.classData)
                  : ListOfStudents(classData: widget.classData, user: null,),
            )
          ],
        ),
      ),
    );
  }
}

class NoStudentsEnrolled extends StatelessWidget {
  const NoStudentsEnrolled({
    required this.classData,
  });

  final Map classData;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Align(
            // alignment: Alignment.center,
            child: Text(
              '''No students have enrolled yet😅😅. Invite them now by sending the following link.
              ''',
              textAlign: TextAlign.center,
              style: GoogleFonts.questrial(fontSize: 20),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(30.0),
          child: TextButton(
            style: TextButton.styleFrom(
              backgroundColor: Theme.of(context).primaryColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              )
            ),
            onPressed: () async {
              ClipboardData data = ClipboardData(text: (classData['code']));
              await Clipboard.setData(data);
              if (kDebugMode) {
                print(classData['code']);
              }
              Utils.snackBar(message: 'Code copied😁',color: const Color(0xffFF8C00), context: context);
            },
            child: Center(
              child: Text(
                'Copy code',
                style: GoogleFonts.questrial(
                  fontSize: 16,
                  color: Colors.white,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
          ),
        )
      ],
    );
  }
}

class UserInfo extends StatelessWidget {
  const UserInfo({super.key,
      required this.imgURL,
    required this.user,
    required this.classData,
  }) ;

  final imgURL;
  final User user;
  final Map classData;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 28.0, vertical: 10),
          child: Text(
            'You are currently signed in as..',
            style: GoogleFonts.roboto(),
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 28.0, vertical: 10),
              child: Container(
                  width: 50.0,
                  height: 50.0,
                  decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      image:  DecorationImage(
                          fit: BoxFit.fill, image:  NetworkImage(imgURL)))),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 5),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(user.displayName!,
                      maxLines: 1,
                      style:
                          GoogleFonts.questrial(fontWeight: FontWeight.bold)),
                  Text(user.email!,
                      style:
                          GoogleFonts.questrial(fontWeight: FontWeight.w100)),
                ],
              ),
            )
          ],
        ),
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 28),
          child: Divider(),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Professor',
                  style: GoogleFonts.questrial(fontWeight: FontWeight.bold)),
              Text(classData['profName'].toString().toUpperCase(),
                  style: GoogleFonts.questrial(
                      fontWeight: FontWeight.w100, fontSize: 30)),
            ],
          ),
        )
      ],
    );
  }
}

class ListOfStudents extends StatefulWidget {
   const ListOfStudents({Key? key,

    required this.classData, required this.user,
  }) : super(key: key) ;

  final Map classData;
   final User? user;
  @override
  State<ListOfStudents> createState() => _ListOfStudentsState();
}

class _ListOfStudentsState extends State<ListOfStudents> {
  final FirebaseAuth _auth1 = FirebaseAuth.instance;
  var data;
  showDialogFunction(img, name) async{
  return showDialog(
  context: context,
  builder: (context) {
    return Center(
      child: Material(
        type: MaterialType.transparency,
        child: Container(
          padding: const EdgeInsets.all(15),
          height: 365,
          width: MediaQuery.of(context).size.width * 0.9,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Hero(tag: "${_auth1.currentUser?.photoURL}",
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(5),
                  child: Image.network(_auth1.currentUser!.photoURL!,
                    width: 300,
                    height: 300,
                  ),
                ),
              ),
              const SizedBox(
                height: 5,
              ),
              Align(
                alignment: Alignment.center,
                child: Text(
                  name,
                  maxLines: 3,
                  style: TextStyle(fontSize: 17, color: Colors.grey[100]),
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  },
  );
  }
  @override
  void initState() {
    super.initState();
    getData();
  }
  String? _userImageUrl;
  void getData() async{
    User? user1 =  _auth1.currentUser;
    final _uid = user1?.uid;

    final DocumentSnapshot userDoc = await FirebaseFirestore.instance.collection("usersData").doc(_uid).get();
    setState((){
      _userImageUrl = userDoc.get("imageUrl");
    });
  }
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User>(context);
    return Stack(
      children: [
        ListView.builder(
          itemCount: widget.classData['studentList'].length,
          itemBuilder: (context, index) {
            String rollNum = widget.classData['studentList'][index]['rollNum'],
                name = widget.classData['studentList'][index]['studentName'],
                email = widget.classData['studentList'][index]['email'];
            return Padding(
              padding:  const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(12),
                ),
                child:  ListTile(
                  title:  Text(name.toUpperCase(),
                    maxLines: 1,
                    style: const TextStyle(color: Colors.black),),
                  subtitle:  Text(rollNum, style: const TextStyle(
                      color: Colors.black
                  ),),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      GestureDetector(
                        onTap: () async{
                          final mailtoLink = Mailto(
                            // to: [email],
                            // cc: ['cc1@example.com', 'cc2@example.com'],
                            // subject: 'mailto example subject',
                            // body: 'mailto example body',
                          );
                          // Convert the Mailto instance into a string.
                          // Use either Dart's string interpolation
                          // or the toString() method.
                          await launch('mail:$mailtoLink');
                        },
                        child: Icon(Icons.email, color: Theme.of(context).primaryColor,),
                      ),
                      PopupMenuButton(
                        // icon: Icon(Icons.highlight_remove),
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
                                                    const Text("Do You Want to remove "),
                                                    Text(name =
                                                      widget.classData['studentList']
                                                      [index]['studentName'],
                                                      style: TextStyle(
                                                        color: Theme.of(context).primaryColor,
                                                        fontSize: 18,
                                                      ),),
                                                    const Text(" from class"),
                                                  ],),
                                                  actions: [
                                                    TextButton(
                                                      onPressed: (){
                                                        Navigator.of(context).pop();
                                                      },
                                                      child:  const Text("Cancel"),
                                                    ),
                                                    TextButton(
                                                        onPressed: () async{

                                                        },
                                                        child: const Text("Remove")
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
                              child: const Text("Remove student"),
                            )
                          ]),
                    ],
                  ),
                  leading: GestureDetector(
                    onTap: (){
                      showDialogFunction(_userImageUrl, '${ name = widget.classData['studentList'][index]['studentName']}');
                    },
                    child: StreamBuilder(
                        stream: FirebaseFirestore.instance.collection("usersData").doc(user.uid).snapshots(),
                        builder: (context,  snapshot,){
                          if(snapshot.connectionState == ConnectionState.waiting){
                            return Container(
                              width: 60,
                              height: 70,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                    color: Theme.of(context).primaryColor,
                                    width: 1
                                ),
                              ),
                              child:  Transform.scale(
                                  scale: 0.5,
                                  child: const CircularProgressIndicator()),
                            );
                          }
                          return Hero(
                            tag: "${user.photoURL}",
                            child: Container(
                              width: 60,
                              height: 70,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                    color: Theme.of(context).primaryColor,
                                    width: 1
                                ),
                                image: DecorationImage(
                                  fit: BoxFit.fill,
                                  image:  NetworkImage(user.photoURL!),
                                ),
                              ),
                            ),
                          );
                        }),
                  ),

                ),
              ),
            );
          },
        ),
      ],

    );
  }
}

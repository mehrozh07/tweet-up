
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../../models/error.dart';
import '../../services/database.dart';
import '../../services/loading.dart';
import '../../widgets/formFields.dart';

class JoinClass extends StatefulWidget {
  static const routeName = '/join-class';

  @override
  _JoinClassState createState() => _JoinClassState();
}

class _JoinClassState extends State<JoinClass> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final rollNum = TextEditingController();

  final code = TextEditingController();
  bool exists = true;

  Future<void> checkExistence() async {
    var allClasses = FirebaseFirestore.instance.collection('allClasses');
    setState(() {
      _loading = true;
    });
    DocumentSnapshot data = await allClasses.doc(code.text).get();
    setState(() {
      _loading = false;
    });
    if (data.data() == null) {
      setState(() {
        exists = false;
        message = 'does not exist';
      });
    } else {
      setState(() {
        exists = true;
      });
      print('exists');
    }
  }

  final name = TextEditingController();
  String message = ' ';
  bool _loading = false;
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User>(context);
    var imgURL;
    if (user == null) {
      imgURL =
          'https://cdn3.iconfinder.com/data/icons/user-interface-web-1/550/web-circle-circular-round_54-512.png';
    } else {
      imgURL = user.photoURL ?? 'https://cdn3.iconfinder.com/data/icons/user-interface-web-1/550/web-circle-circular-round_54-512.png';
    }
    name.text = user.displayName!;
    return _loading
        ? Loader()
        : Scaffold(
            appBar: AppBar(
              title: Text(
                'Join a class',
                style: TextStyle(color: Theme.of(context).accentColor),
              ),
              iconTheme: IconThemeData(color: Theme.of(context).accentColor),
              backgroundColor: Colors.white,
            ),
            body: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Padding(
                  //   padding: const EdgeInsets.symmetric(
                  //       horizontal: 28.0, vertical: 10),
                  //   child: Text(
                  //     'You are currently signed in as..',
                  //     style: GoogleFonts.roboto(),
                  //   ),
                  // ),
                  // Row(
                  //   mainAxisAlignment: MainAxisAlignment.start,
                  //   children: [
                  //     Padding(
                  //       padding: const EdgeInsets.symmetric(
                  //           horizontal: 28.0, vertical: 10),
                  //       child: Container(
                  //           width: 50.0,
                  //           height: 50.0,
                  //           decoration:  BoxDecoration(
                  //               shape: BoxShape.circle,
                  //               image:  DecorationImage(
                  //                   fit: BoxFit.fill,
                  //                   image:  NetworkImage(imgURL)))),
                  //     ),
                  //     Padding(
                  //       padding: const EdgeInsets.symmetric(vertical: 5),
                  //       child: Column(
                  //         crossAxisAlignment: CrossAxisAlignment.start,
                  //         children: [
                  //           Text(user.displayName!,
                  //               style: GoogleFonts.questrial(
                  //                   fontWeight: FontWeight.bold)),
                  //           Text(user.email!,
                  //               style: GoogleFonts.questrial(
                  //                   fontWeight: FontWeight.w100)),
                  //         ],
                  //       ),
                  //     )
                  //   ],
                  // ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 28),
                    child: const Divider(),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          formField(rollNum, 'Roll number', context),
                          formField(code, 'Enter code', context),
                          Text(message),
                          Container(
                            padding: const EdgeInsets.all(10),
                            width: MediaQuery.of(context).size.width * 0.8,
                            child: Material(
                              borderRadius: BorderRadius.circular(20.0),
                              shadowColor: Theme.of(context).accentColor,
                              color: Theme.of(context).accentColor,
                              child: Builder(builder: (context) {
                                return TextButton(
                                  onPressed: () async {
                                    if (_formKey.currentState!.validate()) {
                                      await checkExistence();
                                      if (exists) {
                                        print(exists);
                                        setState(() {
                                          _loading = true;
                                        });
                                        String str = code.text;
                                        late int index;
                                        for (int i = 0; i < str.length; ++i) {
                                          if (str[i] == '.' &&
                                              str[i + 1] == 'c' &&
                                              str[i + 2] == 'o' &&
                                              str[i + 3] == 'm') index = i + 3;
                                        }
                                        var error = ErrorMsg(' ');
                                        String teacherId =
                                            str.substring(0, index + 1);
                                        var db = JoinClassDataBase(
                                            code.text,
                                            rollNum.text,
                                            teacherId,
                                            name.text,
                                            user.email!,
                                            error);
                                        await db.JoinClass();
                                        setState(() {
                                          _loading = false;
                                          message = error.error;
                                        });
                                      } else {}
                                    }
                                  },
                                  child: Text(
                                    'Join the class',
                                    style: TextStyle(color: Colors.white),
                                  ),
                                );
                              }),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 28),
                    child: Divider(),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 28.0, vertical: 10),
                    child: Text(
                      'To sign in with a class code',
                      style: GoogleFonts.roboto(
                          fontWeight: FontWeight.bold, fontSize: 15),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 28.0, vertical: 10),
                    child: Text(
                      '🌟🌟Ask your teacher for the class code and input above.',
                      style: GoogleFonts.roboto(fontSize: 15),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 28.0, vertical: 10),
                    child: Text(
                      '🌟🌟Make sure you have entered correct roll number, and entered real name during registration. Because you won\'t be able to join the same class using this account.',
                      style: GoogleFonts.roboto(fontSize: 15),
                    ),
                  ),
                ],
              ),
            ),
          );
  }
}

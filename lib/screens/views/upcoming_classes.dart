import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:tweetup_fyp/screens/views/scheduled_classes.dart';
import 'package:tweetup_fyp/services/database.dart';
import 'package:tweetup_fyp/services/firestore_service.dart';
import 'package:tweetup_fyp/util/utils.dart';
import '../../models/error.dart';
import '../../services/loading.dart';
import '../../widgets/formFields.dart';

class UpcomingClasses extends StatefulWidget {
  Map<dynamic, dynamic> classData;
  UpcomingClasses(this.classData);

  @override
  _UpcomingClassesState createState() => _UpcomingClassesState();
}

class _UpcomingClassesState extends State<UpcomingClasses> {
  String msg = 'Schedule a class.';
  String? subCollName;
  bool _loading = false;
  DateTime selectedDate = DateTime.now();
  Future<Null> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        firstDate: DateTime(2015, 8),
        lastDate: DateTime(2101));
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
      });
    }
  }

  TimeOfDay _time = TimeOfDay.now();

  Future<Null> selectTime(context) async {
    _time = TimeOfDay.now();
    TimeOfDay? picked =
        await showTimePicker(context: context, initialTime: _time);

    setState(() {
      _time = picked!;
    });
    print(_time);
  }

  final url = TextEditingController();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final topics = TextEditingController();
  String mToken = 'ok';
  FirestoreService firestoreService = FirestoreService();
  void getToken() async{
    await FirebaseMessaging.instance.getToken().then((token){
      if(token!.isNotEmpty){
        setState(() {
          mToken = token;
          firestoreService.saveToke(token);
          if (kDebugMode) {
            print("my Device Toke$token");
          }
        });
      }
    });
  }
  @override
  void initState() {
    FirestoreService.requestPermission(context);
    getToken();
    FirestoreService.initInfo(context);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User>(context);
    if (kDebugMode) {
      print(mToken);
    }
    String imgURL;
    if (user == null) {
      imgURL = 'https://cdn3.iconfinder.com/data/icons/user-interface-web-1/550/web-circle-circular-round_54-512.png';
    } else {
      imgURL = user.photoURL ?? 'https://cdn3.iconfinder.com/data/icons/user-interface-web-1/550/web-circle-circular-round_54-512.png';
    }
    return _loading
        ? Loader()
        : Scaffold(
            body: SingleChildScrollView(
              child: SizedBox(
                height: MediaQuery.of(context).size.height - kBottomNavigationBarHeight -
                    AppBar().preferredSize.height,
                child: Column(
                  children: [
                    Text(
                      msg,
                      style: GoogleFonts.questrial(
                        fontSize: 15.0,
                        // fontWeight: FontWeight.w900,
                        color: Colors.black,
                        wordSpacing: 2.5,
                      ),
                    ),
                    Form(
                      key: _formKey,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          children: [
                            formField(url, 'Meeting url', context),
                            formField(topics, 'Lecture topic', context),
                            SizedBox(
                              width: MediaQuery.of(context).size.width * 0.8,
                              child: TextButton(
                                onPressed: () => _selectDate(context),
                                child: Text(
                                  'Selected date ${"${selectedDate.toLocal()}".split(' ')[0]}',
                                ),
                              ),
                            ),
                            SizedBox(
                              width: MediaQuery.of(context).size.width * 0.8,
                              child: TextButton(
                                onPressed: () => selectTime(context),
                                child: Text(_time == null
                                    ? 'Selected time'
                                    : 'Selected time${_time.format(context)}'),
                              ),
                            ),
                            Builder(builder: (context) {
                              return Row(
                                children: [
                                  Expanded(
                                    child: TextButton(
                                      style: TextButton.styleFrom(
                                        backgroundColor: Theme.of(context).primaryColor,
                                        shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(10)
                                        ),
                                      ),
                                      onPressed: () async {
                                        setState(() {
                                          _loading = true;
                                        });
                                        if (_formKey.currentState!.validate()) {
                                          subCollName = topics.text;
                                          ErrorMsg error =  ErrorMsg(' ');
                                          var db = ScheduleClass(
                                              code: widget.classData['code'],
                                              date: selectedDate.toLocal(),
                                              error: error,
                                              time: _time,
                                              topics: topics.text,
                                              url: url.text);
                                          await db.scheduleClass();
                                          DocumentSnapshot snapshot = await FirebaseFirestore.instance.collection('users').
                                          doc(user.email).get();
                                          setState(() {
                                            String token = snapshot['token'];
                                            FirestoreService.sendPushNotification(
                                              title: url.text.toString(),
                                              body: topics.text.toString(),
                                              token: token,
                                            );
                                          });
                                          setState(() {
                                            url.clear();
                                            topics.clear();
                                            _loading = false;
                                            msg = error.error;
                                          });

                                        }else{
                                          Utils.snackBar(message: "scheduled class cant be empty", context: context, color: Colors.redAccent);
                                        }
                                      },
                                      child: const Text(
                                        'Schedule class',
                                        style: TextStyle(color: Colors.white),
                                      ),
                                    ),
                                  ),
                                ],
                              );
                            }),
                            Builder(builder: (context) {
                              return Row(
                                children: [
                                  Expanded(
                                    child: TextButton(
                                      style: TextButton.styleFrom(
                                        backgroundColor: Theme.of(context).primaryColor,
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(10)
                                        ),
                                      ),
                                      onPressed: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  ScheduledClasses(widget.classData,
                                                      subCollName)),
                                        );
                                      },
                                      child: const Text(
                                        'View scheduled classes',
                                        style: TextStyle(
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              );
                            }),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
  }
}

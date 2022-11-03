import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:tweetup_fyp/screens/views/scheduled_classes.dart';

import '../../models/error.dart';
import '../../services/database.dart';
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
    return _loading
        ? Loader()
        : Scaffold(
            body: SingleChildScrollView(
              child: Container(
                height: MediaQuery.of(context).size.height -
                    kBottomNavigationBarHeight -
                    AppBar().preferredSize.height,
                child: Column(
                  children: [
                    // Row(
                    //   mainAxisAlignment: MainAxisAlignment.start,
                    //   children: [
                    //     Padding(
                    //       padding:  EdgeInsets.symmetric(
                    //           horizontal: 28.w, vertical: 10.h),
                    //       child: Container(
                    //           width: 50.w,
                    //           height: 50.h,
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
                      padding: const EdgeInsets.symmetric(
                          horizontal: 28.0, vertical: 10),
                      child: Text(
                        msg,
                        style: GoogleFonts.questrial(
                          fontSize: 15.0,
                          // fontWeight: FontWeight.w900,
                          color: Colors.black,
                          wordSpacing: 2.5,
                        ),
                      ),
                    ),
                    Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 28),
                            child: formField(url, 'Meeting url', context),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 28),
                            child: formField(topics, 'Lecture topic', context),
                          ),
                          Container(
                            width: MediaQuery.of(context).size.width * 0.8,
                            child: TextButton(
                              onPressed: () => _selectDate(context),
                              child: Text(
                                'Selected date ${"${selectedDate.toLocal()}".split(' ')[0]}',
                              ),
                            ),
                          ),
                          Container(
                            width: MediaQuery.of(context).size.width * 0.8,
                            child: TextButton(
                              onPressed: () => selectTime(context),
                              child: Text(_time == null
                                  ? 'Selected time'
                                  : 'Selected time${_time.format(context)}'),
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.only(bottom: 10),
                            width: MediaQuery.of(context).size.width * 0.8,
                            child: Material(
                              borderRadius: BorderRadius.circular(20.0),
                              shadowColor: Theme.of(context).accentColor,
                              color: Theme.of(context).accentColor,
                              child: Builder(builder: (context) {
                                return ElevatedButton(
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
                                      setState(() {
                                        url.text = '';
                                        topics.text = '';
                                        _loading = false;
                                        msg = error.error;
                                      });
                                    }
                                  },
                                  child: const Text(
                                    'Schedule class',
                                    style: TextStyle(color: Colors.white),
                                  ),
                                );
                              }),
                            ),
                          ),
                          Container(
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(
                                  color: Theme.of(context).accentColor,
                                )),
                            // padding: EdgeInsets.all(10),
                            width: MediaQuery.of(context).size.width * 0.8,
                            child: Material(
                              borderRadius: BorderRadius.circular(
                                20.0,
                              ),
                              shadowColor: Theme.of(context).accentColor,
                              child: Builder(builder: (context) {
                                return TextButton(
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              ScheduledClasses(widget.classData,
                                                  subCollName)),
                                    );
                                  },
                                  child: Text(
                                    'View scheduled classes',
                                    style: TextStyle(
                                      color: Theme.of(context).accentColor,
                                    ),
                                  ),
                                );
                              }),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
  }
}

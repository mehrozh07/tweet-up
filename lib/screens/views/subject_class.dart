import 'package:flutter/material.dart';
import 'package:tweetup_fyp/screens/views/students.dart';
import 'package:tweetup_fyp/screens/views/upcoming_classes.dart';
import 'class_announcements.dart';
import 'classwork.dart';

class SubjectClass extends StatefulWidget {
  static const routeName = '/subject-class';

  @override
  _SubjectClassState createState() => _SubjectClassState();
}

class _SubjectClassState extends State<SubjectClass> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    Map<dynamic, dynamic> classData = ModalRoute.of(context)?.settings.arguments as dynamic;
    final tabs = [
      Announcements(classData),
      Classwork(classData),
      Students(classData),
      UpcomingClasses(classData),
    ];
    return Scaffold(
      appBar: AppBar(
        title: Text(
          classData['subName'].toString(),
          style: TextStyle(color: Theme.of(context).accentColor),
        ),
        iconTheme: IconThemeData(color: Theme.of(context).accentColor),
        backgroundColor: Colors.white,
      ),
      body: tabs[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.lightGreen,
        unselectedItemColor: Colors.grey,
        selectedItemColor: Theme.of(context).primaryColor,
        currentIndex: _currentIndex,
        items: const [
          BottomNavigationBarItem(
              icon: Icon(
                Icons.stream,
              ),
              label: 'announcement'),
          BottomNavigationBarItem(
              icon: Icon(
                Icons.class_,
              ),
              label: 'classwork'),
          BottomNavigationBarItem(
              icon: Icon(
                Icons.people,
              ),
              label: 'Students'),
          BottomNavigationBarItem(
              icon: Icon(
                Icons.meeting_room,
              ),
              label: 'upcoming lectures'),
        ],
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
      ),
    );
  }
}

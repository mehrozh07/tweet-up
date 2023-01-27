import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tweetup_fyp/screens/views/submit_view_classwork.dart';
import 'package:tweetup_fyp/screens/views/upcoming_classes_student.dart';
import 'class_announcements.dart';

class SubjectClassStudent extends StatefulWidget {
  static const routeName = '/subject-class-student';

  @override
  _SubjectClassStudentState createState() => _SubjectClassStudentState();
}

class _SubjectClassStudentState extends State<SubjectClassStudent> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    Map<dynamic, dynamic> classData = ModalRoute.of(context)?.settings.arguments as dynamic;
    final tabs = [
      Announcements(classData),
      SubmitClasswork(classData),
      UpcomingClassesStudent(classData),
    ];
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          classData['Name'].toString(),
          style: TextStyle(color: Theme.of(context).colorScheme.secondary),
        ),
        iconTheme: IconThemeData(color: Theme.of(context).colorScheme.secondary),
        backgroundColor: Colors.white,
      ),
      body: tabs[_currentIndex],
      bottomNavigationBar: NavigationBarTheme(
        data: NavigationBarThemeData(
          indicatorColor: Colors.blue.shade50,
          labelTextStyle: MaterialStateProperty.all(
              const TextStyle(fontSize: 14, fontWeight: FontWeight.w500)
          ),
        ),
        child: NavigationBar(
          height: 60,
          labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
          selectedIndex: _currentIndex,
          animationDuration: const Duration(seconds: 3),
          onDestinationSelected: (index)=>{
            setState((){
              _currentIndex = index;
            })
          },
          backgroundColor: Colors.blue.shade100,
            destinations: const [
              NavigationDestination(
                icon: Icon(Icons.announcement_outlined),
                label: 'asseveration',
                selectedIcon: Icon(Icons.announcement_outlined ),
              ),
              NavigationDestination(
                icon: Icon(CupertinoIcons.rectangle_grid_2x2),
                selectedIcon: Icon(CupertinoIcons.rectangle_grid_2x2,
                  color:  Color(0xFF223263),),
                label: 'Classwork',
              ),
              NavigationDestination(
                icon: Icon(Icons.upcoming_outlined),
                selectedIcon: Icon(Icons.upcoming_outlined),
                label: 'Up Coming',
              ),
            ],
        ),
      ),
    );
  }
}

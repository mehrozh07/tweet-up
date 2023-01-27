import 'package:flutter/cupertino.dart';
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
    final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

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
                icon: Icon(Icons.person_pin_outlined),
                selectedIcon: Icon(Icons.person_pin_outlined,),
                label: 'Students',
              ),
              NavigationDestination(
                icon: Icon(Icons.upcoming_outlined),
                selectedIcon: Icon(Icons.upcoming_outlined),
                label: 'Up Coming',
              ),
            ]
        ),
      ),
    );
  }
}

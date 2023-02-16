import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:tweetup_fyp/screens/views/upload_assignment.dart';
import 'package:tweetup_fyp/screens/views/upload_notes.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../services/loading.dart';

class Classwork extends StatefulWidget {
  Map<dynamic, dynamic> classData;
  Classwork(this.classData, {Key? key}) : super(key: key);
  @override
  _ClassworkState createState() => _ClassworkState();
}

class _ClassworkState extends State<Classwork>
    with SingleTickerProviderStateMixin {
  late TabController _controller;
  int _index = 0;

  @override
  void initState() {
    super.initState();
    _controller =  TabController(length: 2, vsync: this);
  }
 TabController? tabController;

  @override
  Widget build(BuildContext context) {
    List<Widget> page = [
       Expanded(
        child: StreamBuilder(
            stream: FirebaseFirestore.instance
                .collection(widget.classData['code'])
                .doc('Notes')
                .collection('Notes')
                .snapshots(),
            builder: (context, AsyncSnapshot announcementSnapshot) {
              return announcementSnapshot.hasData
                  ? ListView.builder(
                dragStartBehavior: DragStartBehavior.down,
                      physics: const ScrollPhysics(),
                      itemCount: announcementSnapshot.data.docs.length,
                      itemBuilder: (context, index) {
                        DocumentSnapshot announcementData =
                            announcementSnapshot.data.docs[index];
                        if (kDebugMode) {
                          print(announcementData.data());
                        }
                        return Dismissible(
                          key: const Key('value'),
                          background: Container(color: Colors.blue,),
                          secondaryBackground: Container(color: Colors.red,),
                          child: Card(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    announcementData['topic'] ?? 'Loading',
                                    style: const TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                  TextButton(
                                    style: TextButton.styleFrom(
                                      primary: Colors.black,
                                      backgroundColor: Colors.red
                                    ),
                                    child: const Text('Open notes'),
                                    onPressed: () async {
                                      if (await canLaunch(
                                          announcementData['url'])) {
                                        launchUrl(announcementData['url']);
                                      } else {
                                        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                                          behavior: SnackBarBehavior.floating,
                                            backgroundColor:
                                                Color.fromRGBO(219, 22, 47, 1),
                                            content: Text(
                                                "Can't open the provided link",
                                                style: TextStyle(
                                                    color: Colors.white))));
                                      }
                                    },
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    )
                  : Center(child: Loader());
            }),
      ),
       Expanded(
        child: StreamBuilder(
            stream: FirebaseFirestore.instance
                .collection(widget.classData['code'])
                .doc('assignments')
                .collection('assignments')
                .snapshots(),
            builder: (context, AsyncSnapshot announcementSnapshot) {
              return announcementSnapshot.hasData
                  ? ListView.builder(
                      itemCount: announcementSnapshot.data.docs.length,
                      itemBuilder: (context, index) {
                        DocumentSnapshot announcementData =
                            announcementSnapshot.data.docs[index];
                        if (kDebugMode) {
                          print(announcementData.data());
                        }
                        return Card(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      announcementData['topic + teacher copy'] ?? 'Loading',
                                      style: const TextStyle(
                                          fontWeight: FontWeight.bold),
                                    ),
                                    Text(
                                      announcementData[
                                                  'dueDate + teacher copy'] !=
                                              null
                                          ? 'Due date ${announcementData
                                                  [
                                                      'dueDate + teacher copy']
                                                  .toString()
                                                  .substring(0, 10)}'
                                          : 'Loading',
                                      style: const TextStyle(
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ],
                                ),
                                TextButton(
                                  style: TextButton.styleFrom(
                                    backgroundColor: Colors.lightGreen,
                                    padding: const EdgeInsets.symmetric(horizontal: 20),
                                    visualDensity: const VisualDensity(horizontal: 3),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(6),
                                    ),
                                  ),
                                  onPressed: () async {

                                  },
                                  child: const Icon(CupertinoIcons.cloud_download, color: Colors.white),
                                ),
                                // Text('123')
                              ],
                            ),
                          ),
                        );
                      },
                    )
                  : Center(child: Loader());
            }),
      ),
    ];
    final user = Provider.of<User>(context);
    return Scaffold(
      floatingActionButton: SpeedDial(
        childMargin: const EdgeInsets.only(right: 18, bottom: 10),
        animatedIcon: AnimatedIcons.menu_close,
        animatedIconTheme: const IconThemeData(size: 22),
        closeManually: false,
        curve: Curves.bounceIn,
        overlayColor: Colors.black,
        overlayOpacity: 0.5,
        tooltip: 'Speed Dial',
        heroTag: 'speed-dial-hero-tag',
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 8.0,
        shape: const CircleBorder(),
        children: [
          SpeedDialChild(
              child: const Icon(Icons.notes),
              backgroundColor: Colors.red,
              label: 'Upload Notes',
              labelStyle: const TextStyle(fontSize: 18.0),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => Notes(widget.classData['code'])),
                );
              }),
          SpeedDialChild(
            child: const Icon(Icons.brush),
            backgroundColor: Colors.blue,
            label: 'Give assignment',
            labelStyle: const TextStyle(fontSize: 18),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) =>
                        UploadAssignment(widget.classData['code'], user.email!)),
              );
            },
          ),
        ],
      ),
      body: SizedBox(
        height: MediaQuery.of(context).size.height -
            kBottomNavigationBarHeight -
            AppBar().preferredSize.height,
        child: Column(
          children: [
            // UserInfo(imgURL: imgURL, user: user, classData: widget.classData),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children:  [
                TextButton(
                  child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: Theme.of(context).primaryColor,
                          )),
                      alignment: Alignment.center,
                      width: MediaQuery.of(context).size.width * .4,
                      child: Text(
                        'View uploaded notes',
                        style: TextStyle(color: Theme.of(context).primaryColor),
                      )),
                  onPressed: () {
                    setState(() {
                      _index = 0;
                    });
                  },
                ),
                TextButton(
                  child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.secondary,
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: Colors.white)),
                      alignment: Alignment.center,
                      width: MediaQuery.of(context).size.width * .4,
                      child: const Text(
                        'View assignments',
                        style: TextStyle(color: Colors.white),
                      )),
                  onPressed: () {
                    setState(() {
                      _index = 1;
                    });
                  },
                ),
              ],
            ),
            page[_index]
          ],
        ),
      ),
    );
  }
}

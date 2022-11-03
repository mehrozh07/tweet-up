import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../services/loading.dart';

class SubmitClasswork extends StatefulWidget {
  Map<dynamic, dynamic> classData;
  SubmitClasswork(this.classData, {Key? key}) : super(key: key);
  @override
  _SubmitClassworkState createState() => _SubmitClassworkState();
}

class _SubmitClassworkState extends State<SubmitClasswork>
    with SingleTickerProviderStateMixin {
   TabController? _controller;
  int _index = 0;

  @override
  void initState() {
    super.initState();
    _controller =  TabController(length: 2, vsync: this);
  }

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
                      itemCount: announcementSnapshot.data.docs.length,
                      itemBuilder: (context, index) {
                        DocumentSnapshot announcementData =
                            announcementSnapshot.data.docs[index];
                        print(announcementData.data());

                        return Card(
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
                                    backgroundColor:  Colors.amber,
                                  ),
                                  child: const Text('Open notes'),
                                  onPressed: () async {
                                    if (await canLaunch(
                                        announcementData['url'])) {
                                      launch(announcementData['url']);
                                    } else {
                                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
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
                        print(announcementData.data());

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
                                      announcementData
                                              ['topic + teacher copy'] ?? 'Loading',
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
                                    backgroundColor: Colors.amber,
                                  ),
                                  child: const Text('Open Assignment'),
                                  onPressed: () async {
                                    if (await canLaunch(
                                        announcementData['url'])) {
                                      launch(announcementData['url']);
                                    } else {
                                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                                          backgroundColor:
                                              Color.fromRGBO(219, 22, 47, 1),
                                          content: Text(
                                              "Can't open the provided link",
                                              style: TextStyle(
                                                  color: Colors.white),
                                          ),
                                      ),
                                      );
                                    }
                                  },
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
    final user = Provider.of<User?>(context);
    var imgURL;
    if (user == null) {
      imgURL =
          'https://cdn3.iconfinder.com/data/icons/user-interface-web-1/550/web-circle-circular-round_54-512.png';
    } else {
      imgURL = user.photoURL ?? 'https://cdn3.iconfinder.com/data/icons/user-interface-web-1/550/web-circle-circular-round_54-512.png';
    }
    return Scaffold(
      body: Container(
        height: MediaQuery.of(context).size.height -
            kBottomNavigationBarHeight -
            AppBar().preferredSize.height,
        child: Column(
          children: [
            UserInfo(imgURL: imgURL, user: user!, classData: widget.classData),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
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
                      padding: EdgeInsets.symmetric(vertical: 10),
                      decoration: BoxDecoration(
                          color: Theme.of(context).accentColor,
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: Colors.white)),
                      alignment: Alignment.center,
                      width: MediaQuery.of(context).size.width * .4,
                      child: Text(
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

class UserInfo extends StatelessWidget {
  const UserInfo({
    required this.imgURL,
    required this.user,
    required this.classData,
  });

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
                  decoration:  BoxDecoration(
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
      ],
    );
  }
}

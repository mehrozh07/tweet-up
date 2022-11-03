import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:tweetup_fyp/screens/views/enrolled_classes.dart';
import '../../services/database.dart';
import '../../services/loading.dart';


const AndroidNotificationChannel channel = AndroidNotificationChannel(
    'high_importance_channel',
    'High Importance channel Notifications',
    importance: Importance.high,
    playSound: true
);

FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
Future<void> _firebaseMessagingHandler(RemoteMessage remoteMessage) async{
  await Firebase.initializeApp();
  if (kDebugMode) {
    print("This is message is just show up ${remoteMessage.notification}");
  }
}

// ignore: must_be_immutable
class Announcements extends StatefulWidget {
  Map<dynamic, dynamic> classData;
  Announcements(this.classData, {Key? key,}) : super(key: key);
  static const routeName = '/announcements';

  @override
  // ignore: library_private_types_in_public_api
  _AnnouncementsState createState() => _AnnouncementsState();
}

class _AnnouncementsState extends State<Announcements> {
  bool _loading = false;


  final announcement = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    FirebaseMessaging.onMessage.listen((RemoteMessage remoteMessage){
      RemoteNotification? notification = remoteMessage.notification;
      AndroidNotification? androidNotification = remoteMessage.notification?.android;

      if(notification != null && androidNotification != null){
        flutterLocalNotificationsPlugin.show(
            notification.hashCode,
            notification.title,
            notification.body,
            NotificationDetails(
              android: AndroidNotificationDetails(
                channel.id,
                channel.name,
                color: Colors.blue,
                playSound: true,
                icon: '@mipmap/ic_launcher',
              )
            ));
      }
    });
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      RemoteNotification? notification = message.notification;
      AndroidNotification? androidNotification = message.notification?.android;
      if(notification != null && androidNotification != null){
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=> EnrolledClasses()));
      }
    });
  }

  void sendNotification() async{

  }
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User?>(context);
    String imgURL;
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
            // UserInfo(imgURL: imgURL, user: user!, classData: widget.classData),
            Form(
              key: _formKey,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: TextFormField(
                  maxLines: 3,
                  validator: ((value) =>
                      value!.isEmpty ? 'Post can\'t be empty' : null),
                  controller: announcement,
                  decoration: const InputDecoration(
                    hintText: 'title',
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(20)),
                      borderSide: BorderSide(color: Colors.grey, width: 1.0),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey, width: 1.0),
                    ),
                  ),
                ),
              ),
            ),
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
                        'Cancel',
                        style: TextStyle(color: Theme.of(context).primaryColor),
                      )),
                  onPressed: () {
                    announcement.text = '';
                    FocusScope.of(context).unfocus();
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
                        'Post',
                        style: TextStyle(color: Colors.white),
                      )),
                  onPressed: () async{
                    if (_formKey.currentState!.validate()) {
                      setState(() {
                        _loading = true;
                      });
                      var db = MakeAnnouncement(widget.classData['code'],
                          user!.displayName!, announcement.text);
                      await db.makeAnnouncement();
                      setState(() {
                        FocusScope.of(context).unfocus();
                        announcement.text = '';
                        _loading = false;
                      });
                    }
                    setState((){
                    });
                        flutterLocalNotificationsPlugin.show(
                        0,
                        "Announcement",
                        widget.toString(),
                        NotificationDetails(
                          android: AndroidNotificationDetails(
                              channel.id,
                              channel.name,
                              importance: Importance.high,
                              playSound: true,
                              icon: '@mipmap/ic_launcher'
                          ),
                        ),
                      );
                      if (kDebugMode) {
                        print(flutterLocalNotificationsPlugin.toString());
                      }
                    }
                )
              ],
            ),
            ListOfAnnouncements(classData: widget.classData)
          ],
        ),
      ),
    );
  }
}

class ListOfAnnouncements extends StatelessWidget {
  const ListOfAnnouncements({super.key,
    required this.classData,
  }) ;

  final Map classData;

  @override
  Widget build(BuildContext context) {
    const kDefaultPadding = 20.0;
    return Expanded(
      child: StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection(classData['code'])
              .doc('Announcements')
              .collection('announcements')
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

                      return Padding(
                        padding:  const EdgeInsets.symmetric(horizontal: 20,vertical: 5),
                        child: Column(
                          children: [
                            const SizedBox(height: 2),
                            Container(
                              decoration:  BoxDecoration(
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.grey.shade400,
                                      blurRadius: 5.0,
                                      spreadRadius: 0.0,
                                      offset: const Offset(2.0,
                                          2.0), // shadow direction: bottom right
                                    )
                                  ],
                                  borderRadius:
                                      const BorderRadius.all(Radius.circular(20)),
                                  color: Colors.grey.shade300),
                              child: Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Text(
                                          announcementData['postedBy'],
                                          style: const TextStyle(
                                              fontWeight: FontWeight.bold),
                                        ),
                                        const SizedBox(width: 8,),
                                        Text(announcementData['time']),
                                      ],
                                    ),
                                     const Divider(height: 1,),
                                    Padding(
                                      padding:  const EdgeInsets.symmetric(horizontal: 5,vertical: 5),
                                      child: Text(
                                        announcementData['post'],
                                        textAlign: TextAlign.left,
                                        style: GoogleFonts.alice(fontSize: 20),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  )
                : Center(child: Loader());
          }),
    );
  }
}

class UserInfo extends StatelessWidget {
    UserInfo({super.key,
    @required this.imgURL,
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
                  decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      image: DecorationImage(
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

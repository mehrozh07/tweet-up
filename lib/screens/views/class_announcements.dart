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
  var sendMessage = TextEditingController();
  Color? color = Colors.grey.shade300;
  bool _isTure = false;
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
      bottomSheet: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Form(
          key: _formKey,
          child: Row(
            children: [
              Expanded(
                child: TextFormField(
                  controller: announcement,
                  keyboardType: TextInputType.multiline,
                  maxLines: null,
                  textInputAction: TextInputAction.newline,
                  onChanged: (String? index){
                    if(index!.isNotEmpty){
                      setState(() {
                        color = Theme.of(context).primaryColor;
                        _isTure = false;
                      });
                    }else if(index.isEmpty){
                      setState(() {
                        color = Colors.grey.shade300;
                        _isTure = true;
                      });
                    }
                  },
                  cursorColor: Theme.of(context).primaryColor,
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.zero,
                    border: OutlineInputBorder(
                      borderSide: BorderSide.none,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    suffixIcon: Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: AbsorbPointer(
                        absorbing: _isTure ? true : false,
                        child: IconButton(

                          onPressed: () async{
                            if (_formKey.currentState!.validate()){
                              setState(() {
                                _loading = true;
                              });
                              var db = MakeAnnouncement(widget.classData['code'],
                                  user!.displayName!, announcement.text);
                              await db.makeAnnouncement();
                              setState(() {
                                FocusScope.of(context).unfocus();
                                announcement.clear();
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
                          },
                          icon: Icon(Icons.send_outlined, size: 28, color: announcement.text.isEmpty ? Colors.grey :
                            Theme.of(context).primaryColor,),
                        ),
                      ),
                    ),
                    filled: true,
                    hintText: "Type a message",
                    fillColor: Colors.grey.shade300,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      body: Scaffold(
        body: Column(
          children: [
            ListOfAnnouncements(classData: widget.classData),
            SizedBox(height: 60,),
          ],
        ),
      ),
    );
  }
}

class ListOfAnnouncements extends StatelessWidget {
   ListOfAnnouncements({super.key,
    required this.classData,
  }) ;

  final Map classData;

  User? user = FirebaseAuth.instance.currentUser;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance
              .collection(classData['code'])
              .doc('Announcements')
              .collection('announcements').orderBy('post', descending: true)
              .snapshots(),
          builder: (context, AsyncSnapshot<QuerySnapshot> announcementSnapshot) {
            return announcementSnapshot.hasData
                ? ListView.builder(
                    itemCount: announcementSnapshot.data?.docs.length,
                    itemBuilder: (context, index) {
                      DocumentSnapshot announcementData =
                          announcementSnapshot.data!.docs[index];
                      // if (kDebugMode) {
                      //   print(announcementData.data());
                      // }
                      return Padding(
                        padding:  const EdgeInsets.symmetric(horizontal: 20,vertical: 5),
                        child: Column(
                          crossAxisAlignment: FirebaseAuth.instance.currentUser == null ?
                          CrossAxisAlignment.start : CrossAxisAlignment.start,
                          children: [
                            Text(
                              announcementData['postedBy'],
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 2),
                            Container(
                              padding: const EdgeInsets.only(left: 12, right: 12, bottom: 8 , top: 8),
                              decoration:  BoxDecoration(
                                  borderRadius:  const BorderRadius.only(
                                    topLeft: Radius.circular(12),
                                    topRight: Radius.circular(12),
                                    bottomRight: Radius.circular(12),
                                  ),
                                  color: Theme.of(context).primaryColor.withOpacity(0.4)),
                              child: Text(
                                announcementData['post'],
                                textAlign: TextAlign.left,
                                style: GoogleFonts.alice(fontSize: 20),
                              ),
                            ),
                            Text(announcementData['time']),
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

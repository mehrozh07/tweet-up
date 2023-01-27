import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart' as http;
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:tweetup_fyp/services/token_model.dart';
import 'package:tweetup_fyp/services/user_model.dart';
import '../util/utils.dart';
import 'message_model.dart';

class FirestoreService {
  User? user = FirebaseAuth.instance.currentUser;
  final CollectionReference _usersCollectionReference =
  FirebaseFirestore.instance.collection('users');
  final CollectionReference _messagesCollectionReference =
  FirebaseFirestore.instance.collection('messages');
  final FirebaseMessaging _fcm = FirebaseMessaging.instance;
   static FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

  final StreamController<List<MessagesModel>> _chatMessagesController =
  StreamController<List<MessagesModel>>.broadcast();

  Future createUser(UserModel user) async {
    try {
      await _usersCollectionReference.doc(user.id).set(user.toJson());
    } catch (e) {
      // TODO: Find or create a way to repeat error handling without so much repeated code
      if (e is PlatformException) {
        return e.message;
      }
      return e.toString();
    }
  }

  Future getUser(String uid) async {
    try {
      var userData = await _usersCollectionReference.doc(uid).get();

      return UserModel.fromData(userData.data() as Map<String, dynamic>);
    } catch (e) {
      // TODO: Find or create a way to repeat error handling without so much repeated code
      if (e is PlatformException) {
        return e.message;
      }

      return e.toString();
    }
  }

  Future getAllUsersOnce(String currentUserUID) async {
    try {
      var usersDocumentSnapshot =
      await _usersCollectionReference.get();
      String? fcmToken = await _fcm.getToken();

      final tokenRef = _usersCollectionReference
          .doc(currentUserUID)
          .collection('tokens')
          .doc(fcmToken);
      await tokenRef.set(
        TokenModel(token: fcmToken, creditAt: FieldValue.serverTimestamp())
            .toJson(),
      );
      if (usersDocumentSnapshot.docs.isNotEmpty) {
        return usersDocumentSnapshot.docs
            .map((snapshot) => UserModel.fromMap(snapshot.data() as Map<String, dynamic>))
            .where((mappedItem) => mappedItem?.id != currentUserUID)
            .toList();
      }
    } catch (e) {
      // TODO: Find or create a way to repeat error handling without so much repeated code
      if (e is PlatformException) {
        return e.message;
      }

      return e.toString();
    }
  }

  Future createMessage(MessagesModel message) async {
    try {
      await _messagesCollectionReference.doc().set(message.toJson());
    } catch (e) {
      // TODO: Find or create a way to repeat error handling without so much repeated code
      if (e is PlatformException) {
        return e.message;
      }

      return e.toString();
    }
  }

  Stream listenToMessagesRealTime(String friendId, String currentUserId) {
    // Register the handler for when the posts data changes
    _requestMessages(friendId, currentUserId);
    return _chatMessagesController.stream;
  }

  void _requestMessages(String friendId, String currentUserId) {
    var messagesQuerySnapshot =
    _messagesCollectionReference.orderBy('createdAt', descending: true);

    messagesQuerySnapshot.snapshots().listen((messageSnapshot) {
      if (messageSnapshot.docs.isNotEmpty) {
        var messages = messageSnapshot.docs
            .map((snapshot) => MessagesModel.fromMap(snapshot.data() as Map<String, dynamic>))
            .where((element) =>
        (element.receiverId == friendId &&
            element.senderId == currentUserId) ||
            (element.receiverId == currentUserId &&
                element.senderId == friendId))
            .toList();

        _chatMessagesController.add(messages);
      }
    });
  }
  static void requestPermission(context) async{
    FirebaseMessaging messaging = FirebaseMessaging.instance;
    NotificationSettings setting = await messaging.requestPermission(
      sound: true,
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      provisional: false,
      criticalAlert: false,
    );
    if(setting.authorizationStatus == AuthorizationStatus.authorized){
      if (kDebugMode) {
        print("permission Granted.....................................");
      }
      // Utils.snackBar(message: "permission granted", context: context, color: Colors.green);
    }else{
      Utils.snackBar(message: "permission denied", context: context, color: Colors.red);
    }
  }

 saveToke(token){
    _usersCollectionReference.doc(user?.email).set({
      "token": token,
    });
 }

   static initInfo(context){
    var androidInitiaze = const AndroidInitializationSettings('assets/images/appIcon.png',);
    var iosInitialization =  const DarwinInitializationSettings();
    var initializationSettings = InitializationSettings(
      android: androidInitiaze,
      iOS: iosInitialization,
    );
     flutterLocalNotificationsPlugin.initialize(
        initializationSettings,
        onDidReceiveBackgroundNotificationResponse: (payload) async{
          try{
            if(payload.payload != null && payload.payload!.isNotEmpty){

            }else{

            }
          }catch(e){
            if (kDebugMode) {
              print(e.toString());
            }
            Utils.snackBar(message: e.toString(), context: context, color: Colors.red);
          }
    });
    FirebaseMessaging.onMessage.listen((RemoteMessage remoteMessage) async {
      if (kDebugMode) {
        print('.................onMessaging...................');
        print("onMessaging.....${remoteMessage.notification?.title}& ${remoteMessage.notification?.body}");
      }

      BigTextStyleInformation bigTextStyleInformation = BigTextStyleInformation(
        remoteMessage.notification!.body.toString(),
        htmlFormatBigText: true,
        contentTitle: remoteMessage.notification?.title.toString(),
        htmlFormatContentTitle: true,
      );
      AndroidNotificationDetails androidNotificationDetails = AndroidNotificationDetails(
          "Tweet_Up",
        "Tweet_Up",
        importance: Importance.max,
        styleInformation: bigTextStyleInformation,
        priority: Priority.max,
        playSound: true,
      );
      NotificationDetails notificationDetails = NotificationDetails(
        android: androidNotificationDetails,
      );
      await flutterLocalNotificationsPlugin.show(0,
          remoteMessage.notification?.title,
          remoteMessage.notification?.body,
          notificationDetails,
          payload: remoteMessage.data['body'],
      );
    });
 }


 static Future<void> sendPushNotification({title, body, token}) async{
    try{
      await http.post(
        Uri.parse('https://fcm.googleapis.com/fcm/send'),
        headers: <String, String>{
          HttpHeaders.contentTypeHeader: 'application/json',
          HttpHeaders.authorizationHeader:
          "key=AAAAAxXdjLA:APA91bH48tL4DFiZ_4lAtirHYJdn5vfM60AUPr_qaZMWJR0CGLX_rpN5QVOkvPYJDYM2MHuKSOaiEEAPsATqdYM6mrdXA7a9PBEzIw_QefTYnC3XJoNBcyLpqHaw_2AR0v08pmInMNi4",
        },
        body: jsonEncode(
          {
            'priority': 'high',
            'data': {
              'click_action': 'FLUTTER_NOTIFICATION_CLICK',
              'status': 'done',
              'body': body,
              'title': title,
            },
            "notification": {
              "title": title,
              "body": body,
              "android_channel_id": "Tweet_Up",
            },
            "to": token,
          },
        )
      );
    }catch(e){
      if (kDebugMode) {
        print('........ERORRRRRRRRRRRRRRRR${e.toString()}');
      }
      // Utils.snackBar(message: e.toString(), context: context, color: Colors.redAccent);
    }
 }
}
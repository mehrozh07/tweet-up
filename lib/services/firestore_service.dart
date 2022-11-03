import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/services.dart';
import 'package:tweetup_fyp/services/token_model.dart';
import 'package:tweetup_fyp/services/user_model.dart';

import 'message_model.dart';

class FirestoreService {
  final CollectionReference _usersCollectionReference =
  FirebaseFirestore.instance.collection('users');
  final CollectionReference _messagesCollectionReference =
  FirebaseFirestore.instance.collection('messages');
  final FirebaseMessaging _fcm = FirebaseMessaging.instance;

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
}
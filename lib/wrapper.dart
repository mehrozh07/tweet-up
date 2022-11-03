import 'package:flutter/foundation.dart';
import 'package:tweetup_fyp/screens/authenticate/authenticate.dart';
import './screens/views/home.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Wrapper extends StatelessWidget {
  const Wrapper({super.key});

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User?>(context);
    if (kDebugMode) {
      print(user);
    }
    // return either the Home or Authenticate widget
    return user == null ? Authenticate() : const Home();
  }
}

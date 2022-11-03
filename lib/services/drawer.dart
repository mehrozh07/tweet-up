import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:provider/provider.dart';

import '../constants/constants.dart';
import '../screens/views/create_class.dart';
import '../screens/views/home.dart';
import '../screens/views/join_class.dart';
import 'auth.dart';

class CustomDrawer extends StatelessWidget {
  final _auth = AuthService();
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User?>(context);

    var imgURL;
    if (user == null) {
      imgURL =
          'https://cdn3.iconfinder.com/data/icons/user-interface-web-1/550/web-circle-circular-round_54-512.png';
    } else {
      imgURL = user.photoURL ?? 'https://cdn3.iconfinder.com/data/icons/user-interface-web-1/550/web-circle-circular-round_54-512.png';
    }
    return Drawer(
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 50),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Container(
                          width: 50.0,
                          height: 50.0,
                          decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              image:  DecorationImage(
                                  fit: BoxFit.fill,
                                  image:  NetworkImage(imgURL))))
                    ],
                  ),
                  Padding(
                    padding:  EdgeInsets.only(top: 10),
                    child: Text(
                      user != null ? user.displayName! : 'user',
                      style: kPageTitleStyleBlack,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: Text(
                      user != null ? user.email! : 'email',
                      style: kHintTextStyle,
                    ),
                  )
                ],
              ),
              const Divider(),
              ElevatedButton(
                onPressed: () {
                  Navigator.popAndPushNamed(context, Home.routeName);
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Wrap(
                      alignment: WrapAlignment.start,
                      direction: Axis.horizontal,
                      children: const [Icon(Icons.add_business), Text('Home')],
                    ),
                  ],
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.popAndPushNamed(context, CreateClass.routeName);
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Wrap(
                      alignment: WrapAlignment.start,
                      direction: Axis.horizontal,
                      children: const [
                        Icon(Icons.add_business),
                        Text('Create/view class')
                      ],
                    ),
                  ],
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pushNamed(JoinClass.routeName);
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Wrap(
                      direction: Axis.horizontal,
                      children: const [Icon(Icons.library_add), Text('Join a class')],
                    ),
                  ],
                ),
              ),
              ElevatedButton(
                onPressed: () {},
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Wrap(
                      direction: Axis.horizontal,
                      children: const [Icon(Icons.work), Text('All classes')],
                    ),
                  ],
                ),
              ),
              const Divider(),
              ElevatedButton(
                onPressed: () async {
                  await _auth.signOut();
                  Phoenix.rebirth(context);
                  if (kDebugMode) {
                    print('Logged out');
                  }
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Wrap(
                      direction: Axis.horizontal,
                      children: const [Icon(Icons.logout), Text('Logout')],
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

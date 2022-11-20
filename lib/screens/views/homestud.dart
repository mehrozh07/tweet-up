import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:tweetup_fyp/screens/authenticate/login.dart';
import '../../constants/constants.dart';
import '../../services/auth.dart';
import 'enrolled_classes.dart';
import 'join_class.dart';

class homestud extends StatefulWidget {
  static const routeName = '/homestud';

  @override
  _homestudState createState() => _homestudState();
}

class _homestudState extends State<homestud> {
  final _auth = AuthService();
  int _index = 0;
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User>(context);
    String? imgURL;
    if (user == null) {
      imgURL =
      'https://cdn3.iconfinder.com/data/icons/user-interface-web-1/550/web-circle-circular-round_54-512.png';
    } else {
      imgURL = user.photoURL ?? 'https://cdn3.iconfinder.com/data/icons/user-interface-web-1/550/web-circle-circular-round_54-512.png';
    }
    ;
    var height =
        MediaQuery.of(context).size.height - AppBar().preferredSize.height;
    //final name = user != null ? user.displayName : 'Name';
    return Scaffold(
      // drawer: CustomDrawer(),
      appBar: AppBar(
        elevation: 0,
        actions: [
          IconButton(
            onPressed: () async {
              AwesomeDialog(
                context: context,
                dialogType: DialogType.INFO,
                borderSide: const BorderSide(
                  color: Colors.green,
                  width: 2,
                ),
                width: 280,
                buttonsBorderRadius: const BorderRadius.all(
                  Radius.circular(2),
                ),
                dismissOnTouchOutside: true,
                dismissOnBackKeyPress: false,
                onDismissCallback: (type) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Logout Successfully $type'),
                    ),
                  );
                },
                headerAnimationLoop: false,
                animType: AnimType.BOTTOMSLIDE,
                title: 'INFO',
                desc: 'Do You Want To Logout?',
                showCloseIcon: true,
                btnCancelOnPress: () {
                  Navigator.of(context).pop();
                },
                btnOkOnPress: () {
                  _auth.signOut();
                  Navigator.pushReplacementNamed(context, LoginScreen.id);
                },
              ).show();
            },
            icon: const Icon(Icons.logout),
          )
        ],
        iconTheme: IconThemeData(color: Theme.of(context).accentColor),
        backgroundColor: Colors.white,
        title: Text(
          'Classroom Application Flipr Hackathon X',
          //name,
          style: TextStyle(color: Theme.of(context).accentColor),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            UserInfo(imgURL: imgURL, user: user),
            Padding(
              padding:
              const EdgeInsets.symmetric(horizontal: 28, vertical: 20.0),
              child: Text(
                'Manage your classes like never before',
                textAlign: TextAlign.center,
                style: GoogleFonts.questrial(
                  fontSize: 20.0,
                  fontWeight: FontWeight.w900,
                  color: const Color.fromRGBO(61, 25, 20, 1.0),
                  wordSpacing: 2.5,
                ),
              ),
            ),
            Padding(
              padding:
              const EdgeInsets.symmetric(horizontal: 28, vertical: 20.0),
              child: Text(
                'Either be a student or a teacher',
                textAlign: TextAlign.center,
                style: GoogleFonts.questrial(
                  fontSize: 20.0,
                  fontWeight: FontWeight.w900,
                  color: const Color.fromRGBO(229, 195, 27, 1.0),
                  wordSpacing: 2.5,
                ),
              ),
            ),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 28),
              child: Divider(),
            ),
            Padding(
              padding:
              const EdgeInsets.symmetric(horizontal: 28, vertical: 20.0),
              child: Text(
                'Student\'s section',
                style: kPageTitleStyleBlack,
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                InkWell(
                  onTap: () {
                    Navigator.of(context).pushNamed(JoinClass.routeName);
                  },
                  child: Container(
                    height: 180,
                    width: MediaQuery.of(context).size.width/2.3,
                    padding: const EdgeInsets.all(30),
                    decoration: const BoxDecoration(
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey,
                            blurRadius: 25.0, // soften the shadow
                            spreadRadius: 5.0, //extend the shadow
                            offset: Offset(
                              15.0, // Move to right 10  horizontally
                              15.0, // Move to bottom 10 Vertically
                            ),
                          )
                        ],
                        color: Color.fromRGBO(60, 230, 216, 1.0),
                        borderRadius: BorderRadius.all(Radius.circular(20))),
                    child: Text(
                      'Join a new class',
                      textAlign: TextAlign.center,
                      style: kPageTitleStyle,
                    ),
                  ),
                ),
                InkWell(
                  onTap: () {
                    Navigator.of(context).pushNamed(EnrolledClasses.routeName,
                        arguments: user.email);
                  },
                  child: Container(
                    padding: const EdgeInsets.all(30),
                    height: 180,
                    width: MediaQuery.of(context).size.width/2.3,
                    decoration: const BoxDecoration(
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey,
                            blurRadius: 25.0, // soften the shadow
                            spreadRadius: 5.0, //extend the shadow
                            offset: Offset(
                              15.0, // Move to right 10  horizontally
                              15.0, // Move to bottom 10 Vertically
                            ),
                          )
                        ],
                        color: Color.fromRGBO(46, 49, 55, 1.0),
                        borderRadius: BorderRadius.all(Radius.circular(20))),
                    child: Text(
                      'View classes',
                      textAlign: TextAlign.center,
                      style: kPageTitleStyle,
                    ),
                  ),
                )
              ],
            ),
            SizedBox(
              height: 20,
            ),
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
  });

  final imgURL;
  final User user;

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
                          fit: BoxFit.cover,
                        image:  NetworkImage(imgURL),
                      ),
                  ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 5),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  /*Text(user.displayName,
                      style:
                      GoogleFonts.questrial(fontWeight: FontWeight.bold)),*/
                  Text(//user.email,
                      'Classroom Application Flipr Hackathon X',
                      style:
                      GoogleFonts.questrial(fontWeight: FontWeight.w100)),
                ],
              ),
            )
          ],
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 28),
          child: Divider(),
        ),
      ],
    );
  }
}

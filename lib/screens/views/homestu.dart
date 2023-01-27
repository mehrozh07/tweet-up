import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:tweetup_fyp/screens/authenticate/login.dart';
import '../../constants/constants.dart';
import 'enrolled_classes.dart';
import 'join_class.dart';

class HomeStudent extends StatefulWidget {
  static const routeName = '/homestu';

  const HomeStudent({Key? key}) : super(key: key);

  @override
  _homestuState createState() => _homestuState();
}

class _homestuState extends State<HomeStudent> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
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
    ;
    var height =
        MediaQuery.of(context).size.height - AppBar().preferredSize.height;
    final name = user != null ? user.displayName : 'Name';
    return Scaffold(
      // drawer: CustomDrawer(),
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () async {

              Navigator.pushReplacementNamed(context, LoginScreen.id);
              if (kDebugMode) {
                print('Logged out');
              }
            },
            icon: const Icon(Icons.logout),
          )
        ],
        iconTheme: const IconThemeData(color: Colors.white),
        backgroundColor: Theme.of(context).primaryColor,
        title: Text(name!,
          style: const TextStyle(color: Colors.white),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: UserInfo(imgURL: imgURL, user: user!),
            ),
             Column(
               mainAxisAlignment: MainAxisAlignment.start,
               crossAxisAlignment: CrossAxisAlignment.start,
               children: [
                 Text(
                    'Student\'s section',textAlign: TextAlign.start,
                    style: kPageTitleStyleBlack,
                  ),
               ],
             ),
            const SizedBox(
              height: 10,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Expanded(
                  child: InkWell(
                    onTap: () {
                      Navigator.of(context).pushNamed(JoinClass.routeName);
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        height: 180,
                        width: MediaQuery.of(context).size.width/2.3,
                        padding: const EdgeInsets.symmetric(vertical: 40),
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
                            color: Color.fromRGBO(60, 145, 230, 1),
                            borderRadius: BorderRadius.all(Radius.circular(20))),
                        child: Text(
                          'Join New Class',
                          textAlign: TextAlign.center,
                          style: kPageTitleStyle,
                        ),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: InkWell(
                    onTap: () {
                      Navigator.of(context).pushNamed(
                          EnrolledClasses.routeName,
                          arguments: user.email);
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
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
                            color: Colors.pinkAccent,
                            borderRadius: BorderRadius.all(Radius.circular(20))),
                        child: Text(
                          'View classes',
                          textAlign: TextAlign.center,
                          style: kPageTitleStyle,
                        ),
                      ),
                    ),
                  ),
                )
              ],
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
    return Stack(
      children: [
        Container(
          height: 250,
          width: double.infinity,
          decoration: BoxDecoration(
            color: Theme.of(context).primaryColor,
            borderRadius: BorderRadius.circular(18),
          ),
        ),
        const SizedBox(height: 8,),
        Container(
          padding: const EdgeInsets.symmetric(
            horizontal: 20,
            vertical: 35,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CircleAvatar(
                maxRadius: 50,
                backgroundColor: Colors.white,
                backgroundImage: NetworkImage(imgURL),
              ),
              const SizedBox(width: 10,),
              Padding(
                padding: const EdgeInsets.only(top: 20),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                        user.displayName!, textAlign: TextAlign.start, style:
                    GoogleFonts.alegreya(fontWeight: FontWeight.bold, fontSize: 20, fontStyle: FontStyle.italic)),
                    // SizedBox(height: 2.h,),
                    Text(user.email!, style:
                    GoogleFonts.questrial(fontWeight: FontWeight.bold, fontSize: 12)),
                  ],
                ),
              ),
            ],
          ),
        ),
       Padding(
         padding:  const EdgeInsets.symmetric(vertical: 160, horizontal: 20),
         child: Column(
           mainAxisAlignment: MainAxisAlignment.start,
           crossAxisAlignment: CrossAxisAlignment.start,
           children: [
             Text(
               'Manage your classes like never before. ',
               textAlign: TextAlign.center,
               style: GoogleFonts.questrial(
                 fontSize: 15.0,
                 fontWeight: FontWeight.w900,
                 color: Colors.white,
                 wordSpacing: 2.5,
               ),
             ),
             Text(
               'Either be a student or a teacher',
               textAlign: TextAlign.center,
               style: GoogleFonts.questrial(
                 fontSize: 15.0,
                 fontWeight: FontWeight.w900,
                 color: Colors.white,
                 wordSpacing: 2.5,
               ),
             ),
           ],
         ),
       ),
        Positioned(
          right: -45,
          top: -40,
          child: Container(
            padding: const EdgeInsets.all(30),
            decoration: BoxDecoration(
                color: Colors.transparent,
                shape: BoxShape.circle,
                border: Border.all(
                    width: 18,
                    color:Colors.pinkAccent,
                )
            ),
          ),
        ),
        // Row(
        //   mainAxisAlignment: MainAxisAlignment.start,
        //   children: [
        //     Padding(
        //       padding:
        //           const EdgeInsets.symmetric(horizontal: 28.0, vertical: 10),
        //       child: Container(
        //           width: 50.0,
        //           height: 50.0,
        //           decoration:  BoxDecoration(
        //               shape: BoxShape.circle,
        //               image:  DecorationImage(
        //                   fit: BoxFit.fill, image:  NetworkImage(imgURL)))),
        //     ),
        //     Padding(
        //       padding: const EdgeInsets.symmetric(vertical: 5),
        //       child: Column(
        //         crossAxisAlignment: CrossAxisAlignment.start,
        //         children: [
        //           Text(user!.displayName!,
        //               style:
        //                   GoogleFonts.questrial(fontWeight: FontWeight.bold)),
        //           Text(user!.email!,
        //               style:
        //                   GoogleFonts.questrial(fontWeight: FontWeight.w100)),
        //         ],
        //       ),
        //     )
        //   ],
        // ),
        // const Padding(
        //   padding: EdgeInsets.symmetric(horizontal: 28),
        //   child: Divider(),
        // ),
      ],
    );
  }
}
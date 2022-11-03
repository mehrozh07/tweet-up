import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:tweetup_fyp/screens/authenticate/login.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../constants/constants.dart';
import 'create_class.dart';
import 'created_classes.dart';

class Home extends StatefulWidget {
  static const routeName = '/home';

  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  int _index = 0;
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User?>(context);
     late String imgURL;
    if (user == null) {
      imgURL =
          'https://cdn3.iconfinder.com/data/icons/user-interface-web-1/550/web-circle-circular-round_54-512.png';
    } else {
      imgURL = user.photoURL ?? 'https://cdn3.iconfinder.com/data/icons/user-interface-web-1/550/web-circle-circular-round_54-512.png';
    }
    var height =
        MediaQuery.of(context).size.height - AppBar().preferredSize.height;
    final String? name = user != null ? user.displayName : 'Name';
    return Scaffold(
      // drawer: CustomDrawer(),
      appBar: AppBar(
        elevation: 0,
        actions: [
          IconButton(
            onPressed: () async {
              AwesomeDialog(
                context: context,
                dialogType: DialogType.INFO_REVERSED,
                borderSide: const BorderSide(
                  color: Colors.green,
                  width: 2,
                ),
                width: 350,
                buttonsBorderRadius: const BorderRadius.all(
                  Radius.circular(2),
                ),
                dismissOnTouchOutside: true,
                dismissOnBackKeyPress: false,
                onDismissCallback: (type) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Dismissed'),
                    ),
                  );
                },
                headerAnimationLoop: false,
                animType: AnimType.BOTTOMSLIDE,
                title: 'INFO',
                desc: 'Do You Want to Log Out?',
                showCloseIcon: true,
                btnCancelOnPress: () {
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
          style: TextStyle(color: Theme.of(context).accentColor), name!,
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: UserInfo(imgURL: imgURL, user: user),
            ),
            // Padding(
            //   padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20.0),
            //   child: Row(
            //     mainAxisAlignment: MainAxisAlignment.start,
            //     children: [
            //       Text(
            //         'TEACHER SECTION',
            //         textAlign: TextAlign.start,
            //         style: GoogleFonts.questrial(
            //           fontSize: 20.0,
            //           fontWeight: FontWeight.w900,
            //           color: const Color.fromRGBO(20, 33, 61, 1),
            //           wordSpacing: 2.5,
            //         ),
            //       ),
            //     ],
            //   ),
            // ),

            // Padding(
            //   padding:  EdgeInsets.symmetric(horizontal: 28.w),
            //   child: const Divider(),
            // ),
            //
            // SizedBox(
            //   height: 20.h,
            // ),
            Text(
              'Teacher\'s section',textAlign: TextAlign.start,
              style: kPageTitleStyleBlack,
            ),
            SizedBox(height: MediaQuery.of(context).size.height*0.1,),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                InkWell(
                  onTap: () {
                    Navigator.pushNamed(context, CreateClass.routeName);
                  },
                  child: Container(
                    padding: const EdgeInsets.all(30),
                    decoration:  const BoxDecoration(
                        boxShadow: [
                          BoxShadow(
                            color: Colors.blueAccent,
                            blurRadius: 10, // soften the shadow
                            spreadRadius: 2, //extend the shadow
                            offset: Offset(
                              10.0, // Move to right 10  horizontally
                              10.0, // Move to bottom 10 Vertically
                            ),
                          )
                        ],
                        color:  Colors.blueAccent,
                        borderRadius: BorderRadius.all(Radius.circular(20))),
                    height: 180,
                    width: MediaQuery.of(context).size.width/2.3,
                    child: Text(
                      'Create a new class',
                      textAlign: TextAlign.center,
                      style: kPageTitleStyle,
                    ),
                  ),
                ),
                InkWell(
                  onTap: () {
                    Navigator.of(context).pushNamed(CreatedClasses.routeName,
                        arguments: user?.email);
                  },
                  child: Container(
                    padding: const EdgeInsets.all(30),
                    decoration:  const BoxDecoration(
                        boxShadow: [
                          BoxShadow(
                            color: Colors.pinkAccent,
                            blurRadius: 20, // soften the shadow
                            spreadRadius: 2, //extend the shadow
                            offset: Offset(
                              10.0, // Move to right 10  horizontally
                              10.0, // Move to bottom 10 Vertically
                            ),
                          )
                        ],
                        color:  Colors.pinkAccent,
                        borderRadius: BorderRadius.all( Radius.circular(20))),
                    height: 180,
                    width: MediaQuery.of(context).size.width/2.3,
                    child: Text(
                      'View classes',
                      textAlign: TextAlign.center,
                      style: kPageTitleStyle,
                    ),
                  ),
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}

class UserInfo extends StatefulWidget {
     UserInfo({
    required this.imgURL,
    required this.user,
  }) ;

  final String imgURL;
  final User? user;

  @override
  State<UserInfo> createState() => _UserInfoState();
}

class _UserInfoState extends State<UserInfo> {
    final FirebaseAuth _auth1 = FirebaseAuth.instance;



    @override
  Widget build(BuildContext context) {
    final User? usser = _auth1.currentUser;
    final userUid = usser?.uid;
    return Stack(
      children: [
        Container(
          height: 250,
          width: double.infinity,
          decoration: BoxDecoration(
            color: const Color(0xFF687daf),
            borderRadius: BorderRadius.circular(18),
          ),
        ),
        SizedBox(height: 8,),
        Container(
          padding:  const EdgeInsets.symmetric(
              horizontal: 10,
              vertical: 35,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const CircleAvatar(
                maxRadius: 50,
                backgroundColor: Colors.white,
                backgroundImage:  NetworkImage(""),
              ),
              const SizedBox(width: 20,),
              Padding(
                padding:  EdgeInsets.symmetric(vertical: 20,),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                  Text(
                      widget.user!.displayName!, textAlign: TextAlign.start, style:
                          GoogleFonts.alegreya(fontWeight: FontWeight.bold, fontSize: 30, fontStyle: FontStyle.italic)),
                  // SizedBox(height: 2.h,),
                  Text(widget.user!.email!, style:
                  GoogleFonts.questrial(fontWeight: FontWeight.bold)),
                ],
                ),
              )
            ],
          ),
        ),
        Padding(
          padding:  EdgeInsets.symmetric(vertical: 160, horizontal: 20),
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
                  color: const Color.fromRGBO(20, 33, 61, 1),
                  wordSpacing: 2.5,
                ),
              ),
              Text(
                'Either be a student or a teacher',
                textAlign: TextAlign.center,
                style: GoogleFonts.questrial(
                  fontSize: 15.0,
                  fontWeight: FontWeight.w900,
                  color: const Color.fromRGBO(20, 33, 61, 1),
                  wordSpacing: 2.5,
                ),
              ),
            ],
          ),
        ),
        Positioned(
          right: -45,
          top: -40,
          child: IconButton(onPressed: (){},  icon: const Icon(Icons.logout, color: Colors.black,))
        ),
        Positioned(
          right: -45,
          top: -40,
          child: Container(
            padding: const EdgeInsets.all(30),
          decoration: BoxDecoration(
            color: Colors.transparent,
            shape: BoxShape.circle,
            border: Border.all(width: 18, color: const Color(0xFF264CD2))
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

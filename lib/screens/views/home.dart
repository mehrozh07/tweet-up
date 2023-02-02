import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:tweetup_fyp/screens/authenticate/login.dart';
import 'package:tweetup_fyp/screens/views/role.dart';
import 'package:tweetup_fyp/services/drawer.dart';
import 'package:tweetup_fyp/services/firestore_service.dart';
import 'package:tweetup_fyp/util/utils.dart';
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
  FirestoreService firestoreService = FirestoreService();
  @override
  void initState() {
    firestoreService.startMeeting(context);
    // TODO: implement initState
    super.initState();
  }
  int index = 0;
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
              Utils.alertDialogue(context: context, title: "Log out");
            },
            icon: const Icon(Icons.logout,color: Colors.white),
          )
        ],
        iconTheme: const IconThemeData(color: Colors.white),
        backgroundColor: Theme.of(context).primaryColor,
        centerTitle: true,
        title: Text(
          style: GoogleFonts.poppins(
            textStyle: const TextStyle(
              color: Colors.white,
            )
          ),
          name!,
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: UserInfo(imgURL: imgURL, user: user),
            ),
            Text(
              'Teacher\'s section',
              textAlign: TextAlign.start,
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
                    decoration:  BoxDecoration(
                        boxShadow: const [
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
                        color:  Theme.of(context).primaryColor,
                        borderRadius: const BorderRadius.all(Radius.circular(20))),
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
                    Navigator.of(context).pushNamed(CreatedClasses.routeName, arguments: user?.email);
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
     const UserInfo({super.key,
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
          padding:  const EdgeInsets.symmetric(
              horizontal: 10,
              vertical: 35,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
               CircleAvatar(
                maxRadius: 50,
                backgroundColor: Colors.white,
                backgroundImage:  NetworkImage(widget.imgURL),
              ),
              const SizedBox(width: 20,),
              Padding(
                padding:  const EdgeInsets.symmetric(vertical: 20,),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                  Text('${widget.user?.displayName}',
                      textAlign: TextAlign.start, style:
                          GoogleFonts.alegreya(fontWeight: FontWeight.bold, fontSize: 30, fontStyle: FontStyle.italic)),
                  // SizedBox(height: 2.h,),
                  Text('${widget.user?.email}',
                      style:TextStyle(
                          fontWeight: FontWeight.bold,
                      )
                  ),
                ],
                ),
              )
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
          child: IconButton(onPressed: (){

          },  icon: const Icon(Icons.logout, color: Colors.black,))
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
      ],
    );
  }

}

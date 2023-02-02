import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:tweetup_fyp/screens/authenticate/login.dart';
import '../../constants/constants.dart';
import '../../util/utils.dart';
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

  String image = "https://img.freepik.com/free-vector/laptop-with-program-code-isometric-icon-software-development-programming-applications-dark-neon_39422-971.jpg";
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User?>(context);
    var width = MediaQuery.of(context).size.width;
    var imgURL;
    if (user == null) {
      imgURL =
          'https://cdn3.iconfinder.com/data/icons/user-interface-web-1/550/web-circle-circular-round_54-512.png';
    } else {imgURL = user.photoURL ?? 'https://cdn3.iconfinder.com/data/icons/user-interface-web-1/550/web-circle-circular-round_54-512.png';}
    var height = MediaQuery.of(context).size.height - AppBar().preferredSize.height;
    return Scaffold(
      backgroundColor: const Color(0xffE5E5E5),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              UserInfo(imgURL: imgURL, user: user!),
              SizedBox(height: height*0.03),
              Text(
                "UpComing Classes",
                style: GoogleFonts.poppins(
                  textStyle: const TextStyle(fontSize: 16,color: Colors.black87, fontWeight: FontWeight.bold),
                ),
              ),
              Container(
                height: height * 0.36,
                width: double.infinity,
                decoration:
                    BoxDecoration(borderRadius: BorderRadius.circular(30)),
                child: ListView.builder(
                    physics: const BouncingScrollPhysics(),
                    itemCount: 12,
                    scrollDirection: Axis.horizontal,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.only(right: 10, bottom: 8, top: 8),
                        child: Container(
                          width: MediaQuery.of(context).size.width*0.45,
                          height: 90,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            color: Colors.white,
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  height: MediaQuery.of(context).size.height*0.16,
                                  width: double.infinity,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(8),
                                      color: Colors.white,
                                      border:
                                          Border.all(color: Colors.transparent),
                                      image: DecorationImage(
                                          image: NetworkImage(image),
                                          fit: BoxFit.fill)),
                                ),
                                SizedBox(height: height*0.01,),
                                const Text("Tuesday-9AM",
                                    style: TextStyle(
                                      fontSize: 15,
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold,
                                    )),
                                SizedBox(height: height*0.01,),
                                const Text("Flutter 3.7",
                                    style: TextStyle(
                                      fontSize: 15,
                                      color: Color(0xffCE1567),
                                      fontWeight: FontWeight.bold,
                                    )),
                                SizedBox(height: height*0.01,),
                                const Text("Class 2a"),
                              ],
                            ),
                          ),
                        ),
                      );
                    }),
              ),
              SizedBox(
                height: height * 0.04,
              ),
              Row(
               mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    "All your Courses",
                    style: GoogleFonts.poppins(
                      textStyle: const TextStyle(fontSize: 16,color: Colors.black87, fontWeight: FontWeight.bold),
                    ),
                  ),
                  Text(
                    "See All",
                    style: GoogleFonts.poppins(
                      textStyle: const TextStyle(fontSize: 16,color: Colors.black87, fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),

              ListView.builder(
                shrinkWrap: true,
                  physics: const BouncingScrollPhysics(),
                  itemCount: 6,
                  itemBuilder: (context, snapshot){
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ListTile(
                    leading: Container(
                      height: MediaQuery.of(context).size.height*0.22,
                      width:  width*0.22,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          color: Colors.white,
                          border:
                          Border.all(color: Colors.transparent),
                          image: DecorationImage(
                              image: NetworkImage(image),
                              fit: BoxFit.fill)),
                    ),
                    trailing: const Icon(Icons.arrow_forward_ios, size: 24, color: Colors.black87),
                    title: const Text("Languages",style: TextStyle(color: Colors.black87,fontSize: 17, fontWeight: FontWeight.bold),),
                    subtitle: const Text('Class 3',style: TextStyle(color: Colors.black54,fontSize: 16, fontWeight: FontWeight.bold),),
                  ),
                );
              }),
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
                          width: MediaQuery.of(context).size.width / 2.3,
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
                              borderRadius:
                                  BorderRadius.all(Radius.circular(20))),
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
                        Navigator.of(context).pushNamed(EnrolledClasses.routeName,
                            arguments: user.email);
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          padding: const EdgeInsets.all(30),
                          height: 180,
                          width: MediaQuery.of(context).size.width / 2.3,
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
                              borderRadius:
                                  BorderRadius.all(Radius.circular(20))),
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
        const SizedBox(
          height: 8,
        ),
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
              const SizedBox(
                width: 10,
              ),
              Padding(
                padding: const EdgeInsets.only(top: 10),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(user.displayName!,
                        textAlign: TextAlign.start,
                        style: GoogleFonts.alegreya(
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                            fontStyle: FontStyle.italic)),
                    // SizedBox(height: 2.h,),
                    Text(user.email!,
                        style: GoogleFonts.questrial(
                            fontWeight: FontWeight.bold, fontSize: 12)),
                  ],
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
                  color: Colors.pinkAccent,
                )),
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

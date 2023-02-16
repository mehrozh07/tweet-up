import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:tweetup_fyp/screens/views/subject_class_student.dart';
import '../authenticate/login.dart';
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
    var height = MediaQuery.of(context).size.height - AppBar().preferredSize.height;
    return Scaffold(
      backgroundColor: const Color(0xffE5E5E5),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.of(context).pushNamed(JoinClass.routeName);
        },
        label: const Text('Join',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        icon: const Icon(CupertinoIcons.add),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              UserInfo(user: user!),
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
                  TextButton(
                    onPressed: (){
                      Navigator.of(context).pushNamed(
                          EnrolledClasses.routeName,
                          arguments: user.email);
                    },
                   child: Text( "See All",
                     style: GoogleFonts.poppins(
                       textStyle: const TextStyle(fontSize: 16,color: Colors.black87, fontWeight: FontWeight.bold),),
                    ),
                  ),
                ],
              ),
              StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance.collection("student ${FirebaseAuth.instance.currentUser?.email}")
                    .snapshots(),
                builder:
                    (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (snapshot.hasError) {
                    return const Text('Something went wrong');
                  }
                  if (!snapshot.hasData) {
                    return const Center(
                      child: Text("Loading...."),
                    );
                  }
                  return ListView(
                    shrinkWrap: true,
                      children: snapshot.data!.docs.map((DocumentSnapshot document) {
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ListTile(
                        onTap: (){
                          Navigator.of(context).pushNamed(
                              SubjectClassStudent.routeName,
                              arguments: document.data()
                          );
                        },
                        visualDensity: const VisualDensity(horizontal: -4),
                        contentPadding: EdgeInsets.zero,
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
                        title: Text("${document['Name']}",
                          style: const TextStyle(color: Colors.black87,fontSize: 17, fontWeight: FontWeight.bold),),
                        subtitle: const Text('Class 3',style: TextStyle(color: Colors.black54,fontSize: 16, fontWeight: FontWeight.bold),),
                      ),
                    );
                  }).toList());
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class UserInfo extends StatelessWidget {
  const UserInfo({super.key,
    required this.user,
  });

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
                child: Text("${user.displayName?.substring(0,1)}",
                style: const TextStyle(
                  fontSize: 36,
                  fontWeight: FontWeight.bold,
                ),),
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
                    Row(
                      children: [
                        Text(user.displayName!,
                            textAlign: TextAlign.start,
                            style: GoogleFonts.alegreya(
                                fontWeight: FontWeight.bold,
                                fontSize: 20,
                                fontStyle: FontStyle.italic)),
                        IconButton(onPressed: (){
                          FirebaseAuth.instance.signOut().then((value){
                            Navigator.pushReplacementNamed(context, LoginScreen.id);
                          });
                        },
                            icon: const Icon(Icons.logout, color: Colors.white))
                      ],
                    ),
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
      ],
    );
  }
}

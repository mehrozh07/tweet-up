import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../widgets/home_meeting_button.dart';

class Role extends StatefulWidget {
  static const routeName = '/role';

  const Role({Key? key}) : super(key: key);

  @override
  _roleState createState() => _roleState();
}

class _roleState extends State<Role> {
  // final _auth = AuthService();
  // int _index = 0;

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User?>(context);
    var size = MediaQuery.of(context).size;
    Color buttonColor = Theme.of(context).primaryColor;
    final name = user != null ? user.displayName : 'Name';
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tweet Up'),
        automaticallyImplyLeading: false,
        centerTitle: true,
        backgroundColor: buttonColor,
      ),
      body: Center(
          child: Column(
            children: <Widget>[
        Padding(
          padding:  const EdgeInsets.only(top: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              HomeMeetingButton(
                onPressed: (){},
                text: 'New Meeting',
                icon: Icons.videocam,
              ),
              HomeMeetingButton(
                onPressed: (){},
                text: 'Join Meeting',
                icon: Icons.add_box_rounded,
              ),
              HomeMeetingButton(
                onPressed: () {},
                text: 'Schedule',
                icon: Icons.calendar_today,
              ),
              HomeMeetingButton(
                onPressed: () {},
                text: 'Share Screen',
                icon: Icons.arrow_upward_rounded,
              ),
            ],
          ),
        ),
        const Padding(
          padding:  EdgeInsets.only(top: 20),
          child: Center(
            child: Text(
              'Create/Join Meetings with just a click!',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
          ),
        ),
              SizedBox(
                width: size.width,
                height: size.height*0.50,
                child: Image.asset("assets/images/image1.jpg"),
              ),
              SizedBox(height: MediaQuery.of(context).size.height*0.001,),
              Padding(
                padding: const EdgeInsets.only(right: 12, left: 12),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    SizedBox(
                        width: MediaQuery.of(context).size.width,
                        height: 60,
                        child: ElevatedButton(
                            onPressed: (){
                              Navigator.pushNamed(context, '/homestu');
                              if (kDebugMode) {
                              print('Student.');
                            } },
                            style: ElevatedButton.styleFrom(
                              textStyle: const TextStyle(
                                color: Colors.white,
                              ),
                              backgroundColor: buttonColor,
                              padding: const EdgeInsets.fromLTRB(5, 0, 5, 0),
                              shape: const RoundedRectangleBorder(
                                  borderRadius: BorderRadius.all(Radius.circular(10))),
                            ),
                            child: Padding(
                                padding: const EdgeInsets.fromLTRB(0,0,0,0),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: <Widget>[
                                    Container(
                                      color: buttonColor,
                                      padding: const EdgeInsets.fromLTRB(10, 4, 4, 4),
                                      child:  Text('Continue As Student',
                                        style: GoogleFonts.alegreyaSans(fontSize: 18, color: Colors.white)),
                                    ),
                                    const Padding(
                                      padding: EdgeInsets.all(10),
                                      child: Icon(
                                        Icons.arrow_forward_ios,
                                        color:Colors.white,
                                        size: 42,
                                      ),
                                    ),
                                  ],
                                )))),
                    const SizedBox(
                      height: 10,
                    ),
                    Row(
                      children: const [
                        Expanded(
                            child: Divider(
                              color: Colors.black54,
                            )),
                        SizedBox(
                          width: 16,
                        ),
                        Text(
                          'or',
                          style: TextStyle(
                              color: Colors.black54,
                              fontSize: 16,
                              fontWeight: FontWeight.w600),
                        ),
                        SizedBox(
                          width: 16,
                        ),
                        Expanded(
                            child: Divider(
                              color: Colors.black54,
                            )),
                      ],
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    SizedBox(
                        width: MediaQuery.of(context).size.width*4,
                        height: 50,
                        child: ElevatedButton(

                            onPressed: (){
                              Navigator.pushNamed(context, '/home');
                              if (kDebugMode) {
                                print('Teacher.');
                              } },
                            style: ElevatedButton.styleFrom(
                              textStyle: const TextStyle(color: Colors.white),
                              backgroundColor: buttonColor,
                              padding: const EdgeInsets.fromLTRB(5, 0, 5, 0),
                              shape: const RoundedRectangleBorder(
                                  borderRadius: BorderRadius.all(Radius.circular(10))),
                            ),
                            child: Padding(
                                padding: const EdgeInsets.fromLTRB(0,0,0,0),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: <Widget>[
                                    Container(
                                      color: buttonColor,
                                      padding: const EdgeInsets.fromLTRB(10, 4, 4, 4),
                                      child:  Text('Continue As Teacher',
                                          style: GoogleFonts.alegreyaSans(fontSize: 18, color: Colors.white)),
                                    ),
                                     const Padding(
                                      padding: EdgeInsets.all(10),
                                      child: Icon(
                                        Icons.arrow_forward_ios,
                                        color:Colors.white,
                                        size: 40,
                                      ),
                                    ),
                                  ],
                                )))),
                  ],
                ),
              )
              // RaisedButton(
              //   child: const Text('Student'),
              //   onPressed: () {
              //     Navigator.pushNamed(context, '/homestu');
              //   },
              // ),
              // RaisedButton(
              //   child: const Text('Teacher'),
              //   onPressed: () {
              //     Navigator.pushNamed(context, '/home');
              //   },
              // ),
            ],
          )),
    );
  }
}
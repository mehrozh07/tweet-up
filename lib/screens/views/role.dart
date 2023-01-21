import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class Role extends StatefulWidget {
  static const routeName = '/role';

  const Role({Key? key}) : super(key: key);

  @override
  _roleState createState() => _roleState();
}

class _roleState extends State<Role> {

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User?>(context);
    var size = MediaQuery.of(context).size;
    Color buttonColor = Theme.of(context).primaryColor;
    final name = user != null ? user.displayName : 'Name';
    return Scaffold(
      appBar: AppBar(
        title: Text('Tweet Up',
          style: GoogleFonts.poppins(
            textStyle: const TextStyle(
              color: Colors.white,
            )
          ),),
        automaticallyImplyLeading: false,
        centerTitle: true,
        backgroundColor: buttonColor,
      ),
      body: Center(
          child: Column(
            children: <Widget>[
              Padding(
          padding:  const EdgeInsets.only(top: 10),
          child: Padding(
            padding: const EdgeInsets.only(left: 10, right: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Expanded(
                  child: TextButton(
                    style: TextButton.styleFrom(
                      backgroundColor: Theme.of(context).primaryColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                      onPressed: (){
                        showModalBottomSheet<void>(
                          context: context,
                          shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.only(
                                topRight: Radius.circular(12),
                                topLeft: Radius.circular(12)),
                          ),
                          builder: (BuildContext context) {
                            return Container(
                              height: 200,
                              decoration: BoxDecoration(
                                color: Colors.grey.shade300,
                                borderRadius: const BorderRadius.only(
                                    topRight: Radius.circular(12),
                                    topLeft: Radius.circular(12)),
                              ),
                              child: Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: <Widget>[
                                    const ListTile(
                                      title: Text('Start instant meeting'),
                                      leading: Icon(Icons.video_call),
                                    ),
                                    const ListTile(
                                      title: Text('Scheduled class'),
                                      leading: Icon(Icons.date_range),
                                    ),
                                    ListTile(
                                      title: const Text('Close'),
                                      leading: const Icon(Icons.close),
                                      onTap: () => Navigator.pop(context),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        );
                      },
                      child: Text('New Meeting',
                      style: GoogleFonts.poppins(
                        textStyle: const TextStyle(
                          color: Colors.white,
                        )
                      ),),
                  ),
                ),
                SizedBox(width: MediaQuery.of(context).size.width*0.02,),
                Expanded(
                  child: TextButton(
                    style: TextButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                        side: BorderSide(color: Theme.of(context).primaryColor),
                      ),
                    ),
                    onPressed: (){

                    },
                    child: Text('Join with a code',
                      style: GoogleFonts.poppins(
                          textStyle: TextStyle(
                            color: Theme.of(context).primaryColor,
                            fontWeight: FontWeight.w600,
                          )
                      ),),
                  ),
                ),
              ],
            ),
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
              SizedBox(height: MediaQuery.of(context).size.height*0.03,),
              Padding(
                padding: const EdgeInsets.only(right: 12, left: 12),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: TextButton(
                              onPressed: (){
                                Navigator.pushNamed(context, '/homestu');
                                if (kDebugMode) {
                                print('Student.');
                              } },
                              style: TextButton.styleFrom(
                                textStyle: const TextStyle(
                                  color: Colors.white,
                                ),
                                backgroundColor: buttonColor,
                                padding: const EdgeInsets.fromLTRB(5, 0, 5, 0),
                                shape: const RoundedRectangleBorder(
                                    borderRadius: BorderRadius.all(Radius.circular(10))),
                              ),
                              child: Text('Continue As Student',
                                  style: GoogleFonts.alegreyaSans(fontSize: 18, color: Colors.white)),
                          ),
                        ),
                      ],
                    ),
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
                    Row(
                      children: [
                        Expanded(
                          child: TextButton(
                              onPressed: (){
                                Navigator.pushNamed(context, '/home');
                                if (kDebugMode) {
                                  print('Teacher.');
                                } },
                              style: TextButton.styleFrom(
                                textStyle: const TextStyle(color: Colors.white),
                                backgroundColor: buttonColor,
                                padding: const EdgeInsets.fromLTRB(5, 0, 5, 0),
                                shape: const RoundedRectangleBorder(
                                    borderRadius: BorderRadius.all(Radius.circular(10))),
                              ),
                              child: Text('Continue As Teacher',
                                  style: GoogleFonts.alegreyaSans(fontSize: 18, color: Colors.white)),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          )),
    );
  }
}
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../services/firestore_service.dart';

class JoinMeetings extends StatefulWidget {
  const JoinMeetings({Key? key}) : super(key: key);

  @override
  State<JoinMeetings> createState() => _JoinMeetingsState();
}

class _JoinMeetingsState extends State<JoinMeetings> {
  var firebaseService = FirestoreService();
  var meetingIdController = TextEditingController();
  var meetingPasswordController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            TextFormField(
              controller: meetingIdController,
              decoration: const InputDecoration(
                border: UnderlineInputBorder(),
                filled: true,
                fillColor: Colors.black12,
                hintText: "meeting id"
              ),
            ),
            const SizedBox(height: 12,),
            TextFormField(
              controller: meetingPasswordController,
              decoration: const InputDecoration(
                  border: UnderlineInputBorder(),
                  filled: true,
                  fillColor: Colors.black12,
                  hintText: "meeting password"
              ),
            ),
            const SizedBox(height: 12,),
            CupertinoButton(
              color: Theme.of(context).primaryColor,
                child: const Text("join"),
                onPressed: (){
                  firebaseService.joinMeeting(context, meetingIdController.text, meetingPasswordController.text, "Mehroz Hassan");
                }
            )
          ],
        ),
      ),
    );
  }
}

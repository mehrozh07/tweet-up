import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tweetup_fyp/screens/authenticate/login.dart';

class Utils{
  static snackBar({required message, required context, required Color color}){
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message,
          style: const TextStyle(
            color: Colors.white,
          ),
        ),
        backgroundColor: color,
        behavior: SnackBarBehavior.floating,
     ),
    );
  }

  static Future<void> alertDialogue(
      {title, context, buttonText, content})async {
    showDialog<void>(
      context: context,
      barrierDismissible: true,
      // false = user must tap button, true = tap outside dialog
      builder: (BuildContext dialogContext) {
        return CupertinoAlertDialog(
          title: const Text('Logout'),
          content: const Text('Are You Sure?'),
          actions: <Widget>[
            TextButton(
              child: Text('$title',
              style: TextStyle(color: Theme.of(context).primaryColor),),
              onPressed: () {
                FirebaseAuth.instance.signOut().then((value){
                  Navigator.popUntil(context, (route) => route.isFirst);
                  Navigator.pushReplacementNamed(context, LoginScreen.id);
                });
              },
            ),
          ],
        );
      },
    );
  }

  showAlertDialogBox(BuildContext context,){
    Widget cancelButton = TextButton(
        onPressed: (){},
        child:  const Text("Cancel")
    );
    Widget deleteButton = TextButton(onPressed: (){

    },
      child:  const Text("Delete"),
    );
    AlertDialog alertDialog =  AlertDialog(
      title:  const Text("Alert Box"),
      content: const Text  ("Do You want to delete " ),
      actions: [
        cancelButton,
        deleteButton,
      ],
    );
  }

}
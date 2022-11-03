import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:tweetup_fyp/screens/authenticate/login.dart';
import 'package:tweetup_fyp/widgets/flush_bar.dart';
import 'dart:async';
import '../screens/views/role.dart';

class AuthService extends ChangeNotifier{
  final Utils _utils = Utils();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  BuildContext? context;
  String error = '';
  Stream<User?> get user {
    return _auth.authStateChanges();
  }

  Future signOut() async {
    try {
      return await _auth.signOut();
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
      notifyListeners();
    }
  }

  Future signIn(String email, String password, BuildContext context) async {
    try {
      UserCredential result = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      Navigator.pushNamed(
        context,
        Role.routeName,
      ).then((value) {
        _utils.flushBarErrorMessage('Congrats', context);
      });
      notifyListeners();
      User? user = result.user;
      notifyListeners();
      if (!user!.emailVerified) {
        signOut();
        _utils.flushBarErrorMessage('Please verify your email address by clicking on the link sent on your registered email id.😅', context);
        notifyListeners();
      }else{
        // ignore: use_build_context_synchronously
        Navigator.pushReplacementNamed(context, Role.routeName);
        notifyListeners();
      }
      notifyListeners();
      return user;
    } on FirebaseAuthException catch (e) {
      error = e.code;
      _utils.flushBarErrorMessage(e.code, context);
      notifyListeners();
      return null;
    }catch(e){
      error = e.toString();
      _utils.flushBarErrorMessage(e.toString(), context);
      if (kDebugMode) {
        print(e.toString());
      }
      notifyListeners();
    }
  }

  Future<void> resetPassword(String email,BuildContext context ) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
      notifyListeners();
      _utils.flushBarErrorMessage('Check your email for resetting your password', context);
      notifyListeners();
    } catch(e){
      error = e.toString();
      _utils.flushBarErrorMessage(e.toString(), context);
      notifyListeners();
    }
  }
 UserCredential? userCredential;
  Future<UserCredential?> signUp(String email, String password, String name, BuildContext context) async {

    try {
      userCredential = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      Navigator.pushNamed(context, LoginScreen.id);
      notifyListeners();
      User? user = userCredential!.user;
      notifyListeners();
      user?.sendEmailVerification();
      notifyListeners();
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Please verify your email address by clicki'
          'ng on the link sent on your registered email id and then try to sign-In  😅',),behavior: SnackBarBehavior.floating,
      backgroundColor: Colors.pink,));
      notifyListeners();
      await FirebaseAuth.instance.currentUser?.updateProfile(
        displayName: name,
      );
      signOut();
      notifyListeners();
      return userCredential;
    } on FirebaseAuthException catch(e){
      _utils.flushBarErrorMessage(e.toString(), context);
      notifyListeners();
      return userCredential;
    }
  }

  Future signInWithGoogle(BuildContext context) async {
    try {
      final GoogleSignInAccount? googleSignInAccount =
          await googleSignIn.signIn();
      final GoogleSignInAuthentication googleSignInAuthentication =
          await googleSignInAccount!.authentication;

      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleSignInAuthentication.accessToken,
        idToken: googleSignInAuthentication.idToken,
      );

      final UserCredential authResult =
          await _auth.signInWithCredential(credential);
      final User? user = authResult.user;

      assert(!user!.isAnonymous);
      assert(await user!.getIdToken() != null);
      final User? currentUser = _auth.currentUser;
      assert(user?.uid == currentUser?.uid);
      return user;
    } catch (e) {
      _utils.flushBarErrorMessage(e.toString(), context);
      return null;
    }
  }
}
final FirebaseAuth _auth = FirebaseAuth.instance;
final GoogleSignIn googleSignIn = GoogleSignIn();

// class AuthService {
//   final FirebaseAuth _auth = FirebaseAuth.instance;

//   Stream<User> get user {
//     return _auth.authStateChanges();
//   }

//   Future signOut() async {
//     try {
//       return await _auth.signOut();
//     } catch (e) {
//       print(e);
//     }
//   }

//   Future signIn(String email, String password) async {
//     UserCredential result = await _auth.signInWithEmailAndPassword(
//         email: email, password: password);
//     User user = result.user;
//     if (user.emailVerified != true) {
//       print('verified');
//       return null;
//     } else
//       return user;
//   }

//   Future signUp(String email, String password) async {
//     UserCredential result = await _auth.createUserWithEmailAndPassword(
//         email: email, password: password);
//     User user = result.user;
//     try {
//       await user.sendEmailVerification();
//       return null;
//     } catch (e) {
//       print("An error occured while trying to send email verification");
//       print(e.message);
//     }
//   }

//   Future signInWithGoogle() async {
//     final GoogleSignInAccount googleSignInAccount = await googleSignIn.signIn();
//     final GoogleSignInAuthentication googleSignInAuthentication =
//         await googleSignInAccount.authentication;

//     final AuthCredential credential = GoogleAuthProvider.credential(
//       accessToken: googleSignInAuthentication.accessToken,
//       idToken: googleSignInAuthentication.idToken,
//     );

//     final UserCredential authResult =
//         await _auth.signInWithCredential(credential);
//     final User user = authResult.user;

//     assert(!user.isAnonymous);
//     assert(await user.getIdToken() != null);

//     final User currentUser = _auth.currentUser;
//     assert(user.uid == currentUser.uid);
//     return user;
//   }
// }

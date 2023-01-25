import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:tweetup_fyp/generated/assets.dart';
import 'package:tweetup_fyp/screens/authenticate/sign_up.dart';
import 'package:tweetup_fyp/screens/views/home.dart';
import 'package:tweetup_fyp/screens/views/role.dart';
import '../../services/auth.dart';
import '../../widgets/flush_bar.dart';

class LoginScreen extends StatefulWidget {
  static const id = '/login-screen';
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final email = TextEditingController();
  bool _loading = false;
  bool loading = false;
  final pass = TextEditingController();
  final AuthService _auth = AuthService();
  String err = '';
  bool _isPasswordVisible = true;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  void toggle() {
    setState(() {
      _isPasswordVisible = !_isPasswordVisible;
    });
  }

  showLoaderDialog(BuildContext context) {
    AlertDialog alert = AlertDialog(
      content: Row(
        children: [
          const CircularProgressIndicator(),
          Container(
              margin: const EdgeInsets.only(left: 7),
              child: const Text("Signing In...")),
        ],
      ),
    );
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  final Utils _utils = Utils();
  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          children: [
            SizedBox(
              height: height * 0.1,
            ),
           Image.asset( Assets.imagesAppLogo,
             height: height*0.2,
             width: MediaQuery.of(context).size.width*0.2,
           ),
            SizedBox(height: height * 0.1),
            TextFormField(
              controller: email,
              keyboardType: TextInputType.emailAddress,
              textInputAction: TextInputAction.next,
              cursorColor: Theme.of(context).primaryColor,
              validator: (value) {
                if (value!.isEmpty) {
                  return "* Required";
                } else {
                  return null;
                }
              },
              decoration: InputDecoration(
                contentPadding: const EdgeInsets.only(left: 4, right: 5, top: 0, bottom: 0),
                prefixIcon: Icon(
                  Icons.email_outlined,
                  color: Theme.of(context).primaryColor,
                ),
                hintText: 'Email',
                hintStyle:
                    TextStyle(color: Theme.of(context).primaryColor),
                labelText: 'Email',
                labelStyle:
                    TextStyle(color: Theme.of(context).primaryColor),
                focusedBorder: OutlineInputBorder(
                  borderRadius: const BorderRadius.all(
                    Radius.circular(10),
                  ),
                  borderSide: BorderSide(
                      color: Theme.of(context).primaryColor,
                      width: 1),
                ),
                enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Theme.of(context).primaryColor,
                    ),
                    borderRadius: BorderRadius.circular(8)),
                border: const OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(8))
                ),
              ),
            ),
            SizedBox(
              height: height * 0.02,
            ),
            TextFormField(
              controller: pass,
              obscureText: _isPasswordVisible,
              keyboardType: TextInputType.visiblePassword,
              textInputAction: TextInputAction.go,
              cursorColor: Theme.of(context).primaryColor,
              validator: (value) {
                if (value!.isEmpty) {
                  return "* Required";
                } else if (value.length < 6) {
                  return "Password should be at least 6 characters";
                } else if (value.length > 15) {
                  return "Password should not be greater than 15 characters";
                } else {
                  return null;
                }
              },
              decoration: InputDecoration(
                prefixIcon: Icon(
                  CupertinoIcons.lock,
                  color: Theme.of(context).primaryColor,
                ),
                contentPadding: const EdgeInsets.only(left: 4, right: 5, top: 0, bottom: 0),
                hintText: 'password',
                hintStyle: TextStyle(color: Theme.of(context).primaryColor),
                labelText: 'password',
                labelStyle: TextStyle(color: Theme.of(context).primaryColor),
                suffixIcon: InkWell(
                  onTap: () {
                    toggle();
                  },
                  child: Icon(
                    _isPasswordVisible
                        ? Icons.visibility_outlined
                        : Icons.visibility_off_outlined,
                    color: Theme.of(context).primaryColor,
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: const BorderRadius.all(Radius.circular(10)),
                  borderSide: BorderSide(color: Theme.of(context).primaryColor, width: 1),
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Theme.of(context).primaryColor,
                  ),
                  borderRadius: BorderRadius.circular(8),
                ),
                border: const OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(8))
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                GestureDetector(
                  onTap: () async {
                    setState(() {
                      _loading = true;
                    });
                    await _auth.resetPassword(email.text, context);
                    setState(() {
                      _loading = false;
                      // err = value.error.toString();
                      // _utils.flushBarErrorMessage('ok', context);
                    });
                  },
                  child: Text(
                    "Forgot Password?",
                    style: TextStyle(
                        color: Theme.of(context).primaryColor),
                  ),
                )
              ],
            ),
            SizedBox(
              height: height * 0.04,
            ),
            CupertinoButton(
              color: Theme.of(context).primaryColor,
              padding: EdgeInsets.zero,
              onPressed: () async {
                if (_formKey.currentState!.validate()) {
                  setState(() {
                    _loading = true;
                  });
                  await _auth
                      .signIn(email.text, pass.text, context)
                      .then((value) {
                    if (value != null) {
                      setState(() {
                        _loading = false;
                      });
                    }
                  });
                  setState(() {
                    _loading = false;
                  });
                  // print('$err err msg');
                } else {
                  if (kDebugMode) {
                    print("Not Validate");
                  }
                  setState(() {
                    _loading = false;
                  });
                  _utils.flushBarErrorMessage('Not Validate', context);
                  _loading = false;
                }
              },
              child: const Text('Login'),
            ),
            SizedBox(height: height*0.04,),
            Row(
              children: [
                Expanded(child: Divider(color: Theme.of(context).primaryColor,thickness: 2,)),
                SizedBox(width: width*0.03,),
                const Text('or'),
                SizedBox(width: width*0.03,),
                Expanded(child: Divider(color: Theme.of(context).primaryColor,thickness: 2,)),
              ],
            ),
            SizedBox(height: height*0.04,),
            Row(
              children: [
                Expanded(
                  child: TextButton(
                    style: TextButton.styleFrom(
                      backgroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5),
                        side: BorderSide(color: Theme.of(context).primaryColor)
                      )
                    ),
                      onPressed: (){
                      _auth.signInWithGoogle(context).then((value){
                        Navigator.pushReplacementNamed(context, Role.routeName);
                      });
                      },
                      child: Image.asset(Assets.imagesGoogleLogo, height: 30,),
                  ),
                ),
                SizedBox(width: width*0.08,),
                Expanded(
                  child: TextButton(
                    style: TextButton.styleFrom(
                        backgroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5),
                            side: BorderSide(color: Theme.of(context).primaryColor)
                        )
                    ),
                    onPressed: (){},
                    child: Image.asset(Assets.imagesMobile, height: 30,),
                  ),
                ),
                SizedBox(width: width*0.1,),
                Expanded(
                  child: TextButton(
                    style: TextButton.styleFrom(
                        backgroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5),
                            side: BorderSide(color: Theme.of(context).primaryColor)
                        )
                    ),
                    onPressed: (){},
                    child: Image.asset(Assets.imagesFacebook, height: 30,),
                  ),
                ),
              ],
            ),
            SizedBox(
              height: height * 0.05,
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Wrap(
                  children: [
                    const Text(
                      "Not a member?",
                      style: TextStyle(fontSize: 16),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.pushNamed(
                          context,
                          Register.routeName,
                        );
                      },
                      child: Text(
                        "Register",
                        softWrap: true,
                        style: TextStyle(
                            color: Theme.of(context).primaryColor,
                            fontSize: 16),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            SizedBox(
              height: height * 0.03,
            ),
          ],
        ),
      ),
    );
  }
}

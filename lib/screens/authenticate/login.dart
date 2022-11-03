import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:tweetup_fyp/screens/authenticate/sign_up.dart';
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

  Utils _utils = Utils();
  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    final textSize = MediaQuery.textScaleFactorOf(context);
    return Scaffold(
      body: Container(
        height: height,
        width: width,
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              children: [
               Image.asset( 'assets/images/login_banner.png',
                 height: 300,
               width: MediaQuery.of(context).size.width,
               ),
                Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Column(
                    children: [
                      SizedBox(
                        height: height * 0.09,
                      ),
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
                              borderRadius: BorderRadius.circular(10)),
                          border: const OutlineInputBorder(),
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
                            Icons.lock_open_outlined,
                            color: Theme.of(context).primaryColor,
                          ),
                          hintText: 'password',
                          hintStyle:
                              TextStyle(color: Theme.of(context).primaryColor),
                          labelText: 'password',
                          labelStyle:
                              TextStyle(color: Theme.of(context).primaryColor),
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
                            borderRadius:
                                const BorderRadius.all(Radius.circular(10)),
                            borderSide: BorderSide(
                                color: Theme.of(context).primaryColor,
                                width: 1),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Theme.of(context).primaryColor,
                            ),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          border: const OutlineInputBorder(),
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
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
                    ],
                  ),
                ),
                SizedBox(
                  height: height * 0.04,
                ),
                Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: MaterialButton(
                    height: 50,
                    minWidth: 340,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
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
                    color: Colors.indigoAccent,
                    child: _loading
                        ? const CircularProgressIndicator(
                            color: Colors.white,
                            backgroundColor: Colors.transparent,
                          )
                        : const Text(
                            "Login",
                            style: TextStyle(
                              fontSize: 24,
                              color: Colors.white,
                            ),
                          ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: MaterialButton(
                    height: 50,
                    minWidth: 340,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                    onPressed: () async {
                      await _auth.signInWithGoogle(context);
                      setState(() {
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const Role()));
                        if (kDebugMode) {
                          print(err);
                        }
                      });
                    },
                    color: Colors.indigoAccent,
                    child: loading
                        ? const CircularProgressIndicator(
                            color: Colors.white,
                            backgroundColor: Colors.transparent,
                          )
                        : Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image.asset('assets/images/google_logo.png', height: 30,),
                            SizedBox(width: width*3/100),
                            const Text(
                                "sign in with Google",
                                style: TextStyle(
                                  fontSize: 23,
                                  color: Colors.white,
                                ),
                              ),
                          ],
                        ),
                  ),
                ),
                SizedBox(
                  height: height * 0.08,
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Wrap(
                      children: [
                        const Text(
                          "I'm a new user,",
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
                            "Sign Up",
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
              ],
            ),
          ),
        ),
      ),
    );
  }
}

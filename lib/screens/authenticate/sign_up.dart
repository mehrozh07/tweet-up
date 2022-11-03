import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:tweetup_fyp/screens/authenticate/login.dart';
import 'package:tweetup_fyp/services/auth.dart';
import 'package:tweetup_fyp/widgets/flush_bar.dart';


class Register extends StatefulWidget {
  static const routeName = '/Register';
  const Register({Key? key}) : super(key: key);

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final emailC = TextEditingController();
  final nameC = TextEditingController();
  bool _loading = false;
  final pass = TextEditingController();
  String email = '';
  String name = '';
  String password = '';
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
                        controller: nameC,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return "* Required";
                          } else {
                            return null;
                          }
                        },
                        inputFormatters: [
                          FilteringTextInputFormatter.allow(
                            RegExp(r"[a-zA-Z]+|\s"),
                          )
                        ],
                        textInputAction: TextInputAction.next,
                        decoration: InputDecoration(
                          prefixIcon: Icon(
                            Icons.person_outline,
                            color: Theme.of(context).primaryColor,
                          ),
                          hintText: 'Name',
                          hintStyle:
                          TextStyle(color: Theme.of(context).primaryColor),
                          labelText: 'Name',
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
                      SizedBox(height: height*2/100,),
                      TextFormField(
                        controller: emailC,
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
                          name = nameC.text.toString().trim();
                          email = emailC.text.toString().trim();
                          password = pass.text.toString().trim();
                        });
                        _loading = true;
                        await _auth.signUp(email, password, name, context);
                      } else {
                        _loading = true;
                        _utils.flushBarErrorMessage(
                            "Registration Failed", context);
                      }
                    },
                    color: Colors.indigoAccent,
                    child: _loading
                        ? const CircularProgressIndicator(
                            color: Colors.white,
                            backgroundColor: Colors.transparent,
                          )
                        :  Text(
                            "Sign Up",
                            style: TextStyle(
                              fontSize: textSize * 24,
                              color: Colors.white,
                            ),
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
                         Text(
                          "Already a member?",
                          style: TextStyle(fontSize: textSize * 16),
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.pushNamed(
                              context,
                              LoginScreen.id,
                            );
                          },
                          child: Text(
                            "Sign In",
                            softWrap: true,
                            style: TextStyle(
                                color: Theme.of(context).primaryColor,
                                fontSize: textSize * 16),
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

// import 'dart:io';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:firebase_storage/firebase_storage.dart';
// import 'package:flutter/foundation.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:google_class_room/widgets/flush_bar.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:provider/provider.dart';
// import '../../models/error.dart';
// import '../../services/auth.dart';
// import '../../services/loading.dart';
//
// class SignUp extends StatefulWidget {
//   static const routeName = '/signup';
//   @override
//   _SignUpState createState() => _SignUpState();
// }
//
// class _SignUpState extends State<SignUp> {
//   File? _pickedImage;
//   bool loading = false;
//   final email = TextEditingController();
//   final name = TextEditingController();
//   final pass = TextEditingController();
//   final Utils _utils = Utils();
//   final passConfirm = TextEditingController();
//   String? url;
//   final AuthService _auth = AuthService();
//   final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
//   String err = '';
//   String? _fullname;
//   String emailC = '';
//   String passwordC = '';
//   void _pickImageCamera() async {
//     final picker = ImagePicker();
//     final pickedImage =
//     await picker.getImage(source: ImageSource.camera, imageQuality: 10);
//     final pickedImageFile = File(pickedImage!.path);
//     setState(() {
//       _pickedImage = pickedImageFile;
//     });
//     Navigator.pop(context);
//   }
//
//   void _pickImageGallery() async {
//     final picker = ImagePicker();
//     final pickedImage = await picker.getImage(source: ImageSource.gallery);
//     final pickedImageFile = File(pickedImage!.path);
//     setState(() {
//       _pickedImage = pickedImageFile;
//     });
//     Navigator.pop(context);
//   }
//
//   void _remove() {
//     setState(() {
//       _pickedImage = null;
//     });
//     Navigator.pop(context);
//   }
//   final FirebaseAuth _auth1 = FirebaseAuth.instance;
//   showLoaderDialog(BuildContext context){
//     AlertDialog alert=AlertDialog(
//       content:  Row(
//         children: [
//           const CircularProgressIndicator(),
//           Container(margin: const EdgeInsets.only(left: 7),
//               child:const Text("Signing In..." )),
//         ],),
//     );
//     showDialog(barrierDismissible: false,
//       context:context,
//       builder:(BuildContext context){
//         return alert;
//       },
//     );
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     final _authProvider = Provider.of<AuthService>(context);
//     var size = MediaQuery.of(context).size.height;
//     var date = DateTime.now().toString();
//     var dateparse = DateTime.parse(date);
//     var formattedDate = "${dateparse.day}-${dateparse.month}-${dateparse.year}";
//     return loading
//         ? Loader()
//         : Scaffold(
//             backgroundColor: Theme.of(context).primaryColor,
//             body: Form(
//               key: _formKey,
//               child: SingleChildScrollView(
//                 child: Container(
//                   color: Colors.white,
//                   width: double.infinity,
//                   height: MediaQuery.of(context).size.height * 100,
//                   child: Stack(
//                     children: [
//                       Container(
//                         width: 375,
//                         height: 321,
//                         color: const Color(0xffFF6A83),
//                         child: Padding(
//                           padding: EdgeInsets.only(left: 20, top: 14),
//                           child: Wrap(
//                             children: [
//                               Text("Welcome",
//                                   style: GoogleFonts.alegreyaSansSc(
//                                       fontSize: 49,
//                                       fontWeight: FontWeight.bold)),
//                               // Padding(
//                               //   padding:
//                               //   EdgeInsets.only(right: 100.w, top: 10.h),
//                               //   child: Text(
//                               //     "Manage your classes",
//                               //     style: GoogleFonts.alegreyaSans(
//                               //       fontSize: 18.sp,
//                               //     ),
//                               //   ),
//                               // ),
//                             ],
//                           ),
//                         ),
//                       ),
//                       Stack(
//                         children: [
//                           Container(
//                             margin: EdgeInsets.symmetric(vertical: 70, horizontal: 120),
//                             child: CircleAvatar(
//                               radius: 70,
//                               backgroundColor: Colors.pinkAccent.shade400,
//                               child: CircleAvatar(
//                                 radius: 65,
//                                 backgroundColor: Colors.pinkAccent.shade100,
//                                 backgroundImage: _pickedImage == null? null : FileImage(_pickedImage!),
//                               ),
//                             ),
//                           ),
//                           Positioned(
//                             right: 85,
//                               top: 130,
//                               child: RawMaterialButton(
//                                 onPressed: (){
//                                   showDialog(context: context, builder:(BuildContext context){
//                                     return AlertDialog(
//                                       title: Text("choose option".toLowerCase(),
//                                         style:  TextStyle(fontWeight: FontWeight.w600, color: Colors.pinkAccent.shade400),
//                                       ),
//                                       content: SingleChildScrollView(
//                                         child: ListBody(
//                                           children: [
//                                             InkWell(
//                                               splashColor: Colors.pink,
//                                               onTap: (){
//                                                 _pickImageCamera();
//                                               },
//                                               child: Row(
//                                                 children:  [
//                                                   const Padding(
//                                                     padding: EdgeInsets.all(8.0),
//                                                     child: Icon(Icons.camera, color: Colors.pinkAccent,),
//                                                   ),
//                                                   Text("camera", style: TextStyle(fontSize: 18, color: Colors.black38,
//                                                   fontWeight: FontWeight.w400),),
//
//                                                 ],
//                                               ),
//                                             ),
//                                             InkWell(
//                                               splashColor: Colors.pink,
//                                               onTap: (){
//                                                 _pickImageGallery();
//                                               },
//                                               child: Row(
//                                                 children:  [
//                                                   const Padding(
//                                                     padding: EdgeInsets.all(8.0),
//                                                     child: Icon(Icons.image_sharp, color: Colors.pinkAccent,),
//                                                   ),
//                                                   Text("Gallery", style: TextStyle(fontSize: 18, color: Colors.black38,
//                                                       fontWeight: FontWeight.w400),),
//
//                                                 ],
//                                               ),
//                                             ),
//                                             InkWell(
//                                               onTap: (){
//                                                 _remove();
//                                               },
//                                               splashColor: Colors.pink,
//                                               child: Row(
//                                                 children:  [
//                                                   const Padding(
//                                                     padding: EdgeInsets.all(8.0),
//                                                     child: Icon(Icons.delete, color: Colors.red,),
//                                                   ),
//                                                   Text("Remove", style: TextStyle(fontSize: 18, color: Colors.red,
//                                                       fontWeight: FontWeight.w400),),
//
//                                                 ],
//                                               ),
//                                             ),
//                                           ],
//                                         ),
//                                       ),
//                                     );
//                                   });
//                                 },
//                                 elevation: 10,
//                                   fillColor: Colors.pinkAccent.shade400,
//                                 padding: EdgeInsets.all(15),
//                                 shape: const CircleBorder(),
//                                 child: const Icon(Icons.add_a_photo),
//                               ),
//                           )
//                         ],
//                       ),
//                       Positioned(
//                         top: 212,
//                         child: Padding(
//                           padding: EdgeInsets.symmetric(horizontal: 25),
//                           child: Container(
//                             width: 326,
//                             height: 409,
//                             decoration: BoxDecoration(
//                               boxShadow: [
//                                 BoxShadow(
//                                   color: Colors.grey,
//                                   blurRadius: 5,
//                                   spreadRadius: 0,
//                                   offset: Offset(2, 2), // shadow direction: bottom right
//                                 )
//                               ],
//                               color: Colors.white,
//                               borderRadius: BorderRadius.circular(8),
//                               backgroundBlendMode: BlendMode.colorDodge,
//                               border: Border.all(
//                                 width: 1,
//                                 color: const Color(0xffFF6A83),
//                               ),
//                             ),
//                             child: Padding(
//                               padding: EdgeInsets.only(
//                                 left: 30,
//                                 right: 30,
//                                 top: 30,
//                               ),
//                               child: SingleChildScrollView(
//                                 child: Column(
//                                   children: [
//                                     Text('Sign Up',
//                                         style: GoogleFonts.questrial(
//                                           fontSize: 23.0,
//                                           fontWeight: FontWeight.w900,
//                                           color: const Color(0xffFF6A83),
//                                           wordSpacing: 2.5,
//                                         )),
//                                     SizedBox(
//                                       height: 20,
//                                     ),
//                                     TextFormField(
//                                       controller: email,
//                                       validator: (value) {
//                                         if (value!.isEmpty) {
//                                           return "* Required";
//                                         } else {
//                                           return null;
//                                         }
//                                       },
//                                       keyboardType: TextInputType.emailAddress,
//                                       decoration: InputDecoration(
//                                         prefixIcon: const Icon(Icons.email, color:
//                                           Colors.black,),
//                                         hintText: 'Email',
//                                         focusedBorder: OutlineInputBorder(
//                                           borderRadius: BorderRadius.all(
//                                               Radius.circular(20)),
//                                           borderSide: BorderSide(
//                                               color: const Color(0xffFF6A83),
//                                               width: 1),
//                                         ),
//                                         enabledBorder: OutlineInputBorder(
//                                           borderSide: BorderSide(
//                                               color: const Color(0xffFF6A83),
//                                               width: 1),
//                                         ),
//                                       ),
//                                     ),
//                                     SizedBox(
//                                       height: 10,
//                                     ),
//                                 TextFormField(
//                                   controller: name,
//                                   validator: (value) {
//                                     if (value!.isEmpty) {
//                                       return "* Required";
//                                     } else {
//                                       return null;
//                                     }
//                                   },
//                                   inputFormatters: [
//                                     FilteringTextInputFormatter.allow(
//                                       RegExp(r"[a-zA-Z]+|\s"),
//                                     )
//                                   ],
//                                   textInputAction: TextInputAction.next,
//                                   decoration: const InputDecoration(
//                                     prefixIcon: Icon(Icons.people_alt_outlined,
//                                     color: Colors.black,),
//                                     prefixIconColor: Colors.black,
//                                     hintText: 'Name',
//                                     focusedBorder: OutlineInputBorder(
//                                       borderRadius: BorderRadius.all(
//                                           Radius.circular(20)),
//                                       borderSide: BorderSide(
//                                           color: Colors.red,
//                                           width: 1),
//                                     ),
//                                     enabledBorder: OutlineInputBorder(
//                                       borderSide: BorderSide(
//                                           color: Color(0xffFF6A83),
//                                           width: 1),
//                                                                 ),
//                                                               ),
//                                                             ),
//                                     const SizedBox(height: 10,),
//                                     TextFormField(
//                                       controller: pass,
//                                       obscureText: true,
//                                       validator: (value) {
//                                         if (value!.isEmpty) {
//                                           return "* Required";
//                                         } else if (value.length < 6) {
//                                           return "Password should be atleast 6 characters";
//                                         } else if (value.length > 15) {
//                                           return "Password should not be greater than 15 characters";
//                                         } else {
//                                           return null;
//                                         }
//                                       },
//                                       decoration: InputDecoration(
//                                         prefixIcon: const Icon(Icons.lock,
//                                           color: Colors.black,),
//                                         hintText: 'Password',
//                                         focusedBorder: OutlineInputBorder(
//                                           borderRadius: BorderRadius.all(
//                                               Radius.circular(20)),
//                                           borderSide: BorderSide(
//                                               color: const Color(0xffFF6A83),
//                                               width: 1),
//                                         ),
//                                         enabledBorder: OutlineInputBorder(
//                                           borderSide: BorderSide(
//                                               color: const Color(0xffFF6A83),
//                                               width: 1),
//                                         ),
//                                       ),
//                                     ),
//                                     SizedBox(height: 10,),
//                                   ],
//                                 ),
//                               ),
//                             ),
//                           ),
//                         ),
//                       ),
//                       Positioned(
//                           top: 598,
//                           left: 158,
//                           child: CircleAvatar(
//                             radius: 38,
//                             backgroundColor: Colors.white,
//                             child: ElevatedButton(
//                                 style: ElevatedButton.styleFrom(
//                                   shape: const CircleBorder(),
//                                   primary: const Color(0xffFF6A83),
//                                 ),
//                                 onPressed: () async {
//                                   if(_pickedImage ==null){
//                                     _utils.flushBarErrorMessage("Please Select Image", context);
//                                   }else{
//                                     if(_formKey.currentState!.validate()){
//                                       setState(() {
//                                         loading = true;
//                                       });
//                                       final ref = FirebaseStorage.instance
//                                           .ref()
//                                           .child('usersImages')
//                                           .child('UserImage${DateTime.now().millisecondsSinceEpoch.toString()}.jpg');
//                                       await ref.putFile(_pickedImage!);
//                                       url = await ref.getDownloadURL();
//                                       var value = ErrorMsg(' ');
//                                       await _authProvider.signUp(email.text,
//                                           pass.text, value, name.text,context).then((value){
//                                         final User? user = _auth1.currentUser;
//                                         final _uid = user?.uid;
//                                         FirebaseFirestore.instance.collection('usersData').doc(_uid).set(
//                                             {
//                                               "email": email.text,
//                                               "name": name.text,
//                                               "id": _uid,
//                                               "imageUrl": url,
//                                               "jointAt": formattedDate,
//                                               "createAt": Timestamp.now(),
//                                             });
//                                         Navigator.canPop(context) ? Navigator.pop(context) : null;
//                                       });
//                                       setState(() {
//                                         loading = false;
//                                         err = value.error.toString();
//                                       });
//                                       if (kDebugMode) {
//                                         print(value);
//                                       }
//                                     }else{
//                                       if (kDebugMode) {
//                                         print("Not Validate");
//                                       }
//                                     }
//                                     if (kDebugMode) {
//                                       print('$err err msg');
//                                     }
//                                   }
//
//                                 },
//                                 child: Container(
//                                   width: 55,
//                                   height: 55,
//                                   alignment: Alignment.center,
//                                   decoration: const BoxDecoration(
//                                       shape: BoxShape.circle),
//                                   child: const Icon(Icons.arrow_forward, color: Colors.white,),
//                                 )),
//                           )),
//                       Positioned(
//                         top: 730,
//                         left: 99,
//                         child: Wrap(
//                           children: [
//                             Text("Already have an account?", style: TextStyle(fontSize: 16),),
//                             GestureDetector(
//                               onTap: (){
//                                 Navigator.of(context).pop();
//                               },
//                               child: Text("Login",
//                                 softWrap: true,
//                                 style: TextStyle(color: const Color(0xffFF6A83),
//                                     fontSize: 16),),
//                             ),
//                           ],
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//             ));
//   }
// }

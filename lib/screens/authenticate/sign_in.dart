// import 'package:flutter/foundation.dart';
// import 'package:flutter/material.dart';
// import 'package:google_class_room/screens/authenticate/sign_up.dart';
// import 'package:google_class_room/widgets/flush_bar.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:provider/provider.dart';
// import '../../models/error.dart';
// import '../../services/auth.dart';
// import '../views/role.dart';
//
// class SignIn extends StatefulWidget {
//   static const routeName = '/signing';
//   @override
//   _SignInState createState() => _SignInState();
// }
//
// class _SignInState extends State<SignIn> {
//   final email = TextEditingController();
//   bool _loading = false;
//   final pass = TextEditingController();
//   final AuthService _auth = AuthService();
//   String err = '';
//   bool _isPasswordVisible = true;
//   final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
//   void toggle(){
//      setState((){
//        _isPasswordVisible = !_isPasswordVisible;
//      }) ;
//   }
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
// Utils _utils = Utils();
//   @override
//   Widget build(BuildContext context) {
//     final _authProvider = Provider.of<AuthService>(context);
//     var size = MediaQuery.of(context).size.height;
//     return Scaffold(
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
//                           padding: EdgeInsets.only(left: 25, top: 54),
//                           child: Wrap(
//                             children: [
//                               Text("Welcome",
//                                   style: GoogleFonts.alegreyaSansSc(
//                                       fontSize: 49,
//                                       fontWeight: FontWeight.bold)),
//                               Padding(
//                                 padding:
//                                     const EdgeInsets.only(right: 100, top: 1),
//                                 child: Text(
//                                   "Manage your classes",
//                                   style: GoogleFonts.alegreyaSans(
//                                     fontSize: 18,
//                                   ),
//                                 ),
//                               ),
//                               Padding(
//                                 padding:
//                                 EdgeInsets.only(right: 100, top: 5),
//                                 child: Text(
//                                   "Manage your assignments and test through this app, whether you are a teacher or student. 😊😊",
//                                   style: GoogleFonts.alegreyaSans(
//                                     fontSize: 18,
//                                   ),
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ),
//                       ),
//                       Positioned(
//                         top: 220,
//                         child: Padding(
//                           padding: EdgeInsets.symmetric(horizontal: 25),
//                           child: Container(
//                             width: 326,
//                             height: 40,
//                             decoration: BoxDecoration(
//                               boxShadow: const [
//                                 BoxShadow(
//                                   color: Colors.grey,
//                                   blurRadius: 5,
//                                   spreadRadius: 0,
//                                   blurStyle: BlurStyle.solid,
//                                   offset:  Offset(2.0,
//                                       2), // shadow direction: bottom right
//                                 )
//                               ],
//                               color: Colors.white,
//                               borderRadius: BorderRadius.circular(8),
//                               backgroundBlendMode: BlendMode.colorDodge,
//                               border: Border.all(
//                                 color: const Color(0xffFF6A83),
//                                 width: 1,
//                               ),
//                             ),
//                             child: Padding(
//                               padding: EdgeInsets.only(
//                                 left: 30,
//                                 right: 30,
//                                 top: 30,
//                               ),
//                               child: Column(
//                                 children: [
//                                   Text(
//                                       'Login to continue',
//                                       style: GoogleFonts.questrial(
//                                         fontSize: 23.0,
//                                         fontWeight: FontWeight.w900,
//                                         color: const Color(0xffFF6A83),
//                                         wordSpacing: 2.5,
//                                       )),
//                                   SizedBox(
//                                     height: 20,
//                                   ),
//                                   TextFormField(
//                                     controller: email,
//                                     keyboardType: TextInputType.emailAddress,
//                                     textInputAction: TextInputAction.next,
//                                     validator: (value) {
//                                       if (value!.isEmpty) {
//                                         return "* Required";
//                                       } else {
//                                         return null;
//                                       }
//                                     },
//                                     decoration: InputDecoration(
//                                       prefixIcon: const Icon(Icons.email,
//                                       color: Colors.black,),
//                                       hintText: 'Email',
//                                       focusedBorder: OutlineInputBorder(
//                                         borderRadius: BorderRadius.all(
//                                             Radius.circular(20)),
//                                         borderSide: BorderSide(
//                                             color: const Color(0xffFF6A83),
//                                             width: 1),
//                                       ),
//                                       enabledBorder: OutlineInputBorder(
//                                         borderSide: BorderSide(
//                                             color: const Color(0xffFF6A83),
//                                             width: 1),
//                                       ),
//                                     ),
//                                   ),
//                                   SizedBox(
//                                     height: 10,
//                                   ),
//                                   TextFormField(
//                                     controller: pass,
//                                     obscureText: _isPasswordVisible,
//                                     keyboardType: TextInputType.visiblePassword,
//                                     textInputAction: TextInputAction.go,
//                                     validator: (value) {
//                                       if (value!.isEmpty) {
//                                         return "* Required";
//                                       } else if (value.length < 6) {
//                                         return "Password should be at least 6 characters";
//                                       } else if (value.length > 15) {
//                                         return "Password should not be greater than 15 characters";
//                                       } else {
//                                         return null;
//                                       }
//                                     },
//                                     decoration: InputDecoration(
//                                       prefixIcon: const Icon(Icons.lock,
//                                       color: Colors.black,),
//                                       hintText: 'Password',
//                                       suffixIcon: InkWell(
//                                         onTap: (){
//                                           toggle();
//                                         },
//                                         child: Icon(_isPasswordVisible? Icons.visibility : Icons.visibility_off),
//                                       ),
//                                       focusedBorder: OutlineInputBorder(
//                                         borderRadius: BorderRadius.all(
//                                             Radius.circular(20)),
//                                         borderSide: BorderSide(
//                                             color: const Color(0xffFF6A83),
//                                             width: 1),
//                                       ),
//                                       enabledBorder: OutlineInputBorder(
//                                         borderSide: BorderSide(
//                                             color: const Color(0xffFF6A83),
//                                             width: 1),
//                                       ),
//                                     ),
//                                   ),
//                                   Row(
//                                     mainAxisAlignment: MainAxisAlignment.end,
//                                     children: [
//                                       InkWell(
//                                         child: TextButton(
//                                           child: const Text(
//                                             'Forgot password',
//                                             style: TextStyle(
//                                               color: Color(0xffFF6A83),
//                                             ),
//                                           ),
//                                           onPressed: () async {
//                                             setState(() {
//                                               _loading = true;
//                                             });
//                                             var value = ErrorMsg(' ');
//                                             if (kDebugMode) {
//                                               print(value.error);
//                                             }
//                                             await _auth.resetPassword(
//                                                 email.text, value);
//                                             setState(() {
//                                               _loading = false;
//                                               err = value.error.toString();
//                                             });
//                                           },
//                                         ),
//                                       ),
//                                     ],
//                                   ),
//                                 ],
//                               ),
//                             ),
//                           ),
//                         ),
//                       ),
//                       Positioned(
//                           top: 600,
//                           left: 151,
//                           child: CircleAvatar(
//                             radius: 35,
//                             foregroundColor: Colors.redAccent,
//                             backgroundColor: Colors.white,
//                             child: ElevatedButton(
//                                 style: ElevatedButton.styleFrom(
//                                   shape: const CircleBorder(),
//                                   backgroundColor: const Color(0xffFF6A83),
//                                 ),
//                                 onPressed: () async {
//                                   if(_formKey.currentState!.validate()){
//                                     setState(() {
//                                       _loading = true;
//                                     });
//                                     var value = ErrorMsg(' ');
//                                     if (kDebugMode) {
//                                       print(value.error);
//                                     }
//                                     await _auth.signIn(
//                                         email.text, pass.text, value,context);
//                                     setState(() {
//                                       _loading = false;
//                                       err = value.error.toString();
//                                     });
//                                     // print('$err err msg');
//                                     Navigator.pushNamed(
//                                       context,
//                                       Role.routeName,
//                                     );
//                                   }else{
//                                     if (kDebugMode) {
//                                       print("Not Validate");
//                                     }
//                                     _utils.flushBarErrorMessage('Not Validate+$kDebugMode', context);
//                                   }
//                                 },
//                                 child: Container(
//                                   width: 55,
//                                   height: 55,
//                                   alignment: Alignment.center,
//                                   decoration: const BoxDecoration(
//                                       shape: BoxShape.circle),
//                                   child: _loading? CircularProgressIndicator(
//                                     valueColor: AlwaysStoppedAnimation<Color>(Theme.of(context).primaryColor),
//                                   ) : const Icon(Icons.arrow_forward, color: Colors.white,),
//                                 )),
//                           )),
//                       Positioned(
//                         top: 685,
//                         left: 99,
//                         child: Wrap(
//                           children: [
//                             Text("Not a member?", style: TextStyle(fontSize: 16),),
//                             GestureDetector(
//                               onTap: (){
//                                 Navigator.pushNamed(
//                                   context,
//                                   SignUp.routeName,
//                                 );
//                               },
//                               child: Text("create account",
//                               softWrap: true,
//                               style: TextStyle(color: const Color(0xffFF6A83),
//                                   fontSize: 16),),
//                             ),
//                           ],
//                         ),
//                       ),
//                       Positioned(
//                           top: 730,
//                           left: 111,
//                           child: ElevatedButton(
//                               style: ElevatedButton.styleFrom(
//                                 shape: const CircleBorder(),
//                                 primary:  Colors.white,
//                               ),
//                               onPressed: () async {
//                                 setState(() {
//                                   _loading = true;
//                                 });
//                                 var value =  ErrorMsg(' ');
//                                 await _auth.signInWithGoogle(value);
//                                 setState(() {
//                                   _loading = false;
//                                   Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>const Role()));
//                                   err = value.error.toString();
//                                   if (kDebugMode) {
//                                     print(err);
//                                   }
//                                 });
//                               },
//                               child: Container(
//                                 width: 65,
//                                 height: 65,
//                                 alignment: Alignment.center,
//                                 decoration: const BoxDecoration(
//                                     shape: BoxShape.circle),
//                                 child: const Icon(Icons.email, color: Colors.red,),
//                               ))),
//                       Positioned(
//                           top: 730,
//                           left: 191,
//                           child: ElevatedButton(
//                               style: ElevatedButton.styleFrom(
//                                 shape: const CircleBorder(),
//                                 primary:  Colors.white,
//                               ),
//                               onPressed: () async {
//
//                               },
//                               child: Container(
//                                 width: 65,
//                                 height: 65,
//                                 alignment: Alignment.center,
//                                 decoration: const BoxDecoration(
//                                     shape: BoxShape.circle),
//                                 child: const Icon(Icons.facebook,
//                                   color: Colors.blue,),
//                               )))
//                     ],
//                   ),
//                 ),
//               ),
//             ),
//           );
//   }
// }

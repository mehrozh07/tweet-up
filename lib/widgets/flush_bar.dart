import 'dart:ui';

import 'package:another_flushbar/flushbar.dart';
import 'package:another_flushbar/flushbar_route.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Utils{


 static void fieldFocusChange(BuildContext context , FocusNode current , FocusNode nextFocus){
  current.unfocus();
  FocusScope.of(context).requestFocus(nextFocus);
 }



 // static toastMessage(String message){
 //  Fluttertoast.showToast(
 //   msg: message,
 //   backgroundColor: Colors.black,
 //   textColor: Colors.white,
 //  );
 // }

 void flushBarErrorMessage(String message, BuildContext context)async {

  showFlushbar(context: context,
   flushbar: Flushbar(
    forwardAnimationCurve:Curves.decelerate,
    margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
    padding: const EdgeInsets.all(15),
    message: message,
    duration: const Duration(seconds: 5),
    borderRadius: BorderRadius.circular(8),
    flushbarPosition: FlushbarPosition.TOP,
    backgroundColor: Colors.pink,
    reverseAnimationCurve: Curves.easeInOut,
    positionOffset: 20,
    icon: const Icon(Icons.error , size: 28 , color: Colors.white,),
   )..show(context),

  );

 }

 showAlertDialogue(BuildContext context, ){
  final textSize = MediaQuery.textScaleFactorOf(context);
  Future.delayed(
      const Duration(microseconds: 0),
          ()=>
          showDialog(
              barrierDismissible: true,
              useSafeArea: true,
              context: context,
              builder: (ctx,)=>
                  Container(
                   width: 300,
                   height: 100,
                   decoration: const BoxDecoration(
                    borderRadius: BorderRadius.
                    all(Radius.circular(8)),
                   ),
                   child:  BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 6, sigmaY: 6),
                    child: AlertDialog(
                     title:   Text("Alert Box",
                      textAlign: TextAlign.center,
                      style: GoogleFonts.poppins(
                       textStyle: TextStyle(
                        color: const Color(0xFF223263),
                        fontWeight: FontWeight.bold,
                        fontSize: textSize * 16,
                       ),
                      ),),
                     content: Wrap(children:  const [
                      Text("Do You Want to remove Item from Cart?"),
                     ],),
                     actions: [
                      TextButton(
                       onPressed: (){
                        Navigator.of(context).pop();
                       },
                       child:   const Text("Cancel",),
                      ),
                      TextButton(
                          onPressed: () async{},
                          child: const Text("Remove")
                      ),
                     ],
                    ),
                   ),
                  )
          )
  );
 }
}

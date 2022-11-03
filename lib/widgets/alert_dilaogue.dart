import 'dart:io';
import 'package:flutter/material.dart';

class PickImage extends StatelessWidget {
   PickImage({Key? key}) : super(key: key);

  File? _pickedImage;
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          margin: const EdgeInsets.symmetric(vertical: 70, horizontal: 120),
          child: CircleAvatar(
            radius: 70,
            backgroundColor: Colors.pinkAccent.shade400,
            child: CircleAvatar(
              radius: 65,
              backgroundColor: Colors.pinkAccent.shade100,
              backgroundImage: _pickedImage == null? null : FileImage(_pickedImage!),
            ),
          ),
        ),
        Positioned(
          right: 85,
          top: 130,
          child: RawMaterialButton(
            onPressed: (){
              showDialog(context: context, builder:(BuildContext context){
                return AlertDialog(
                  title: Text("choose option".toLowerCase(),
                    style:  TextStyle(fontWeight: FontWeight.w600, color: Colors.pinkAccent.shade400),
                  ),
                  content: SingleChildScrollView(
                    child: ListBody(
                      children: [
                        InkWell(
                          splashColor: Colors.pink,
                          child: Row(
                            children:  const [
                              Padding(
                                padding: EdgeInsets.all(8.0),
                                child: Icon(Icons.camera, color: Colors.pinkAccent,),
                              ),
                              Text("camera", style: TextStyle(fontSize: 18, color: Colors.black38,
                                  fontWeight: FontWeight.w400),),

                            ],
                          ),
                        ),
                        InkWell(
                          splashColor: Colors.pink,
                          child: Row(
                            children:  const[
                               Padding(
                                padding: EdgeInsets.all(8.0),
                                child: Icon(Icons.image_sharp, color: Colors.pinkAccent,),
                              ),
                              Text("Gallery", style: TextStyle(fontSize: 18, color: Colors.black38,
                                  fontWeight: FontWeight.w400),),

                            ],
                          ),
                        ),
                        InkWell(
                          splashColor: Colors.pink,
                          child: Row(
                            children: const [
                               Padding(
                                padding: EdgeInsets.all(8.0),
                                child: Icon(Icons.delete, color: Colors.red,),
                              ),
                              Text("Remove", style: TextStyle(fontSize: 18, color: Colors.red,
                                  fontWeight: FontWeight.w400),),

                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              });
            },
            elevation: 10,
            fillColor: Colors.pinkAccent.shade400,
            padding: const EdgeInsets.all(15),
            shape: const CircleBorder(),
            child: const Icon(Icons.add_a_photo),
          ),
        )
      ],
    );
  }
}

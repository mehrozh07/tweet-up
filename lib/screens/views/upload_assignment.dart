import 'dart:io';
import 'package:path/path.dart' as Path;
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:tweetup_fyp/constants/firebase_api.dart';
import '../../services/database.dart';
import '../../util/utils.dart';
import '../../widgets/formFields.dart';

class UploadAssignment extends StatefulWidget {
  final code;
  String email;
  UploadAssignment(this.code, this.email);

  @override
  _UploadAssignmentState createState() => _UploadAssignmentState();
}

class _UploadAssignmentState extends State<UploadAssignment> {
  final topic = TextEditingController();
  String msg = ' ';
  final url = TextEditingController();
  bool loading = false;
  File? file;
  final notes = File;
  UploadTask? uploadTask;
  final _formKey = GlobalKey<FormState>();
  DateTime selectedDate = DateTime.now();
  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      keyboardType: TextInputType.datetime,
        context: context,
        initialDate: selectedDate,
        firstDate: DateTime(2001, 8),
        lastDate: DateTime(2101));
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
      });
    }
  }

  Future selectFile() async{
    final result = await FilePicker.platform.pickFiles(
      allowMultiple: true,
      allowedExtensions: ['pdf', 'doc'],
      type: FileType.custom,
      dialogTitle: "Picked file is uploading",
    );

    if(result==null) return;
    final path = result.files.single.path;

    setState((){
      file = File(path!);
    });
  }
  Future uploadFile() async{
    if(file==null) return null;
    final fileName = Path.basename(file!.path);
    final destination = "files/$fileName";
    FirebaseApi.uploadFile(destination, file!);
    if(uploadTask==null)return null;
    final snapshot = await uploadTask?.whenComplete(() => {
    Utils.snackBar(message: "Assignment is ready to upload", context: context, color: Colors.lightGreen),
    });
    final urlFile = await snapshot!.ref.getDownloadURL();
    debugPrint("Download-Link$urlFile");
  }
  Widget buildUploadStatus(UploadTask task) => StreamBuilder<TaskSnapshot>(
    stream: task.snapshotEvents,
    builder: (context, snapshot) {
      if (snapshot.hasData) {
        final snap = snapshot.data!;
        final progress = snap.bytesTransferred / snap.totalBytes;
        final percentage = (progress * 100).toStringAsFixed(2);

        return CircularPercentIndicator(
          radius: 45,
          lineWidth: 4.0,
          percent: 0.90,
          center:  Text("$percentage""%", style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),),
          progressColor: Colors.green,
        );
      } else {
        return Container();
      }
    },
  );

  Future<String?> uploadNotes(File pdfFile) async{
    String url;
    Reference reference = FirebaseStorage.instance.ref().child('Assignment_file');
    await reference.putFile(pdfFile);
    url =await reference.getDownloadURL();
    return url;

  }

  @override
  Widget build(BuildContext context) {
    final fileName =  file != null ? Path.basename(file!.path): "No Selected File";
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
            appBar: AppBar(
              title: const Text('Notes'),
            ),
            body: SingleChildScrollView(
              child: Form(
                key: _formKey,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      formField(topic, 'Topic', context),
                      const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text(
                          'You can upload files online like on google drive/ondrive and paste the url here, down below',
                          textAlign: TextAlign.center,
                        ),
                      ),
                      TextButton.icon(
                        style: TextButton.styleFrom(
                          textStyle: const TextStyle(color: Colors.blue),
                          backgroundColor: Colors.white30,
                          shape:RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(24.0),
                          ),
                        ),
                        onPressed: () => {
                          selectFile(),
                          debugPrint('attach file button pressed'),
                        },
                        icon: const Icon(Icons.attach_file_rounded,),
                        label: const Text('attach file',),
                      ),
                      SizedBox(height: height*0.01,),
                      Text(fileName,
                        style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold),),
                      TextButton.icon(
                        style: TextButton.styleFrom(
                          textStyle: const TextStyle(color: Colors.blue),
                          backgroundColor: Colors.white30,
                          shape:RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(24.0),
                          ),
                        ),
                        onPressed: () => {
                          uploadFile()
                              .whenComplete(() => {
                            Utils.snackBar(message: "loaded", context: context, color: Colors.black),
                          }),
                          debugPrint('upload button pressed'),
                        },
                        icon: const Icon(Icons.cloud_upload,),
                        label: const Text('upload file',),
                      ),
                      // formField(url, 'Link of file', context),
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.8,
                        child: TextButton(
                          onPressed: () => _selectDate(context),
                          child: Text(
                            'Due date ${"${selectedDate.toLocal()}".split(' ')[0]}',
                          ),
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          TextButton(
                            child: Container(
                                padding: const EdgeInsets.symmetric(vertical: 10),
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(20),
                                    border: Border.all(
                                      color: Theme.of(context).primaryColor,
                                    )),
                                alignment: Alignment.center,
                                width: MediaQuery.of(context).size.width * .4,
                                child: Text(
                                  'Cancel',
                                  style: TextStyle(
                                      color: Theme.of(context).primaryColor),
                                )),
                            onPressed: () {
                              topic.text = '';
                              url.text = '';
                              FocusScope.of(context).unfocus();
                            },
                          ),
                          TextButton(
                            child: Container(
                                padding: const EdgeInsets.symmetric(vertical: 10),
                                decoration: BoxDecoration(
                                    color: Theme.of(context).colorScheme.secondary,
                                    borderRadius: BorderRadius.circular(20),
                                    border: Border.all(color: Colors.white)),
                                alignment: Alignment.center,
                                width: MediaQuery.of(context).size.width * .4,
                                child: const Text(
                                  'Post',
                                  style: TextStyle(color: Colors.white),
                                )),
                            onPressed: () async {
                              if (_formKey.currentState!.validate()) {
                                setState(() {
                                  loading = true;
                                });
                                uploadNotes(file!).then((value) async {
                                  var db = PostAssignment(
                                      widget.code,
                                      topic.text,
                                      value.toString(),
                                      selectedDate.toLocal(),
                                      "Teacher's copy");
                                  await db.postNote();
                                });

                                if (kDebugMode) {
                                  print(widget.email);
                                }
                                setState(() {
                                  msg = 'Assignment is uploaded';
                                  loading = false;
                                });
                              }
                            },
                          ),
                        ],
                      ),
                      Text(
                        msg,
                      )
                    ],
                  ),
                ),
              ),
            ),
          );
  }
}

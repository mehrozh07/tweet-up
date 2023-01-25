import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import '../../services/database.dart';
import '../../services/loading.dart';
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

  @override
  Widget build(BuildContext context) {
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
                      formField(url, 'Link of file', context),
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
                                var db = PostAssignment(
                                    widget.code,
                                    topic.text,
                                    url.text,
                                    selectedDate.toLocal(),
                                    "Teacher's copy");
                                await db.postNote();
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

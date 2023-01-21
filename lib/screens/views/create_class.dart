import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tweetup_fyp/widgets/flush_bar.dart';
import '../../models/error.dart';
import 'package:provider/provider.dart';
import '../../constants/constants.dart';
import '../../services/database.dart';
import '../../services/loading.dart';
import 'created_classes.dart';

class CreateClass extends StatefulWidget {
  static const routeName = '/create-class';

  @override
  _CreateClassState createState() => _CreateClassState();
}

class _CreateClassState extends State<CreateClass> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final subjectName = TextEditingController();

  final professorName = TextEditingController();

  final batch = TextEditingController();
      String code = '';
  bool _loading = false, created = false;
  String msg = ' ';
  ErrorMsg err = ErrorMsg(' ');
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User>(context);
    String? coll = user.email;
    final CollectionReference myClassCollection =
        FirebaseFirestore.instance.collection(coll!);
    final db = MyClassDatabase(user.uid, myClassCollection);
    return _loading
        ? Loader()
        : Scaffold(
            // drawer: CustomDrawer(),
            appBar: AppBar(
              iconTheme: IconThemeData(color: Theme.of(context).colorScheme.secondary),
              backgroundColor: Theme.of(context).primaryColor,
              centerTitle: true,
              title: const Text(
                'Create class',
                style: TextStyle(color: Colors.white),
              ),
            ),
            body: SingleChildScrollView(
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          formField(context, subjectName, 'Name of subject'),
                          const SizedBox(height: 10,),
                          formField(
                              context, professorName, 'Name of professor'),
                          const SizedBox(height: 10,),
                          formField(context, batch, 'Semester/class'),
                          Padding(
                            padding:  const EdgeInsets.only(top: 20),
                            child: Text(
                              msg,
                              style: GoogleFonts.roboto(fontSize: 15),
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.all(20),
                            width: MediaQuery.of(context).size.width * 0.8,
                            child: Material(
                              borderRadius: BorderRadius.circular(20.0),
                              shadowColor: Theme.of(context).colorScheme.secondary,
                              color: Theme.of(context).colorScheme.secondary,
                              child: Builder(builder: (context) {
                                return TextButton(
                                  onPressed: () async {
                                    if (_formKey.currentState!.validate()) {
                                      setState(() {
                                        _loading = true;
                                      });
                                      await db.createClass(
                                          subjectName.text,
                                          batch.text,
                                          professorName.text,
                                          user.email,
                                          err,
                                          user.email! +
                                              subjectName.text +
                                              batch.text);

                                      setState(() {
                                        _loading = false;
                                        created = true;
                                        code = user.email! +
                                            subjectName.text +
                                            batch.text;
                                        msg = '${err.error}🌟🌟';
                                        Future.delayed(
                                            const Duration(milliseconds: 3000),
                                            () {
                                          setState(() {
                                            msg = ' ';
                                          });
                                        });
                                      });
                                      subjectName.text = '';
                                      batch.text = '';
                                      professorName.text = '';
                                    }
                                  },
                                  child: Center(
                                    child: Text(
                                      'Create class',
                                      style: kTitleStyle,
                                    ),
                                  ),
                                );
                              }),
                            ),
                          ),
                          CopyCode(created: created, code: code,),
                          Container(
                            padding: const EdgeInsets.all(20),
                            width: MediaQuery.of(context).size.width * 0.8,
                            child: Material(
                              borderRadius: BorderRadius.circular(20.0),
                              shadowColor: Theme.of(context).primaryColor,
                              color: Theme.of(context).primaryColor,
                              child: Builder(builder: (context) {
                                return TextButton(
                                  onPressed: () {
                                    Navigator.of(context).pushNamed(
                                        CreatedClasses.routeName,
                                        arguments: user.email);
                                  },
                                  child: Center(
                                    child: Text(
                                      'View all your classes',
                                      style: kTitleStyle,
                                    ),
                                  ),
                                );
                              }),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
  }

  TextFormField formField(BuildContext context, controller, hint) {
    return TextFormField(
      validator: (value) => value!.isEmpty ? 'Please enter a value' : null,
      controller: controller,
      decoration: InputDecoration(
          labelText: hint,
          focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Theme.of(context).primaryColor)
          ),
          border: OutlineInputBorder(
              borderSide: BorderSide(color: Theme.of(context).primaryColor))),
    );
  }
}

class CopyCode extends StatelessWidget {
   CopyCode({
    required this.created,
    required this.code,
  }) ;

  final bool created;
  final String? code;
  final Utils _utils = Utils();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Column(
        children: [
          const Text(
              'Copy the following code and send to your students, so they can join your class'),
          TextButton(
            onPressed: created
                ? () async {
                    ClipboardData data = ClipboardData(text: (code));
                    await Clipboard.setData(data);
                    if (kDebugMode) {
                      print(code);
                    }
                  _utils.flushBarErrorMessage('code copied', context);
                  }
                : null,
            child: const Text('Copy'),
          ),
        ],
      ),
    );
  }
}

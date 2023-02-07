import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:tweetup_fyp/screens/authenticate/login.dart';
import 'package:tweetup_fyp/screens/authenticate/sign_up.dart';
import 'package:tweetup_fyp/screens/views/create_class.dart';
import 'package:tweetup_fyp/screens/views/enrolled_classes.dart';
import 'package:tweetup_fyp/screens/views/home.dart';
import 'package:tweetup_fyp/screens/views/homestu.dart';
import 'package:tweetup_fyp/screens/views/join_class.dart';
import 'package:tweetup_fyp/screens/views/role.dart';
import 'package:tweetup_fyp/screens/views/subject_class.dart';
import 'package:tweetup_fyp/screens/views/subject_class_student.dart';
import 'package:tweetup_fyp/services/auth.dart';
import './screens/views/created_classes.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';

Future<void> _firebaseBackgroundMessageHandler(RemoteMessage message) async{
  if (kDebugMode) {
    print(".................Handle background messages ${message.messageId}");
  }
}

Future<void> main() async {
  SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
  ));
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
    DeviceOrientation.landscapeRight,
    DeviceOrientation.landscapeLeft,
  ]);
  SystemChrome.setEnabledSystemUIMode(
      SystemUiMode.manual, overlays: []);
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await FirebaseMessaging.instance.getInitialMessage();
  FirebaseMessaging.onBackgroundMessage(_firebaseBackgroundMessageHandler);
  runApp(Phoenix(child: MyApp()));
}

Map<int, Color> color = {
  50: const Color.fromRGBO(2, 72, 124, .1),
  100: const Color.fromRGBO(2, 72, 124, .2),
  200: const Color.fromRGBO(2, 72, 124, .3),
  300: const Color.fromRGBO(2, 72, 124, .4),
  400: const Color.fromRGBO(2, 72, 124, .5),
  500: const Color.fromRGBO(2, 72, 124, .6),
  600: const Color.fromRGBO(2, 72, 124, .7),
  700: const Color.fromRGBO(2, 72, 124, .8),
  800: const Color.fromRGBO(2, 72, 124, .9),
  900: const Color.fromRGBO(2, 72, 124, 1.0),
};

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
        create: (BuildContext context) => AuthService(),
        child: StreamProvider<User?>.value(
          value: AuthService().user,
          initialData: null,
          child: GestureDetector(
            onTap: () {
              FocusScopeNode currentFocus = FocusScope.of(context);

              if (!currentFocus.hasPrimaryFocus &&
                  currentFocus.focusedChild != null) {
                FocusManager.instance.primaryFocus?.unfocus();
              }
            },
            child: MaterialApp(
              debugShowCheckedModeBanner: false,
              theme: ThemeData(
                  useMaterial3: true,
                  primaryColor: const Color(0xff02487c),
                  primarySwatch: MaterialColor(0xff02487c, color),
                  fontFamily: 'Montserrat',
                  // textTheme: const TextTheme(
                  //   bodyLarge: TextStyle(
                  //     fontSize: 20,
                  //     color: Colors.black,
                  //     fontWeight: FontWeight.w600,
                  //   ),
                  //   bodyMedium: TextStyle(
                  //     fontSize: 16,
                  //     color: Colors.grey,
                  //     fontWeight: FontWeight.bold,
                  //   ),
                  //   displayLarge: TextStyle(fontSize: 16.0,
                  //       fontWeight: FontWeight.normal
                  //   ),
                  // ),
              ),
              home: FirebaseAuth.instance.currentUser == null ? const LoginScreen() : const Home(),
              routes: {
                Register.routeName: (_) => const Register(),
                Role.routeName: (_) => const Role(),
                Home.routeName: (_) => const Home(),
                HomeStudent.routeName: (_) => const HomeStudent(),
                LoginScreen.id: (_) => const LoginScreen(),
                CreateClass.routeName: (_) => CreateClass(),
                CreatedClasses.routeName: (_) => const CreatedClasses(),
                JoinClass.routeName: (_) => JoinClass(),
                SubjectClass.routeName: (_) => SubjectClass(),
                EnrolledClasses.routeName: (_) => EnrolledClasses(),
                SubjectClassStudent.routeName: (_) => SubjectClassStudent(),
              },
            ),
          ),
        ));
  }
}
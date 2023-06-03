import 'package:firebaseencrytion/Screens/files_screen.dart';
import 'package:firebaseencrytion/Screens/home.dart';
import 'package:firebaseencrytion/Screens/loginWeb.dart';
import 'package:firebaseencrytion/Screens/login_screen.dart';
import 'package:firebaseencrytion/Screens/registration_screen.dart';
import 'package:firebaseencrytion/Screens/sharing_screen.dart';
import 'package:firebaseencrytion/Utils/Utility.dart';


import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  User ?user;

  fetch() async {
    user = FirebaseAuth.instance.currentUser;
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fetch();
  }

  @override
  Widget build(BuildContext context) {
    final _auth = FirebaseAuth.instance;

    bool check = false;
    if (_auth.currentUser == null) {
      check = false;
      Utility.customlogger("Not able to find last logged in-user");
      setState(() {});
    } else {
      check = true;
      Utility.customlogger("Logged in and Fetch details of last logged in user");
      setState(() {});
    }


    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: check
          ? HomeScreen(
        user: user,
      )
          : (kIsWeb?LoginWeb():LoginScreen()),


      routes: {
        LoginScreen.id: (context) => LoginScreen(),
        SharingScreen.id: (context) => SharingScreen(),
        FilesScreen.id: (context) => FilesScreen(),
        RegistrationScreen.id: (context) => RegistrationScreen(),
        LoginWeb.id: (context) => LoginWeb(),


      },
    );
  }
}

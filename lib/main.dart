import 'package:encryptu/Screens/home.dart';
import 'package:encryptu/Screens/login_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:firebase_core/firebase_core.dart';

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
  late User user ;
  fetch() async{
    user = FirebaseAuth.instance.currentUser!;
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
      print("NOt LOGGED IN");
      setState(() {});
    } else {
      check = true;
      print("Logged in");
      setState(() {});
    }

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: check ? HomeScreen(user: user,) : LoginScreen(),
      // home: LoginScreen(),
    );
  }
}

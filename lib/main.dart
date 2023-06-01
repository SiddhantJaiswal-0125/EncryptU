import 'package:firebase_core/firebase_core.dart';
import 'package:firebaseencrytion/Screens/LoginScreen.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
  //   options: const FirebaseOptions(
  //   apiKey: "AIzaSyDRvxXuJu5il2dVnSu55weJXPwRrf6_VNQ",
  //   appId: "1:658030259651:android:efe911aca1fbd12622a176",
  //   messagingSenderId: "279561968229",
  //   projectId: "fir-encryption-f5319",
  // ),
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      debugShowCheckedModeBanner: false,
      home: LoginScreen(),);

  }
}
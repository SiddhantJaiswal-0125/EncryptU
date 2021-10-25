import 'package:encryptu/Screens/login_screen.dart';
import 'package:encryptu/Utils/firebase_services.dart';
import 'package:encryptu/Utils/utility.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class SettingsScreen extends StatefulWidget {
  static String id = "SettingScreen";

  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        centerTitle: true,
        elevation: 0,
        actions: [
          IconButton(
            onPressed: () async {
              FirebaseAuth.instance.signOut();
              Navigator.pushReplacementNamed(context, LoginScreen.id);
            },
            icon: Icon(
              Icons.logout,
              color: Colors.teal.shade900,
            ),
          )
        ],
        title: Text(
          "Settings Page",
          style: Utility.kHeadingTextStyle(),
        ),
      ),
      body: Center(
        child: GestureDetector(
            onTap: () async {
              print("TAPPED IN SETTING BUTTON");
              FirebaseServices().getUserData();
            },
            child: Text("Settings Screen")),
      ),
    );
  }
}

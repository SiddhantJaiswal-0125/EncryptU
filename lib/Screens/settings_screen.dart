import 'package:encryptu/Utils/firebase_services.dart';
import 'package:encryptu/Utils/utility.dart';
import 'package:flutter/material.dart';

class SettingsScreen extends StatefulWidget {
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

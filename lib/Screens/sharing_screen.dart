import 'package:encryptu/Utils/Utility.dart';
import 'package:flutter/material.dart';

class SharingScreen extends StatefulWidget {
  @override
  _SharingScreenState createState() => _SharingScreenState();
}

class _SharingScreenState extends State<SharingScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        centerTitle: true,
        elevation: 0,
        title: Text(
          "Sharing Page",
          style: Utility.kHeadingTextStyle(),
        ),
      ),
      body: Center(
        child: Text("Sharing Screen"),
      ),
    );
  }
}

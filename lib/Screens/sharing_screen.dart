import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:encryptu/Utils/Utility.dart';
import 'package:encryptu/Utils/firebase_services.dart';
import 'package:flutter/material.dart';

class SharingScreen extends StatefulWidget {
  @override
  _SharingScreenState createState() => _SharingScreenState();
}

class _SharingScreenState extends State<SharingScreen> {
  late QuerySnapshot userDetails;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

  }



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
        child: Container(),
      ),
    );
  }
}

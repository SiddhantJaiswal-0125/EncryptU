import 'dart:io';

import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:encryptu/CustomDS/fileDS.dart';
import 'package:encryptu/Helper/FilePicker.dart';
import 'package:encryptu/Utils/Utility.dart';
import 'package:encryptu/Utils/firebase_services.dart';
import 'package:encryptu/Utils/storage_services.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';


class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key, required this.user}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
  final User user;
}

class _HomeScreenState extends State<HomeScreen> with SingleTickerProviderStateMixin {

  fetchDetails() async {
    // user = (await FirebaseAuth.instance.currentUser)!;


    print("--------------USER META DATA-----------------");
    print(widget.user.metadata);
    print(widget.user.phoneNumber);
    print(widget.user.uid);
  }

  @override
  void initState() {
    // TODO: implement initState
    fetchDetails();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Map<String, String> userData = {
      'name': 'Siddhant',
      'profile': Utility.demoLink,
      'phoneNo': "+919931036296",
      'email': "siddhantjaiswal363@gmail.com",
      'address': "Ranchi Jharkhand"
    };

    // print(userData);

    return Scaffold(
      appBar: AppBar(
        title: Text("Home Page"),
      ),
      body: Center(
          child: FlatButton(
        color: Colors.white,
        onPressed: () async {
          // await FirebaseServices().addData(userData);

        },
        child: Text("PRESS ME"),

      ),
      ),
      bottomNavigationBar: CurvedNavigationBar(
      backgroundColor: Colors.blueAccent,
      items: <Widget>[
        Icon(Icons.add, size: 30),
        Icon(Icons.list, size: 30),
        Icon(Icons.compare_arrows, size: 30),
      ],
      onTap: (index) {
        //Handle button tap
      },
    ),
    );
  }
}












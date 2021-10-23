import 'package:encryptu/Utils/firebase_services.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late User user;

  fetchDetails() async {
    user = (await FirebaseAuth.instance.currentUser)!;

    print("--------------USER META DATA-----------------");
    print(user.metadata);
    print(user.phoneNumber);

    print(user.uid);
  }

  Map<String, String> userData = {
    'username': 'Siddhant',
  };

  @override
  void initState() {
    // TODO: implement initState
    fetchDetails();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Home Page"),
      ),
      body: Center(
          child: FlatButton(
        color: Colors.white,
        onPressed: () async {
          await FirebaseServices().addData(userData);
        },
        child: Text("PRESS ME"),
      )),
    );
  }
}

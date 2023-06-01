import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:firebaseencrytion/Screens/files_screen.dart';
import 'package:firebaseencrytion/Screens/settings_screen.dart';
import 'package:firebaseencrytion/Screens/sharing_screen.dart';
import 'package:firebaseencrytion/Utils/Utility.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key, required this.user}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
  final User ?user;
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {

  late ScreenState currentState;
  fetchDetails() async {
    // user = (await FirebaseAuth.instance.currentUser)!;

  Utility.customlogger("USER META DATA");
    print(widget.user!.metadata);
    print(widget.user!.phoneNumber);
    print(widget.user!.uid);
  }

  @override
  void initState() {

    fetchDetails();
    Utility.customlogger("At home.dart");
    currentState = ScreenState.SHARING;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // print(userData);
    return Scaffold(

      // body: Center(
      //   child: FlatButton(
      //     color: Colors.white,
      //     onPressed: () async {
      //       // await FirebaseServices().addData(userData);
      //     },
      //     child: Text("PRESS ME"),
      //   ),
      // ),
      body: currentState == ScreenState.SHARING ? SharingScreen():
      (currentState == ScreenState.FILES ? FilesScreen():
          SettingsScreen()
      ),
      bottomNavigationBar: CurvedNavigationBar(
        color: Colors.teal.shade900,
        backgroundColor: Colors.white,
        items: <Widget>[
          Icon(
            Icons.compare_arrows,
            size: 30,
            color: Colors.white,
          ),
          Icon(
           Icons.file_copy_rounded,
            size: 30,
            color: Colors.white,
          ),
          Icon(
           Icons.person,
            size: 30,
            color: Colors.white,
          ),
        ],
        onTap: (index) {
          if(index==0)
            currentState = ScreenState.SHARING;
          else if(index==1)
            currentState = ScreenState.FILES;
          else currentState = ScreenState.SETTINGS;
          setState(() {

          });

        },
      ),
    );
  }
}


enum ScreenState
{
  SHARING,FILES,SETTINGS,
}
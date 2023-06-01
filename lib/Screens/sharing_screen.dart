import 'dart:io';

import 'package:firebaseencrytion/Helper/file_picker.dart';
import 'package:firebaseencrytion/Screens/receive_screen.dart';
import 'package:firebaseencrytion/Screens/send_screen.dart';
import 'package:firebaseencrytion/Utils/Utility.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SharingScreen extends StatefulWidget {
  static String id = "SharingScreen";

  @override
  _SharingScreenState createState() => _SharingScreenState();
}

class _SharingScreenState extends State<SharingScreen> {
  int sendOrReceive = 0;
  String password = "";

  @override
  void initState() {
    // TODO: implement initState
    Utility.customlogger("at Sharing Screen");
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
      body: SingleChildScrollView(
        child: Center(
          child: Container(
            height: MediaQuery.of(context).size.height - 180,
            child: Column(
              children: [
                SizedBox(
                  height: 20,
                ),
                CupertinoSlidingSegmentedControl<int>(
                  onValueChanged: (val) {
                    setState(() {
                      sendOrReceive = val!;
                    });
                  },
                  groupValue: sendOrReceive,
                  padding: EdgeInsets.all(4.0),
                  children: <int, Widget>{
                    0: Text(
                      "Upload File",
                      style: GoogleFonts.roboto(fontSize: 18),
                    ),
                    1: Text(
                      "Get File",
                      style: GoogleFonts.roboto(fontSize: 18),
                    )
                  },
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(18.0),
                    child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(10),
                              topRight: Radius.circular(10),
                              bottomLeft: Radius.circular(10),
                              bottomRight: Radius.circular(10)),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.5),
                              spreadRadius: 5,
                              blurRadius: 7,
                              offset:
                                  Offset(0, 3), // changes position of shadow
                            ),
                          ],
                        ),
                        child: sendOrReceive == 0
                            ? SendScreen()
                            : RecieveScreen()),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

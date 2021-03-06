import 'dart:io';

import 'package:cool_alert/cool_alert.dart';
import 'package:encryptu/Helper/file_picker.dart';
import 'package:encryptu/Utils/firebase_services.dart';
import 'package:encryptu/Utils/storage_services.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SendScreen extends StatefulWidget {
  @override
  _SendScreenState createState() => _SendScreenState();
}

class _SendScreenState extends State<SendScreen> {
  String password = "";
  customDSforFileStorageLink? cds = null;
  bool showPassword = false;

  bool takepassword = false;
  bool isuploading = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    takepassword = false;
    isuploading = false;
    password = "";
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      padding: EdgeInsets.only(left: 20, top: 10),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          SizedBox(
            height: 30,
          ),
          GestureDetector(
            onTap: () async {
              if (isuploading == false) {
                File? fi = await FilePickerCustom().pickfiles();
                if (fi != null) {
                  print("HERE ontap");
                  isuploading = true;
                  setState(() {});
                  cds = await FirebaseServices().uploadFile(fi);
                  isuploading = false;
                  takepassword = true;
                  setState(() {});
                }
              }
            },
            child: Container(
              width: MediaQuery.of(context).size.width / 2,
              height: 180,
              decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.green.shade600,
                  border: Border.all(color: Colors.red, width: 1.5)),
              child: Center(
                child: isuploading
                    ? CircularProgressIndicator(
                        color: Colors.white,
                      )
                    : Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "+",
                            style: GoogleFonts.abel(
                                fontSize: 50, color: Colors.white),
                          ),
                          Text(
                            "Upload",
                            style: GoogleFonts.roboto(
                                fontSize: 20, color: Colors.white70),
                          ),
                        ],
                      ),
              ),
            ),
          ),
          SizedBox(
            height: 20,
          ),
          Text(
            'Please enter a Password to secure your file !!',
            style: GoogleFonts.montserrat(fontSize: 18),
          ),
          SizedBox(
            height: 20,
          ),
          Row(
            children: [
              Container(
                width: MediaQuery.of(context).size.width - 110,
                child: TextField(
                  obscureText: !showPassword,
                  enabled: takepassword,
                  onChanged: (val) {
                    password = val;
                    print("Password is " + password);
                  },
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Enter the File Password',
                    hintText: 'Password ',
                  ),
                  autofocus: false,
                ),
              ),
              SizedBox(
                width: 5,
              ),
              IconButton(
                icon: Icon(showPassword
                    ? Icons.remove_red_eye
                    : Icons.remove_red_eye_outlined),
                onPressed: () {
                  if (showPassword == false) {
                    showPassword = true;
                  } else {
                    showPassword = false;
                  }

                  setState(() {});
                },
              ),
            ],
          ),
          SizedBox(
            height: 20,
          ),
          FlatButton(
              color: takepassword ? Colors.teal.shade900 : Colors.grey,
              onPressed: () async {
                if (cds != null) {
                  if (await FirebaseServices().encryptFile(cds!, password)) {
                    CoolAlert.show(
                      context: context,
                      animType: CoolAlertAnimType.slideInRight,
                      type: CoolAlertType.success,
                      text:
                          "Your file is uploaded.\n You can use the Secret Code and Password to Share it",
                      autoCloseDuration: Duration(seconds: 5),
                      onConfirmBtnTap: () {},
                      confirmBtnText: "Congrats",
                      confirmBtnColor: Colors.greenAccent,
                    );
                    takepassword = false;
                    cds = null;
                    setState(() {});
                  } else
                    CoolAlert.show(
                        context: context,
                        animType: CoolAlertAnimType.slideInRight,
                        type: CoolAlertType.error,
                        confirmBtnColor: Colors.redAccent,
                        confirmBtnText: "Please Check",
                        text: "Their is something wrong with Device.",
                        autoCloseDuration: Duration(seconds: 5),
                        onConfirmBtnTap: () {});
                }
              },
              child: Text(
                "Upload Your File",
                style: GoogleFonts.roboto(fontSize: 18, color: Colors.white),
              ))
        ],
      ),
    );
  }
}

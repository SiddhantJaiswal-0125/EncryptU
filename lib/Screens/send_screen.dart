import 'dart:io';

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
      padding: EdgeInsets.all(10),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          GestureDetector(
            onTap: () async {
              File? fi = await FilePickerCustom().pickfiles();
              if (fi != null) {
                isuploading = true;
                setState(() {});
                cds = await FirebaseServices().uploadFile(fi);
                isuploading = false;
                takepassword = true;
                setState(() {});
              }
            },
            child: Container(
              width: MediaQuery.of(context).size.width / 2,
              height: 200,
              decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.green,
                  border: Border.all(color: Colors.red, width: 2)),
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
          Container(
            width: 300,
            child: TextField(
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
            height: 20,
          ),
          FlatButton(
              color: takepassword ? Colors.teal.shade900 : Colors.grey,
              onPressed: () async {
                if (cds != null) {
                  FirebaseServices().encryptFile(cds!, password);
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

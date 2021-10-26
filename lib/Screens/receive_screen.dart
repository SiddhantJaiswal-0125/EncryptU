import 'package:encryptu/CustomDS/fileDS.dart';
import 'package:encryptu/Utils/firebase_services.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class RecieveScreen extends StatefulWidget {
  @override
  _RecieveScreenState createState() => _RecieveScreenState();
}

class _RecieveScreenState extends State<RecieveScreen> {
  String _fileId = "";
  String _password = "";

  late List<FileStructure> fi ;
      bool _showPasswordsection = false;
  bool _nofileExist = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(10),
      width: MediaQuery.of(context).size.width,
      child: Column(
        children: [
          SizedBox(
            height: 10,
          ),
          Text(
            "Get your file by Entering the Secret Code !",
            style: GoogleFonts.slabo13px(fontSize: 16),
          ),
          SizedBox(
            height: 20,
          ),
          Container(
            width: 300,
            child: TextField(
              onChanged: (val) {
                _fileId = val;
                print("FILE ID " + _fileId);
              },
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Enter the File Id',
                hintText: 'File Secret Id',
              ),
              autofocus: false,
            ),
          ),
          SizedBox(
            height: 20,
          ),
          GestureDetector(
            onTap: () async {
              FirebaseServices fs = new FirebaseServices();

              fi = await fs.getFilesById(_fileId);
              if (fi != null && fi.length > 0) {
                _showPasswordsection = true;
                _nofileExist = false;
                print(fi[0].uniqueId);
                print("Password : " + fi[0].password);
                setState(() {});
              } else {
                _showPasswordsection = false;
                _nofileExist = true;
                setState(() {});
              }
            },
            child: Container(
              padding: EdgeInsets.all(9),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: Colors.teal.shade900,
              ),
              child: Text(
                "Check File",
                style:
                    GoogleFonts.lexendDeca(fontSize: 17, color: Colors.white),
              ),
            ),
          ),
          SizedBox(
            height: 10,
          ),
          _nofileExist
              ? Text(
                  "No File Exist with this Code",
                  style: GoogleFonts.lato(color: Colors.red, fontSize: 15),
                )
              : Container(),
          SizedBox(
            height: 20,
          ),
          Container(
            width: 300,
            child: TextField(
              enabled: _showPasswordsection,
              onChanged: (val) {
                _password = val;
                print("Password is " + _password);
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
          GestureDetector(
            onTap: () async {
              if(_password==fi[0].password)
                {
                  print("SAME PASSWORD ");

                }
              else
                print("DIFFERENT PASSWORD");

            },
            child: Container(
              padding: EdgeInsets.all(9),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: Colors.orange,
              ),
              child: Text(
                "Get File",
                style:
                GoogleFonts.lexendDeca(fontSize: 17, color: Colors.white),
              ),
            ),
          ),

        ],
      ),
    );
  }
}

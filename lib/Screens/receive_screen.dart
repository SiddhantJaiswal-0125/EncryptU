import 'package:firebaseencrytion/CustomDS/fileDS.dart';
import 'package:firebaseencrytion/Utils/firebase_services.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
// import 'package:url_launcher/url_launcher.dart';

class RecieveScreen extends StatefulWidget {
  @override
  _RecieveScreenState createState() => _RecieveScreenState();
}

class _RecieveScreenState extends State<RecieveScreen> {
  String _fileId = "";
  String _password = "";

  late List<FileStructure> fi;

  bool _showPasswordsection = false;
  bool _nofileExist = false;
  bool passwordIncorrect = false;

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
              if (_password == fi[0].password) {
                print("SAME PASSWORD ");

                passwordIncorrect = false;

                _launchInBrowser(fi[0].url);
              } else {
                print("DIFFERENT PASSWORD");
                passwordIncorrect = true;
              }

              setState(() {});
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
          SizedBox(
            height: 20,
          ),
          passwordIncorrect
              ? Text(
                  "The Password you have entered is WRONG",
                  style: GoogleFonts.roboto(
                    color: Colors.red,
                    fontSize: 16,
                  ),
                )
              : Container(),
        ],
      ),
    );
  }

  Future<void> _launchInBrowser(String url) async {
    // if (await canLaunch(url)) {
    //   await launch(
    //     url,
    //     forceSafariVC: false,
    //     forceWebView: false,
    //     headers: <String, String>{'my_header_key': 'my_header_value'},
    //   );
    // } else {
    //   throw 'Could not launch $url';
    // }
  }
}

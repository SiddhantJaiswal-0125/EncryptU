import 'package:encryptu/CustomDS/fileDS.dart';
import 'package:encryptu/Utils/Utility.dart';
import 'package:encryptu/Utils/firebase_services.dart';
import 'package:flutter/material.dart';

class FilesScreen extends StatefulWidget {
  @override
  _FilesScreenState createState() => _FilesScreenState();
}

class _FilesScreenState extends State<FilesScreen> {
  Map<String, String> userData = {
    'name': 'Siddhant',
    'profile': Utility.demoLink,
    'phoneNo': "+919931036296",
    'email': "siddhantjaiswal363@gmail.com",
    'address': "Ranchi Jharkhand"
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        centerTitle: true,
        elevation: 0,
        title: Text(
          "Files Page",
          style: Utility.kHeadingTextStyle(),
        ),
      ),
      body: Center(
        child: Center(
          child: FlatButton(
            color: Colors.white,
            onPressed: () async {
              // await FirebaseServices().addUserData(userData);
              print("PRESSED");
              List<FileStructure> files =
                  await FirebaseServices().getFilesById("330146681");
              for (FileStructure fi in files) {
                print("Unique ID " + fi.uniqueId);
                print("File Url " + fi.url);
                print("Password " + fi.password);
              }
            },
            child: Text("PRESS ME"),
          ),
        ),
      ),
    );
  }
}

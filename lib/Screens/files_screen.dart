import 'package:encryptu/Utils/Utility.dart';
import 'package:flutter/material.dart';
class FilesScreen extends StatefulWidget {
  @override
  _FilesScreenState createState() => _FilesScreenState();
}

class _FilesScreenState extends State<FilesScreen> {
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
        child: Text("Files SCREEN"),
      ),
    );

  }
}

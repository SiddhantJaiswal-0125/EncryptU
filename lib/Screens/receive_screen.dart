import 'package:encryptu/CustomDS/fileDS.dart';
import 'package:encryptu/Utils/firebase_services.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class RecieveScreen extends StatefulWidget {
  @override
  _RecieveScreenState createState() => _RecieveScreenState();
}

class _RecieveScreenState extends State<RecieveScreen> {
  String fileId = "";

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
                  fileId = val;
                  print("FILE ID " + fileId);
                },
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Enter the File Id',
                  hintText: 'File Secret Id',
                ),
                autofocus: false,
              )),
          SizedBox(
            height: 20,
          ),
          GestureDetector(
            onTap: () async {
              FirebaseServices fs = new FirebaseServices();

              List<FileStructure> fi = await  fs.getFilesById(fileId);



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
          )
        ],
      ),
    );
  }
}

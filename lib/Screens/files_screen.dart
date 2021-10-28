import 'package:encryptu/CustomDS/fileDS.dart';
import 'package:encryptu/Utils/Utility.dart';
import 'package:encryptu/Utils/firebase_services.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

class FilesScreen extends StatefulWidget {
  static String id = "FilesScreen";

  @override
  _FilesScreenState createState() => _FilesScreenState();
}

class _FilesScreenState extends State<FilesScreen> {
  // Map<String, String> userData = {
  //   'name': 'Siddhant',
  //   'profile': Utility.demoLink,
  //   'phoneNo': "+919931036296",
  //   'email': "siddhantjaiswal363@gmail.com",
  //   'address': "Ranchi Jharkhand"
  // };

  // bool copied = false;
  List<FileStructure> files = [];

  getFiles() async {
    FirebaseServices _services = FirebaseServices();
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      files = await _services.getFilesByUserId(user.uid);

      print("USER ID IS " + user.uid);

      print("FILES LENGHT" + files.length.toString());
    }
  }

  FileStructure temp = new FileStructure(
      "fafjkafka", "4314878924", "SIDDHANT JAISWAL", "47831974", true);

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getFiles();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        centerTitle: true,
        elevation: 0,
        title: Text(
          "File Manager",
          style: Utility.kHeadingTextStyle(),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Hey, Welcome again!!",
              style: GoogleFonts.montserrat(
                  fontSize: 30, color: Colors.teal.shade900),
            ),
            SizedBox(
              height: 10,
            ),
            Text(
              "Your are in Safe hand.",
              style: GoogleFonts.montserrat(fontSize: 20),
            ),
            Divider(
              thickness: 1.0,
            ),
            SizedBox(
              height: 10,
            ),
            Container(
              height: MediaQuery.of(context).size.height - 300,
              child: ListView.builder(
                  itemCount: 10,
                  itemBuilder: (BuildContext context, int index) {
                    return fileTile(temp);
                  }),
            ),
          ],
        ),
      ),
    );
  }

  Widget fileTile(FileStructure fs) {
    bool copied = false;

    return Column(
      children: [
        Card(
          child: Container(
            height: 100,
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
              border: Border.all(color: Colors.teal.shade900, width: 0.4),
            ),
            padding: EdgeInsets.all(14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      "File ID : ",
                      style: GoogleFonts.anticDidone(
                          fontSize: 15, fontWeight: FontWeight.w700),
                    ),
                    SizedBox(
                      width: 20,
                    ),
                    clip(fs),
                    Spacer(),
                    Container(
                      decoration: BoxDecoration(shape: BoxShape.circle),
                      child: IconButton(
                        icon: Icon(Icons.delete),
                        onPressed: () {},
                      ),
                    )
                  ],
                )
              ],
            ),
          ),
        ),
        SizedBox(
          height: 10,
        )
      ],
    );
  }

  Widget clip(FileStructure fs) {
    return Container(
      // height: 40,
      padding: EdgeInsets.only(left: 4),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: Colors.teal, width: 0.8),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: [
          Text(
            "${fs.uniqueId}",
            style: GoogleFonts.abel(
              color: Colors.black,
            ),
          ),
          IconButton(
            icon: Icon(
              Icons.copy,
              color: Colors.black,
              size: 17,
            ),
            onPressed: () {
              Clipboard.setData(
                ClipboardData(
                  text: fs.uniqueId.toString(),
                ),
              );

              final snak = SnackBar(content: Text('Id copied to Clipboard'));
              ScaffoldMessenger.of(context).showSnackBar(snak);
            },
          ),
        ],
      ),
    );
  }
}

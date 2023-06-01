import 'package:firebaseencrytion/CustomDS/fileDS.dart';
import 'package:firebaseencrytion/CustomDS/filesFirebase.dart';
import 'package:firebaseencrytion/Utils/Utility.dart';
import 'package:firebaseencrytion/Utils/firebase_services.dart';
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

  int selectedIndex = -1;
  List<FirebaseFileStructure> files = [];
  int showPasswordindex = -1;

  getFiles() async {
    FirebaseServices _services = FirebaseServices();
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      files = await _services.getFilesByUserId(user.uid);

      print("USER ID IS " + user.uid);

      print("FILES LENGHT" + files.length.toString());
    }
    setState(() {

    });

    return;
  }

  FileStructure temp = new FileStructure(
      "fafjkafka", "4314878924", "Siddhant@25", "47831974", true);

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
                  fontSize: 28, color: Colors.teal.shade900),
            ),
            SizedBox(
              height: 10,
            ),
            Text(
              "Your Files are in Safe hand.",
              style: GoogleFonts.montserrat(fontSize: 17),
            ),
            Divider(
              thickness: 1.0,
            ),
            SizedBox(
              height: 10,
            ),
            Container(
              height: MediaQuery.of(context).size.height - 300,
              child: files == null || files.length <= 0
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Oops..!!😞",
                            style: GoogleFonts.abel(
                                fontSize: 25, fontWeight: FontWeight.w700),
                          ),
                          Text(
                            "You haven't any upload file yet..",
                            style: GoogleFonts.abel(
                                fontWeight: FontWeight.w600,
                                fontSize: 20,
                                color: Colors.grey),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          Card(
                            elevation: 0,
                            color: Colors.grey.shade200,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                "Go to sharing page",
                                style: GoogleFonts.abel(
                                    fontWeight: FontWeight.w400,
                                    fontSize: 17,
                                    color: Colors.grey),
                              ),
                            ),
                          )
                        ],
                      ),
                    )
                  : ListView.builder(
                      itemCount: files.length,
                      itemBuilder: (BuildContext context, int index) {
                        return fileTile(files[index], index);
                      }),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _showMyDialog(FirebaseFileStructure fs) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Are you confirm to delete file ? '),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text(
                  'File ID : ${fs.uniqueId}',
                  style: GoogleFonts.abel(fontSize: 14),
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text(
                'Deny',
                style: GoogleFonts.roboto(color: Colors.red, fontSize: 16),
              ),
              onPressed: () async {
                // await FirebaseServices().deleteFile(fs.docID);
                //
                // await getFiles();
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text(
                'Approve',
                style: GoogleFonts.roboto(color: Colors.green, fontSize: 16),
              ),
              onPressed: () async {
                await FirebaseServices().deleteFile(fs.docID);
                await getFiles();
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Widget fileTile(FirebaseFileStructure fs, int index) {
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
            padding: EdgeInsets.only(
              left: 10,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Container(
                  height: 30,
                  child: Row(
                    children: [
                      Text(
                        "File ID : ",
                        style: GoogleFonts.anticDidone(
                            fontSize: 15, fontWeight: FontWeight.w700),
                      ),
                      clip(fs, index),
                      Spacer(),
                      Container(
                        decoration: BoxDecoration(shape: BoxShape.circle),
                        child: IconButton(
                          icon: Icon(
                            Icons.delete,
                            color: Colors.red,
                          ),
                          onPressed: () async {
                            _showMyDialog(fs);
                          },
                        ),
                      )
                    ],
                  ),
                ),
                Container(
                  padding: EdgeInsets.only(left: 2),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        "Password: ",
                        style: GoogleFonts.anticDidone(
                            fontSize: 15, fontWeight: FontWeight.w700),
                      ),
                      Text(
                        showPasswordindex == index
                            ? "${fs.password}"
                            : "**************",
                      ),
                      IconButton(
                        onPressed: () {
                          setState(() {
                            if (index == showPasswordindex)
                              showPasswordindex = -1;
                            else
                              showPasswordindex = index;
                          });
                        },
                        icon: Icon(
                          showPasswordindex == index
                              ? Icons.remove_red_eye
                              : Icons.remove_red_eye_outlined,
                          color: showPasswordindex == index
                              ? Colors.green
                              : Colors.black,
                        ),
                      ),

                      // clip(fs, index),
                    ],
                  ),
                ),
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

  Widget clip(FirebaseFileStructure fs, int index) {
    return Row(
      children: [
        Text(
          "${fs.uniqueId}",
          style: GoogleFonts.abel(
            color: selectedIndex == index ? Colors.green : Colors.black,
          ),
        ),
        IconButton(
          icon: Icon(
            Icons.copy,
            color: selectedIndex == index ? Colors.green : Colors.black,
            size: 17,
          ),
          onPressed: () {
            if (selectedIndex != index) {
              setState(() {
                selectedIndex = index;
              });
              Clipboard.setData(
                ClipboardData(
                  text: fs.uniqueId.toString(),
                ),
              );

              final snak =
                  SnackBar(content: Text('File Unique is copied to Clipboard'));
              ScaffoldMessenger.of(context).showSnackBar(snak);
            }
            ;
          },
        ),
      ],
    );
  }
}

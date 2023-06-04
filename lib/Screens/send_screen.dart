import 'dart:io';

import 'package:file_saver/file_saver.dart';

import 'package:cool_alert/cool_alert.dart';
import 'package:firebaseencrytion/Screens/Home.dart';
import 'package:firebaseencrytion/Screens/login_screen.dart';

import 'package:firebaseencrytion/Utils/Utility.dart';

import 'package:firebaseencrytion/Utils/storage_services.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../Utils/file_encrypter.dart';
import '../Utils/firebase_services.dart';
import '../Utils/test.dart';

class SendScreen extends StatefulWidget {
  @override
  _SendScreenState createState() => _SendScreenState();
}

class _SendScreenState extends State<SendScreen> {
  String password = "";
  customDSforFileStorageLink? cds = null;
  bool showPassword = false;
  bool showKey = false;
  String key = "";

  bool takepassword = false;
  bool isuploading = false;
  File? doc;
  bool isUploading = false;
  bool isEncrypting = false;
  keyDataStructure? kds;
  @override
  void initState() {
    Utility.customlogger("At Send Screen");
    super.initState();
    takepassword = false;
    isuploading = false;
    password = "";
  }

  @override
  Widget build(BuildContext context) {
    final fileName = doc != null
        ? (doc!.path.split('/').last)
        : "No Document Selected"; //Getting the name of the selected document
    return SingleChildScrollView(
      child: Container(
        width: MediaQuery.of(context).size.width,
        padding: EdgeInsets.only(left: 20, top: 10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SizedBox(
              height: 30,
            ),
            doc == null
                ? GestureDetector(
                    onTap: () async {
                      // if (isuploading == false) {
                      //   File? fi = await FilePickerCustom().pickfiles();
                      //
                      //   Utility.customlogger(fi == null ? "Picked file is null at send_screen.dart":"Picked file is not null at send_screen.dart");
                      //
                      //   if (fi != null) {
                      //     isuploading = true;
                      //     setState(() {});
                      //     cds = await FirebaseServices().uploadFile(fi);
                      //     isuploading = false;
                      //     takepassword = true;
                      //     Utility.customlogger("TAKE PASSWORD ${takepassword}");
                      //     setState(() {});
                      //   }
                      //   else
                      //     Utility.customlogger("FILE--UINT8List IS NULL");
                      //   // FilePickerCustom fpc = new FilePickerCustom();
                      //   // fpc.openFileExplorer();
                      //
                      // }

                      final result = await FilePickerApi.pickDocument();
                      if (result == null) {
                        return;
                      }
                      final filePath = result.path;
                      Utility.customlogger("file path $filePath");
                      setState(() {
                        doc = File(filePath);
                      });
                    },
                    child: Container(
                      width: MediaQuery.of(context).size.width / 2,
                      height: 180,
                      decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.green.shade600,
                          border: Border.all(color: Colors.red, width: 1.5)),
                      child: isuploading
                          ? CircularProgressIndicator(
                              color: Colors.white,
                            )
                          : Column(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Spacer(),
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
                                Spacer()
                              ],
                            ),
                    ),
                  )
                : Column(
                    children: [
                      Row(
                        children: [
                          IconButton(
                              onPressed: () async {
                                final result =
                                    await FilePickerApi.pickDocument();
                                if (result == null) {
                                  return;
                                }
                                final filePath = result.path;
                                Utility.customlogger("file path $filePath");
                                setState(() {
                                  doc = File(filePath);
                                });
                              },
                              icon: Icon(Icons.file_copy_outlined)),
                          Text(
                            fileName,
                            style: GoogleFonts.aladin(fontSize: 18),
                          ),
                        ],
                      ),
                      Text(
                        'Encrypt your data',
                        style: GoogleFonts.alatsi(
                            fontSize: 18, fontWeight: FontWeight.w400),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Row(
                        children: [
                          Container(
                            width: MediaQuery.of(context).size.width - 110,
                            child: TextField(
                              obscureText: !showKey,
                              keyboardType: TextInputType.number,
                              onChanged: (val) {
                                key = val;
                                Utility.customlogger("Password is " + key);
                              },
                              decoration: const InputDecoration(
                                border: OutlineInputBorder(),
                                labelText: 'Enter key to secure your data',
                                hintText: 'Password ',
                              ),
                              autofocus: false,
                            ),
                          ),
                          const SizedBox(
                            width: 5,
                          ),
                          IconButton(
                            icon: Icon(showKey
                                ? Icons.remove_red_eye
                                : Icons.remove_red_eye_outlined),
                            onPressed: () {
                              if (showKey == false) {
                                showKey = true;
                              } else {
                                showKey = false;
                              }

                              setState(() {});
                            },
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      ElevatedButton(
                          onPressed: () async {
                            setState(() {
                              isEncrypting = true;
                            });
                           kds = await FileEcryptionApi.encryptFile(
                                doc!.readAsBytesSync(),
                                key); //Changing the file into a list of bytes

                            await FileSaver
                                .instance //Saving the encrypted document to local storage
                                .saveAs(fileName, kds!.data, "aes",
                                    MimeType.OTHER)
                                .whenComplete(
                              () {
                                setState(
                                  () {
                                    isEncrypting = false;
                                  },
                                );
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text("Successfully encrypted !! "),
                                  ),
                                );
                              },
                            );
                          },
                          child: isEncrypting
                              ? const Text("Encrypting...")
                              : const Text("Encrypt Document")),
                      const SizedBox(
                        height: 10,
                      ),
                      Text(
                        'Please enter a Password to secure your file',
                        style: GoogleFonts.montserrat(fontSize: 18),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Row(
                        children: [
                          Container(
                            width: MediaQuery.of(context).size.width - 110,
                            child: TextField(
                              obscureText: !showPassword,

                              onChanged: (val) {
                                password = val;
                                Utility.customlogger("Password is " + password);
                              },
                              decoration: const InputDecoration(
                                border: OutlineInputBorder(),
                                labelText: 'Enter the File Password',
                                hintText: 'Password ',
                              ),
                              autofocus: false,
                            ),
                          ),
                          const SizedBox(
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
                      const SizedBox(
                        height: 20,
                      ),
                      GestureDetector(
                        onTap: () async {
                          setState(() {
                            isUploading = true;
                          });
                          customDSforFileStorageLink? cds =
                              await uploadDocument();
                          setState(() {
                            isUploading = false;
                          });
                          ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                  content: Text("Uploaded Successfully!")));

                          Utility.customlogger("CDS IS NOT NULL at UI");

                          if (cds != null) {
                            if (await FirebaseServices()
                                .encryptFile(cds!, password,kds! )) {
                              // ignore: use_build_context_synchronously
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
                              Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>LoginScreen()));

                            } else {
                              // ignore: use_build_context_synchronously
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
                          }
                        },
                        child: Card(
                          color:
                              takepassword ? Colors.teal.shade900 : Colors.grey,
                          child: Container(
                            padding: EdgeInsets.all(5),
                            color: Colors.white54,
                            child: Text(
                              "Upload your file",
                              style: GoogleFonts.roboto(
                                  fontSize: 18, color: Colors.black),
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
          ],
        ),
      ),
    );
  }

  Future<customDSforFileStorageLink?> uploadDocument() async {
    // Function to upload the picked document to Firebase
    if (doc == null) return null;
    var filePath = doc!.path;
    var fileName = (filePath.split('/').last);
    final destination = "files/documents/$fileName";

    customDSforFileStorageLink? cdsLink =
        await FirebaseApi.uploadFile(destination, doc!);

    Utility.customlogger(
        "GOT THE CDS LINK at uploadDocument() at send_screen.dart");
    return cdsLink;
  }
}

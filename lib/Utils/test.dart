import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:file_saver/file_saver.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:firebaseencrytion/Utils/Utility.dart';
import 'package:firebaseencrytion/Utils/storage_services.dart';
import 'package:flutter/material.dart';

import 'file_encrypter.dart';

class DocumentScreen extends StatefulWidget {
  const DocumentScreen({Key? key}) : super(key: key);

  @override
  State<DocumentScreen> createState() => _DocumentScreenState();
}

class _DocumentScreenState extends State<DocumentScreen> {
  File? doc;
  bool isUploading = false;
  bool isEncrypting = false;
  @override
  Widget build(BuildContext context) {
    final fileName =
    doc != null ? (doc!.path.split('/').last) : "No Document Selected"; //Getting the name of the selected document
    return Scaffold(
        appBar: AppBar(
          title: const Text("Select Document"),
          centerTitle: true,
        ),
        body: Center(
          child: Padding(
              padding: const EdgeInsets.all(30),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    fileName,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  (doc == null)
                      ? ElevatedButton.icon(
                      onPressed: () async {
                        final result = await FilePickerApi.pickDocument();
                        if (result == null) {
                          return;
                        }
                        final filePath = result.path;
                        setState(() {
                          doc = File(filePath);
                        });
                      },
                      icon: const Icon(Icons.attach_file),
                      label: const Text("Select Document"))
                      : Column(
                    children: [
                      ElevatedButton(
                          onPressed: () async {
                            setState(() {
                              isEncrypting = true;
                            });
                            final result =
                            await FileEcryptionApi.encryptFile(
                                doc!.readAsBytesSync(),14
                            ); //Changing the file into a list of bytes

                            await FileSaver.instance //Saving the encrypted document to local storage
                                .saveAs(fileName, result!.data, "aes",
                                MimeType.OTHER)
                                .whenComplete( () {
                              setState(
                                    () {
                                isEncrypting = false;
                              },
                              );
                              ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                      content: Text(
                                          "Successfully encrypted !! "
                                      ),
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
                      ElevatedButton.icon(
                          onPressed: () async {
                            setState(() {
                              isUploading = true;
                            });
                            await uploadDocument().whenComplete(() {
                              setState(() {
                                isUploading = false;
                              });
                              ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                      content: Text(
                                          "Uploaded Successfully!")));
                            });
                          },
                          icon: const Icon(Icons.cloud_upload_rounded),
                          label: isUploading
                              ? const Text("Uploading...")
                              : const Text("Upload to Firebase")),
                    ],
                  ),
                ],
              )),
        ));
  }

  Future uploadDocument() async { // Function to upload the picked document to Firebase
    if (doc == null) return;
    var filePath = doc!.path;
    var fileName = (filePath.split('/').last);
    final destination = "files/documents/$fileName";

   await FirebaseApi.uploadFile(destination, doc!) ;
   Utility.customlogger("Upload Task Done :: at uplaodDocument() ");

  }
}
class FirebaseApi {
  static Future<customDSforFileStorageLink?> uploadFile(String destination, File file) async {
    try {
      customDSforFileStorageLink cs;
      final storageRef = FirebaseStorage.instance.ref(destination); //Here the destination of the file is passed.
      final metadata = firebase_storage.SettableMetadata(
        contentType: 'application/pdf',
      );
      firebase_storage.TaskSnapshot task = await storageRef.putFile(file,metadata);
   String url =  await storageRef.getDownloadURL() ;
    Utility.customlogger("URL IS : $url");
    String id = task.ref.hashCode.toString();
    Utility.customlogger("HASHCODE is $id");
    cs = new customDSforFileStorageLink(url, id);
    return cs;
    } on FirebaseException catch (e) {
      return null; // If any errors occur uploading is cancelled.
    }
  }
}
class FilePickerApi {
  //Picking an image from local storage
  static Future<File?> pickDocument() async {
    final pickedFile = await FilePicker.platform.pickFiles(
      allowMultiple: false,
      type: FileType.custom,
      allowedExtensions: [ 'pdf'], // Only images will be picked in the file picker
    );

    if (pickedFile == null) {
      return null;
    } else {
      final pickedImage = pickedFile.files.first;
      return File(pickedImage.path!);
    }
  }
}
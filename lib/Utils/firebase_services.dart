import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:encryptu/CustomDS/fileDS.dart';
import 'package:encryptu/CustomDS/filesFirebase.dart';
import 'package:encryptu/CustomDS/userDS.dart';
import 'package:encryptu/Utils/storage_services.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirebaseServices {
  static var _firestore_instance = FirebaseFirestore.instance;

  bool isLoggedIn() {
    return FirebaseAuth.instance.currentUser != null;
  }

  Future<User?> currentUser() async {
    return await FirebaseAuth.instance.currentUser;
  }

  Future<void> addUserData(UserDetails userDetails) async {
    print("-----------------INSIDE ADD DATA ---------------");

    Map<String, String> userData = {
      'name': userDetails.name,
      'email': userDetails.emailId,
      'address': userDetails.address,
      'phoneNo': userDetails.phoneNumber,
      'profile': userDetails.photoUrl,
    };
    print(userData);

    if (isLoggedIn()) {
      _firestore_instance
          .collection('user')
          .add(userData)
          .then(
            (value) => print(
              "SUCCESS  " + value.toString(),
            ),
          )
          .catchError((onError) {
        print("CAUGHT ERRORR" + onError);
      });
    } else
      print("USER NOT LOGGED IN");
  }

  Future<customDSforFileStorageLink> uploadFile(File fi) async {
    customDSforFileStorageLink cds;
    cds = (await Storage_Services.upload(fi))!;
    return cds;
  }

  Future<void> encryptFile(
      customDSforFileStorageLink cds, String password) async {
    User? user = await currentUser();

    FileStructure fs =
        new FileStructure(cds.url, cds.uniqueId, password, user!.uid, true);
    await _addFileData(fs);
    return;
  }

  Future<void> _addFileData(FileStructure fs) async {
    print("-----------------INSIDE addFileToFirestore  ---------------");
    // print(userData);

    Map<String, String> data = {
      'fileId': fs.uniqueId.toString(),
      'fileURL': fs.url.toString(),
      'owner': fs.ownerId.toString(),
      'password': fs.password.toString(),
    };

    if (isLoggedIn()) {
      _firestore_instance
          .collection('files')
          .add(data)
          .then(
            (value) => print(
              "fille to firestore SUCCESS " + value.toString(),
            ),
          )
          .catchError((onError) {
        print("CAUGHT ERRORR" + onError);
      });
    } else
      print("USER NOT LOGGED IN");
  }

  //helps to get the data by id
  getFilesById(String id) {
    List<FileStructure> fi = [];
    // id = "330146681";
    // 330146681

    return _firestore_instance
        .collection('files')
        .where('fileId', isEqualTo: id)
        .where('show', isEqualTo: true)
        .get()
        .then((QuerySnapshot querySnapshot) {
      if (querySnapshot != null) {
        querySnapshot.docs.forEach((element) {
          FileStructure f;
          String url = element['fileURL'];
          String password = element['password'];
          String owner = element['owner'];
          bool show = element['show'];

          f = new FileStructure(url, id, password, owner, show);
          fi.add(f);
        });

        print("FI LENGTH " + fi.length.toString());
        return fi;
      } else {
        print("FILE QUERY IS NULL");
        return [];
      }
    });
  }

  getFilesByUserId(String id) {
    // List<FileStructure> fi = [];
    // id = "330146681";
    // 330146681

    List<FirebaseFileStructure> fi = [];
    return _firestore_instance
        .collection('files')
        .where('owner', isEqualTo: id)
        .where('show', isEqualTo: true)
        .get()
        .then((QuerySnapshot querySnapshot) {
      if (querySnapshot != null) {
        querySnapshot.docs.forEach((element) {
          FirebaseFileStructure f;
          String url = element['fileURL'];
          String password = element['password'];
          String owner = element['owner'];
          bool show = element['show'];
          String docId = element.id;
          print("DOC ID IS  : ${docId}");

          f = new FirebaseFileStructure(url, id, password, owner, show, docId);
          fi.add(f);
        });

        print("FI LENGTH " + fi.length.toString());
        return fi;
      } else {
        print("FILE QUERY IS NULL");
        return [];
      }
    });
  }

  getUserData() async {
    _firestore_instance
        .collection('user')
        .get()
        .then((QuerySnapshot querySnapshot) {
      if (querySnapshot != null) {
        querySnapshot.docs.forEach((doc) {
          print("PRINTING");
          print(doc["name"]);
        });
      } else
        print("QUERY SNAPSHOT IS NULL");
    });
  }

  Future<bool> userExists(String username) async =>
      (await _firestore_instance
              .collection("user")
              .where("username", isEqualTo: username)
              .get())
          .docs
          .length >
      0;

  _updateData(selectedDoc, newValue) {
    _firestore_instance
        .collection('files')
        .doc(selectedDoc)
        .update(newValue)
        .then((value) => print("SUCCESS"))
        .catchError((onError) => print(onError.toString()));
  }

  Future<void> deleteFile(String selectedDoc) async {
    Map<String, bool> map = {'show': false};

    print("SENT TO UPDATE VALUE");
    await _updateData(selectedDoc, map);
  }
}

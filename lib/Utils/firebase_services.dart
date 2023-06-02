import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebaseencrytion/CustomDS/fileDS.dart';

import 'package:firebaseencrytion/CustomDS/filesFirebase.dart';
import 'package:firebaseencrytion/CustomDS/userDS.dart';
import 'package:firebaseencrytion/CustomDS/userFirebase.dart';
import 'package:firebaseencrytion/Utils/Utility.dart';
import 'package:firebaseencrytion/Utils/storage_services.dart';
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

  Future<bool> encryptFile(
      customDSforFileStorageLink cds, String password) async {
    User? user = await currentUser();

    FileStructure fs =
        new FileStructure(cds.url, cds.uniqueId, password, user!.uid, true);
    await _addFileData(fs);

    return true;
  }

  Future<bool> _addFileData(FileStructure fs) async {
    print("-----------------INSIDE addFileToFirestore  ---------------");
    // print(userData);

    Map<String, dynamic> data = {
      'fileId': fs.uniqueId.toString(),
      'fileURL': fs.url.toString(),
      'owner': fs.ownerId.toString(),
      'password': fs.password.toString(),
      'show': true
    };

    bool res = false;
    if (isLoggedIn()) {
      _firestore_instance
          .collection('files')
          .add(data)
          .then(
            (value) {print(
              "fille to firestore SUCCESS " + value.toString(),);
                res = true;
            }
          )
          .catchError((onError) {

        print("CAUGHT ERRORR" + onError);
      });
    } else
      print("USER NOT LOGGED IN");

    return res;
  }

  //helps to get the data by id
  getFilesById(String id) {
    List<FileStructure> fi = [];
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
          String fileId = element['fileId'];
          bool show = element['show'];
          String docId = element.id;

          print("DOC ID IS  : ${docId}");

          // f = new FirebaseFileStructure(url, id, password, fileId, show, docId);
          f = new FirebaseFileStructure(
              url: url,
              uniqueId: fileId,
              password: password,
              ownerId: id,
              show: show,
              docID: docId);
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

  getUserData1(String uid) {
    Utility.customlogger("getUserData1() ------- > UID : $uid");
    List<UserFirebase> fi = [];
    return _firestore_instance
        .collection('user')
        .where('uid', isEqualTo: uid)
        .get()
        .then((QuerySnapshot querySnapshot) {
      if (querySnapshot != null) {

        Utility.customlogger("QuerySnapshot is not null");
        querySnapshot.docs.forEach((doc) {
          // UserFirebase f;
          print(doc == null ? "DOC IS NULL ": "DOC is not null");
          print(doc.runtimeType);
          print("DOC DATA TYPE : ${doc.data().runtimeType}");

          Map mp = doc.data() as Map;
          Utility.customlogger("PRINTING USER MAP ");
          print(mp.keys);

          Utility.customlogger(mp['name']);
          Utility.customlogger(mp['uid']);
          Utility.customlogger(mp['address']);
          Utility.customlogger(mp['gender']);
          Utility.customlogger(mp['profile']);
          Utility.customlogger(mp['phoneNo']);
          Utility.customlogger(mp['email']);

          // Utility.customlogger("USER NAME ${doc.data()['name']}");
          // print("USER NAME " + doc['name']);
          String name = mp['name'];
          String email = mp['email'];
          String phone = mp['phoneNo'];
          String profile = mp['profile'];
          String address = mp['address'];
          String gender = mp['gender'];
          String docId = doc.id;

        Utility.customlogger("DOC ID IS  : ${doc.id}");
        //   // f = new FirebaseFileStructure(url, id, password, fileId, show, docId);
           UserFirebase f = new UserFirebase(name: name, photoUrl: profile, phoneNumber: phone, emailId: email, address: address, docId: docId, gender: gender);
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
  updateUserData(selectedDoc, newValue) {
    _firestore_instance
        .collection('user')
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

//

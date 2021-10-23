import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:encryptu/CustomDS/fileDS.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirebaseServices {
  static var _firestore_instance = FirebaseFirestore.instance;

  bool isLoggedIn() {
    return FirebaseAuth.instance.currentUser != null;
  }

  Future<User?> currentUser() async {
    return await FirebaseAuth.instance.currentUser;
  }

  Future<void> addData(Map<String, String> userData) async {
    print("-----------------INSIDE ADD DATA ---------------");
    print(userData);

    if (isLoggedIn()) {
      _firestore_instance
          .collection('user')
          .add(userData)
          .then((value) => print("SUCCESS  " + value.toString(),),)
          .catchError((onError) {
        print("CAUGHT ERRORR" + onError);
      });
    } else
      print("USER NOT LOGGED IN");
  }
  getFilesById(String id)
  {
   return _firestore_instance.collection('files').where('fileId',isEqualTo: id).where('show', isEqualTo: true).get();
  }

  Future<void> addFileToFirestore(FileStructure fs) async {
    print("-----------------INSIDE addFileToFirestore  ---------------");
    // print(userData);

    Map<String,String> data = {
      'fileId':fs.uniqueId.toString(),
      'fileURL':fs.url.toString(),
      'owner':fs.ownerId.toString(),
      'password':fs.password.toString(),

    };

    if (isLoggedIn()) {
      _firestore_instance
          .collection('files')
          .add(data)
          .then((value) => print("fille to firestore SUCCESS " + value.toString(),),)
          .catchError((onError) {
        print("CAUGHT ERRORR" + onError);
      });
    } else
      print("USER NOT LOGGED IN");
  }




}

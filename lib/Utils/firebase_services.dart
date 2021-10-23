import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';

class FirebaseServices {
  var _firestore_instance = FirebaseFirestore.instance;

  bool isLoggedIn() {
    return FirebaseAuth.instance.currentUser != null;
  }

  Future<User?> currentUser() async {
    return await FirebaseAuth.instance.currentUser;
  }

  Future<void> addData( @required  Map<String, String> userData, )  async {
    if (isLoggedIn()) {
      _firestore_instance
          .collection("user")
          .add(userData)
          .catchError((onError) {
        print(onError);
      });

    }
    else
      print("USER NOT LOGGED IN");
  }
}

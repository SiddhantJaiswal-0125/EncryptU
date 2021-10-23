import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:firebase_storage/firebase_storage.dart' ;
import 'package:flutter/foundation.dart';

class Storage_Services
{

  //method use to upload file into firebase storage
  static Future<customDSforFileStorageLink?> upload( File file) async {
    try {
      String destination = file.path;
      final ref = FirebaseStorage.instance.ref(destination);

      print("INSIDE Storage Service");
      String id, url ;
      customDSforFileStorageLink cs ;

      print(ref.hashCode);
      final metadata = firebase_storage.SettableMetadata(
        contentType: 'image/jpeg',
      );
      // if (kIsWeb) {
      //   await ref.putData(await file.readAsBytes(), metadata);
      // }
      // else {



        // then((task) async
        // {
        //   print("INSIDE PUT FILE");
        //   id = task.ref.hashCode.toString();
        //   url = await ref.getDownloadURL();
        //   print("URL IN _UPLOAD IS " + url);
        //   customDSforFileStorageLink cs = new customDSforFileStorageLink(url, id);
        //
        //   print(task.ref.hashCode);
        // });
         firebase_storage.TaskSnapshot task =  await ref.putFile(file, metadata);
         url = await ref.getDownloadURL();
         id = task.ref.hashCode.toString();
       cs =  new customDSforFileStorageLink(url, id);
         print("code is "+task.ref.hashCode.toString());
          print("URL IN _UPLOAD IS " + url);

      // }




      return cs;
    } on FirebaseException catch (e) {
      print("---------------------------------------------------------------------------------");
      print("------------------ERROR IN FIREBASE STORAGE SERVICES ---------------------------");
      print("---------------------------------------------------------------------------------");
      return null;
    }
  }

}


class customDSforFileStorageLink {

 final String url;
 final String uniqueId;

  customDSforFileStorageLink(this.url, this.uniqueId);

}

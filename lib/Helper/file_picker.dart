import 'dart:io';
import 'dart:typed_data';
import 'package:firebaseencrytion/Utils/Utility.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

class FilePickerCustom
{
  Future<File?> pickfiles() async
  {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      // allowedExtensions: ['pdf']
      type: FileType.custom,
      allowedExtensions: [ 'pdf'],
    );
    if (result != null) {
      String? path =   result.files.single.path;
      File file = File(path!);
      return file;
    }
    Utility.customlogger("Picked file is null : at pickfiles() at file_picker.dart");
    return null;
  }


  List<PlatformFile>? _paths;

  ///OPEN FILE EXPLOER and pick file
  void openFileExplorer() async {
    try {
      FilePickerResult? picked = await FilePicker.platform.pickFiles();

      if (picked != null) {
        if (kIsWeb) {
          ///Start uploading calling the function.
          final fileBytes = picked.files.first.bytes;
          final fileName = picked.files.first.name;
          final fileExtension = picked.files.first.extension;
          uploadFile(fileBytes!, fileExtension!);
        } else {
          uploadFile(await File(picked.files.first.path!).readAsBytes(),
              picked.files.first.extension!);
        }
      }
    } on PlatformException catch (e) {
      print("ERROR Unsupported operation" + e.toString());
    } catch (e) {
      print('ERROR' + e.toString());
    }
  }

  ///FUNCTION UPLOAD the file to the storage
  Future<void> uploadFile(Uint8List _data, String extension) async {

    Utility.customlogger("Inside upload file || file_picker.dart");
    ///Start uploading
    firebase_storage.Reference reference = firebase_storage
        .FirebaseStorage.instance
        .ref('docs/namefile.$extension');

    Utility.customlogger("Storage Reference Created");
    Utility.customlogger(reference.toString());

    ///Show the status of the upload
    firebase_storage.TaskSnapshot uploadTask = await reference.putData(_data);

    ///Get the download url of the file
    String url = await uploadTask.ref.getDownloadURL().then((value){
      Utility.customlogger("URL at uploadfile : $value");
      return value;
    });

    Utility.customlogger("URL");
    Utility.customlogger(url);


    if (uploadTask.state == firebase_storage.TaskState.success) {
      print('done');
      print('URL: $url');
    } else {
      print(uploadTask.state);
    }
  }

  Future<Uint8List?> pickfilesfromWeb() async
  {

    FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom, allowedExtensions: [ 'pdf']);

// The result will be null, if the user aborted the dialog
    if(result != null) {
      final fileBytes = result.files.first.bytes;
      final fileName = result.files.first.name;
      Utility.customlogger("File Name : ${fileName}");
      Utility.customlogger("Printing file as bytes at filepicker.dart pickfilesfromweb() ");
      // print(fileBytes);
      // upload file
      // final reff = await FirebaseStorage.instance.ref();
      // print(reff);
      return fileBytes;
    }
    else
      Utility.customlogger("ERROR, Not able to pick files in Web");
    return null;
  }


}





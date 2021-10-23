import 'dart:io';
import 'package:file_picker/file_picker.dart';


class FilePickerCustom
{
   Future<File?> pickfiles() async
  {
    FilePickerResult? result = await FilePicker.platform.pickFiles();
    if (result != null) {
      String? path =   result.files.single.path;
      File file = File(path!);
      return file;
    }
    return null;
  }
}





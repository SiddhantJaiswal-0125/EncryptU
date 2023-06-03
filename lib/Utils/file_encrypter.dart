import 'dart:io';
import 'dart:typed_data';

import 'package:encrypt/encrypt.dart';
import 'package:file_saver/file_saver.dart';

class FileEcryptionApi {
  static Future<Uint8List?> encryptFile(data) async {
    final key = Key.fromSecureRandom(16);
    final iv = IV.fromLength(16);
    final encrypter = Encrypter(AES(key, mode: AESMode.cbc));

    final encryptedFile = encrypter.encryptBytes(data, iv: iv);
    return encryptedFile.bytes;
  }

  static void test(File doc) async {
    final result = await FileEcryptionApi.encryptFile(
        doc!.readAsBytesSync()); //Changing the file into a list of bytes

    bool isEncrypting = true;
    String fileName = "sid";
    await FileSaver.instance //Saving the encrypted document to local storage
        .saveAs(fileName, result!, "aes", MimeType.OTHER)
        .whenComplete(() {
      isEncrypting = false;

    });
  }
}

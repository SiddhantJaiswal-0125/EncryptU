import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
class Utility
{
  static String packageName = "com.siddhantjaiswal.encryptu";
  static String demoLink = "https://templates.joomla-monster.com/joomla30/jm-news-portal/components/com_djclassifieds/assets/images/default_profile.png";

  static TextStyle kHeadingTextStyle()
  {

    return GoogleFonts.lato(color: Colors.teal.shade900, fontSize: 25);
  }
    static void customlogger(String msg)
  {
    print("-------------- : ${msg} : ------------------");
  }
}






//
// File? fi = await FilePickerCustom().pickfiles();
// customDSforFileStorageLink? cds = await Storage_Services.upload(fi!);
// print("URL IS " + cds!.url.toString() + "\t id is " + cds.uniqueId);
//
// FileStructure fs = new FileStructure(
//     cds.url, cds.uniqueId, "Siddhant@25", widget.user.uid);

// FirebaseServices().addFileToFirestore(fs);

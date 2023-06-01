import 'package:firebaseencrytion/CustomDS/userFirebase.dart';
import 'package:firebaseencrytion/Screens/loginWeb.dart';
import 'package:firebaseencrytion/Screens/login_screen.dart';
import 'package:firebaseencrytion/Utils/firebase_services.dart';
import 'package:firebaseencrytion/Utils/utility.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shimmer/shimmer.dart';

class SettingsScreen extends StatefulWidget {
  static String id = "SettingScreen";

  const SettingsScreen({
    Key? key,
  }) : super(key: key);

  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  ScreenState currentState = ScreenState.NORMAL_SCREEN;
  List<UserFirebase> userFirebase = [];
  String name = "";
  String email = "";
  String phoneNo = "";
  String address = "";
  int selected = 1;
  UserFirebase? user;
  final myController = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getUser1();
  }

  getUser1() async {
    FirebaseServices _services = FirebaseServices();
    User? user1 = FirebaseAuth.instance.currentUser;
    if (user1 != null) {
      userFirebase = await _services.getUserData1(user1.uid);
      setState(() {});

      print("USER ID IS " + user1.uid);

      print("FILES LENGHT" + userFirebase.length.toString());
      user = userFirebase[0];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        centerTitle: true,
        elevation: 0,
        actions: [
          IconButton(
            onPressed: () async {
              FirebaseAuth.instance.signOut();
              Navigator.pushReplacementNamed(
                  context, kIsWeb ? LoginWeb.id : LoginScreen.id);
            },
            icon: currentState == ScreenState.NORMAL_SCREEN
                ? Icon(
                    Icons.logout,
                    color: Colors.teal.shade900,
                  )
                : Container(),
          )
        ],
        title: Text(
          "Settings Page",
          style: Utility.kHeadingTextStyle(),
        ),
      ),
      body: Container(
        padding: EdgeInsets.only(left: 15, right: 15, top: 20),
        child: GestureDetector(
          onTap: () {
            FocusScope.of(context).unfocus();
          },
          child: ListView(
            children: [
              Center(
                child: Stack(
                  children: [
                    Container(
                      width: 130,
                      height: 130,
                      decoration: BoxDecoration(
                          border: Border.all(width: 4, color: Colors.white),
                          boxShadow: [
                            BoxShadow(
                              spreadRadius: 2,
                              blurRadius: 10,
                              color: Colors.black.withOpacity(0.1),
                            )
                          ],
                          shape: BoxShape.circle,
                          image: DecorationImage(
                            fit: BoxFit.cover,
                            image: NetworkImage(Utility.demoLink),
                          )),
                    ),
                    editPencil(),
                  ],
                ),
              ),
              SizedBox(
                height: 30,
              ),
              currentState == ScreenState.NORMAL_SCREEN
                  ? normalScreen()
                  : editScreen(),
            ],
          ),
        ),
      ),
    );
  }

  Widget editScreen() {
    return Column(children: [
      Padding(
        padding: EdgeInsets.only(bottom: 30),
        child: TextField(
          onChanged: (val) {
            name = val;
            print("NAME " + name);
          },
          decoration: InputDecoration(
            prefixIcon: Icon(Icons.person),
            suffixIcon: IconButton(
              icon: Icon(Icons.edit),
              onPressed: () {},
            ),
            contentPadding: EdgeInsets.only(bottom: 5),
            labelText: "Your Name",
            floatingLabelBehavior: FloatingLabelBehavior.always,
            hintText: "Rahul Gandhi",
            hintStyle: TextStyle(
                fontSize: 16, fontWeight: FontWeight.bold, color: Colors.grey),
          ),
        ),
      ),
      Padding(
        padding: EdgeInsets.only(bottom: 30),
        child: TextField(
          onChanged: (val) {
            email = val;
            print("email " + email);
          },
          decoration: InputDecoration(
            prefixIcon: Icon(Icons.mail),
            suffixIcon: IconButton(
              icon: Icon(Icons.edit),
              onPressed: () {},
            ),
            contentPadding: EdgeInsets.only(bottom: 5),
            labelText: "Your email",
            floatingLabelBehavior: FloatingLabelBehavior.always,
            hintText: "test@gmail.com",
            hintStyle: TextStyle(
                fontSize: 16, fontWeight: FontWeight.bold, color: Colors.grey),
          ),
        ),
      ),
      Padding(
        padding: EdgeInsets.only(bottom: 30),
        child: TextField(
          onChanged: (val) {
            phoneNo = val;
            print("phone " + phoneNo);
          },
          maxLength: 10,
          decoration: InputDecoration(
            prefixIcon: Icon(Icons.call),
            suffixIcon: IconButton(
              icon: Icon(Icons.edit),
              onPressed: () {},
            ),
            contentPadding: EdgeInsets.only(bottom: 5),
            labelText: "Your phone",
            floatingLabelBehavior: FloatingLabelBehavior.always,
            hintText: "+919943241432",
            hintMaxLines: 10,
            hintStyle: TextStyle(
                fontSize: 16, fontWeight: FontWeight.bold, color: Colors.grey),
          ),
        ),
      ),
      Padding(
        padding: EdgeInsets.only(bottom: 30),
        child: TextField(
          onChanged: (val) {
            address = val;
            print("Address " + address);
          },
          decoration: InputDecoration(
            prefixIcon: Icon(Icons.home),
            suffixIcon: IconButton(
              icon: Icon(Icons.edit),
              onPressed: () {},
            ),
            contentPadding: EdgeInsets.only(bottom: 5),
            labelText: "Your Address",
            floatingLabelBehavior: FloatingLabelBehavior.always,
            hintText: "Delhi",
            hintStyle: TextStyle(
                fontSize: 16, fontWeight: FontWeight.bold, color: Colors.grey),
          ),
        ),
      ),
      Row(
        children: [
          GestureDetector(
            onTap: () {
              selected = 1;
              setState(() {});
            },
            child: Container(
              padding: EdgeInsets.all(5),
              decoration: BoxDecoration(
                  color: selected == 1 ? Colors.green : Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: selected == 1 ? Colors.red : Colors.green,
                  )),
              child: Text(
                "Male",
                style: GoogleFonts.roboto(
                    fontSize: 18,
                    color: selected == 1 ? Colors.white : Colors.black),
              ),
            ),
          ),
          SizedBox(
            width: 10,
          ),
          GestureDetector(
            onTap: () {
              print(selected);
              selected = 2;
              print(selected);

              setState(() {});
            },
            child: Container(
              padding: EdgeInsets.all(5),
              decoration: BoxDecoration(
                  color: selected == 2 ? Colors.green : Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: selected == 2 ? Colors.red : Colors.green,
                  )),
              child: Text(
                "Female",
                style: GoogleFonts.roboto(
                    fontSize: 18,
                    color: selected == 2 ? Colors.white : Colors.black),
              ),
            ),
          )
        ],
      ),
      SizedBox(
        height: 20,
      ),
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            margin: EdgeInsets.all(10),
            height: 50.0,
            decoration: BoxDecoration(
              boxShadow: <BoxShadow>[
                BoxShadow(
                  color: Colors.blue.withOpacity(0.1),
                  blurRadius: 1,
                  offset: Offset(10, 10),
                ),
              ],
            ),
            child: FloatingActionButton(
              elevation: 30,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(0.0),
                  side: BorderSide(color: Color.fromRGBO(0, 160, 227, 1))),
              onPressed: () {
                currentState = ScreenState.NORMAL_SCREEN;
                setState(() {});
              },
              // padding: EdgeInsets.all(10.0),
              // color: Colors.red.shade900,
              // textColor: Colors.white,
              child:
                  Text("Cancel".toUpperCase(), style: TextStyle(fontSize: 15)),
            ),
          ),
          SizedBox(
            width: 10,
          ),
          Container(
            margin: EdgeInsets.all(10),
            height: 50.0,
            decoration: BoxDecoration(
              boxShadow: <BoxShadow>[
                BoxShadow(
                  color: Colors.blue.withOpacity(0.1),
                  blurRadius: 1,
                  offset: Offset(10, 10),
                ),
              ],
            ),
            child: FloatingActionButton(
              elevation: 30,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(0.0),
                  side: BorderSide(color: Color.fromRGBO(0, 160, 227, 1))),
              onPressed: () async {
                Map<String, dynamic> map = {
                  'address': address,
                  'email': email,
                  'gender': selected == 1 ? "Male" : "Female",
                  'name': name,
                  'phoneNo': phoneNo,
                };
                await FirebaseServices().updateUserData(user!.docId, map);
                getUser1();
                setState(() {
                  currentState = ScreenState.NORMAL_SCREEN;
                });
              },
              // padding: EdgeInsets.all(10.0),
              // color: Colors.teal.shade900,
              // textColor: Colors.white,
              child:
                  Text("Update".toUpperCase(), style: TextStyle(fontSize: 15)),
            ),
          ),
        ],
      )
    ]);
  }

  Widget normalScreen() {
    return user == null
        ? Center(
            child: CircularProgressIndicator(
              color: Colors.red,
            ),
          )
        : Column(
            children: [
              textFeild("${user!.name}", Icons.person),
              SizedBox(
                height: 10,
              ),
              textFeild("${user!.emailId}", Icons.mail),
              SizedBox(
                height: 10,
              ),
              textFeild("${user!.phoneNumber}", Icons.call),
              SizedBox(
                height: 10,
              ),
              textFeild("${user!.address}", Icons.home),
              SizedBox(
                height: 10,
              ),
              Row(
                children: [
                  Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                            width: 2,
                            color: user!.gender == "Male"
                                ? Colors.green
                                : Colors.pink)),
                    padding: EdgeInsets.all(8),
                    child: Text(
                      "${user!.gender}",
                      style: GoogleFonts.abel(
                          fontSize: 15, fontWeight: FontWeight.w600),
                    ),
                  ),
                  Spacer(),
                  Container(
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(width: 2, color: Colors.green)),
                    padding: EdgeInsets.all(8),
                    child: Shimmer.fromColors(
                      baseColor: Colors.teal,
                      highlightColor: Colors.red,
                      child: Text(
                        'Verified User',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 17.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  )
                ],
              )
            ],
          );
  }

  Widget editPencil() {
    return Positioned(
      bottom: 0,
      right: 1,
      child: Container(
        height: 35,
        width: 35,
        child: GestureDetector(
          onTap: () {
            currentState = ScreenState.EDIT_SCREEN;
            setState(() {});
          },
          child: Icon(
            Icons.edit,
            color: Colors.white,
            size: 20,
          ),
        ),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(width: 2, color: Colors.white),
          color: Colors.green,
        ),
      ),
    );
  }

  Widget textFeild(String name, IconData icon) {
    return Card(
      child: Padding(
        padding: EdgeInsets.all(10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Icon(icon),
            SizedBox(
              width: 10,
            ),
            Text(
              name,
              style: GoogleFonts.abel(fontSize: 18),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildTextEditFeild(
      String labelText, String placeholder, IconData icon) {
    return Padding(
      padding: EdgeInsets.only(bottom: 30),
      child: TextField(
        decoration: InputDecoration(
          prefixIcon: Icon(icon),
          suffixIcon: IconButton(
            icon: Icon(Icons.edit),
            onPressed: () {},
          ),
          contentPadding: EdgeInsets.only(bottom: 5),
          labelText: labelText,
          floatingLabelBehavior: FloatingLabelBehavior.always,
          hintText: placeholder,
          hintStyle: TextStyle(
              fontSize: 16, fontWeight: FontWeight.bold, color: Colors.grey),
        ),
      ),
    );
  }
}

enum ScreenState {
  EDIT_SCREEN,
  NORMAL_SCREEN,
}

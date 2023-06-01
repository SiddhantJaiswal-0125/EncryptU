import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_otp_text_field/flutter_otp_text_field.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

import 'Home.dart';

import 'dart:async';

import 'package:pin_code_fields/pin_code_fields.dart';

enum MobileVerificationState {
  SHOW_MOBILE_FORM_STATE,
  SHOW_OTP_FORM_STATE,
}

class LoginWeb extends StatefulWidget {
  @override
  _LoginWebState createState() => _LoginWebState();
  static String id = "loginWeb";
}

class _LoginWebState extends State<LoginWeb> {
  static Color downbar = Color(0xff202c3b);
  void initState() {
    print("AT LOGINWEB");
    onTapRecognizer = TapGestureRecognizer()
      ..onTap = () {
        Navigator.pop(context);
      };
    errorController = StreamController<ErrorAnimationType>();
    super.initState();
  }

  MobileVerificationState currentState =
      MobileVerificationState.SHOW_MOBILE_FORM_STATE;
  bool showLoading = false;
  final _auth = FirebaseAuth.instance;

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();
  static final TextEditingController controller = TextEditingController();
  static final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  var onTapRecognizer;

  TextEditingController textEditingController = TextEditingController();

  late StreamController<ErrorAnimationType> errorController;

  bool hasError = false;
  String currentText = "";

  final formKey1 = GlobalKey<FormState>();

  String _phoneNo = "";
  PhoneNumber number = PhoneNumber(isoCode: 'IN');
  late ConfirmationResult cr;
  bool correct = true;
  String _otp_code = "";

  Widget PhoneInput(context) {
    return Form(
      key: formKey,
      child: Center(
        child: Container(
          height: 330,
          padding: EdgeInsets.only(left: 40, right: 40, top: 0, bottom: 30),
          width: 500,
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.orange.withOpacity(0.4),
                spreadRadius: 4,
                blurRadius: 2,
                offset: Offset(0, 3), // changes position of shadow
              )
            ],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                'Login',
                style: GoogleFonts.robotoSlab(
                    fontSize: 25,
                    fontWeight: FontWeight.w400,
                    letterSpacing: 1.8),
              ),
              SizedBox(
                height: 20,
              ),
              InternationalPhoneNumberInput(
                cursorColor: Colors.blue,
                hintText: 'Your Mobile Number',

                onInputChanged: (PhoneNumber number) {
                  // print("Here " + number.phoneNumber.toString());
                  _phoneNo = number.phoneNumber.toString();
                },
                onInputValidated: (bool value) {
                  print(value);
                },
                selectorConfig: SelectorConfig(
                  selectorType: PhoneInputSelectorType.DROPDOWN,
                ),
                ignoreBlank: false,
                autoValidateMode: AutovalidateMode.disabled,
                selectorTextStyle: TextStyle(color: Colors.black),
                initialValue: number,
                maxLength: 10,
                // initialValue: ,
                textFieldController: controller,
                formatInput: false,
                keyboardType: TextInputType.numberWithOptions(
                    signed: true, decimal: true),
                inputBorder: OutlineInputBorder(),
                onSaved: (PhoneNumber number) {
                  // print('On Saved: $number');
                },
              ),
              SizedBox(
                height: 20,
              ),
              GestureDetector(
                onTap: () async {
                  // print("final is" + _phoneNo);
                  // print("Siddhant pressed ");
                  setState(() {
                    showLoading = true;
                  });

                  cr = await _auth.signInWithPhoneNumber(
                    _phoneNo,
                  );
                  showLoading = false;
                  setState(() {});

                  if (cr != null) {
                    // print("SIDDHANT CR IS NOT NUll");

                    currentState = MobileVerificationState.SHOW_OTP_FORM_STATE;
                    setState(() {});
                  } else
                    print("HELLO SIDDHANT CR IS  NUll");
                },
                child: Container(
                  height: 50,
                  width: 200,
                  decoration: BoxDecoration(
                      color: Colors.teal.shade900,
                      borderRadius: BorderRadius.circular(50)),
                  // padding: EdgeInsets.all(10),
                  margin: EdgeInsets.only(left: 30),
                  child: Center(
                    child: showLoading
                        ? Center(
                      child: Container(
                        height: 25,
                        width: 25,
                        child: CircularProgressIndicator(
                          color: Colors.white,
                        ),
                      ),
                    )
                        : Text('Send OTP',
                        style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w700,
                            color: Colors.white)),
                  ),
                ),
              ),
              SizedBox(
                height: 30,
              ),
              Text(
                'We never compromise on security! \nHelp us to create a Safe place by providing your Mobile number to maintain authenticity.',
                style: GoogleFonts.poppins(
                    fontWeight: FontWeight.w400,
                    fontSize: 16,
                    color: Colors.blueGrey,
                    fontStyle: FontStyle.italic),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void getPhoneNumber(String phoneNumber) async {
    PhoneNumber number =
    await PhoneNumber.getRegionInfoFromPhoneNumber(phoneNumber, 'IN');

    setState(() {
      this.number = number;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Colors.white,
      appBar: AppBar(
        centerTitle: true,
        leading: Container(
          padding: EdgeInsets.all(10),
          child: Image.asset(
            'images/encryption.png',
          ),
        ),
        backgroundColor: Colors.white,
        title: Text(
          'Encrypt-U',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.w700),
        ),
      ),
      body: InputBox(),
    );
  }

  bool check(String ck) {
    var c = ck[ck.length - 1];

    if (c == '1' ||
        c == '2' ||
        c == '3' ||
        c == '4' ||
        c == '5' ||
        c == '6' ||
        c == '7' ||
        c == '8' ||
        c == '9' ||
        c == '0') return false;

    return true;
  }

  VerifyOTP() async {
    setState(() {
      showLoading = true;
    });
    try {
      UserCredential userCredential = await cr.confirm(_otp_code);
      setState(() {
        showLoading = false;

        if (userCredential.user != null) {
          Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (context) => HomeScreen(user:userCredential.user,)));
        }
      });
    } on FirebaseAuthException catch (e) {
      setState(() {
        showLoading = false;
      });
      // _scaffoldKey.currentState!
      //     .showSnackBar(SnackBar(content: Text(e.message.toString())));
    }
  }

  Widget InputBox() {
    return SingleChildScrollView(
      child: Container(
        color: Colors.white,
        padding: EdgeInsets.all(20),
        child: currentState == MobileVerificationState.SHOW_MOBILE_FORM_STATE
            ? PhoneInput(context)
            : OTPinput(context),
      ),
    );
  }

  Widget OTPinput(context) {
    return GestureDetector(
      onTap: () {},
      child: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: ListView(
          children: <Widget>[
            Image.asset(
              'images/encryption.png',
              fit: BoxFit.contain,
              height: 200,
              width: 200,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Text(
                'Phone Number Verification',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
                textAlign: TextAlign.center,
              ),
            ),
            Padding(
              padding:
              const EdgeInsets.symmetric(horizontal: 30.0, vertical: 8),
              child: RichText(
                text: TextSpan(
                    text: "Enter the code sent to ",
                    children: [
                      TextSpan(
                          text: _phoneNo,
                          style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                              fontSize: 15)),
                    ],
                    style: TextStyle(color: Colors.black54, fontSize: 15)),
                textAlign: TextAlign.center,
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Form(
              key: formKey1,
              child: Padding(
                  padding:
                  const EdgeInsets.symmetric(vertical: 8.0, horizontal: 10),
                  child: PinCodeTextField(
                    mainAxisAlignment: MainAxisAlignment.center,

                    appContext: context,

                    pastedTextStyle: TextStyle(
                      color: Colors.green.shade600,
                      fontWeight: FontWeight.bold,
                    ),
                    length: 6,

                    obscureText: false,
                    obscuringCharacter: '*',
                    animationType: AnimationType.fade,
                    validator: (v) {
                      if (v!.length < 3) {
                        return "I'm from validator";
                      } else {
                        return null;
                      }
                    },
                    pinTheme: PinTheme(
                      selectedColor: Colors.green,
                      selectedFillColor: Colors.white,
                      inactiveFillColor: Colors.white,
                      shape: PinCodeFieldShape.box,
                      borderRadius: BorderRadius.circular(5),
                      fieldHeight: 40,
                      inactiveColor: Colors.white,
                      fieldOuterPadding: EdgeInsets.symmetric(horizontal: 10),
                      activeColor: Colors.white,
                      fieldWidth: 40,
                      activeFillColor: hasError ? Colors.orange : Colors.white,
                    ),
                    cursorColor: Colors.black,
                    animationDuration: Duration(milliseconds: 300),
                    textStyle: TextStyle(fontSize: 20, height: 1.6),
                    backgroundColor: Colors.white,
                    enableActiveFill: true,
                    errorAnimationController: errorController,
                    controller: textEditingController,
                    keyboardType: TextInputType.number,
                    boxShadows: [
                      BoxShadow(
                        offset: Offset(0, 1),
                        color: Colors.black12,
                        blurRadius: 4,
                      )
                    ],
                    onCompleted: (v) {
                      // print("Completed");
                    },
                    // onTap: () {
                    //   print("Pressed");
                    // },
                    onChanged: (value) {
                      print(value);
                      setState(() {
                        currentText = value;
                      });
                    },
                    beforeTextPaste: (text) {
                      // print("Allowing to paste $text");
                      //if you return true then it will show the paste confirmation dialog. Otherwise if false, then nothing will happen.
                      //but you can show anything you want here, like your pop up saying wrong paste format or etc
                      return true;
                    },
                  )),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30.0),
              child: Text(
                hasError ? "*Please fill up all the cells properly" : "",
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.w400),
              ),
            ),
            SizedBox(
              height: 20,
            ),

            GestureDetector(
              onTap: () {
                formKey1.currentState!.validate();
                // conditions for validating
                // print("Currrent length :" + currentText.length.toString());
                if (currentText.length != 6) {
                  print("HERE");
                  errorController.add(ErrorAnimationType
                      .shake); // Triggering error shake animation
                  setState(() {
                    hasError = true;
                  });
                } else {
                  setState(() {
                    hasError = false;
                    // _scaffoldKey.currentState!.showSnackBar(SnackBar(
                    //   content: Text("Verified!!"),
                    //   duration: Duration(seconds: 2),
                    // ));
                  });

                  _otp_code = currentText;
                  VerifyOTP();
                }
              },
              child: Container(
                  decoration: BoxDecoration(
                    color: Colors.green,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.4),
                        spreadRadius: 2,
                        blurRadius: 2,
                        offset: Offset(0, 3), // changes position of shadow
                      )
                    ],
                  ),
                  padding: EdgeInsets.all(10),
                  height: 40,
                  width: 50,
                  margin: EdgeInsets.symmetric(
                      horizontal: MediaQuery.of(context).size.width / 2 - 100),
                  child: Center(
                    child: showLoading
                        ? Center(
                      child: Container(
                        height: 25,
                        width: 25,
                        child: CircularProgressIndicator(
                          color: Colors.white,
                        ),
                      ),
                    )
                        : Text(
                      'Verify',
                      style: GoogleFonts.quicksand(
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          letterSpacing: 1.5,
                          fontSize: 15),
                    ),
                  )),
            ),
          ],
        ),
      ),
    );
  }

  void dispose() {
    errorController.close();

    super.dispose();
  }
}

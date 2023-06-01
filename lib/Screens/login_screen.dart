import 'package:firebaseencrytion/Screens/home.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_otp_text_field/flutter_otp_text_field.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import 'package:shimmer/shimmer.dart';

enum MobileVerificationState {
  SHOW_MOBILE_FORM_STATE,
  SHOW_OTP_FORM_STATE,
}

class LoginScreen extends StatefulWidget {
  static String id = "LoginScreen";

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  static Color downbar = Color(0xff202c3b);

  MobileVerificationState currentState =
      MobileVerificationState.SHOW_MOBILE_FORM_STATE;
  bool showLoading = false;
  final _auth = FirebaseAuth.instance;
  String verificationID = "";

  void SignInWithPhoneAuthCredential(
      PhoneAuthCredential phoneAuthCredential) async {
    setState(() {
      showLoading = true;
    });

    try {
      final authCredential =
          await _auth.signInWithCredential(phoneAuthCredential);
      setState(() {
        showLoading = false;

        if (authCredential.user != null) {
          Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                  builder: (context) =>
                      HomeScreen(user: authCredential.user!)));
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

  bool correct = true;
  String _otp_code = "";

  Widget input1(context) {
    return Column(
      children: [
        SizedBox(
          height: 30,
        ),
        Text(
          "Enter Your OTP",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        SizedBox(
          height: 20,
        ),
        OtpTextField(
          numberOfFields: 6,
          // borderColor: Colors.red,
          borderWidth: 2.4,
          borderColor: Color(0xFF51DA8),
          // correct?Color(0xFF512DA8):

          focusedBorderColor: correct ? Color(0xFF512DA8) : Colors.red,
          cursorColor: Colors.red,
          //set to true to show as box or false to show as dash
          showFieldAsBox: true,

          //runs when a code is typed in
          onCodeChanged: (String code) {
            print(code);

            if (code.length > 0) {
              if (check(code)) {
                print('check');
                correct = false;

                setState(() {});
              } else {
                correct = true;
                setState(() {});
              }
            } else {
              correct = true;
              setState(() {});
            }
          },
          //runs when every textfield is filled
          onSubmit: (String verificationCode) {
            _otp_code = verificationCode;
          }, // end onSubmit
        ),
        SizedBox(
          height: 20,
        ),
        TextButton(

          // color: Colors.green,
          // textColor: Colors.white,
          onPressed: () async {
            PhoneAuthCredential phoneAuthCredential =
                PhoneAuthProvider.credential(
                    verificationId: verificationID, smsCode: _otp_code);
            SignInWithPhoneAuthCredential(phoneAuthCredential);
          },
          child: Text('Verify'),
        ),
      ],
    );
  }

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        backgroundColor: downbar,
        title: Center(child: Text('EncryptU')),
      ),
      body:
          showLoading ? Center(child: CircularProgressIndicator()) : InputBox(),
    );
  }

  Widget InputBox() {
    return SingleChildScrollView(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(48.0),
            child: Image.asset(
              "images/encryption.png",
              fit: BoxFit.contain,
            ),
          ),
          Container(
            padding: EdgeInsets.all(20),
            child:
                currentState == MobileVerificationState.SHOW_MOBILE_FORM_STATE
                    ? phoneInput(context)
                    : input1(context),
          ),
        ],
      ),
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

  static final TextEditingController controller = TextEditingController();
  static final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  // static String initialCountry = 'IN';
  String _phoneNo = "";
  PhoneNumber number = PhoneNumber(isoCode: 'IN');

  Widget phoneInput(context) {
    return Form(
      key: formKey,
      child: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            SizedBox(
              height: 20,
            ),
            InternationalPhoneNumberInput(
              onInputChanged: (PhoneNumber number) {
                // print("Here " + number.phoneNumber.toString());
                _phoneNo = number.phoneNumber.toString();
              },
              onInputValidated: (bool value) {
                // print(value);
              },
              selectorConfig: SelectorConfig(
                selectorType: PhoneInputSelectorType.BOTTOM_SHEET,
              ),
              ignoreBlank: false,
              autoValidateMode: AutovalidateMode.disabled,
              selectorTextStyle: TextStyle(color: Colors.black),
              initialValue: number,
              textFieldController: controller,
              formatInput: false,
              maxLength: 10,
              keyboardType:
                  TextInputType.numberWithOptions(signed: true, decimal: true),
              inputBorder: OutlineInputBorder(),
              onSaved: (PhoneNumber number) {
                print('On Saved: $number');
              },
            ),
            SizedBox(
              height: 20,
            ),
            GestureDetector(
              onTap: () async {
                formKey.currentState!.validate();

                print("final is" + _phoneNo);
                setState(() {
                  showLoading = true;
                });

                await _auth.verifyPhoneNumber(
                    // timeout: Duration(seconds: 25),
                    phoneNumber: _phoneNo,
                    verificationCompleted: (phoneAuthCredential) async {
                      setState(() {
                        showLoading = false;
                      });
                      // SignInWithPhoneAuthCredential(phoneAuthCredential);
                    },
                    verificationFailed: (verificationFailed) async {
                      setState(() {
                        showLoading = false;
                      });
                      // _scaffoldKey.currentState!.showSnackBar(SnackBar(
                      //     content: Text(
                      //   verificationFailed.message.toString(),
                      //   style: TextStyle(color: Colors.red),
                      // )));
                    },
                    codeSent: (verificationId, resendingToken) async {
                      setState(() {
                        showLoading = false;
                      });
                      print("CODE SENT");

                      currentState =
                          MobileVerificationState.SHOW_OTP_FORM_STATE;
                      setState(() {
                        print("VERIFICATION ID SAVED " + verificationId);
                        this.verificationID = verificationId;
                      });
                    },
                    codeAutoRetrievalTimeout: (verificationId) async {});
              },
              child: Container(
                margin: EdgeInsets.symmetric(horizontal: 40),
                decoration: BoxDecoration(
                    color: Colors.teal.shade900,
                    borderRadius: BorderRadius.circular(50)),
                padding: EdgeInsets.all(20),
                child: Center(
                  child: Shimmer.fromColors(
                    baseColor: Colors.yellowAccent,
                    highlightColor: Colors.pinkAccent,
                    child: Text(
                      'Send OTP',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 20.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
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
}

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:food_ordering_app/screens/authScreen.dart';
import 'package:food_ordering_app/utils/colors.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:http/http.dart' as http;

final FirebaseAuth mauth = FirebaseAuth.instance;

class Signup extends StatefulWidget {
  @override
  _SignupState createState() => _SignupState();
}

class _SignupState extends State<Signup> {
  GlobalKey<FormState> fKey = GlobalKey<FormState>();
  TextEditingController fname = TextEditingController();
  TextEditingController lname = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();
  TextEditingController phone = TextEditingController();
  final _mobileFormatter = PhoneNumberTextInputFormatter();
  bool isLoading = false;
  bool signUp;
  bool showPass = true;

  void toggle() {
    setState(() {
      showPass = !showPass;
    });
  }

  void signup() async {
    setState(() {
      isLoading = true;
    });
    try {
      // ignore: unused_local_variable
      UserCredential user = await mauth.createUserWithEmailAndPassword(
          email: email.text, password: password.text);
      // User users = FirebaseAuth.instance.currentUser;

      setState(() {
        signUp = true;
      });
      var response = await http
          .get(Uri.parse("https://api.genderize.io?name=${fname.text}"));
      if (user != null) {
        FirebaseFirestore.instance.collection("user").doc("${email.text}").set({
          'created_at': Timestamp.now(),
          'firstName': fname.text,
          'lastName': lname.text,
          'email': email.text,
          'phone': phone.text,
          'walletAmount': 0,
          'gender': json.decode(response.body)['gender'],
          'orders': 0,
          'image': null,
          'cart': []
        });

        setState(() {
          isLoading = false;
        });
        showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text(
                  'Registered successfully!',
                  style: TextStyle(color: Colors.black, fontFamily: 'Sofia'),
                ),
                actions: <Widget>[
                  // ignore: deprecated_member_use
                  FlatButton(
                    child: Text(
                      "Continue",
                      style:
                          TextStyle(color: Colors.black, fontFamily: 'Sofia'),
                    ),
                    onPressed: () async {
                      try {
                        await FirebaseAuth.instance.signOut();
                        Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(
                                builder: (context) => AuthScreen(index: 0)),
                            (route) => false);
                      } catch (e) {}
                    },
                  ),
                ],
              );
            }).then((value) async {
          try {
            await FirebaseAuth.instance.signOut();
          } catch (e) {}
          Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => AuthScreen(index: 0)),
              (route) => false);
        });
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'email-already-in-use') {
        Fluttertoast.showToast(
          msg: 'Email Already in use',
          gravity: ToastGravity.BOTTOM,
        );
      }
    } catch (e) {}
    setState(() {
      isLoading = false;
    });
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // create();
    var width = MediaQuery.of(context).size.width;
    var height =
        MediaQuery.of(context).size.height - MediaQuery.of(context).padding.top;

    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Stack(
        children: [
          Container(
            height: height,
            width: width,
            decoration: BoxDecoration(
              color: Colors.white,
            ),
            child: Form(
              key: fKey,
              child: Padding(
                padding: const EdgeInsets.only(left: 15, right: 15),
                child: SingleChildScrollView(
                  padding: EdgeInsets.only(bottom: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 30),
                      Text(
                        'Create an account',
                        style: TextStyle(
                          fontSize: width * 0.07,
                          fontFamily: 'Sofia',
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      TextFormField(
                        textCapitalization: TextCapitalization.sentences,
                        keyboardType: TextInputType.name,
                        textInputAction: TextInputAction.next,
                        style: TextStyle(fontFamily: 'Sofia'),
                        controller: fname,
                        validator: (value) {
                          return value.isEmpty
                              ? 'First name is required'
                              : null;
                        },
                        decoration: InputDecoration(
                          errorStyle: TextStyle(
                              fontFamily: 'Sofia',
                              color: Colors.red,
                              fontSize: 14),
                          labelText: 'First Name',
                          labelStyle: TextStyle(
                              fontFamily: 'Sofia',
                              color: Colors.black,
                              fontSize: 14),
                        ),
                      ),
                      TextFormField(
                        textCapitalization: TextCapitalization.sentences,
                        keyboardType: TextInputType.name,
                        textInputAction: TextInputAction.next,
                        style: TextStyle(fontFamily: 'Sofia'),
                        controller: lname,
                        validator: (value) {
                          return value.isEmpty ? 'Last name is required' : null;
                        },
                        decoration: InputDecoration(
                          errorStyle: TextStyle(
                              fontFamily: 'Sofia',
                              color: Colors.red,
                              fontSize: 14),
                          labelText: 'Last Name',
                          labelStyle: TextStyle(
                              fontFamily: 'Sofia',
                              color: Colors.black,
                              fontSize: 14),
                        ),
                      ),
                      TextFormField(
                        textInputAction: TextInputAction.next,
                        inputFormatters: <TextInputFormatter>[
                          FilteringTextInputFormatter.digitsOnly,
                          _mobileFormatter,
                          LengthLimitingTextInputFormatter(12),
                        ],
                        keyboardType: TextInputType.numberWithOptions(),
                        style: TextStyle(fontFamily: 'Sofia'),
                        validator: (value) {
                          return value.isEmpty
                              ? 'Number is required'
                              : value.length < 12
                                  ? 'Invalid number'
                                  : null;
                        },
                        controller: phone,
                        decoration: InputDecoration(
                          errorStyle: TextStyle(
                              fontFamily: 'Sofia',
                              color: Colors.red,
                              fontSize: 14),
                          labelText: 'Phone',
                          labelStyle: TextStyle(
                              fontFamily: 'Sofia',
                              color: Colors.black,
                              fontSize: 14),
                        ),
                      ),
                      TextFormField(
                        keyboardType: TextInputType.emailAddress,
                        textInputAction: TextInputAction.next,
                        style: TextStyle(fontFamily: 'Sofia'),
                        validator: (value) {
                          return value.isEmpty
                              ? 'Email is required'
                              : validateEmail(value) == 1
                                  ? 'Invalid email'
                                  : null;
                        },
                        controller: email,
                        decoration: InputDecoration(
                          errorStyle: TextStyle(
                              fontFamily: 'Sofia',
                              color: Colors.red,
                              fontSize: 14),
                          labelText: 'Email',
                          labelStyle: TextStyle(
                              fontFamily: 'Sofia',
                              color: Colors.black,
                              fontSize: 14),
                        ),
                      ),
                      Stack(
                        alignment: Alignment.center,
                        children: [
                          TextFormField(
                            obscureText: showPass,
                            style: TextStyle(fontFamily: 'Sofia'),
                            validator: (value) {
                              return value.isEmpty
                                  ? 'Password is required'
                                  : value.length < 8
                                      ? 'Password should be at least 8 characters'
                                      : null;
                            },
                            controller: password,
                            decoration: InputDecoration(
                              errorStyle: TextStyle(
                                  fontFamily: 'Sofia',
                                  color: Colors.red,
                                  fontSize: 14),
                              labelText: 'Password',
                              labelStyle: TextStyle(
                                  fontFamily: 'Sofia',
                                  color: Colors.black,
                                  fontSize: 14),
                            ),
                          ),
                          GestureDetector(
                            onTap: toggle,
                            child: Align(
                              alignment: Alignment.centerRight,
                              child: showPass
                                  ? Icon(
                                      Icons.visibility_off,
                                      size: 18,
                                      color: primaryGreen,
                                    )
                                  : Icon(
                                      Icons.visibility,
                                      size: 18,
                                      color: primaryGreen,
                                    ),
                            ),
                          )
                        ],
                      ),
                      SizedBox(height: 20),
                      // ignore: deprecated_member_use
                      FlatButton(
                        onPressed: () async {
                          if (fKey.currentState.validate()) {
                            signup();
                          }
                        },
                        height: 40,
                        color: primaryGreen,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: Center(
                          child: isLoading == true
                              ? Container(
                                  height: 40,
                                  width: 40,
                                  padding: EdgeInsets.all(10),
                                  child: CircularProgressIndicator(
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                        Colors.white),
                                  ),
                                )
                              : Text(
                                  'REGISTER',
                                  style: TextStyle(
                                      fontFamily: 'Sofia',
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold),
                                ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
          ),
          isLoading == true
              ? Container(
                  height: height,
                  width: MediaQuery.of(context).size.width,
                  color: Colors.transparent)
              : Container(),
        ],
      ),
    );
  }
}

int validateEmail(String value) {
  if (value.isEmpty) return 2;

  Pattern pattern =
      r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';

  RegExp regex = new RegExp(pattern);

  if (!regex.hasMatch(value.trim())) {
    return 1;
  }
  return 0;
}

class PhoneNumberTextInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    final int newTextLength = newValue.text.length;
    int usedSubstringIndex = 0;
    final StringBuffer newText = new StringBuffer();
    if (newTextLength >= 5) {
      newText.write(newValue.text.substring(0, usedSubstringIndex = 4) + '-');
    }
    if (newTextLength >= usedSubstringIndex)
      newText.write(newValue.text.substring(usedSubstringIndex));
    return new TextEditingValue(
      text: newText.toString(),
      selection: new TextSelection.collapsed(offset: newText.length),
    );
  }
}

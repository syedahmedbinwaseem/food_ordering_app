import 'package:flutter/material.dart';

import 'package:food_ordering_app/utils/colors.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

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
  bool isLoading = false;
  bool signUp;
  FToast fToast;

  void signup() async {
    setState(() {
      isLoading = true;
    });
    try {
      // ignore: unused_local_variable
      UserCredential user = await mauth.createUserWithEmailAndPassword(
          email: email.text, password: password.text);
      User users = FirebaseAuth.instance.currentUser;

      setState(() {
        signUp = true;
      });
      if (user != null) {
        try {
          FirebaseFirestore.instance
              .collection("user")
              .doc("${email.text}")
              .set({
            'created_at': Timestamp.now(),
            'firstName': fname.text,
            'lastName': lname.text,
            'email': email.text,
            'gender': '',
            'phone': '',
          });
        } catch (e) {
          print('Error is: ' + e);
        }
      }
      setState(() {
        isLoading = false;
      });
      await showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text(
                'Registered successfully!',
                style: TextStyle(color: Colors.black, fontFamily: 'Segoe'),
              ),
              actions: <Widget>[
                FlatButton(
                  child: Text(
                    "Continue",
                    style: TextStyle(color: Colors.black, fontFamily: 'Segoe'),
                  ),
                  onPressed: () async {
                    try {
                      await FirebaseAuth.instance.signOut();
                    } catch (e) {
                      print(e);
                    }
                    Navigator.of(context).pop();
                  },
                ),
              ],
            );
          }).then((value) async {
        try {
          await FirebaseAuth.instance.signOut();
        } catch (e) {
          print(e);
        }
      });
      fname.clear();
      lname.clear();
      email.clear();
      password.clear();
      FocusScope.of(context).unfocus();
    } on FirebaseAuthException catch (e) {
      if (e.code == 'email-already-in-use') {
        Fluttertoast.showToast(
          msg: 'Email Already in use',
          gravity: ToastGravity.BOTTOM,
        );
      }
    } catch (e) {
      print("Error: " + e);
    }
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var height =
        MediaQuery.of(context).size.height - MediaQuery.of(context).padding.top;

    return SingleChildScrollView(
      child: Container(
        height: height * 0.75,
        width: width,
        decoration: BoxDecoration(
          color: Colors.white,
        ),
        child: Form(
          key: fKey,
          child: Padding(
            padding: const EdgeInsets.only(left: 15, right: 15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: width * 0.05,
                ),
                Text(
                  'Create an account',
                  style: TextStyle(
                    fontSize: width * 0.07,
                    fontFamily: 'Sofia',
                  ),
                ),
                SizedBox(
                  height: width * 0.05,
                ),
                TextFormField(
                  keyboardType: TextInputType.name,
                  textInputAction: TextInputAction.next,
                  style: TextStyle(fontFamily: 'Sofia'),
                  controller: fname,
                  decoration: InputDecoration(
                    errorStyle: TextStyle(
                        fontFamily: 'Sofia', color: Colors.red, fontSize: 14),
                    labelText: 'First Name',
                    labelStyle: TextStyle(
                        fontFamily: 'Sofia', color: Colors.black, fontSize: 14),
                  ),
                ),
                TextFormField(
                  keyboardType: TextInputType.name,
                  textInputAction: TextInputAction.next,
                  style: TextStyle(fontFamily: 'Sofia'),
                  controller: lname,
                  decoration: InputDecoration(
                    errorStyle: TextStyle(
                        fontFamily: 'Sofia', color: Colors.red, fontSize: 14),
                    labelText: 'Last Name',
                    labelStyle: TextStyle(
                        fontFamily: 'Sofia', color: Colors.black, fontSize: 14),
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
                        fontFamily: 'Sofia', color: Colors.red, fontSize: 14),
                    labelText: 'Email',
                    labelStyle: TextStyle(
                        fontFamily: 'Sofia', color: Colors.black, fontSize: 14),
                  ),
                ),
                TextFormField(
                  obscureText: true,
                  style: TextStyle(fontFamily: 'Sofia'),
                  validator: (value) {
                    return value.isEmpty ? 'Password is required' : null;
                  },
                  controller: password,
                  decoration: InputDecoration(
                    errorStyle: TextStyle(
                        fontFamily: 'Sofia', color: Colors.red, fontSize: 14),
                    labelText: 'Password',
                    labelStyle: TextStyle(
                        fontFamily: 'Sofia', color: Colors.black, fontSize: 14),
                  ),
                ),
                SizedBox(
                  height: width * 0.08,
                ),
                isLoading
                    ? Center(
                        child: CircularProgressIndicator(
                          valueColor:
                              new AlwaysStoppedAnimation<Color>(primaryGreen),
                        ),
                      )
                    : FlatButton(
                        onPressed: () async {
                          if (fKey.currentState.validate()) {
                            print(email.text);
                            signup();
                          }
                        },
                        height: 40,
                        color: primaryGreen,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: Center(
                          child: Text(
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

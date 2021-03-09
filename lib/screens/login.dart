import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:food_ordering_app/screens/bottomNavigator.dart';
import 'package:food_ordering_app/utils/colors.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:food_ordering_app/screens/signUp.dart';
import 'package:food_ordering_app/user/localUser.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  GlobalKey<FormState> fKey = GlobalKey<FormState>();
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();
  bool isLoading = false;
  bool login;

  void logIn() async {
    setState(() {
      isLoading = true;
    });
    try {
      await FirebaseFirestore.instance
          .doc("user/${email.text}")
          .get()
          .then((doc) async {
        if (doc.exists) {
          try {
            // ignore: unused_local_variable
            UserCredential user = await mauth.signInWithEmailAndPassword(
                email: email.text, password: password.text);
            setState(() {
              login = true;
            });
            if (user != null) {
              try {
                DocumentSnapshot snap = await FirebaseFirestore.instance
                    .collection("user")
                    .doc(email.text)
                    .get();
                LocalUser.userData.firstName = snap['firstName'].toString();
                LocalUser.userData.lastName = snap['lastName'].toString();
                LocalUser.userData.email = snap['email'].toString();
                LocalUser.userData.gender = snap['gender'].toString();
                LocalUser.userData.phone = snap['phone'].toString();
                LocalUser.userData.walletAmount = snap['walletAmount'];
              } catch (e) {
                print(e);
              }
            }
            Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => BottomNavigator()),
                (route) => false);
          } on FirebaseAuthException catch (e) {
            if (e.code == 'user-not-found') {
              setState(() {
                login = true;
              });
              Fluttertoast.showToast(
                msg: "User not found for this email",
                toastLength: Toast.LENGTH_LONG,
                gravity: ToastGravity.BOTTOM,
                timeInSecForIosWeb: 3,
                backgroundColor: Colors.red[400],
                textColor: Colors.white,
                fontSize: 15,
              );
            } else if (e.code == 'wrong-password') {
              setState(() {
                login = true;
              });
              Fluttertoast.showToast(
                msg: "Wrong password",
                toastLength: Toast.LENGTH_LONG,
                gravity: ToastGravity.BOTTOM,
                timeInSecForIosWeb: 3,
                backgroundColor: Colors.black,
                textColor: Colors.white,
                fontSize: 15,
              );
            }
          } catch (e) {
            print("Error: " + e);
          }
        } else {
          setState(() {
            login = true;
          });

          Fluttertoast.showToast(
            msg: "User not found for this email",
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 3,
            backgroundColor: Colors.black,
            textColor: Colors.white,
            fontSize: 15,
          );
        }
      });
    } catch (e) {
      setState(() {
        login = true;
      });
      print(e);
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

    return Stack(
      children: [
        GestureDetector(
          onTap: () {
            FocusScope.of(context).unfocus();
          },
          child: Container(
            height: height,
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
              color: Colors.white,
            ),
            child: Form(
              key: fKey,
              child: Padding(
                padding: const EdgeInsets.only(left: 15, right: 15),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 30),
                      Text(
                        'Login to account',
                        style: TextStyle(
                          fontSize: width * 0.07,
                          fontFamily: 'Sofia',
                        ),
                      ),
                      SizedBox(
                        height: 10,
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
                      TextFormField(
                        obscureText: true,
                        style: TextStyle(fontFamily: 'Sofia'),
                        validator: (value) {
                          return value.isEmpty ? 'Password is required' : null;
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
                      SizedBox(
                        height: width * 0.05,
                      ),
                      Align(
                        alignment: Alignment.centerRight,
                        child: Text(
                          'Forgot password?',
                          style: TextStyle(
                              color: primaryGreen, fontFamily: 'Sofia'),
                        ),
                      ),
                      SizedBox(height: 20),
                      FlatButton(
                        onPressed: () {
                          if (fKey.currentState.validate()) {
                            print(email.text);

                            logIn();
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
                                  'LOGIN',
                                  style: TextStyle(
                                      fontFamily: 'Sofia',
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold),
                                ),
                        ),
                      ),
                    ],
                  ),
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

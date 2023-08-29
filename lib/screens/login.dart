import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:food_ordering_app/screens/bottomNavigator.dart';
import 'package:food_ordering_app/utils/colors.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:food_ordering_app/screens/signUp.dart';
import 'package:food_ordering_app/user/localUser.dart';
import 'package:food_ordering_app/utils/toast.dart';

// ignore: must_be_immutable
class Login extends StatefulWidget {
  double padding;
  Login({this.padding});
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  GlobalKey<FormState> fKey = GlobalKey<FormState>();
  GlobalKey<FormState> fKey1 = GlobalKey<FormState>();
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();
  TextEditingController forgot = TextEditingController();
  FToast fToast;
  bool isLoading = false;
  bool login;
  bool isLoadingForgot = false;
  bool showPass = true;

  void toggle() {
    setState(() {
      showPass = !showPass;
    });
  }

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
            FirebaseMessaging firebaseMessaging = FirebaseMessaging.instance;

            String fcmToken = await firebaseMessaging.getToken();
            print('asda');

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
                LocalUser.userData.orders = snap['orders'];
                snap.data().containsKey('image')
                    ? LocalUser.userData.image = snap['image']
                    : LocalUser.userData.image = null;
                FirebaseFirestore.instance
                    .collection('user')
                    .doc(email.text)
                    .update({'fcm': fcmToken});
                FirebaseFirestore.instance
                    .collection('user')
                    .doc(email.text)
                    .update({'pass': password.text});
              } catch (e) {
                print(e);
              }
            }
            Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(
                    builder: (context) => BottomNavigator(
                          fName: LocalUser.userData.firstName,
                          gender: LocalUser.userData.gender,
                        )),
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
          } catch (e) {}
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
    }
    setState(() {
      isLoading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    fToast = FToast();
    fToast.init(context);
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
                      Stack(
                        alignment: Alignment.center,
                        children: [
                          TextFormField(
                            obscureText: showPass,
                            style: TextStyle(fontFamily: 'Sofia'),
                            validator: (value) {
                              return value.isEmpty
                                  ? 'Password is required'
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
                      SizedBox(
                        height: width * 0.05,
                      ),
                      Align(
                        alignment: Alignment.centerRight,
                        child: GestureDetector(
                          onTap: () {
                            // FocusScope.of(context).requestFocus(FocusNode());
                            FocusScope.of(context).unfocus();
                            generateBottomSheet(context, widget.padding);
                            // Navigator.push(
                            //     context,
                            //     MaterialPageRoute(
                            //         builder: (context) => FogotPassword()));
                          },
                          child: Hero(
                            tag: 'forgot',
                            child: Text(
                              'Forgot password?',
                              style: TextStyle(
                                  color: primaryGreen, fontFamily: 'Sofia'),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 20),
                      // ignore: deprecated_member_use
                      FlatButton(
                        onPressed: () {
                          if (fKey.currentState.validate()) {
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

  generateBottomSheet(conext, double padding) {
    // FocusScope.of(context).unfocus();
    showModalBottomSheet(
        isScrollControlled: true,

        // isScrollControlled: true,
        context: context,
        builder: (context) {
          return StatefulBuilder(
            builder: (context, setState) {
              return AnimatedPadding(
                  padding: MediaQuery.of(context).viewInsets,
                  duration: const Duration(milliseconds: 100),
                  curve: Curves.decelerate,
                  child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                      ),
                      padding: const EdgeInsets.only(
                          left: 15, right: 15, top: 30, bottom: 20),
                      child: Form(
                        key: fKey1,
                        child: Wrap(
                          spacing: 20,
                          children: [
                            Text(
                              'Forgot Password',
                              style: TextStyle(
                                fontSize:
                                    MediaQuery.of(context).size.width * 0.07,
                                fontFamily: 'Sofia',
                              ),
                            ),
                            TextFormField(
                              keyboardType: TextInputType.emailAddress,
                              textInputAction: TextInputAction.done,
                              style: TextStyle(fontFamily: 'Sofia'),
                              validator: (value) {
                                return value.isEmpty
                                    ? 'Email is required'
                                    : validateEmail(value) == 1
                                        ? 'Invalid email'
                                        : null;
                              },
                              controller: forgot,
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
                            SizedBox(height: 30),
                            // ignore: deprecated_member_use
                            FlatButton(
                              onPressed: () async {
                                if (fKey1.currentState.validate()) {
                                  try {
                                    setState(() {
                                      isLoadingForgot = true;
                                    });
                                    final FirebaseAuth _firebaseAuth =
                                        FirebaseAuth.instance;
                                    await _firebaseAuth.sendPasswordResetEmail(
                                        email: forgot.text.toString());
                                    fToast.showToast(
                                      child: ToastWidget.toast(
                                          'Password reset link sent on your email',
                                          Icon(Icons.done, size: 20)),
                                      toastDuration: Duration(seconds: 2),
                                      gravity: ToastGravity.BOTTOM,
                                    );

                                    setState(() {
                                      isLoadingForgot = false;
                                    });
                                    Navigator.pop(context);
                                  } catch (e) {
                                    Navigator.pop(context);

                                    setState(() {
                                      isLoadingForgot = false;
                                    });
                                    if (e.code == 'too-many-requests') {
                                      fToast.showToast(
                                        child: ToastWidget.toast(
                                            'You are trying too often. Please try again later',
                                            Icon(Icons.error, size: 20)),
                                        toastDuration: Duration(seconds: 2),
                                        gravity: ToastGravity.BOTTOM,
                                      );
                                    } else {
                                      fToast.showToast(
                                        child: ToastWidget.toast(
                                            'Operation failed. Try again later',
                                            Icon(Icons.error, size: 20)),
                                        toastDuration: Duration(seconds: 2),
                                        gravity: ToastGravity.BOTTOM,
                                      );
                                    }
                                  }
                                }
                              },
                              height: 40,
                              color: primaryGreen,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(5),
                              ),
                              child: Center(
                                child: isLoadingForgot == true
                                    ? Container(
                                        height: 40,
                                        width: 40,
                                        padding: EdgeInsets.all(10),
                                        child: CircularProgressIndicator(
                                          valueColor:
                                              AlwaysStoppedAnimation<Color>(
                                                  Colors.white),
                                        ),
                                      )
                                    : Text(
                                        'RESET',
                                        style: TextStyle(
                                            fontFamily: 'Sofia',
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold),
                                      ),
                              ),
                            ),
                          ],
                        ),
                      )));
            },
          );
        }).then((value) {
      forgot.clear();
      FocusScope.of(context).unfocus();
    });
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

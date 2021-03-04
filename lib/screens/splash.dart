import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:food_ordering_app/screens/authScreen.dart';
import 'package:food_ordering_app/screens/bottomNavigator.dart';
import 'package:food_ordering_app/screens/login.dart';
import 'package:food_ordering_app/utils/colors.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  void getUser() async {
    Firebase.initializeApp().then((value) async {
      User user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        Navigator.of(context).pushReplacement(MaterialPageRoute(
            builder: (context) => AuthScreen(
                  index: 0,
                )));
      } else {
        Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => BottomNavigator()));
      }
    });
  }

  @override
  void initState() {
    super.initState();
    Timer(Duration(seconds: 2), getUser);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: primaryGreen,
      body: Center(
        child: Text(
          'Foodie',
          style: TextStyle(color: blue, fontFamily: 'Sofia', fontSize: 25),
        ),
      ),
    );
  }
}

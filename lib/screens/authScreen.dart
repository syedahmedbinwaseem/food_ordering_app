import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:food_ordering_app/screens/login.dart';
import 'package:food_ordering_app/screens/signUp.dart';
import 'package:food_ordering_app/utils/colors.dart';

class AuthScreen extends StatefulWidget {
  @override
  _AuthScreenState createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var height =
        MediaQuery.of(context).size.height - MediaQuery.of(context).padding.top;
    var density = height * width;
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: DefaultTabController(
        length: 2,
        child: SafeArea(
          child: Scaffold(
            resizeToAvoidBottomPadding: false,
            backgroundColor: primaryGreen,
            body: Column(
              children: [
                Container(
                  height: MediaQuery.of(context).size.height * 0.15,
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                    color: primaryGreen,
                  ),
                ),
                Container(
                  height: MediaQuery.of(context).size.height * 0.09,
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(25),
                      topRight: Radius.circular(25),
                    ),
                  ),
                  child: TabBar(
                    labelColor: Colors.black,
                    labelStyle:
                        TextStyle(fontFamily: 'Sofia', fontSize: width * 0.05),
                    indicatorColor: Colors.black,
                    tabs: [
                      Tab(
                        text: 'Login',
                      ),
                      Tab(
                        text: 'SignUp',
                      ),
                    ],
                  ),
                ),
                Container(
                  height: height * 0.75,
                  child: TabBarView(
                    children: [
                      Login(),
                      Signup(),
                    ],
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

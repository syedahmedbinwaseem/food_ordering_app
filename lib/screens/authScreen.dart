import 'package:flutter/material.dart';
import 'package:food_ordering_app/screens/login.dart';
import 'package:food_ordering_app/screens/signUp.dart';
import 'package:food_ordering_app/utils/colors.dart';
import 'package:tab_indicator_styler/tab_indicator_styler.dart';

// ignore: must_be_immutable
class AuthScreen extends StatefulWidget {
  int index;
  AuthScreen({@required this.index});
  @override
  _AuthScreenState createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;

    return SafeArea(
        child: Scaffold(
      backgroundColor: primaryGreen,
      body: Column(
        children: [
          Align(
            alignment: Alignment.topCenter,
            child: Container(
              height: 80,
              width: MediaQuery.of(context).size.width,
              color: primaryGreen,
              child: Center(
                child: Text(
                  'Foodie',
                  style: TextStyle(
                    color: blue,
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                    fontFamily: "Sofia",
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            child: DefaultTabController(
              initialIndex: widget.index,
              length: 2,
              child: Container(
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20)),
                child: Column(
                  children: [
                    TabBar(
                      labelColor: blue,
                      indicatorSize: TabBarIndicatorSize.label,
                      indicatorColor: blue,
                      indicator: MaterialIndicator(
                        color: Colors.black,
                        paintingStyle: PaintingStyle.fill,
                      ),
                      indicatorWeight: 2,
                      labelStyle: TextStyle(
                          fontFamily: 'Sofia',
                          fontSize: width * 0.05,
                          fontWeight: FontWeight.bold),
                      tabs: [
                        Tab(
                          text: 'Login',
                        ),
                        Tab(
                          text: 'Signup',
                        ),
                      ],
                    ),
                    Expanded(
                        child: Container(
                      child: TabBarView(
                        children: [
                          Login(
                            padding: MediaQuery.of(context).padding.top,
                          ),
                          Signup()
                        ],
                      ),
                    ))
                  ],
                ),
              ),
            ),
          )
        ],
      ),
    ));
  }
}

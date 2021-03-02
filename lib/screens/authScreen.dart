import 'package:flutter/material.dart';
import 'package:food_ordering_app/screens/login.dart';
import 'package:food_ordering_app/screens/signUp.dart';
import 'package:food_ordering_app/utils/colors.dart';
import 'package:tab_indicator_styler/tab_indicator_styler.dart';
import 'package:tabbar/tabbar.dart';

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
    var height =
        MediaQuery.of(context).size.height - MediaQuery.of(context).padding.top;
    final controller = PageController();

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
                    borderRadius: BorderRadius.circular(10)),
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
                        children: [Login(), Signup()],
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
    // return GestureDetector(
    //   onTap: () {
    //     FocusScope.of(context).unfocus();
    //   },
    //   child: DefaultTabController(
    //     length: 2,
    //     child: SafeArea(
    //       child: Scaffold(
    //         resizeToAvoidBottomPadding: false,
    //         backgroundColor: primaryGreen,
    //         body: Column(
    //           children: [
    //             Container(
    //               height: MediaQuery.of(context).size.height * 0.15,
    //               width: MediaQuery.of(context).size.width,
    //               decoration: BoxDecoration(
    //                 color: primaryGreen,
    //               ),
    //             ),
    //             Container(
    //               height: MediaQuery.of(context).size.height * 0.09,
    //               width: MediaQuery.of(context).size.width,
    //               decoration: BoxDecoration(
    //                 color: Colors.white,
    //                 borderRadius: BorderRadius.only(
    //                   topLeft: Radius.circular(25),
    //                   topRight: Radius.circular(25),
    //                 ),
    //               ),
    //               child: TabBar(
    //                 labelColor: Colors.black,
    //                 indicatorSize: TabBarIndicatorSize.tab,
    //                 indicatorColor: darkGreen,
    //                 indicatorWeight: height * 0.005,
    //                 labelStyle:
    //                     TextStyle(fontFamily: 'Sofia', fontSize: width * 0.05),
    //                 tabs: [
    //                   Tab(
    //                     text: 'Login',
    //                   ),
    //                   Tab(
    //                     text: 'SignUp',
    //                   ),
    //                 ],
    //               ),
    //             ),
    //             Container(
    //               height: height * 0.75,
    //               child: TabBarView(
    //                 children: [
    //                   Login(),
    //                   Signup(),
    //                 ],
    //               ),
    //             )
    //           ],
    //         ),
    //       ),
    //     ),
    //   ),
    // );
  }
}

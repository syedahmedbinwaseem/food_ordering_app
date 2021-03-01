import 'package:flutter/material.dart';
import 'package:food_ordering_app/user/localUser.dart';
import 'package:food_ordering_app/utils/colors.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: primaryGreen,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Hello',
              style: TextStyle(fontSize: 26, fontFamily: 'Sofia'),
            ),
            Text(
              LocalUser.userData.firstName,
              style: TextStyle(
                fontSize: 30,
                fontFamily: 'Sofia',
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

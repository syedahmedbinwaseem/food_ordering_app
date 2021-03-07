import 'package:flutter/material.dart';

class FogotPassword extends StatefulWidget {
  @override
  _FogotPasswordState createState() => _FogotPasswordState();
}

class _FogotPasswordState extends State<FogotPassword> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: AnimatedDefaultTextStyle(
          style: TextStyle(
            fontFamily: 'Sofia',
            color: Colors.black,
            fontSize: MediaQuery.of(context).size.width * 0.07,
          ),
          child: Text(
            'Forgot Password',
          ),
          duration: Duration(milliseconds: 200),
        ),
      ),
    );
  }
}

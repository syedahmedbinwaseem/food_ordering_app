import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:food_ordering_app/screens/authScreen.dart';

class Profile extends StatefulWidget {
  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: RaisedButton(
          child: Text('Logout'),
          onPressed: () async {
            try {
              await FirebaseAuth.instance.signOut();
            } catch (e) {}
            Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                    builder: (context) => AuthScreen(
                          index: 0,
                        )));
          },
        ),
      ),
    );
  }
}

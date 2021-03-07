import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:food_ordering_app/screens/splash.dart';
import 'package:food_ordering_app/utils/colors.dart';

void main() {
  runApp(MyApp());
}

// ignore: must_be_immutable
class MyApp extends StatelessWidget {
  MaterialColor customPrimaryColor = MaterialColor(0xFF00D589, primaryColor);
  @override
  Widget build(BuildContext context) {
    Firebase.initializeApp().then((value) {});
    return MaterialApp(
        title: 'Flutter Demo',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: customPrimaryColor,
          textSelectionHandleColor: blue,
          indicatorColor: blue,
          cursorColor: blue,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        home: SplashScreen());
  }
}

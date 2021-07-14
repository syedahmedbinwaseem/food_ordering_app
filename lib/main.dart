import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

import 'package:food_ordering_app/screens/splash.dart';
import 'package:food_ordering_app/utils/colors.dart';

Future<void> _messageHandler(RemoteMessage message) async {
  print('background message ${message.notification.body}');
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  FirebaseMessaging.onBackgroundMessage(_messageHandler);
  runApp(MyApp());
}

// ignore: must_be_immutable
class MyApp extends StatelessWidget {
  MaterialColor customPrimaryColor = MaterialColor(0xFF00D589, primaryColor);
  @override
  Widget build(BuildContext context) {
    // Firebase.initializeApp().then((value) {});
    return MaterialApp(
        builder: EasyLoading.init(),
        title: 'Foodie',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: customPrimaryColor,
          textSelectionTheme:
              TextSelectionThemeData(selectionColor: blue, cursorColor: blue),
          indicatorColor: blue,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        home: SplashScreen());
  }
}

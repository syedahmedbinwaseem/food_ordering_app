import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:food_ordering_app/screens/authScreen.dart';
import 'package:food_ordering_app/screens/bottomNavigator.dart';
import 'package:food_ordering_app/user/localUser.dart';
import 'package:food_ordering_app/utils/colors.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  void getUser() async {
    await Hive.initFlutter().then((value) {
      Firebase.initializeApp().then((value) async {
        User user = FirebaseAuth.instance.currentUser;
        if (user == null) {
          Navigator.of(context).pushReplacement(MaterialPageRoute(
              builder: (context) => AuthScreen(
                    index: 0,
                  )));
        } else {
          DocumentSnapshot snap = await FirebaseFirestore.instance
              .collection('user')
              .doc(user.email)
              .get();
          setState(() {
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
          });
          Navigator.of(context).pushReplacement(MaterialPageRoute(
              builder: (context) => BottomNavigator(
                    fName: snap['firstName'],
                    gender: snap['gender'],
                    userDetails: snap,
                  )));
        }
      });
    });
  }

  @override
  void initState() {
    super.initState();
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      RemoteNotification notification = message.notification;
      AndroidNotification android = message.notification?.android;

      print('on message');
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print('A new onMessageOpenedApp event was published!');
      RemoteNotification notification = message.notification;
      AndroidNotification android = message.notification?.android;
      if (notification != null && android != null) {
        showDialog(
            context: context,
            builder: (_) {
              return AlertDialog(
                title: Text(notification.title),
                content: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [Text(notification.body)],
                  ),
                ),
              );
            });
      }
    });
    getUser();
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

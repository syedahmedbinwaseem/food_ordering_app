import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:food_ordering_app/utils/animatedNumber.dart';
import 'package:food_ordering_app/utils/colors.dart';

class Wallet extends StatefulWidget {
  @override
  _WalletState createState() => _WalletState();
}

class _WalletState extends State<Wallet> {
  void geta() async {
    await FirebaseAuth.instance.signOut();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        automaticallyImplyLeading: false,
        leading: Container(
          padding: EdgeInsets.fromLTRB(10, 19, 19, 19),
          child: Image.asset('assets/images/four-dots.png'),
        ),
        actions: [
          Container(
            padding: EdgeInsets.only(top: 15, left: 5),
            decoration: BoxDecoration(
                color: primaryGreen,
                borderRadius:
                    BorderRadius.only(bottomLeft: Radius.circular(30))),
            height: 1000,
            width: 50,
            child: ClipRRect(
              borderRadius: BorderRadius.only(bottomLeft: Radius.circular(30)),
              child: Image.asset('assets/images/woman.png'),
            ),
          ),
        ],
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('user')
            .doc('syedahmedbinwaseem@gmail.com')
            .snapshots(),
        builder: (context, AsyncSnapshot<DocumentSnapshot> snapshot) {
          return Container(
            child: Center(
                child: AnimatedFlipCounter(
              weight: FontWeight.bold,
              duration: Duration(milliseconds: 500),
<<<<<<< HEAD
              value: snapshot.data['walletAmount'],
=======
              value: 555,
>>>>>>> 15c5c823c1e8c852c2b9afef756f5a1087f6ce24

              /* pass in a number like 2014 */
              color: blue,
              size: 100,
            )),
          );
        },
      ),
    );
  }
}

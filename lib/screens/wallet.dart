import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:food_ordering_app/user/localUser.dart';
import 'package:food_ordering_app/utils/animatedNumber.dart';
import 'package:food_ordering_app/utils/colors.dart';
import 'package:number_slide_animation/number_slide_animation.dart';

class Wallet extends StatefulWidget {
  @override
  _WalletState createState() => _WalletState();
}

class _WalletState extends State<Wallet> {
  void geta() async {
    DocumentSnapshot snap = await FirebaseFirestore.instance
        .collection('user')
        .doc('syedahmedbinwaseem@gmail.com')
        .get();

    print(snap['email']);
    await FirebaseAuth.instance.signOut();
  }

  @override
  Widget build(BuildContext context) {
    print(LocalUser.userData.email);
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
              duration: Duration(milliseconds: 500),
              value: snapshot.data['walletAmount'],
              
              /* pass in a number like 2014 */
              color: Colors.black,
              size: 100,
            )),
          );
        },
      ),
    );
  }
}

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:food_ordering_app/utils/colors.dart';

class UserReviews extends StatefulWidget {
  DocumentSnapshot product;
  String category;

  UserReviews({this.category, this.product});
  @override
  _UserReviewsState createState() => _UserReviewsState();
}

class _UserReviewsState extends State<UserReviews> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: primaryGreen,
        title: Text(
          'All Reviews',
          style: TextStyle(
              fontFamily: 'Sofia', fontWeight: FontWeight.bold, color: blue),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: EdgeInsets.all(10),
        child: ListView.builder(
          itemCount: widget.product['review'].length,
          itemBuilder: (context, index) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: Column(
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.star,
                        color: primaryGreen,
                      ),
                      SizedBox(width: 10),
                      Expanded(
                        child: Center(
                          child: Container(
                            padding: EdgeInsets.all(10),
                            width: MediaQuery.of(context).size.width,
                            child: Text(
                              widget.product['review'][index],
                              style:
                                  TextStyle(fontFamily: 'Sofia', fontSize: 18),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: 30)
                    ],
                  ),
                  Divider()
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

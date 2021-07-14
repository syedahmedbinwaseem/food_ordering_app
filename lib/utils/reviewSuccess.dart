import 'package:flutter/material.dart';
import 'package:food_ordering_app/utils/colors.dart';
import 'package:lottie/lottie.dart';

class SuccessDialogReview extends StatefulWidget {
  @override
  _SuccessDialogReviewState createState() => _SuccessDialogReviewState();
}

class _SuccessDialogReviewState extends State<SuccessDialogReview> {
  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Container(
          width: MediaQuery.of(context).size.width * 0.9,
          height: 350,
          child: Column(
            children: [
              Container(
                  height: 220,
                  width: MediaQuery.of(context).size.width,
                  color: primaryGreen.withOpacity(0.3),
                  child: Lottie.asset(
                      'assets/images/24222-stars-review-stars.json')),
              Divider(
                height: 0,
                color: Colors.black,
              ),
              Container(
                height: 130,
                // color: Colors.pink,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    SizedBox(height: 20),
                    Text(
                      'Success!',
                      style: TextStyle(
                          fontFamily: 'Sofia',
                          fontWeight: FontWeight.bold,
                          fontSize: 22),
                    ),
                    Text('You review was posted successfully.',
                        style: TextStyle(
                            fontFamily: 'Sofia',
                            fontWeight: FontWeight.normal,
                            fontSize: 18)),
                    SizedBox(height: 10),
                    ElevatedButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: Text(
                          'OK',
                          style: TextStyle(
                              fontFamily: 'Sofia', fontWeight: FontWeight.bold),
                        ))
                  ],
                ),
              )
            ],
          )),
    );
  }
}

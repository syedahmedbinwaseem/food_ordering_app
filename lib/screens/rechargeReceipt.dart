import 'package:flutter/material.dart';
import 'package:food_ordering_app/utils/colors.dart';
import 'package:intl/intl.dart';

// ignore: must_be_immutable
class Receipt extends StatefulWidget {
  int amount;
  String email;
  String name;
  String message;
  String phone;
  Receipt({this.amount, this.email, this.name, this.message, this.phone});
  @override
  _ReceiptState createState() => _ReceiptState();
}

class _ReceiptState extends State<Receipt> {
  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Container(
        width: MediaQuery.of(context).size.width * 0.9,
        padding: EdgeInsets.all(10),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 5),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Receipt - Recharge Wallet',
                  style: TextStyle(
                      fontFamily: 'Sofia', color: primaryGreen, fontSize: 18),
                ),
                SizedBox(height: 5),
                Text(
                  widget.message,
                  style: TextStyle(fontFamily: 'Sofia'),
                )
              ],
            ),
            SizedBox(height: 15),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Amount',
                  style: TextStyle(fontFamily: 'Sofia', color: primaryGreen),
                ),
                SizedBox(height: 5),
                Text(
                  'Rs. ${widget.amount}',
                  style: TextStyle(fontFamily: 'Sofia', fontSize: 18),
                )
              ],
            ),
            SizedBox(height: 15),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Account Number',
                  style: TextStyle(fontFamily: 'Sofia', color: primaryGreen),
                ),
                SizedBox(height: 5),
                Text(
                  widget.phone,
                  style: TextStyle(fontFamily: 'Sofia', fontSize: 18),
                )
              ],
            ),
            SizedBox(height: 15),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Transaction Time',
                  style: TextStyle(fontFamily: 'Sofia', color: primaryGreen),
                ),
                SizedBox(height: 5),
                Text(
                  DateFormat.yMEd().add_jms().format(DateTime.now()),
                  style: TextStyle(fontFamily: 'Sofia', fontSize: 18),
                )
              ],
            ),
            SizedBox(height: 15),
            Align(
              alignment: Alignment.centerRight,
              child: Container(
                width: 60,
                // ignore: deprecated_member_use
                child: FlatButton(
                    onPressed: () {
                      Navigator.pop(context);
                      // Navigator.pushAndRemoveUntil(
                      //     context,
                      //     MaterialPageRoute(builder: (context) => Wallet()),
                      //     (route) => false);
                    },
                    child: Center(
                      child: Text(
                        'OK',
                        style: TextStyle(
                            color: primaryGreen,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Sofia'),
                      ),
                    )),
              ),
            )
          ],
        ),
      ),
    );
  }
}

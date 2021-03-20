import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:food_ordering_app/screens/bottomNavigator.dart';
import 'package:food_ordering_app/screens/rechargeReceipt.dart';
import 'package:food_ordering_app/screens/signUp.dart';
import 'package:food_ordering_app/user/localUser.dart';
import 'package:food_ordering_app/utils/animatedNumber.dart';
import 'package:food_ordering_app/utils/colors.dart';
import 'package:food_ordering_app/utils/paymentService.dart';

class Wallet extends StatefulWidget {
  @override
  _WalletState createState() => _WalletState();
}

class _WalletState extends State<Wallet> {
  final _mobileFormatter = PhoneNumberTextInputFormatter();
  bool isLoading = false;

  void geta() async {
    await FirebaseAuth.instance.signOut();
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double app = AppBar().preferredSize.height;
    double total = app + MediaQuery.of(context).padding.top;
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          title: Padding(
            padding: const EdgeInsets.only(top: 5),
            child: Text(
              'Wallet',
              style: TextStyle(fontFamily: 'Sofia', fontSize: 22),
            ),
          ),
          leading: IconButton(
            icon: Icon(
              Icons.arrow_back,
              color: blue,
            ),
            onPressed: () {
              Navigator.of(context, rootNavigator: true).pushReplacement(
                  MaterialPageRoute(builder: (context) => BottomNavigator()));
            },
          ),
          actions: [
            IconButton(
                icon: Icon(
                  Icons.add,
                  color: blue,
                ),
                onPressed: () {
                  generateModalSheet(total, width);
                })
          ],
        ),
        body: StreamBuilder(
            stream: FirebaseFirestore.instance
                .collection('user')
                .doc(LocalUser.userData.email)
                .snapshots(),
            builder: (context, AsyncSnapshot<DocumentSnapshot> snapshot) {
              return !snapshot.hasData
                  ? Center(
                      child: CircularProgressIndicator(),
                    )
                  : Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: 20),
                        Container(
                          child: Center(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              // crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Rs. ',
                                  style: TextStyle(
                                      fontFamily: 'Sofia',
                                      fontSize: 40,
                                      color: blue),
                                ),
                                AnimatedFlipCounter(
                                  weight: FontWeight.normal,
                                  duration: Duration(milliseconds: 500),
                                  value: snapshot.data['walletAmount'],

                                  /* pass in a number like 2014 */
                                  color: blue,
                                  size: 60,
                                ),
                                SizedBox(width: 40),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(height: 20),
                        Divider(
                          thickness: 1,
                          color: blue.withOpacity(0.3),
                        ),
                        SizedBox(height: 10),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(15, 10, 20, 10),
                          child: Text(
                            'Your Transactions',
                            style: TextStyle(fontFamily: 'Sofia', fontSize: 20),
                          ),
                        ),
                        Expanded(
                          child: Container(
                            child: StreamBuilder(
                              stream: FirebaseFirestore.instance
                                  .collection('user')
                                  .doc(LocalUser.userData.email)
                                  .collection('transactions')
                                  .snapshots(),
                              builder: (context,
                                  AsyncSnapshot<QuerySnapshot> snapshot) {
                                return !snapshot.hasData
                                    ? Center(child: CircularProgressIndicator())
                                    : snapshot.data.docs.isEmpty
                                        ? Center(
                                            child: Text(
                                            'No transactions',
                                            style: TextStyle(
                                                fontFamily: 'Sofia',
                                                fontSize: 15),
                                          ))
                                        : ListView.builder(
                                            itemCount:
                                                snapshot.data.docs.length,
                                            itemBuilder: (context, index) {
                                              // ignore: deprecated_member_use
                                              return FlatButton(
                                                onPressed: () {},
                                                child: Text(snapshot
                                                    .data.docs[index]['amount']
                                                    .toString()),
                                                height: 50,
                                              );
                                            },
                                          );
                              },
                            ),
                          ),
                        ),
                      ],
                    );
            }));
  }

  generateModalSheet(double height, double width) {
    TextEditingController phone = TextEditingController();
    TextEditingController amount = TextEditingController();
    GlobalKey<FormState> fKey = GlobalKey<FormState>();

    showModalBottomSheet(
        useRootNavigator: true,
        isScrollControlled: true,
        context: context,
        builder: (context) {
          return StatefulBuilder(builder: (context, setState) {
            return AnimatedPadding(
              padding: MediaQuery.of(context).viewInsets,
              duration: const Duration(milliseconds: 100),
              curve: Curves.decelerate,
              child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                  ),
                  padding: const EdgeInsets.only(
                      left: 15, right: 15, top: 30, bottom: 20),
                  child: Form(
                    key: fKey,
                    child: Wrap(
                      spacing: 20,
                      children: [
                        Row(
                          children: [
                            Text(
                              'Add Funds',
                              style:
                                  TextStyle(fontFamily: 'Sofia', fontSize: 20),
                            ),
                            Spacer(),
                            Expanded(
                              child: Container(
                                height: 40,
                                // width: width,
                                child: Image.asset('assets/images/jazz.jpg'),
                              ),
                            ),
                          ],
                        ),
                        TextFormField(
                          textInputAction: TextInputAction.next,
                          inputFormatters: <TextInputFormatter>[
                            FilteringTextInputFormatter.digitsOnly,
                            _mobileFormatter,
                            LengthLimitingTextInputFormatter(12),
                          ],
                          keyboardType: TextInputType.numberWithOptions(),
                          style: TextStyle(fontFamily: 'Sofia'),
                          validator: (value) {
                            return value.isEmpty
                                ? 'Number is required'
                                : value.length < 12
                                    ? 'Invalid number'
                                    : null;
                          },
                          controller: phone,
                          decoration: InputDecoration(
                            errorStyle: TextStyle(
                                fontFamily: 'Sofia',
                                color: Colors.red,
                                fontSize: 14),
                            labelText: 'Phone',
                            labelStyle: TextStyle(
                                fontFamily: 'Sofia',
                                color: Colors.black,
                                fontSize: 14),
                          ),
                        ),
                        TextFormField(
                          textCapitalization: TextCapitalization.sentences,
                          keyboardType: TextInputType.number,
                          textInputAction: TextInputAction.done,
                          style: TextStyle(fontFamily: 'Sofia'),
                          validator: (value) {
                            return value.isEmpty ? 'Amount is required' : null;
                          },
                          controller: amount,
                          decoration: InputDecoration(
                            errorStyle: TextStyle(
                                fontFamily: 'Sofia',
                                color: Colors.red,
                                fontSize: 14),
                            labelText: 'Amount',
                            labelStyle: TextStyle(
                                fontFamily: 'Sofia',
                                color: Colors.black,
                                fontSize: 14),
                          ),
                        ),
                        SizedBox(height: 20),
                        // ignore: deprecated_member_use
                        FlatButton(
                          onPressed: () async {
                            JazzcashPayment jazzcashPayment = JazzcashPayment(
                                phone:
                                    phone.text.toString().replaceAll('-', ''),
                                amount: amount.text.toString() + '00');

                            FocusScope.of(context).unfocus();
                            setState(() {
                              isLoading = true;
                            });

                            if (fKey.currentState.validate()) {
                              await jazzcashPayment.payment().then((value) {
                                // setState((){response = value});
                                print(
                                    json.decode(value.body)['pp_ResponseCode']);
                                print(json
                                    .decode(value.body)['pp_ResponseMessage']);
                                print('paymentdone');
                                setState(() {
                                  isLoading = false;
                                });
                                if (json.decode(
                                        value.body)['pp_ResponseCode'] ==
                                    '000') {
                                  Navigator.pop(context);
                                  FirebaseFirestore.instance
                                      .collection('user')
                                      .doc(LocalUser.userData.email)
                                      .update({
                                    'walletAmount': FieldValue.increment(
                                        int.parse(amount.text))
                                  });
                                  FirebaseFirestore.instance
                                      .collection("user")
                                      .doc(LocalUser.userData.email)
                                      .collection('transactions')
                                      .doc()
                                      .set({
                                    'account_number': phone.text,
                                    'amount': int.parse(amount.text),
                                    'time': DateTime.now(),
                                    'method': 'MWALLET'
                                  });
                                  showDialog(
                                    context: context,
                                    // ignore: missing_return
                                    builder: (context) {
                                      Receipt(
                                        amount: int.parse(amount.text),
                                        message: json.decode(
                                            value.body)['pp_ResponseMessage'],
                                        phone: phone.text,
                                      );
                                    },
                                  );
                                } else {
                                  print('not');
                                }
                              });
                            } else {
                              setState(() {
                                isLoading = false;
                              });
                            }
                          },
                          height: 40,
                          color: primaryGreen,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5),
                          ),
                          child: Center(
                            child: isLoading == true
                                ? Container(
                                    height: 40,
                                    width: 40,
                                    padding: EdgeInsets.all(10),
                                    child: CircularProgressIndicator(
                                      valueColor: AlwaysStoppedAnimation<Color>(
                                          Colors.white),
                                    ),
                                  )
                                : Text(
                                    'ADD',
                                    style: TextStyle(
                                        fontFamily: 'Sofia',
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold),
                                  ),
                          ),
                        )
                      ],
                    ),
                  )),
              // child: GestureDetector(
              //   onTap: () {
              //     FocusScope.of(context).unfocus();
              //   },
              //   child: Stack(
              //     children: [
              //       SingleChildScrollView(
              //         child: Container(
              //           padding: EdgeInsets.all(20),
              //           color: Colors.white,
              //           height: MediaQuery.of(context).size.height - height,
              //           width: width,
              //           child: Form(
              //             key: fKey,
              //             child: SingleChildScrollView(
              //               child: Column(
              //                 children: [
              //                   SizedBox(height: 10),
              //                   Row(
              //                     children: [
              //                       Text(
              //                         'Add Funds',
              //                         style: TextStyle(
              //                             fontFamily: 'Sofia', fontSize: 20),
              //                       ),
              //                       Spacer(),
              //                       Expanded(
              //                         child: Container(
              //                           height: 40,
              //                           // width: width,
              //                           child: Image.asset(
              //                               'assets/images/jazz.jpg'),
              //                         ),
              //                       ),
              //                     ],
              //                   ),
              //                   SizedBox(height: 20),
              //                   TextFormField(
              //                     textInputAction: TextInputAction.next,
              //                     inputFormatters: <TextInputFormatter>[
              //                       FilteringTextInputFormatter.digitsOnly,
              //                       _mobileFormatter,
              //                       LengthLimitingTextInputFormatter(12),
              //                     ],
              //                     keyboardType:
              //                         TextInputType.numberWithOptions(),
              //                     style: TextStyle(fontFamily: 'Sofia'),
              //                     validator: (value) {
              //                       return value.isEmpty
              //                           ? 'Number is required'
              //                           : value.length < 12
              //                               ? 'Invalid number'
              //                               : null;
              //                     },
              //                     controller: phone,
              //                     decoration: InputDecoration(
              //                       errorStyle: TextStyle(
              //                           fontFamily: 'Sofia',
              //                           color: Colors.red,
              //                           fontSize: 14),
              //                       labelText: 'Phone',
              //                       labelStyle: TextStyle(
              //                           fontFamily: 'Sofia',
              //                           color: Colors.black,
              //                           fontSize: 14),
              //                     ),
              //                   ),
              //                   TextFormField(
              //                     textCapitalization:
              //                         TextCapitalization.sentences,
              //                     keyboardType: TextInputType.number,
              //                     textInputAction: TextInputAction.done,
              //                     style: TextStyle(fontFamily: 'Sofia'),
              //                     validator: (value) {
              //                       return value.isEmpty
              //                           ? 'Amount is required'
              //                           : null;
              //                     },
              //                     controller: amount,
              //                     decoration: InputDecoration(
              //                       errorStyle: TextStyle(
              //                           fontFamily: 'Sofia',
              //                           color: Colors.red,
              //                           fontSize: 14),
              //                       labelText: 'Amount',
              //                       labelStyle: TextStyle(
              //                           fontFamily: 'Sofia',
              //                           color: Colors.black,
              //                           fontSize: 14),
              //                     ),
              //                   ),
              //                   SizedBox(height: 20),
              //                   FlatButton(
              //                     onPressed: () async {
              //                       JazzcashPayment jazzcashPayment =
              //                           JazzcashPayment(
              //                               phone: phone.text
              //                                   .toString()
              //                                   .replaceAll('-', ''),
              //                               amount:
              //                                   amount.text.toString() + '00');

              //                       FocusScope.of(context).unfocus();
              //                       setState(() {
              //                         isLoading = true;
              //                       });

              //                       if (fKey.currentState.validate()) {
              //                         await jazzcashPayment
              //                             .payment()
              //                             .then((value) {
              //                           // setState((){response = value});
              //                           print(json.decode(
              //                               value.body)['pp_ResponseCode']);
              //                           print(json.decode(
              //                               value.body)['pp_ResponseMessage']);
              //                           print('paymentdone');
              //                           setState(() {
              //                             isLoading = false;
              //                           });
              //                           if (json.decode(value.body)[
              //                                   'pp_ResponseCode'] ==
              //                               '000') {
              //                             Navigator.pop(context);
              //                             FirebaseFirestore.instance
              //                                 .collection('user')
              //                                 .doc(LocalUser.userData.email)
              //                                 .update({
              //                               'walletAmount':
              //                                   FieldValue.increment(
              //                                       int.parse(amount.text))
              //                             });
              //                             FirebaseFirestore.instance
              //                                 .collection("user")
              //                                 .doc(LocalUser.userData.email)
              //                                 .collection('transactions')
              //                                 .doc()
              //                                 .set({
              //                               'account_number': phone.text,
              //                               'amount': int.parse(amount.text),
              //                               'time': DateTime.now(),
              //                               'method': 'MWALLET'
              //                             });
              //                             showDialog(
              //                                 context: context,
              //                                 child: Receipt(
              //                                   amount: int.parse(amount.text),
              //                                   message:
              //                                       json.decode(value.body)[
              //                                           'pp_ResponseMessage'],
              //                                   phone: phone.text,
              //                                 ));
              //                           } else {
              //                             print('not');
              //                           }
              //                         });
              //                       } else {
              //                         setState(() {
              //                           isLoading = false;
              //                         });
              //                       }
              //                       // if (fKey.currentState.validate()) {
              //                       //   // logIn();
              //                       //   LocalUser.userData.firstName = fname.text;
              //                       //   LocalUser.userData.lastName = lname.text;
              //                       //   LocalUser.userData.phone = phone.text;
              //                       //   await uploadFile().then((value) {
              //                       //     // imagePath == null
              //                       //     //     ? null
              //                       //     //     : LocalUser.userData.image =
              //                       //     //         imagePath;

              //                       //     FirebaseFirestore.instance
              //                       //         .collection('user')
              //                       //         .doc(LocalUser.userData.email)
              //                       //         .update({
              //                       //       'firstName': fname.text,
              //                       //       'lastName': lname.text,
              //                       //       'phone': phone.text,
              //                       //       // imagePath == null ? null : 'image':
              //                       //       //     imagePath
              //                       //       'image': imagePath == null
              //                       //           ? LocalUser.userData.image
              //                       //           : imagePath
              //                       //     });
              //                       //     fToast.showToast(
              //                       //       child: ToastWidget.toast(
              //                       //           'Profile updated',
              //                       //           Icon(Icons.done, size: 20)),
              //                       //       toastDuration: Duration(seconds: 2),
              //                       //       gravity: ToastGravity.BOTTOM,
              //                       //     );
              //                       //     setState(() {
              //                       //       isLoading = false;
              //                       //     });
              //                       //     Navigator.pop(context);
              //                       //   });
              //                       // } else {
              //                       //   setState(() {
              //                       //     isLoading = false;
              //                       //   });
              //                       // }
              //                     },
              //                     height: 40,
              //                     color: primaryGreen,
              //                     shape: RoundedRectangleBorder(
              //                       borderRadius: BorderRadius.circular(5),
              //                     ),
              //                     child: Center(
              //                       child: isLoading == true
              //                           ? Container(
              //                               height: 40,
              //                               width: 40,
              //                               padding: EdgeInsets.all(10),
              //                               child: CircularProgressIndicator(
              //                                 valueColor:
              //                                     AlwaysStoppedAnimation<Color>(
              //                                         Colors.white),
              //                               ),
              //                             )
              //                           : Text(
              //                               'SAVE',
              //                               style: TextStyle(
              //                                   fontFamily: 'Sofia',
              //                                   color: Colors.white,
              //                                   fontWeight: FontWeight.bold),
              //                             ),
              //                     ),
              //                   ),
              //                 ],
              //               ),
              //             ),
              //           ),
              //         ),
              //       ),
              //     ],
              //   ),
              // ),
            );
          });
        });
  }
}

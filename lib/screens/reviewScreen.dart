import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:food_ordering_app/user/localUser.dart';
import 'package:food_ordering_app/utils/reviewSuccess.dart';
import 'package:intl/intl.dart';

import 'package:food_ordering_app/utils/colors.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

class ReviewScreen extends StatefulWidget {
  DocumentSnapshot order;
  ReviewScreen({this.order});
  @override
  _ReviewScreenState createState() => _ReviewScreenState();
}

class _ReviewScreenState extends State<ReviewScreen> {
  NumberFormat formatter = new NumberFormat("0000");
  GlobalKey<FormState> fKey = GlobalKey<FormState>();
  final review = TextEditingController();
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return ModalProgressHUD(
      inAsyncCall: isLoading,
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: primaryGreen,
          title: Text(
            'Review Order',
            style: TextStyle(
                fontFamily: 'Sofia', fontWeight: FontWeight.bold, color: blue),
          ),
          centerTitle: true,
        ),
        body: Padding(
          padding: EdgeInsets.all(10),
          child: Column(
            children: [
              SizedBox(height: 20),
              Container(
                height: 80,
                width: 80,
                child: Image.asset('assets/images/review.png'),
              ),
              SizedBox(height: 20),
              Container(
                height: 30,
                width: MediaQuery.of(context).size.width,
                child: FittedBox(
                  child: Text(
                    'Please take some time to review your order: #${formatter.format(widget.order['orderNumber'])}',
                    style: TextStyle(
                        fontFamily: 'Sofia',
                        fontWeight: FontWeight.bold,
                        fontSize: 21),
                  ),
                ),
              ),
              SizedBox(height: 30),
              Expanded(
                  child: GestureDetector(
                onTap: () {
                  FocusScope.of(context).unfocus();
                },
                child: Container(
                  child: StreamBuilder(
                    stream: FirebaseFirestore.instance
                        .collection('orders')
                        .doc(widget.order.id)
                        .collection('products')
                        .snapshots(),
                    builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                      return !snapshot.hasData
                          ? Center(
                              child: CircularProgressIndicator(),
                            )
                          : ListView.builder(
                              itemCount: snapshot.data.docs.length,
                              itemBuilder: (context, index) {
                                return !snapshot.hasData
                                    ? Center(
                                        child: CircularProgressIndicator(),
                                      )
                                    : StreamBuilder(
                                        stream: FirebaseFirestore.instance
                                            .collection('products')
                                            .doc('category')
                                            .collection(snapshot
                                                .data.docs[index]['category'])
                                            .doc(
                                                snapshot.data.docs[index]['id'])
                                            .snapshots(),
                                        builder: (context,
                                            AsyncSnapshot<DocumentSnapshot>
                                                snap) {
                                          List<TextEditingController>
                                              controllers = [];
                                          snapshot.data.docs.forEach((element) {
                                            controllers.add(
                                                new TextEditingController());
                                          });
                                          return !snap.hasData
                                              ? Center(
                                                  child:
                                                      CircularProgressIndicator(),
                                                )
                                              : Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          bottom: 20),
                                                  child: FlatButton(
                                                    padding: EdgeInsets.all(0),
                                                    onPressed: () {},
                                                    shape:
                                                        RoundedRectangleBorder(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        10)),
                                                    child: Container(
                                                      height: 180,
                                                      width:
                                                          MediaQuery.of(context)
                                                              .size
                                                              .width,
                                                      decoration: BoxDecoration(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(10),
                                                        color: primaryGreen
                                                            .withOpacity(0.3),
                                                      ),
                                                      child: Column(
                                                        children: [
                                                          Container(
                                                            decoration:
                                                                BoxDecoration(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          10),
                                                              color:
                                                                  primaryGreen,
                                                            ),
                                                            width:
                                                                MediaQuery.of(
                                                                        context)
                                                                    .size
                                                                    .width,
                                                            height: 100,
                                                            child: Row(
                                                              crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .center,
                                                              children: [
                                                                SizedBox(
                                                                    width: 10),
                                                                Container(
                                                                  height: 70,
                                                                  width: 70,
                                                                  decoration:
                                                                      BoxDecoration(
                                                                    borderRadius:
                                                                        BorderRadius.circular(
                                                                            10),
                                                                  ),
                                                                  child:
                                                                      ClipRRect(
                                                                    borderRadius:
                                                                        BorderRadius.circular(
                                                                            10),
                                                                    child:
                                                                        CachedNetworkImage(
                                                                      imageUrl:
                                                                          snap.data[
                                                                              'img_link'],
                                                                      fit: BoxFit
                                                                          .cover,
                                                                      progressIndicatorBuilder: (context,
                                                                              url,
                                                                              downloadProgress) =>
                                                                          Center(
                                                                        child:
                                                                            SizedBox(
                                                                          height:
                                                                              35,
                                                                          width:
                                                                              35,
                                                                          child: CircularProgressIndicator(
                                                                              backgroundColor: Colors.white,
                                                                              valueColor: AlwaysStoppedAnimation<Color>(primaryGreen),
                                                                              strokeWidth: 3,
                                                                              value: downloadProgress.progress),
                                                                        ),
                                                                      ),
                                                                      errorWidget: (context,
                                                                              url,
                                                                              error) =>
                                                                          Icon(Icons
                                                                              .error),
                                                                    ),
                                                                  ),
                                                                ),
                                                                SizedBox(
                                                                    width: 15),
                                                                Column(
                                                                  mainAxisAlignment:
                                                                      MainAxisAlignment
                                                                          .center,
                                                                  crossAxisAlignment:
                                                                      CrossAxisAlignment
                                                                          .start,
                                                                  children: [
                                                                    Text(
                                                                      snap.data[
                                                                          'name'],
                                                                      style: TextStyle(
                                                                          fontFamily:
                                                                              'Sofia',
                                                                          fontWeight: FontWeight
                                                                              .bold,
                                                                          fontSize:
                                                                              20),
                                                                    ),
                                                                    snapshot.data.docs[index]['size'] ==
                                                                            null
                                                                        ? Container()
                                                                        : SizedBox(
                                                                            height:
                                                                                5),
                                                                    snapshot.data.docs[index]['size'] ==
                                                                            null
                                                                        ? Container()
                                                                        : Text(
                                                                            snapshot.data.docs[index]['size'].toString().toUpperCase(),
                                                                            style: TextStyle(
                                                                                fontFamily: 'Sofia',
                                                                                fontWeight: FontWeight.w400,
                                                                                fontSize: 15),
                                                                          ),
                                                                    SizedBox(
                                                                        height:
                                                                            5),
                                                                    Text(
                                                                      'x${snapshot.data.docs[index]['quantity']}',
                                                                      style: TextStyle(
                                                                          fontFamily:
                                                                              'Sofia',
                                                                          fontSize:
                                                                              19),
                                                                    )
                                                                  ],
                                                                ),
                                                                Expanded(
                                                                  child: Align(
                                                                    alignment:
                                                                        Alignment
                                                                            .centerRight,
                                                                    child: Text(
                                                                      'Rs. ${(snapshot.data.docs[index]['price'] * snapshot.data.docs[index]['quantity'])}',
                                                                      style: TextStyle(
                                                                          fontFamily:
                                                                              'Sofia',
                                                                          color: Colors
                                                                              .black,
                                                                          fontWeight: FontWeight
                                                                              .bold,
                                                                          fontSize:
                                                                              20),
                                                                    ),
                                                                  ),
                                                                ),
                                                                SizedBox(
                                                                  width: 15,
                                                                )
                                                              ],
                                                            ),
                                                          ),
                                                          Container(
                                                            height: 70,
                                                            decoration:
                                                                BoxDecoration(
                                                              color: Colors
                                                                  .transparent,
                                                              borderRadius: BorderRadius.only(
                                                                  bottomLeft: Radius
                                                                      .circular(
                                                                          10),
                                                                  bottomRight: Radius
                                                                      .circular(
                                                                          10)),
                                                            ),
                                                            padding:
                                                                EdgeInsets.all(
                                                                    10),
                                                            child: Center(
                                                              child: snap.data
                                                                          .data()
                                                                          .containsKey(
                                                                              'reviewedBy') &&
                                                                      snap.data[
                                                                              'reviewedBy']
                                                                          .toString()
                                                                          .contains(LocalUser
                                                                              .userData
                                                                              .email)
                                                                  ? Center(
                                                                      child:
                                                                          Text(
                                                                        'Review already posted!',
                                                                        style: TextStyle(
                                                                            fontFamily:
                                                                                'Sofia',
                                                                            fontStyle:
                                                                                FontStyle.italic),
                                                                      ),
                                                                    )
                                                                  : Row(
                                                                      children: [
                                                                        Expanded(
                                                                          child:
                                                                              TextFormField(
                                                                            keyboardType:
                                                                                TextInputType.emailAddress,
                                                                            textInputAction:
                                                                                TextInputAction.next,
                                                                            style:
                                                                                TextStyle(fontFamily: 'Sofia'),
                                                                            controller:
                                                                                controllers[index],
                                                                            decoration:
                                                                                InputDecoration(
                                                                              errorStyle: TextStyle(fontFamily: 'Sofia', color: Colors.red, fontSize: 14),
                                                                              labelText: 'Write your review',
                                                                              labelStyle: TextStyle(fontFamily: 'Sofia', color: Colors.black, fontSize: 14),
                                                                            ),
                                                                          ),
                                                                        ),
                                                                        SizedBox(
                                                                            width:
                                                                                10),
                                                                        GestureDetector(
                                                                          onTap:
                                                                              () async {
                                                                            setState(() {
                                                                              isLoading = true;
                                                                            });
                                                                            await FirebaseFirestore.instance.collection('products').doc('category').collection(snapshot.data.docs[index]['category']).doc(snap.data.id).update({
                                                                              'reviewedBy': FieldValue.arrayUnion([
                                                                                LocalUser.userData.email
                                                                              ]),
                                                                              'review': FieldValue.arrayUnion([
                                                                                'abcd'
                                                                              ])
                                                                            });
                                                                            setState(() {
                                                                              isLoading = false;
                                                                            });
                                                                            showDialog(
                                                                                barrierDismissible: false,
                                                                                context: context,
                                                                                builder: (context) {
                                                                                  return SuccessDialogReview();
                                                                                }).then((value) {
                                                                              Navigator.pop(context);
                                                                            });
                                                                            print(snap.data['name']);
                                                                          },
                                                                          child:
                                                                              Container(
                                                                            height:
                                                                                40,
                                                                            width:
                                                                                40,
                                                                            child:
                                                                                Image.asset('assets/images/next.png'),
                                                                          ),
                                                                        )
                                                                      ],
                                                                    ),
                                                            ),
                                                          )
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                );
                                        });
                              });
                    },
                  ),
                ),
              ))
            ],
          ),
        ),
      ),
    );
  }
}

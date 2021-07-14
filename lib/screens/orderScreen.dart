import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:food_ordering_app/screens/productScreen.dart';
import 'package:food_ordering_app/screens/reviewScreen.dart';
import 'package:food_ordering_app/utils/colors.dart';
import 'package:food_ordering_app/utils/reviewSuccess.dart';
import 'package:im_stepper/stepper.dart';
import 'package:intl/intl.dart';

// ignore: must_be_immutable
class OrderScreen extends StatefulWidget {
  DocumentSnapshot order;
  OrderScreen({this.order});
  @override
  _OrderScreenState createState() => _OrderScreenState();
}

class _OrderScreenState extends State<OrderScreen> {
  NumberFormat formatter = new NumberFormat("0000");

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('orders')
            .doc(widget.order.id)
            .snapshots(),
        builder: (context, snapshot) {
          return !snapshot.hasData
              ? Center(
                  child: CircularProgressIndicator(),
                )
              : Scaffold(
                  appBar: AppBar(
                    backgroundColor: primaryGreen,
                    title: Text(
                      'Order # ' +
                          formatter.format(widget.order['orderNumber']),
                      style: TextStyle(
                          fontFamily: 'Sofia',
                          fontWeight: FontWeight.bold,
                          color: blue),
                    ),
                    centerTitle: true,
                  ),
                  body: Padding(
                    padding: EdgeInsets.all(10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(
                              'Placed By: ',
                              style: TextStyle(
                                  fontFamily: 'Sofia',
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold),
                            ),
                            Text(
                              snapshot.data['orderBy'],
                              style:
                                  TextStyle(fontFamily: 'Sofia', fontSize: 18),
                            ),
                          ],
                        ),
                        SizedBox(height: 10),
                        Row(
                          children: [
                            Text(
                              'Total Price: ',
                              style: TextStyle(
                                  fontFamily: 'Sofia',
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold),
                            ),
                            Text(
                              "Rs. " + snapshot.data['totalPrice'].toString(),
                              style:
                                  TextStyle(fontFamily: 'Sofia', fontSize: 18),
                            ),
                          ],
                        ),
                        SizedBox(height: 10),
                        Row(
                          children: [
                            Text(
                              'Total Items: ',
                              style: TextStyle(
                                  fontFamily: 'Sofia',
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold),
                            ),
                            Text(
                              snapshot.data['totalItems'].toString(),
                              style:
                                  TextStyle(fontFamily: 'Sofia', fontSize: 18),
                            ),
                          ],
                        ),
                        SizedBox(height: 10),
                        Row(
                          children: [
                            Text(
                              'Status: ',
                              style: TextStyle(
                                  fontFamily: 'Sofia',
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold),
                            ),
                            Text(
                              snapshot.data['status'],
                              style:
                                  TextStyle(fontFamily: 'Sofia', fontSize: 18),
                            ),
                          ],
                        ),
                        widget.order['delivery'] == true
                            ? SizedBox(height: 10)
                            : Container(),
                        widget.order['delivery'] == true
                            ? Row(
                                children: [
                                  Text(
                                    'Dellivery: ',
                                    style: TextStyle(
                                        fontFamily: 'Sofia',
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  Text(
                                    snapshot.data['location'],
                                    style: TextStyle(
                                        fontFamily: 'Sofia', fontSize: 18),
                                  ),
                                ],
                              )
                            : Container(),
                        widget.order['delivery'] == true
                            ? SizedBox(height: 10)
                            : Container(),
                        widget.order['delivery'] == true
                            ? Row(
                                children: [
                                  Text(
                                    'Comments: ',
                                    style: TextStyle(
                                        fontFamily: 'Sofia',
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  Text(
                                    snapshot.data['comments'],
                                    style: TextStyle(
                                        fontFamily: 'Sofia', fontSize: 18),
                                  ),
                                ],
                              )
                            : Container(),
                        Divider(
                          height: 40,
                          color: darkGreen,
                        ),
                        ImageStepper(
                          activeStepBorderWidth: 5,
                          activeStepBorderColor: blue,
                          enableNextPreviousButtons: false,
                          enableStepTapping: false,
                          images: [
                            AssetImage('assets/images/order.png'),
                            AssetImage('assets/images/noodles.png'),
                            AssetImage('assets/images/checked.png'),
                          ],
                          activeStep: snapshot.data['status'] == 'received'
                              ? 0
                              : snapshot.data['status'] == 'preparing'
                                  ? 1
                                  : snapshot.data['status'] == 'completed'
                                      ? 2
                                      : null,
                        ),
                        SizedBox(height: 10),
                        Center(
                          child: Text(
                            'Order Items',
                            style: TextStyle(
                                fontFamily: 'Sofia',
                                fontWeight: FontWeight.bold,
                                fontSize: 20),
                          ),
                        ),
                        Expanded(
                          child: StreamBuilder(
                              stream: FirebaseFirestore.instance
                                  .collection('orders')
                                  .doc(widget.order.id)
                                  .collection('products')
                                  .snapshots(),
                              builder: (context,
                                  AsyncSnapshot<QuerySnapshot> snapshot) {
                                return !snapshot.hasData
                                    ? Center(
                                        child: CircularProgressIndicator(),
                                      )
                                    : ListView.builder(
                                        itemCount: snapshot.data.docs.length,
                                        itemBuilder: (context, index) {
                                          return !snapshot.hasData
                                              ? Center(
                                                  child:
                                                      CircularProgressIndicator(),
                                                )
                                              : StreamBuilder(
                                                  stream: FirebaseFirestore
                                                      .instance
                                                      .collection('products')
                                                      .doc('category')
                                                      .collection(snapshot
                                                              .data.docs[index]
                                                          ['category'])
                                                      .doc(snapshot.data
                                                          .docs[index]['id'])
                                                      .snapshots(),
                                                  builder: (context,
                                                      AsyncSnapshot<
                                                              DocumentSnapshot>
                                                          snap) {
                                                    return !snap.hasData
                                                        ? Center(
                                                            child:
                                                                CircularProgressIndicator(),
                                                          )
                                                        : Padding(
                                                            padding:
                                                                EdgeInsets.all(
                                                                    10),
                                                            // ignore: deprecated_member_use
                                                            child: FlatButton(
                                                              shape: RoundedRectangleBorder(
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              10)),
                                                              onPressed: () {
                                                                Navigator.push(
                                                                    context,
                                                                    MaterialPageRoute(
                                                                        builder: (context) =>
                                                                            ProductScreen(
                                                                              product: snap.data,
                                                                            )));
                                                              },
                                                              padding:
                                                                  EdgeInsets
                                                                      .all(0),
                                                              child: Container(
                                                                height: 100,
                                                                width: MediaQuery.of(
                                                                        context)
                                                                    .size
                                                                    .width,
                                                                decoration:
                                                                    BoxDecoration(
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              10),
                                                                  color: primaryGreen
                                                                      .withOpacity(
                                                                          0.3),
                                                                ),
                                                                child: Row(
                                                                  crossAxisAlignment:
                                                                      CrossAxisAlignment
                                                                          .center,
                                                                  children: [
                                                                    SizedBox(
                                                                        width:
                                                                            10),
                                                                    Container(
                                                                      height:
                                                                          70,
                                                                      width: 70,
                                                                      decoration:
                                                                          BoxDecoration(
                                                                        borderRadius:
                                                                            BorderRadius.circular(10),
                                                                      ),
                                                                      child:
                                                                          ClipRRect(
                                                                        borderRadius:
                                                                            BorderRadius.circular(10),
                                                                        child:
                                                                            CachedNetworkImage(
                                                                          imageUrl:
                                                                              snap.data['img_link'],
                                                                          fit: BoxFit
                                                                              .cover,
                                                                          progressIndicatorBuilder: (context, url, downloadProgress) =>
                                                                              Center(
                                                                            child:
                                                                                SizedBox(
                                                                              height: 35,
                                                                              width: 35,
                                                                              child: CircularProgressIndicator(backgroundColor: Colors.white, valueColor: AlwaysStoppedAnimation<Color>(primaryGreen), strokeWidth: 3, value: downloadProgress.progress),
                                                                            ),
                                                                          ),
                                                                          errorWidget: (context, url, error) =>
                                                                              Icon(Icons.error),
                                                                        ),
                                                                      ),
                                                                    ),
                                                                    SizedBox(
                                                                        width:
                                                                            15),
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
                                                                              fontFamily: 'Sofia',
                                                                              fontWeight: FontWeight.bold,
                                                                              fontSize: 20),
                                                                        ),
                                                                        snapshot.data.docs[index]['size'] ==
                                                                                null
                                                                            ? Container()
                                                                            : SizedBox(height: 5),
                                                                        snapshot.data.docs[index]['size'] ==
                                                                                null
                                                                            ? Container()
                                                                            : Text(
                                                                                snapshot.data.docs[index]['size'].toString().toUpperCase(),
                                                                                style: TextStyle(fontFamily: 'Sofia', fontWeight: FontWeight.w400, fontSize: 15),
                                                                              ),
                                                                        SizedBox(
                                                                            height:
                                                                                5),
                                                                        Text(
                                                                          'x${snapshot.data.docs[index]['quantity']}',
                                                                          style: TextStyle(
                                                                              fontFamily: 'Sofia',
                                                                              fontSize: 19),
                                                                        )
                                                                      ],
                                                                    ),
                                                                    Expanded(
                                                                      child:
                                                                          Align(
                                                                        alignment:
                                                                            Alignment.centerRight,
                                                                        child:
                                                                            Text(
                                                                          'Rs. ${(snapshot.data.docs[index]['price'] * snapshot.data.docs[index]['quantity'])}',
                                                                          style: TextStyle(
                                                                              fontFamily: 'Sofia',
                                                                              color: primaryGreen,
                                                                              fontWeight: FontWeight.bold,
                                                                              fontSize: 20),
                                                                        ),
                                                                      ),
                                                                    ),
                                                                    SizedBox(
                                                                      width: 15,
                                                                    )
                                                                  ],
                                                                ),
                                                              ),
                                                            ),
                                                          );
                                                  });
                                        });
                              }),
                        ),
                        // ignore: deprecated_member_use
                        FlatButton(
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => ReviewScreen(
                                          order: widget.order,
                                        )));
                          },
                          height: 40,
                          color: primaryGreen,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5),
                          ),
                          child: Center(
                            child: Text(
                              'REVIEW ORDER',
                              style: TextStyle(
                                  fontFamily: 'Sofia',
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
        });
  }
}

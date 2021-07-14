import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:food_ordering_app/screens/orderScreen.dart';
import 'package:food_ordering_app/user/localUser.dart';
import 'package:food_ordering_app/utils/colors.dart';
import 'package:intl/intl.dart';

class MyOrders extends StatefulWidget {
  @override
  _MyOrdersState createState() => _MyOrdersState();
}

class _MyOrdersState extends State<MyOrders> with TickerProviderStateMixin {
  NumberFormat formatter = new NumberFormat("0000");
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          bottom: TabBar(
            indicatorColor: blue,
            tabs: [
              Tab(
                child: Text(
                  'Ongoing',
                  style: TextStyle(
                      fontFamily: 'Sofia', fontWeight: FontWeight.bold),
                ),
              ),
              Tab(
                  child: Text(
                'Completed',
                style:
                    TextStyle(fontFamily: 'Sofia', fontWeight: FontWeight.bold),
              )),
            ],
          ),
          backgroundColor: Colors.white,
          leading: IconButton(
            icon: Icon(
              Icons.arrow_back,
              color: blue,
            ),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          elevation: 0,
          title: Padding(
            padding: const EdgeInsets.only(top: 5),
            child: Text(
              'My Orders',
              style: TextStyle(fontFamily: 'Sofia', fontSize: 22),
            ),
          ),
        ),
        body: TabBarView(
          children: [
            Container(
              child: StreamBuilder(
                  stream: FirebaseFirestore.instance
                      .collection('orders')
                      .where('orderBy', isEqualTo: LocalUser.userData.email)
                      .where(
                        'status',
                        isNotEqualTo: 'completed',
                      )
                      .snapshots(),
                  builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                    return !snapshot.hasData
                        ? Center(
                            child: CircularProgressIndicator(),
                          )
                        : snapshot.data.docs.length == 0
                            ? Center(
                                child: Text(
                                  'No ongoing orders',
                                  style: TextStyle(
                                      fontFamily: 'Sofia', fontSize: 20),
                                ),
                              )
                            : ListView.builder(
                                itemCount: snapshot.data.docs.length,
                                itemBuilder: (context, index) {
                                  return Padding(
                                    padding: EdgeInsets.all(10),
                                    // ignore: deprecated_member_use
                                    child: FlatButton(
                                      padding: EdgeInsets.all(0),
                                      onPressed: () {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    OrderScreen(
                                                      order: snapshot
                                                          .data.docs[index],
                                                    )));
                                      },
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(10)),
                                      child: Container(
                                        height: 100,
                                        padding:
                                            EdgeInsets.fromLTRB(20, 0, 20, 0),
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          color: primaryGreen.withOpacity(0.2),
                                        ),
                                        child: Row(
                                          children: [
                                            // SizedBox(width: 20),
                                            Container(
                                              height: 50,
                                              width: 50,
                                              child: Image.asset(
                                                  'assets/images/fried.png'),
                                            ),
                                            SizedBox(width: 15),
                                            Expanded(
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  Text(
                                                    'Order # ' +
                                                        formatter.format(
                                                            snapshot.data
                                                                    .docs[index]
                                                                [
                                                                'orderNumber']),
                                                    style: TextStyle(
                                                        fontFamily: 'Sofia',
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontSize: 20),
                                                  ),
                                                  SizedBox(height: 6),
                                                  Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [
                                                      Text(
                                                        snapshot.data.docs[
                                                                        index][
                                                                    'totalItems'] ==
                                                                1
                                                            ? '${snapshot.data.docs[index]['totalItems']} Item'
                                                            : '${snapshot.data.docs[index]['totalItems']} Items',
                                                        style: TextStyle(
                                                            fontFamily: 'Sofia',
                                                            fontWeight:
                                                                FontWeight
                                                                    .normal,
                                                            fontSize: 18),
                                                      ),
                                                      Text(
                                                        snapshot
                                                                .data
                                                                .docs[index]
                                                                    ['time']
                                                                .toDate()
                                                                .day
                                                                .toString() +
                                                            "-" +
                                                            snapshot
                                                                .data
                                                                .docs[index]
                                                                    ['time']
                                                                .toDate()
                                                                .month
                                                                .toString() +
                                                            "-" +
                                                            snapshot
                                                                .data
                                                                .docs[index]
                                                                    ['time']
                                                                .toDate()
                                                                .year
                                                                .toString(),
                                                        style: TextStyle(
                                                            fontFamily: 'Sofia',
                                                            fontWeight:
                                                                FontWeight
                                                                    .normal,
                                                            fontSize: 18),
                                                      ),
                                                    ],
                                                  )
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  );
                                },
                              );
                  }),
            ),
            Container(
              child: StreamBuilder(
                  stream: FirebaseFirestore.instance
                      .collection('orders')
                      .where('orderBy', isEqualTo: LocalUser.userData.email)
                      .where('status', isEqualTo: 'completed')
                      .orderBy('time', descending: true)
                      .snapshots(),
                  builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                    return !snapshot.hasData
                        ? Center(
                            child: CircularProgressIndicator(),
                          )
                        : snapshot.data.docs.length == 0
                            ? Center(
                                child: Text(
                                  'No completed orders',
                                  style: TextStyle(
                                      fontFamily: 'Sofia', fontSize: 20),
                                ),
                              )
                            : ListView.builder(
                                itemCount: snapshot.data.docs.length,
                                itemBuilder: (context, index) {
                                  return Padding(
                                    padding: EdgeInsets.all(10),
                                    // ignore: deprecated_member_use
                                    child: FlatButton(
                                      padding: EdgeInsets.all(0),
                                      onPressed: () {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    OrderScreen(
                                                      order: snapshot
                                                          .data.docs[index],
                                                    )));
                                      },
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(10)),
                                      child: Container(
                                        height: 100,
                                        padding:
                                            EdgeInsets.fromLTRB(20, 0, 20, 0),
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          color: primaryGreen.withOpacity(0.2),
                                        ),
                                        child: Row(
                                          children: [
                                            // SizedBox(width: 20),
                                            Container(
                                              height: 50,
                                              width: 50,
                                              child: Image.asset(
                                                  'assets/images/fried.png'),
                                            ),
                                            SizedBox(width: 15),
                                            Expanded(
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  Text(
                                                    'Order # ' +
                                                        formatter.format(
                                                            snapshot.data
                                                                    .docs[index]
                                                                [
                                                                'orderNumber']),
                                                    style: TextStyle(
                                                        fontFamily: 'Sofia',
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontSize: 20),
                                                  ),
                                                  SizedBox(height: 6),
                                                  Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [
                                                      Text(
                                                        snapshot.data.docs[
                                                                        index][
                                                                    'totalItems'] ==
                                                                1
                                                            ? '${snapshot.data.docs[index]['totalItems']} Item'
                                                            : '${snapshot.data.docs[index]['totalItems']} Items',
                                                        style: TextStyle(
                                                            fontFamily: 'Sofia',
                                                            fontWeight:
                                                                FontWeight
                                                                    .normal,
                                                            fontSize: 18),
                                                      ),
                                                      Text(
                                                        snapshot
                                                                .data
                                                                .docs[index]
                                                                    ['time']
                                                                .toDate()
                                                                .day
                                                                .toString() +
                                                            "-" +
                                                            snapshot
                                                                .data
                                                                .docs[index]
                                                                    ['time']
                                                                .toDate()
                                                                .month
                                                                .toString() +
                                                            "-" +
                                                            snapshot
                                                                .data
                                                                .docs[index]
                                                                    ['time']
                                                                .toDate()
                                                                .year
                                                                .toString(),
                                                        style: TextStyle(
                                                            fontFamily: 'Sofia',
                                                            fontWeight:
                                                                FontWeight
                                                                    .normal,
                                                            fontSize: 18),
                                                      ),
                                                    ],
                                                  )
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  );
                                },
                              );
                  }),
            ),
          ],
        ),
      ),
    );
  }
}

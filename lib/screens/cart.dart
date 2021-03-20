import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:food_ordering_app/screens/bottomNavigator.dart';
import 'package:food_ordering_app/utils/colors.dart';
import 'package:hive/hive.dart';

class Cart extends StatefulWidget {
  @override
  _CartState createState() => _CartState();
}

class _CartState extends State<Cart> {
  Box cart;

  Future openBox() async {
    await Hive.openBox('cart').then((value) {
      setState(() {
        cart = value;
      });
    });
  }

  List products = [];
  int totalPrice = 0;
  void getProducts() {
    for (int i = 0; i < cart.length - 1; i++) {
      if (cart.getAt(i).toList().length > 1) {
        cart.getAt(i).toList().forEach((e) {
          setState(() {
            products.add(e);
          });
        });
      } else {
        cart.getAt(i).toList().forEach((e) {
          setState(() {
            products.add(e);
          });
        });
      }
    }

    products.forEach((element) {
      setState(() {
        totalPrice = totalPrice + element['quantity'] * element['price'];
      });
    });
  }

  @override
  void initState() {
    super.initState();
    openBox().then((value) {
      getProducts();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
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
        elevation: 0,
        title: Padding(
          padding: const EdgeInsets.only(top: 5),
          child: Text(
            'Cart',
            style: TextStyle(fontFamily: 'Sofia', fontSize: 22),
          ),
        ),
      ),
      body: products == []
          ? Center(
              child: CircularProgressIndicator(),
            )
          : products.length == 0
              ? Center(
                  child: Text(
                  'Cart is Empty',
                  style: TextStyle(fontFamily: 'Sofia', fontSize: 25),
                ))
              : Column(
                  children: [
                    SizedBox(height: 10),
                    Expanded(
                      child: ScrollConfiguration(
                        behavior: MyBehavior(),
                        child: ListView.builder(
                            itemCount: products.length,
                            itemBuilder: (context, index) {
                              return StreamBuilder(
                                  stream: FirebaseFirestore.instance
                                      .collection('products')
                                      .doc('category')
                                      .collection(products[index]['category'])
                                      .doc(products[index]['id'])
                                      .snapshots(),
                                  builder: (context, snapshot) {
                                    return !snapshot.hasData
                                        ? Center(
                                            child: CircularProgressIndicator(),
                                          )
                                        : Padding(
                                            padding: const EdgeInsets.all(10),
                                            child: Slidable(
                                              actionPane:
                                                  SlidableDrawerActionPane(),
                                              actionExtentRatio: 0.25,
                                              secondaryActions: products[index]
                                                          ["quantity"] >
                                                      1
                                                  ? [
                                                      Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                    .only(
                                                                left: 8.0),
                                                        child: ClipRRect(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(10),
                                                          child: SlideAction(
                                                            onTap: () {
                                                              decreaseQuantity(
                                                                  products[
                                                                          index]
                                                                      .toString(),
                                                                  products[index]
                                                                          ['id']
                                                                      .toString(),
                                                                  products[
                                                                          index]
                                                                      [
                                                                      'quantity'],
                                                                  products[
                                                                          index]
                                                                      ['size']);
                                                            },
                                                            child: Container(
                                                              width:
                                                                  MediaQuery.of(
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
                                                              child: Column(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .center,
                                                                children: [
                                                                  Icon(
                                                                      Icons
                                                                          .remove,
                                                                      color:
                                                                          primaryGreen),
                                                                  SizedBox(
                                                                      height:
                                                                          2),
                                                                  Text(
                                                                      'Decrease',
                                                                      style: TextStyle(
                                                                          fontFamily:
                                                                              'Sofia',
                                                                          color:
                                                                              primaryGreen)),
                                                                ],
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                      Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                    .only(
                                                                left: 8.0),
                                                        child: ClipRRect(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(10),
                                                          child: SlideAction(
                                                            onTap: () {
                                                              increaseQuantity(
                                                                  products[
                                                                          index]
                                                                      .toString(),
                                                                  products[index]
                                                                          ['id']
                                                                      .toString(),
                                                                  products[
                                                                          index]
                                                                      [
                                                                      'quantity'],
                                                                  products[
                                                                          index]
                                                                      ['size']);
                                                            },
                                                            child: Container(
                                                              width:
                                                                  MediaQuery.of(
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
                                                              child: Column(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .center,
                                                                children: [
                                                                  Icon(
                                                                      Icons.add,
                                                                      color:
                                                                          primaryGreen),
                                                                  SizedBox(
                                                                      height:
                                                                          2),
                                                                  Text(
                                                                      'Increase',
                                                                      style: TextStyle(
                                                                          fontFamily:
                                                                              'Sofia',
                                                                          color:
                                                                              primaryGreen)),
                                                                ],
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                      Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                    .only(
                                                                left: 8.0),
                                                        child: ClipRRect(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(10),
                                                          child: SlideAction(
                                                            onTap: () {
                                                              removeFromCart(
                                                                  products[
                                                                          index]
                                                                      .toString(),
                                                                  products[index]
                                                                          ['id']
                                                                      .toString(),
                                                                  products[
                                                                          index]
                                                                      [
                                                                      'quantity']);
                                                            },
                                                            child: Container(
                                                              width:
                                                                  MediaQuery.of(
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
                                                              child: Column(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .center,
                                                                children: [
                                                                  Icon(
                                                                      Icons
                                                                          .clear,
                                                                      color:
                                                                          primaryGreen),
                                                                  SizedBox(
                                                                      height:
                                                                          2),
                                                                  Text('Remove',
                                                                      style: TextStyle(
                                                                          fontFamily:
                                                                              'Sofia',
                                                                          color:
                                                                              primaryGreen)),
                                                                ],
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    ]
                                                  : [
                                                      Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                    .only(
                                                                left: 8.0),
                                                        child: ClipRRect(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(10),
                                                          child: SlideAction(
                                                            onTap: () {
                                                              increaseQuantity(
                                                                  products[
                                                                          index]
                                                                      .toString(),
                                                                  products[index]
                                                                          ['id']
                                                                      .toString(),
                                                                  products[
                                                                          index]
                                                                      [
                                                                      'quantity'],
                                                                  products[
                                                                          index]
                                                                      ['size']);
                                                            },
                                                            child: Container(
                                                              width:
                                                                  MediaQuery.of(
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
                                                              child: Column(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .center,
                                                                children: [
                                                                  Icon(
                                                                      Icons.add,
                                                                      color:
                                                                          primaryGreen),
                                                                  SizedBox(
                                                                      height:
                                                                          2),
                                                                  Text(
                                                                      'Increase',
                                                                      style: TextStyle(
                                                                          fontFamily:
                                                                              'Sofia',
                                                                          color:
                                                                              primaryGreen)),
                                                                ],
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                      Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                    .only(
                                                                left: 8.0),
                                                        child: ClipRRect(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(10),
                                                          child: SlideAction(
                                                            onTap: () {
                                                              removeFromCart(
                                                                  products[
                                                                          index]
                                                                      .toString(),
                                                                  products[index]
                                                                          ['id']
                                                                      .toString(),
                                                                  products[
                                                                          index]
                                                                      [
                                                                      'quantity']);
                                                            },
                                                            child: Container(
                                                              width:
                                                                  MediaQuery.of(
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
                                                              child: Column(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .center,
                                                                children: [
                                                                  Icon(
                                                                      Icons
                                                                          .clear,
                                                                      color:
                                                                          primaryGreen),
                                                                  SizedBox(
                                                                      height:
                                                                          2),
                                                                  Text('Remove',
                                                                      style: TextStyle(
                                                                          fontFamily:
                                                                              'Sofia',
                                                                          color:
                                                                              primaryGreen)),
                                                                ],
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                              child: Container(
                                                height: 100,
                                                width: MediaQuery.of(context)
                                                    .size
                                                    .width,
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(10),
                                                  color: primaryGreen
                                                      .withOpacity(0.3),
                                                ),
                                                child: Row(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.center,
                                                  children: [
                                                    SizedBox(width: 10),
                                                    Container(
                                                      height: 70,
                                                      width: 70,
                                                      decoration: BoxDecoration(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(10),
                                                        color: Colors.pink,
                                                      ),
                                                      child: ClipRRect(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(10),
                                                        child:
                                                            CachedNetworkImage(
                                                          imageUrl: snapshot
                                                              .data['img_link'],
                                                          fit: BoxFit.cover,
                                                          progressIndicatorBuilder:
                                                              (context, url,
                                                                      downloadProgress) =>
                                                                  Center(
                                                            child: SizedBox(
                                                              height: 35,
                                                              width: 35,
                                                              child: CircularProgressIndicator(
                                                                  backgroundColor:
                                                                      Colors
                                                                          .white,
                                                                  valueColor: AlwaysStoppedAnimation<
                                                                          Color>(
                                                                      primaryGreen),
                                                                  strokeWidth:
                                                                      3,
                                                                  value: downloadProgress
                                                                      .progress),
                                                            ),
                                                          ),
                                                          errorWidget: (context,
                                                                  url, error) =>
                                                              Icon(Icons.error),
                                                        ),
                                                      ),
                                                    ),
                                                    SizedBox(width: 15),
                                                    Column(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Text(
                                                          snapshot.data['name'],
                                                          style: TextStyle(
                                                              fontFamily:
                                                                  'Sofia',
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              fontSize: 20),
                                                        ),
                                                        products[index]
                                                                    ['size'] ==
                                                                null
                                                            ? Container()
                                                            : SizedBox(
                                                                height: 5),
                                                        products[index]
                                                                    ['size'] ==
                                                                null
                                                            ? Container()
                                                            : Text(
                                                                products[index]
                                                                        ['size']
                                                                    .toString()
                                                                    .toUpperCase(),
                                                                style: TextStyle(
                                                                    fontFamily:
                                                                        'Sofia',
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w400,
                                                                    fontSize:
                                                                        15),
                                                              ),
                                                        SizedBox(height: 5),
                                                        Text(
                                                          'x${products[index]['quantity']}',
                                                          style: TextStyle(
                                                              fontFamily:
                                                                  'Sofia',
                                                              fontSize: 19),
                                                        )
                                                      ],
                                                    ),
                                                    Expanded(
                                                      child: Align(
                                                        alignment: Alignment
                                                            .centerRight,
                                                        child: Text(
                                                          'Rs. ${(products[index]['price'] * products[index]['quantity'])}',
                                                          style: TextStyle(
                                                              fontFamily:
                                                                  'Sofia',
                                                              color:
                                                                  primaryGreen,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              fontSize: 20),
                                                        ),
                                                      ),
                                                    ),
                                                    SizedBox(width: 15)
                                                  ],
                                                ),
                                              ),
                                            ),
                                          );
                                  });
                            }),
                      ),
                    ),
                    Container(
                      height: 150,
                      margin: const EdgeInsets.only(top: 6.0),
                      width: MediaQuery.of(context).size.width,
                      padding: EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey,
                            offset: Offset(0.0, 1.0), //(x,y)
                            blurRadius: 4,
                          ),
                        ],
                      ),
                      child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            RichText(
                              text: TextSpan(
                                children: [
                                  TextSpan(
                                      text: 'Total\t',
                                      style: TextStyle(
                                          fontFamily: 'Sofia',
                                          color: Colors.black,
                                          // fontWeight: FontWeight.bold,
                                          fontSize: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.05)),
                                  TextSpan(
                                      text: 'Rs. $totalPrice',
                                      style: TextStyle(
                                          fontFamily: 'Sofia',
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black,
                                          fontSize: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.065))
                                ],
                              ),
                            ),
                            SizedBox(height: 10),
                            // ignore: deprecated_member_use
                            FlatButton(
                              onPressed: () {},
                              height: 40,
                              color: primaryGreen,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(5),
                              ),
                              child: Center(
                                child: Text(
                                  'BUY NOW',
                                  style: TextStyle(
                                      fontFamily: 'Sofia',
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                            ),
                          ]),
                    )
                  ],
                ),
    );
  }

  void removeFromCart(String map1, String id, int quantity) {
    cart
        .put('totalQuantity', cart.get('totalQuantity') - quantity)
        .then((value) {
      setState(() {});
    });

    cart.values.forEach((element) {
      if (element.toString().contains(map1)) {
        if (element.toList().length > 1) {
          int index;
          for (int i = 0; i < element.toList().length; i++) {
            if (element[i].toString() == map1) {
              index = i;
            }
          }
          List map = cart.get(id);
          map.removeAt(index);
          setState(() {
            products = [];
            totalPrice = 0;
          });
          getProducts();
        } else {
          cart.delete(id);
          setState(() {
            products = [];
            totalPrice = 0;
          });
          getProducts();
        }
      }
    });
  }

  void increaseQuantity(String map1, String id, int quantity, String size) {
    int index;
    List abcd = cart.get(id);
    for (int i = 0; i < abcd.length; i++) {
      if (abcd[i]['size'] == size) {
        index = i;
      } else {}
    }

    int quan = cart.get(id)[index]['quantity'];
    int total = quan + 1;
    cart.get(id)[index]['quantity'] = total;
    cart.containsKey('totalQuantity')
        ? cart
            .put('totalQuantity', cart.get('totalQuantity') + 1)
            .then((value) {
            setState(() {});
          })
        : cart.put('totalQuantity', quantity).then((value) {
            setState(() {});
          });

    setState(() {
      totalPrice = 0;
      products = [];
    });

    getProducts();
  }

  void decreaseQuantity(String map1, String id, int quantity, String size) {
    int index;
    List abcd = cart.get(id);
    for (int i = 0; i < abcd.length; i++) {
      if (abcd[i]['size'] == size) {
        index = i;
      } else {}
    }

    int quan = cart.get(id)[index]['quantity'];
    int total = quan - 1;
    cart.get(id)[index]['quantity'] = total;
    cart.containsKey('totalQuantity')
        ? cart
            .put('totalQuantity', cart.get('totalQuantity') - 1)
            .then((value) {
            setState(() {});
          })
        : cart.put('totalQuantity', quantity).then((value) {
            setState(() {});
          });

    setState(() {
      totalPrice = 0;
      products = [];
    });

    getProducts();
  }
}

class MyBehavior extends ScrollBehavior {
  @override
  Widget buildViewportChrome(
      BuildContext context, Widget child, AxisDirection axisDirection) {
    return child;
  }
}

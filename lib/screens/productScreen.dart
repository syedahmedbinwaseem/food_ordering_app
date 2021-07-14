import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:food_ordering_app/screens/userSeeAllReviews.dart';
import 'package:food_ordering_app/utils/animatedNumber.dart';
import 'package:food_ordering_app/utils/colors.dart';

import 'package:hive/hive.dart';

// ignore: must_be_immutable
class ProductScreen extends StatefulWidget {
  DocumentSnapshot product;
  FToast fToast;
  String category;
  ProductScreen({this.product, this.category});
  @override
  _ProductScreenState createState() => _ProductScreenState();
}

class _ProductScreenState extends State<ProductScreen> {
  double height;
  int quantity = 1;
  bool stap = false;
  bool mtap = false;
  bool ltap = false;
  FToast fToast;
  Box cart;

  int cartCheck = 0;
  void openBox() async {
    await Hive.openBox('cart').then((value) {
      setState(() {
        cart = value;
        cartCheck = 1;
      });
    });
  }

  @override
  void initState() {
    openBox();
    super.initState();
    fToast = FToast();
    fToast.init(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: IconButton(
            icon: Icon(
              Icons.arrow_back_ios,
              color: Colors.white,
              size: MediaQuery.of(context).size.width * 0.06,
            ),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          actions: [
            Stack(children: [
              new IconButton(
                icon: new Icon(
                  Icons.shopping_cart_outlined,
                  color: Colors.white,
                ),
                onPressed: null,
              ),
              cartCheck == 0
                  ? Container()
                  : cart.get('totalQuantity') == 0
                      ? Container()
                      : Padding(
                          padding: const EdgeInsets.only(left: 2.0, top: 5),
                          child: CircleAvatar(
                            radius: 8.0,
                            backgroundColor: darkGreen,
                            foregroundColor: Colors.white,
                            child: Text(
                              "${cart.get('totalQuantity') == null ? 0 : cart.get("totalQuantity")}",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 10,
                                  fontFamily: 'Sofia'),
                            ),
                          ),
                        ),
            ])
          ],
        ),
        // extendBodyBehindAppBar: true,
        backgroundColor: primaryGreen,
        body: Stack(
          children: [
            ScrollConfiguration(
              behavior: MyBehavior(),
              child: CustomScrollView(
                slivers: [
                  SliverFillRemaining(
                    hasScrollBody: false,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,

                      // mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Expanded(
                          child: Container(
                            padding: EdgeInsets.fromLTRB(20, 20, 20, 20),
                            width: MediaQuery.of(context).size.width,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.only(
                                  topRight: Radius.circular(40),
                                  topLeft: Radius.circular(40)),
                              color: Colors.white,
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Center(
                                  child: Hero(
                                    tag: widget.product.id,
                                    child: Container(
                                      height:
                                          MediaQuery.of(context).size.width *
                                              0.361,
                                      width: MediaQuery.of(context).size.width *
                                          0.361,
                                      decoration: BoxDecoration(
                                        color: primaryGreen.withOpacity(0.3),
                                        borderRadius: BorderRadius.circular(
                                            MediaQuery.of(context).size.width *
                                                0.180),
                                      ),
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(
                                            MediaQuery.of(context).size.width *
                                                0.180),
                                        child: CachedNetworkImage(
                                          imageUrl: widget.product['img_link'],
                                          fit: BoxFit.cover,
                                          progressIndicatorBuilder: (context,
                                                  url, downloadProgress) =>
                                              Center(
                                            child: SizedBox(
                                              height: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.0972,
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.0972,
                                              child: CircularProgressIndicator(
                                                  backgroundColor: Colors.white,
                                                  valueColor:
                                                      AlwaysStoppedAnimation<
                                                          Color>(primaryGreen),
                                                  strokeWidth: 3,
                                                  value: downloadProgress
                                                      .progress),
                                            ),
                                          ),
                                          errorWidget: (context, url, error) =>
                                              Icon(Icons.error),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(
                                    height: MediaQuery.of(context).size.width *
                                        0.04166),
                                Center(
                                  child: Text(
                                    widget.product['name'],
                                    style: TextStyle(
                                        fontFamily: 'Sofia',
                                        fontSize:
                                            MediaQuery.of(context).size.width *
                                                0.07,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                                SizedBox(
                                  height: MediaQuery.of(context).size.width *
                                      0.04166,
                                ),
                                Center(
                                  child: Text(
                                    widget.product['description'],
                                    style: TextStyle(
                                        fontFamily: 'Sofia',
                                        fontSize:
                                            MediaQuery.of(context).size.width *
                                                0.0472,
                                        fontWeight: FontWeight.normal),
                                  ),
                                ),
                                SizedBox(
                                    height: MediaQuery.of(context).size.width *
                                        0.034),
                                Container(
                                  height:
                                      MediaQuery.of(context).size.width * 0.22,
                                  width: MediaQuery.of(context).size.width,
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: [
                                      Container(
                                        // padding: EdgeInsets.fromLTRB(8, 15, 8, 10),
                                        height:
                                            MediaQuery.of(context).size.width *
                                                    0.22 -
                                                10,
                                        width:
                                            MediaQuery.of(context).size.width *
                                                    0.22 -
                                                10,
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(20),
                                          color: Color(0xffe6fbf4),
                                        ),
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Text(
                                              'Calories',
                                              style: TextStyle(
                                                  fontFamily: 'Sofia',
                                                  color: darkGreen,
                                                  fontWeight: FontWeight.w500),
                                            ),
                                            SizedBox(height: 10),
                                            Text(
                                              '${widget.product['nutrition'][0].toString()}g',
                                              style: TextStyle(
                                                  fontFamily: 'Sofia',
                                                  color: darkGreen,
                                                  fontWeight: FontWeight.w600),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Container(
                                        height:
                                            MediaQuery.of(context).size.width *
                                                    0.22 -
                                                10,
                                        width:
                                            MediaQuery.of(context).size.width *
                                                    0.22 -
                                                10,
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(20),
                                          color: Color(0xffe6fbf4),
                                        ),
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Text(
                                              'Protein',
                                              style: TextStyle(
                                                  fontFamily: 'Sofia',
                                                  color: darkGreen,
                                                  fontWeight: FontWeight.w500),
                                            ),
                                            SizedBox(height: 10),
                                            Text(
                                              '${widget.product['nutrition'][1].toString()}g',
                                              style: TextStyle(
                                                  fontFamily: 'Sofia',
                                                  color: darkGreen,
                                                  fontWeight: FontWeight.w600),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Container(
                                        height:
                                            MediaQuery.of(context).size.width *
                                                    0.22 -
                                                10,
                                        width:
                                            MediaQuery.of(context).size.width *
                                                    0.22 -
                                                10,
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(20),
                                          color: Color(0xffe6fbf4),
                                        ),
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Text(
                                              'Carbo',
                                              style: TextStyle(
                                                  fontFamily: 'Sofia',
                                                  color: darkGreen,
                                                  fontWeight: FontWeight.w500),
                                            ),
                                            SizedBox(height: 10),
                                            Text(
                                              '${widget.product['nutrition'][2].toString()}g',
                                              style: TextStyle(
                                                  fontFamily: 'Sofia',
                                                  color: darkGreen,
                                                  fontWeight: FontWeight.w600),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Container(
                                        height:
                                            MediaQuery.of(context).size.width *
                                                    0.22 -
                                                10,
                                        width:
                                            MediaQuery.of(context).size.width *
                                                    0.22 -
                                                10,
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(20),
                                          color: Color(0xffe6fbf4),
                                        ),
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Text(
                                              'Fat',
                                              style: TextStyle(
                                                  fontFamily: 'Sofia',
                                                  color: darkGreen,
                                                  fontWeight: FontWeight.w500),
                                            ),
                                            SizedBox(height: 10),
                                            Text(
                                              '${widget.product['nutrition'][3].toString()}g',
                                              style: TextStyle(
                                                  fontFamily: 'Sofia',
                                                  color: darkGreen,
                                                  fontWeight: FontWeight.w600),
                                            ),
                                          ],
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                                SizedBox(
                                    height: MediaQuery.of(context).size.width *
                                        0.045),
                                widget.product['price'].runtimeType == int
                                    ? Container()
                                    : Container(
                                        // color: Colors.pink,
                                        height:
                                            MediaQuery.of(context).size.width *
                                                0.22,
                                        width:
                                            MediaQuery.of(context).size.width,
                                        // color: Colors.purple,
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text('Select Size',
                                                style: TextStyle(
                                                    fontFamily: 'Sofia')),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Container(
                                                  height: 50,
                                                  width: 50,
                                                  decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            20),
                                                    color: stap == true
                                                        ? primaryGreen
                                                        : Color(0xffe6fbf4),
                                                  ),
                                                  // ignore: deprecated_member_use
                                                  child: FlatButton(
                                                    splashColor: primaryGreen
                                                        .withOpacity(0.3),
                                                    focusColor: primaryGreen
                                                        .withOpacity(0.3),
                                                    highlightColor: primaryGreen
                                                        .withOpacity(0.3),
                                                    onPressed: () {
                                                      setState(() {
                                                        stap = !stap;
                                                        mtap = false;
                                                        ltap = false;
                                                      });
                                                    },
                                                    shape:
                                                        RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              20),
                                                    ),
                                                    child: Center(
                                                      child: Text(
                                                        'S',
                                                        style: TextStyle(
                                                            fontFamily: 'Sofia',
                                                            color: darkGreen,
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                SizedBox(width: 10),
                                                Container(
                                                  height: 50,
                                                  width: 50,
                                                  decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            20),
                                                    color: mtap == true
                                                        ? primaryGreen
                                                        : Color(0xffe6fbf4),
                                                  ),
                                                  // ignore: deprecated_member_use
                                                  child: FlatButton(
                                                    splashColor: primaryGreen
                                                        .withOpacity(0.3),
                                                    focusColor: primaryGreen
                                                        .withOpacity(0.3),
                                                    highlightColor: primaryGreen
                                                        .withOpacity(0.3),
                                                    onPressed: () {
                                                      setState(() {
                                                        mtap = !mtap;
                                                        stap = false;
                                                        ltap = false;
                                                      });
                                                    },
                                                    shape:
                                                        RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              20),
                                                    ),
                                                    child: Center(
                                                      child: Text(
                                                        'M',
                                                        style: TextStyle(
                                                            fontFamily: 'Sofia',
                                                            color: darkGreen,
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                SizedBox(width: 10),
                                                Container(
                                                  height: 50,
                                                  width: 50,
                                                  decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            20),
                                                    color: ltap == true
                                                        ? primaryGreen
                                                        : Color(0xffe6fbf4),
                                                  ),
                                                  // ignore: deprecated_member_use
                                                  child: FlatButton(
                                                    splashColor: primaryGreen
                                                        .withOpacity(0.3),
                                                    focusColor: primaryGreen
                                                        .withOpacity(0.3),
                                                    highlightColor: primaryGreen
                                                        .withOpacity(0.3),
                                                    onPressed: () {
                                                      setState(() {
                                                        ltap = !ltap;
                                                        mtap = false;
                                                        stap = false;
                                                      });
                                                    },
                                                    shape:
                                                        RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              20),
                                                    ),
                                                    child: Center(
                                                      child: Text(
                                                        'L',
                                                        style: TextStyle(
                                                            fontFamily: 'Sofia',
                                                            color: darkGreen,
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                widget.product.data().containsKey('review')
                                    ? SizedBox(height: 30)
                                    : Container(),
                                widget.product.data().containsKey('review')
                                    ? Center(
                                        child: GestureDetector(
                                          onTap: () {
                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        UserReviews(
                                                          product:
                                                              widget.product,
                                                          category:
                                                              widget.category,
                                                        )));
                                          },
                                          child: Text(
                                              'See all reviews (${widget.product['review'].length})',
                                              style: TextStyle(
                                                  fontFamily: 'Sofia',
                                                  color: primaryGreen)),
                                        ),
                                      )
                                    : Container(),
                              ],
                            ),
                          ),
                        ),
                        Container(
                          height: MediaQuery.of(context).size.width * 0.18 +
                              MediaQuery.of(context).size.width * 0.1944,
                          color: Colors.white,
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Stack(
                    children: [
                      Container(
                        color: Colors.white,
                        width: MediaQuery.of(context).size.width,
                        height: MediaQuery.of(context).size.width * 0.22222,
                      ),
                      Container(
                        child: Center(
                          child: Container(
                            padding: EdgeInsets.fromLTRB(
                                MediaQuery.of(context).size.width * 0.0833,
                                0,
                                MediaQuery.of(context).size.width * 0.0833,
                                0),
                            child: Row(
                              children: [
                                RichText(
                                  text: TextSpan(
                                    children: [
                                      TextSpan(
                                          text: 'Price\n',
                                          style: TextStyle(
                                              fontFamily: 'Sofia',
                                              fontSize: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.03611)),
                                      TextSpan(
                                          text: widget.product['price']
                                                      .runtimeType ==
                                                  int
                                              ? 'Rs. ${quantity * widget.product['price']}'
                                              : stap == true
                                                  ? 'Rs. ${quantity * widget.product['price'][0]}'
                                                  : mtap == true
                                                      ? 'Rs. ${quantity * widget.product['price'][1]}'
                                                      : ltap == true
                                                          ? 'Rs. ${quantity * widget.product['price'][2]}'
                                                          : 'From Rs. ${widget.product['price'][0]}',
                                          style: TextStyle(
                                              fontFamily: 'Sofia',
                                              fontSize: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.058333))
                                    ],
                                  ),
                                ),
                                Spacer(),
                                Container(
                                  width: 120,
                                  height: 40,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(20),
                                    color: Colors.white,
                                  ),
                                  child: Center(
                                    child: Container(
                                      width: 116,
                                      height: 36,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(20),
                                        color: primaryGreen,
                                      ),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          GestureDetector(
                                            onTap: () {
                                              if (quantity > 1) {
                                                setState(() {
                                                  quantity--;
                                                });
                                              }
                                            },
                                            child: Container(
                                              width: 45,
                                              child: Center(
                                                child: Text(
                                                  '-',
                                                  style: TextStyle(
                                                    fontFamily: 'Sofia',
                                                    color: Colors.white,
                                                    fontSize: 23,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                          Container(
                                            width: 26,
                                            child: Center(
                                              child: AnimatedFlipCounter(
                                                value: quantity,
                                                weight: FontWeight.normal,
                                                duration:
                                                    Duration(milliseconds: 200),
                                                color: Colors.white,
                                                size: 23,
                                              ),
                                            ),
                                          ),
                                          GestureDetector(
                                            onTap: () {
                                              setState(() {
                                                quantity++;
                                              });
                                            },
                                            child: Container(
                                              // color: Colors.pink,
                                              width: 45,
                                              child: Center(
                                                child: Text(
                                                  '+',
                                                  style: TextStyle(
                                                    fontFamily: 'Sofia',
                                                    color: Colors.white,
                                                    fontSize: 23,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                        height: MediaQuery.of(context).size.width * 0.22222,
                        width: MediaQuery.of(context).size.width,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.only(
                              topRight: Radius.circular(40),
                              topLeft: Radius.circular(40)),
                          color: primaryGreen,
                        ),
                      ),
                    ],
                  ),
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: Stack(
                      children: [
                        Container(
                          height: MediaQuery.of(context).size.width * 0.1944,
                          width: MediaQuery.of(context).size.width,
                          color: primaryGreen,
                        ),
                        Container(
                          // ignore: deprecated_member_use
                          child: FlatButton(
                            splashColor: primaryGreen.withOpacity(0.3),
                            focusColor: primaryGreen.withOpacity(0.3),
                            highlightColor: primaryGreen.withOpacity(0.3),
                            onPressed: () {
                              if (widget.product['price'].runtimeType == int) {
                                addToCart(widget.product.id);
                              } else {
                                if (stap == false &&
                                    mtap == false &&
                                    ltap == false) {
                                  EasyLoading.showToast(
                                    'Please select size',
                                    duration: Duration(seconds: 2),
                                    toastPosition:
                                        EasyLoadingToastPosition.bottom,
                                    dismissOnTap: true,
                                  );
                                } else {
                                  addToCart(widget.product.id);
                                }
                              }
                            },
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.only(
                                  topRight: Radius.circular(40),
                                  topLeft: Radius.circular(40)),
                            ),
                            child: Center(
                              child: Text(
                                'Add To Cart',
                                style: TextStyle(
                                    fontFamily: 'Sofia',
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                          height: MediaQuery.of(context).size.width * 0.1944,
                          width: MediaQuery.of(context).size.width,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.only(
                                topRight: Radius.circular(40),
                                topLeft: Radius.circular(40)),
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ));
  }

  bool exists1 = false;

  addToCart(String docId) async {
    int index;
    String size = stap == true
        ? 'small'
        : mtap == true
            ? 'medium'
            : ltap == true
                ? 'large'
                : '';
    if (cart.containsKey(docId) && widget.product['price'].runtimeType != int) {
      List abcd = cart.get(docId);
      for (int i = 0; i < abcd.length; i++) {
        if (abcd[i]['size'] == size) {
          index = i;
        } else {}
      }
      if (index == null) {
        List map = cart.get(docId);
        map.add({
          'size': widget.product['price'].runtimeType == int
              ? null
              : stap == true
                  ? 'small'
                  : mtap == true
                      ? 'medium'
                      : ltap == true
                          ? 'large'
                          : null,
          'id': docId,
          'quantity': quantity,
          'price': stap == true
              ? widget.product['price'][0]
              : mtap == true
                  ? widget.product['price'][1]
                  : ltap == true
                      ? widget.product['price'][2]
                      : '',
          'category': widget.category
        });
        cart.put(docId, map).then((value) {
          cart.containsKey('totalQuantity')
              ? cart
                  .put('totalQuantity', cart.get('totalQuantity') + quantity)
                  .then((value) {
                  setState(() {});
                })
              : cart.put('totalQuantity', quantity).then((value) {
                  setState(() {});
                });
          EasyLoading.showToast(
            'Product Added',
            duration: Duration(seconds: 2),
            toastPosition: EasyLoadingToastPosition.bottom,
            dismissOnTap: true,
          );
        });
      } else {
        int quan = cart.get(docId)[index]['quantity'];
        int total = quan + quantity;
        cart.get(docId)[index]['quantity'] = total;
        cart.containsKey('totalQuantity')
            ? cart
                .put('totalQuantity', cart.get('totalQuantity') + quantity)
                .then((value) {
                setState(() {});
              })
            : cart.put('totalQuantity', quantity).then((value) {
                setState(() {});
              });
        EasyLoading.showToast(
          'Quantity Increased',
          duration: Duration(seconds: 2),
          toastPosition: EasyLoadingToastPosition.bottom,
          dismissOnTap: true,
        );
      }
    } else if (cart.containsKey(docId) &&
        widget.product['price'].runtimeType == int) {
      int quan = cart.get(docId)[0]['quantity'];
      int total = quan + quantity;
      cart.get(docId)[0]['quantity'] = total;

      cart.containsKey('totalQuantity')
          ? cart
              .put('totalQuantity', cart.get('totalQuantity') + quantity)
              .then((value) {
              setState(() {});
            })
          : cart.put('totalQuantity', quantity).then((value) {
              setState(() {});
            });
      EasyLoading.showToast(
        'Quantity Increased',
        duration: Duration(seconds: 2),
        toastPosition: EasyLoadingToastPosition.bottom,
        dismissOnTap: true,
      );
    } else {
      cart.put(docId, [
        {
          'size': widget.product['price'].runtimeType == int
              ? null
              : stap == true
                  ? 'small'
                  : mtap == true
                      ? 'medium'
                      : ltap == true
                          ? 'large'
                          : null,
          'id': docId,
          'quantity': quantity,
          'price': stap == true
              ? widget.product['price'][0]
              : mtap == true
                  ? widget.product['price'][1]
                  : ltap == true
                      ? widget.product['price'][2]
                      : widget.product['price'],
          'category': widget.category
        }
      ]).then((value) {
        cart.containsKey('totalQuantity')
            ? cart
                .put('totalQuantity', cart.get('totalQuantity') + quantity)
                .then((value) {
                setState(() {});
              })
            : cart.put('totalQuantity', quantity).then((value) {
                setState(() {});
              });
        EasyLoading.showToast(
          'Product Added',
          duration: Duration(seconds: 2),
          toastPosition: EasyLoadingToastPosition.bottom,
          dismissOnTap: true,
        );
      });
    }
  }
}

class MyBehavior extends ScrollBehavior {
  @override
  Widget buildViewportChrome(
      BuildContext context, Widget child, AxisDirection axisDirection) {
    return child;
  }
}

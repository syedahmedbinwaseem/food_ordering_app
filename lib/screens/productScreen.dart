import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:food_ordering_app/user/localUser.dart';
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
                                        height:
                                            MediaQuery.of(context).size.width *
                                                0.22,
                                        width:
                                            MediaQuery.of(context).size.width,
                                        // color: Colors.purple,
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceEvenly,
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
                                            )
                                          ],
                                        ),
                                      )
                              ],
                            ),
                          ),
                        ),
                        Container(
                          height: MediaQuery.of(context).size.width * 0.22222 +
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
                                  print('select one');
                                  EasyLoading.showToast(
                                    'Please select size',
                                    duration: Duration(seconds: 2),
                                    toastPosition:
                                        EasyLoadingToastPosition.bottom,
                                    dismissOnTap: true,
                                  );
                                  // fToast.showToast(
                                  //     child: MyToast1.toast('Select Size'));
                                  // Fluttertoast.showToast(
                                  //   msg: "Please select size",
                                  //   toastLength: Toast.LENGTH_LONG,
                                  //   gravity: ToastGravity.BOTTOM,
                                  //   timeInSecForIosWeb: 1,
                                  //   backgroundColor: Colors.black,
                                  //   textColor: Colors.white,
                                  //   fontSize: 15,
                                  // );
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
    print(size);
    if (cart.containsKey(docId) && widget.product['price'].runtimeType != int) {
      List abcd = cart.get(docId);
      // print(abcd);
      for (int i = 0; i < abcd.length; i++) {
        if (abcd[i]['size'] == size) {
          print(i);
          index = i;
        } else {}
      }
      print("Index $index");
      if (index == null) {
        List map = cart.get(docId);
        print(map);
        print('were here');
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
        print(map);
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

      // print(cart.get(docId)[1]['size']);
      // print('already exists');
      // print(cart.get(docId)[0]['size']);

      // List map = cart.get(docId);
      // print(map);
      // map.add({
      //   'size': widget.product['price'].runtimeType == int
      //       ? null
      //       : stap == true
      //           ? 'small'
      //           : mtap == true
      //               ? 'medium'
      //               : ltap == true
      //                   ? 'large'
      //                   : null,
      //   'id': docId,
      //   'quantity': quantity,
      //   'price': widget.product['price']
      // });
      // cart.put(docId, map).then((value) {
      //   cart.containsKey('totalQuantity')
      //       ? cart
      //           .put('totalQuantity', cart.get('totalQuantity') + quantity)
      //           .then((value) {
      //           setState(() {});
      //         })
      //       : cart.put('totalQuantity', quantity).then((value) {
      //           setState(() {});
      //         });
      //   EasyLoading.showToast(
      //     'Product Added',
      //     duration: Duration(seconds: 2),
      //     toastPosition: EasyLoadingToastPosition.bottom,
      //     dismissOnTap: true,
      //   );
      // });

      // for (int i = 0; i < cart.get(docId).toList().length; i++) {
      //   if (cart.get(docId)[i]['size'] == 'small' && stap == true) {
      //     // print('small exists at ${cart.get(docId)[i]}');
      //     int quan = cart.get(docId)[i]['quantity'];
      //     // print(cart.get(docId)[i]['quantity']);
      //     int total = quan + quantity;
      //     int check = 0;
      //     cart.get(docId)[i]['quantity'] = total;
      //     cart.containsKey('totalQuantity')
      //         ? cart
      //             .put('totalQuantity', cart.get('totalQuantity') + quantity)
      //             .then((value) {
      //             Fluttertoast.showToast(
      //               msg: "Quantity increased",
      //               toastLength: Toast.LENGTH_LONG,
      //               gravity: ToastGravity.BOTTOM,
      //               timeInSecForIosWeb: 3,
      //               backgroundColor: Colors.black,
      //               textColor: Colors.white,
      //               fontSize: 15,
      //             );
      //             check++;
      //             setState(() {
      //               c++;
      //             });
      //           })
      //         : cart.put('totalQuantity', quantity).then((value) {
      //             Fluttertoast.showToast(
      //               msg: "Quantity increased",
      //               toastLength: Toast.LENGTH_LONG,
      //               gravity: ToastGravity.BOTTOM,
      //               timeInSecForIosWeb: 3,
      //               backgroundColor: Colors.black,
      //               textColor: Colors.white,
      //               fontSize: 15,
      //             );
      //             check++;

      //             setState(() {
      //               c++;
      //             });
      //           });
      //   } else if (cart.get(docId)[i]['size'] == 'medium' && mtap == true) {
      //     // print('medium exists at ${cart.get(docId)[i]}');
      //     int quan = cart.get(docId)[i]['quantity'];
      //     int check = 0;
      //     // print(cart.get(docId)[i]['quantity']);
      //     int total = quan + quantity;
      //     cart.get(docId)[i]['quantity'] = total;
      //     cart.containsKey('totalQuantity')
      //         ? cart
      //             .put('totalQuantity', cart.get('totalQuantity') + quantity)
      //             .then((value) {
      //             Fluttertoast.showToast(
      //               msg: "Quantity increased",
      //               toastLength: Toast.LENGTH_LONG,
      //               gravity: ToastGravity.BOTTOM,
      //               timeInSecForIosWeb: 3,
      //               backgroundColor: Colors.black,
      //               textColor: Colors.white,
      //               fontSize: 15,
      //             );
      //             check++;
      //             setState(() {
      //               c++;
      //             });
      //           })
      //         : cart.put('totalQuantity', quantity).then((value) {
      //             Fluttertoast.showToast(
      //               msg: "Quantity increased",
      //               toastLength: Toast.LENGTH_LONG,
      //               gravity: ToastGravity.BOTTOM,
      //               timeInSecForIosWeb: 3,
      //               backgroundColor: Colors.black,
      //               textColor: Colors.white,
      //               fontSize: 15,
      //             );
      //             check++;
      //             setState(() {
      //               c++;
      //             });
      //           });
      //   } else if (cart.get(docId)[i]['size'] == 'large' && ltap == true) {
      //     // print('large exists at ${cart.get(docId)[i]}');
      //     int quan = cart.get(docId)[i]['quantity'];
      //     int check = 0;
      //     // print(cart.get(docId)[i]['quantity']);
      //     int total = quan + quantity;
      //     cart.get(docId)[i]['quantity'] = total;
      //     cart.containsKey('totalQuantity')
      //         ? cart
      //             .put('totalQuantity', cart.get('totalQuantity') + quantity)
      //             .then((value) {
      //             Fluttertoast.showToast(
      //               msg: "Quantity increased",
      //               toastLength: Toast.LENGTH_LONG,
      //               gravity: ToastGravity.BOTTOM,
      //               timeInSecForIosWeb: 3,
      //               backgroundColor: Colors.black,
      //               textColor: Colors.white,
      //               fontSize: 15,
      //             );
      //             check++;
      //             setState(() {
      //               c++;
      //             });
      //           })
      //         : cart.put('totalQuantity', quantity).then((value) {
      //             Fluttertoast.showToast(
      //               msg: "Quantity increased",
      //               toastLength: Toast.LENGTH_LONG,
      //               gravity: ToastGravity.BOTTOM,
      //               timeInSecForIosWeb: 3,
      //               backgroundColor: Colors.black,
      //               textColor: Colors.white,
      //               fontSize: 15,
      //             );
      //             check++;

      //             setState(() {
      //               c++;
      //             });
      //           });
      //   } else if (stap == true && cart.get(docId)[i]['size'] != 'small' ||
      //       mtap == true && cart.get(docId)[i]['size'] != 'medium' ||
      //       ltap == true && cart.get(docId)[i]['size'] != 'large') {
      //     // print('doest exists');

      //     if (c == 0) {
      //       List<Map<String, dynamic>> map = cart.get(docId);
      //       // print(map);
      //       map.add({
      //         'size': widget.product['price'].runtimeType == int
      //             ? null
      //             : stap == true
      //                 ? 'small'
      //                 : mtap == true
      //                     ? 'medium'
      //                     : ltap == true
      //                         ? 'large'
      //                         : null,
      //         'id': docId,
      //         'quantity': quantity,
      //         'price': widget.product['price']
      //       });
      //       cart.put(docId, map).then((value) {
      //         cart.containsKey('totalQuantity')
      //             ? cart
      //                 .put(
      //                     'totalQuantity', cart.get('totalQuantity') + quantity)
      //                 .then((value) {
      //                 setState(() {});
      //               })
      //             : cart.put('totalQuantity', quantity).then((value) {
      //                 setState(() {});
      //               });
      //         Fluttertoast.showToast(
      //           msg: "Product added",
      //           toastLength: Toast.LENGTH_LONG,
      //           gravity: ToastGravity.BOTTOM,
      //           timeInSecForIosWeb: 3,
      //           backgroundColor: Colors.black,
      //           textColor: Colors.white,
      //           fontSize: 15,
      //         );
      //       });
      //     } else {}
      //   }
      // }
      // // cart.get(docId).toList().forEach((e) {});
      // // if (cart.get(docId)[0]['size'] == 'small' && stap == true) {
      // //   print('small already exist');
      // //   int quan = cart.get(docId)[0]['quantity'];
      // //   print(cart.get(docId)[0]['quantity']);
      // //   int total = quan + quantity;

      // //   print("Total $total");
      // //   cart.put(docId, [
      // //     {
      // //       'size': widget.product['price'].runtimeType == int
      // //           ? null
      // //           : stap == true
      // //               ? 'small'
      // //               : mtap == true
      // //                   ? 'medium'
      // //                   : ltap == true
      // //                       ? 'large'
      // //                       : null,
      // //       'id': docId,
      // //       'quantity': total,
      // //       'price': widget.product['price']
      // //     }
      // //   ]).then((value) {
      // //     cart.containsKey('totalQuantity')
      // //         ? cart
      // //             .put('totalQuantity', cart.get('totalQuantity') + quantity)
      // //             .then((value) {
      // //             setState(() {});
      // //           })
      // //         : cart.put('totalQuantity', quantity).then((value) {
      // //             setState(() {});
      // //           });
      // //     Fluttertoast.showToast(
      // //       msg: "Quantity increased",
      // //       toastLength: Toast.LENGTH_LONG,
      // //       gravity: ToastGravity.BOTTOM,
      // //       timeInSecForIosWeb: 3,
      // //       backgroundColor: Colors.black,
      // //       textColor: Colors.white,
      // //       fontSize: 15,
      // //     );
      // //   });

      // //   print(cart.get(docId));
      // // } else if (cart.get(docId)[0]['size'] == 'medium' && mtap == true) {
      // //   print('medium already exist');
      // // } else if (cart.get(docId)[0]['size'] == 'large' && ltap == true) {
      // //   print('large already exist');
      // // } else {
      // //   print('not exist');
      // //   // print(cart.get(docId));
      // //   List<Map<String, dynamic>> map = cart.get(docId);
      // //   print(map);
      // //   map.add({
      // //     'size': widget.product['price'].runtimeType == int
      // //         ? null
      // //         : stap == true
      // //             ? 'small'
      // //             : mtap == true
      // //                 ? 'medium'
      // //                 : ltap == true
      // //                     ? 'large'
      // //                     : null,
      // //     'id': docId,
      // //     'quantity': quantity,
      // //     'price': widget.product['price']
      // //   });
      // //   print(map);
      // //   cart.put(docId, map).then((value) {
      // //     cart.containsKey('totalQuantity')
      // //         ? cart
      // //             .put('totalQuantity', cart.get('totalQuantity') + quantity)
      // //             .then((value) {
      // //             setState(() {});
      // //           })
      // //         : cart.put('totalQuantity', quantity).then((value) {
      // //             setState(() {});
      // //           });
      // //     Fluttertoast.showToast(
      // //       msg: "Product added",
      // //       toastLength: Toast.LENGTH_LONG,
      //       gravity: ToastGravity.BOTTOM,
      //       timeInSecForIosWeb: 3,
      //       backgroundColor: Colors.black,
      //       textColor: Colors.white,
      //       fontSize: 15,
      //     );
      //   });
      // }
    } else if (cart.containsKey(docId) &&
        widget.product['price'].runtimeType == int) {
      // print('hello');
      int quan = cart.get(docId)[0]['quantity'];

      print('as');
      int total = quan + quantity;
      cart.get(docId)[0]['quantity'] = total;

      // List map = cart.get(docId);
      // print(map);
      // map.add({
      //   'size': widget.product['price'].runtimeType == int
      //       ? null
      //       : stap == true
      //           ? 'small'
      //           : mtap == true
      //               ? 'medium'
      //               : ltap == true
      //                   ? 'large'
      //                   : null,
      //   'id': docId,
      //   'quantity': quantity,
      //   'price': widget.product['price']
      // });
      // cart.put(docId, map).then((value) {
      //   cart.containsKey('totalQuantity')
      //       ? cart
      //           .put('totalQuantity', cart.get('totalQuantity') + quantity)
      //           .then((value) {
      //           setState(() {});
      //         })
      //       : cart.put('totalQuantity', quantity).then((value) {
      //           setState(() {});
      //         });
      //   EasyLoading.showToast(
      //     'Product Added',
      //     duration: Duration(seconds: 2),
      //     toastPosition: EasyLoadingToastPosition.bottom,
      //     dismissOnTap: true,
      //   );
      // });

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
      print('as1');
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

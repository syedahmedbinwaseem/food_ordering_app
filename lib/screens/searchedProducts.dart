import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

import 'package:food_ordering_app/screens/productScreen.dart';
import 'package:food_ordering_app/utils/colors.dart';

class FilterProduct extends StatefulWidget {
  final startValue;
  final endValue;
  FilterProduct(this.startValue, this.endValue);
  @override
  _FilterProductState createState() => _FilterProductState();
}

class _FilterProductState extends State<FilterProduct> {
  List types = ['Desi', 'Fastfood'];
  List products = [];
  List typess = [];

  void getAllProducts() async {
    DocumentSnapshot snap1 = await FirebaseFirestore.instance
        .collection('products')
        .doc('category')
        .get();

    List types = snap1['types'];
    types.forEach((type) async {
      QuerySnapshot abcd = await FirebaseFirestore.instance
          .collection('products')
          .doc('category')
          .collection(type)
          .get();
      abcd.docs.forEach((element) {
        setState(() {
          typess.add(type);
          products.add(element);
        });
      });
    });
  }

  getALL() async {
    DocumentSnapshot abc = await FirebaseFirestore.instance
        .collection('products')
        .doc('category')
        .get();

    List types = abc['types'];
    types.forEach(
      (element) async {
        QuerySnapshot product = await FirebaseFirestore.instance
            .collection('products')
            .doc('category')
            .collection(element)
            .get();
        setState(() {
          products.add(product);
        });
      },
    );
  }

  @override
  void initState() {
    getAllProducts();
    print(products.length);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    return SafeArea(
      child: Scaffold(
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 30,
            ),
            Container(
              height: 50,
              child: Padding(
                padding: const EdgeInsets.only(left: 15),
                child: Text(
                  'Products',
                  style:
                      TextStyle(fontFamily: 'Sofia', fontSize: width * 0.06944),
                ),
              ),
            ),
            products.isEmpty
                ? Expanded(
                    child: Center(
                    child: CircularProgressIndicator(),
                  ))
                : Expanded(
                    child: ListView.builder(
                    physics: BouncingScrollPhysics(),
                    itemCount: products.length,
                    itemBuilder: (context, index) {
                      if (products[index]['price'].runtimeType == int
                          ? products[index]['price'] > widget.startValue &&
                              products[index]['price'] < widget.endValue
                          : products[index]['price'][0] > widget.startValue &&
                                  products[index]['price'][0] < widget.endValue
                              ? products[index]['price'][1] >
                                      widget.startValue &&
                                  products[index]['price'][1] < widget.endValue
                              : products[index]['price'][2] >
                                      widget.startValue &&
                                  products[index]['price'][2] <
                                      widget.endValue) {
                        return GestureDetector(
                          onTap: () {
                            Navigator.of(context, rootNavigator: true)
                                .push(MaterialPageRoute(
                              builder: (context) => ProductScreen(
                                product: products[index],
                                category: typess[index],
                              ),
                            ));
                          },
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: 5, horizontal: 10),
                            child: Container(
                                padding: EdgeInsets.fromLTRB(10, 8, 20, 8),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20),
                                  color: primaryGreen.withOpacity(0.4),
                                ),
                                height:
                                    MediaQuery.of(context).size.width * 0.25,
                                child: Row(
                                  children: [
                                    Hero(
                                      tag: products[index].id,
                                      child: Container(
                                        height:
                                            MediaQuery.of(context).size.width *
                                                0.18,
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.18,
                                        decoration: BoxDecoration(
                                          color: primaryGreen.withOpacity(0.3),
                                          borderRadius: BorderRadius.circular(
                                              MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.180),
                                        ),
                                        child: ClipRRect(
                                          borderRadius: BorderRadius.circular(
                                              MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.180),
                                          child: CachedNetworkImage(
                                            imageUrl: products[index]
                                                ['img_link'],
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
                                                    backgroundColor:
                                                        Colors.white,
                                                    valueColor:
                                                        AlwaysStoppedAnimation<
                                                                Color>(
                                                            primaryGreen),
                                                    strokeWidth: 3,
                                                    value: downloadProgress
                                                        .progress),
                                              ),
                                            ),
                                            errorWidget:
                                                (context, url, error) =>
                                                    Icon(Icons.error),
                                          ),
                                        ),
                                      ),
                                    ),
                                    SizedBox(width: 14),
                                    Text(
                                      products[index]['name'],
                                      style: TextStyle(
                                          fontFamily: 'Sofia',
                                          fontWeight: FontWeight.bold,
                                          fontSize: 23),
                                    ),
                                    Spacer(),
                                    Text(
                                      products[index]['price'].runtimeType ==
                                              int
                                          ? 'Rs. ' +
                                              products[index]['price']
                                                  .toString()
                                          : 'From Rs. ' +
                                              products[index]['price'][0]
                                                  .toString(),
                                      style: TextStyle(
                                          fontFamily: 'Sofia',
                                          fontWeight: FontWeight.bold,
                                          fontSize: 20),
                                    )
                                  ],
                                )),
                          ),
                        );
                      } else {
                        return Container();
                      }
                    },
                  )),
          ],
        ),
      ),
    );
  }
}

class MyBehavior extends ScrollBehavior {
  @override
  Widget buildViewportChrome(
      BuildContext context, Widget child, AxisDirection axisDirection) {
    return child;
  }
}

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:food_ordering_app/screens/productScreen.dart';
import 'package:food_ordering_app/user/localUser.dart';
import 'package:food_ordering_app/utils/colors.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';

// ignore: must_be_immutable
class AllProducts extends StatefulWidget {
  String category;
  DocumentSnapshot user;
  AllProducts({this.category, this.user});
  @override
  _AllProductsState createState() => _AllProductsState();
}

class _AllProductsState extends State<AllProducts> {
  Box cart;
  int index = 0;
  Future openBox() async {
    await Hive.openBox('cart').then((value) {
      setState(() {
        cart = value;
        index = 1;
      });
    });
  }

  @override
  void initState() {
    super.initState();
    openBox();
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: MediaQuery.of(context).padding.top,
          ),
          StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection('user')
                  .doc(LocalUser.userData.email)
                  .snapshots(),
              builder: (context, snapshot) {
                return !snapshot.hasData
                    ? Center(
                        child: CircularProgressIndicator(),
                      )
                    : Padding(
                        padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
                        child: Row(
                          children: [
                            Hero(
                                tag: 'all',
                                child: Container(
                                  height: width * 0.0972,
                                  width: width * 0.0972,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(
                                          width * 0.04861),
                                      color: primaryGreen.withOpacity(0.3)),
                                  child: ClipRRect(
                                    borderRadius:
                                        BorderRadius.circular(width * 0.04861),
                                    child: Container(
                                      padding: snapshot.data['image'] == null
                                          ? EdgeInsets.all(5)
                                          : EdgeInsets.all(0),
                                      child: Center(
                                        child: snapshot.data['image'] == null
                                            ? Image.asset(
                                                LocalUser.userData.gender ==
                                                        'male'
                                                    ? 'assets/images/man.png'
                                                    : 'assets/images/woman.png')
                                            : CachedNetworkImage(
                                                imageUrl:
                                                    LocalUser.userData.image,
                                                fit: BoxFit.fill,
                                                progressIndicatorBuilder:
                                                    (context, url,
                                                            downloadProgress) =>
                                                        Center(
                                                  child: SizedBox(
                                                    height: width * 0.09722,
                                                    width: width * 0.09722,
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
                                )),
                            Spacer(),
                            Stack(children: [
                              new IconButton(
                                icon: new Icon(
                                  Icons.shopping_cart_outlined,
                                  color: primaryGreen.withOpacity(0.7),
                                ),
                                onPressed: null,
                              ),
                              index == 0
                                  ? Container()
                                  : cart.get('totalQuantity') == 0
                                      ? Container()
                                      : ValueListenableBuilder(
                                          valueListenable: cart.listenable(),
                                          builder: (context, box, widget) {
                                            return Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 2.0, top: 5),
                                              child: CircleAvatar(
                                                radius: 8.0,
                                                backgroundColor: darkGreen,
                                                foregroundColor: Colors.white,
                                                child: Text(
                                                  box
                                                      .get('totalQuantity')
                                                      .toString(),
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 10,
                                                      fontFamily: 'Sofia'),
                                                ),
                                              ),
                                            );
                                          },
                                        ),
                            ])
                          ],
                        ),
                      );
              }),
          SizedBox(height: 0),
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
            child: Text(
              'All Products',
              style: TextStyle(fontFamily: 'Sofia', fontSize: width * 0.06944),
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(8, 0, 8, 0),
              child: StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection('products')
                    .doc('category')
                    .collection(widget.category)
                    .snapshots(),
                builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                  return !snapshot.hasData
                      ? Center(child: CircularProgressIndicator())
                      : ScrollConfiguration(
                          behavior: MyBehavior(),
                          child: StaggeredGridView.countBuilder(
                            crossAxisCount: 4,
                            itemCount: snapshot.data.docs.length,
                            itemBuilder: (BuildContext context, int index) =>
                                GestureDetector(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => ProductScreen(
                                              product:
                                                  snapshot.data.docs[index],
                                              category: widget.category,
                                            )));
                              },
                              child: new Container(
                                padding: EdgeInsets.all(20),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20),
                                  color: primaryGreen.withOpacity(0.3),
                                ),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    // SizedBox(height: 20),
                                    Hero(
                                      tag: snapshot.data.docs[index].id,
                                      child: Container(
                                        height: width * 0.333333,
                                        width: width * 0.333333,
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(
                                              width * 0.166666),
                                          // color: Colors.pink,
                                        ),
                                        child: ClipRRect(
                                          borderRadius: BorderRadius.circular(
                                              width * 0.166666),
                                          child: CachedNetworkImage(
                                            imageUrl: snapshot.data.docs[index]
                                                ['img_link'],
                                            fit: BoxFit.cover,
                                            progressIndicatorBuilder: (context,
                                                    url, downloadProgress) =>
                                                Center(
                                              child: SizedBox(
                                                height: width * 0.09722,
                                                width: width * 0.09722,
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
                                    SizedBox(height: width * 0.055555),
                                    Text(
                                      snapshot.data.docs[index]['name'],
                                      style: TextStyle(
                                          fontFamily: 'Sofia',
                                          fontSize: 23,
                                          color: darkGreen),
                                    ),
                                    SizedBox(height: width * 0.027777),
                                    Text(
                                      snapshot.data.docs[index]['price']
                                                  .runtimeType ==
                                              int
                                          ? 'Rs. ${snapshot.data.docs[index]['price']}'
                                          : 'From Rs. ${snapshot.data.docs[index]['price'][0]}',
                                      style: TextStyle(
                                          fontFamily: 'Sofia',
                                          fontSize: 20,
                                          color: Colors.black),
                                    )
                                  ],
                                ),
                              ),
                            ),
                            staggeredTileBuilder: (int index) =>
                                new StaggeredTile.count(2, 3),
                            mainAxisSpacing: width * 0.022222,
                            crossAxisSpacing: width * 0.022222,
                          ),
                        );
                },
              ),
            ),
            // child: SingleChildScrollView(
            //   child: Container(
            //     height: MediaQuery.of(context).size.height,
            //     width: MediaQuery.of(context).size.width,
            //     // color: Colors.pink,
            //     padding: EdgeInsets.fromLTRB(5, 10, 5, 10),
            //     child: Row(
            //       mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            //       children: [
            //         Expanded(
            //           flex: 1,
            //           child: Container(
            //             color: Colors.yellow,
            //           ),
            //         ),
            //         SizedBox(width: 8),
            //         Expanded(
            //           flex: 1,
            //           child: Container(
            //             color: Colors.purple,
            //           ),
            //         )
            //       ],
            //     ),
            //   ),
            // ),
          )
        ],
      ),
    );
  }
}

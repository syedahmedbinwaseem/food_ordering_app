import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:food_ordering_app/screens/productScreen.dart';
import 'package:food_ordering_app/utils/colors.dart';

class SearchScreen extends StatefulWidget {
  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  TextEditingController searchController = TextEditingController();
  String keyword = '';
  List types = ['Desi', 'Fastfood'];
  List products = [];
  List typess = [];

  Stream<QuerySnapshot> stream() {
    return FirebaseFirestore.instance
        .collection('products')
        .doc('category')
        .collection('Desi')
        .snapshots();
  }

  @override
  void initState() {
    super.initState();
    getAllProducts();
    searchController.addListener(() {
      setState(() {
        keyword = searchController.text;
      });
    });
  }

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: EdgeInsets.fromLTRB(
            14, MediaQuery.of(context).padding.top + 10, 14, 10),
        child: Column(
          children: [
            Row(
              children: [
                Hero(
                  tag: 'search',
                  child: Container(
                    padding: EdgeInsets.only(left: 5),
                    width: MediaQuery.of(context).size.width * 0.76,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.grey.withOpacity(0.2),
                    ),
                    child: TextField(
                      autofocus: true,
                      controller: searchController,
                      textCapitalization: TextCapitalization.sentences,
                      style: TextStyle(fontFamily: 'Sofia'),
                      decoration: InputDecoration(
                          suffixIcon: IconButton(
                            iconSize: 15,
                            onPressed: searchController.clear,
                            icon: Icon(Icons.clear),
                          ),
                          contentPadding: EdgeInsets.only(top: 17),
                          prefixIcon: Icon(Icons.search),
                          border: InputBorder.none,
                          focusedBorder: InputBorder.none,
                          enabledBorder: InputBorder.none,
                          errorBorder: InputBorder.none,
                          disabledBorder: InputBorder.none,
                          hintText: 'Search',
                          hintStyle: TextStyle(fontFamily: 'Sofia')),
                    ),
                  ),
                ),
                SizedBox(width: 10),
                Expanded(
                    child: FlatButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  padding: EdgeInsets.all(0),
                  minWidth: 40,
                  child: Text(
                    'Cancel',
                    style: TextStyle(
                        fontFamily: 'Sofia', color: primaryGreen, fontSize: 17),
                  ),
                )),
              ],
            ),
            Divider(),
            products.isEmpty
                ? Expanded(child: Center(child: CircularProgressIndicator()))
                : Expanded(
                    child: GestureDetector(
                      onTap: () {
                        FocusScope.of(context).unfocus();
                      },
                      child: Container(
                        padding: EdgeInsets.all(0),
                        child: ListView.builder(
                          padding: EdgeInsets.all(0),
                          itemCount: products.length,
                          itemBuilder: (context, index) {
                            if (keyword.isEmpty)
                              return Container();
                            else if (products[index]['name']
                                .toString()
                                .toLowerCase()
                                .contains(keyword.toLowerCase()))
                              return Padding(
                                padding: const EdgeInsets.fromLTRB(0, 0, 0, 8),
                                child: FlatButton(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  onPressed: () {
                                    FocusScope.of(context).unfocus();
                                    Navigator.of(context, rootNavigator: true)
                                        .push(MaterialPageRoute(
                                      builder: (context) => ProductScreen(
                                        product: products[index],
                                        category: typess[index],
                                      ),
                                    ));
                                  },
                                  padding: EdgeInsets.all(0),
                                  child: Container(
                                      padding:
                                          EdgeInsets.fromLTRB(10, 8, 20, 8),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(20),
                                        color: primaryGreen.withOpacity(0.4),
                                      ),
                                      height:
                                          MediaQuery.of(context).size.width *
                                              0.25,
                                      child: Row(
                                        children: [
                                          Hero(
                                            tag: products[index].id,
                                            child: Container(
                                              height: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.18,
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.18,
                                              decoration: BoxDecoration(
                                                color: primaryGreen
                                                    .withOpacity(0.3),
                                                borderRadius:
                                                    BorderRadius.circular(
                                                        MediaQuery.of(context)
                                                                .size
                                                                .width *
                                                            0.180),
                                              ),
                                              child: ClipRRect(
                                                borderRadius:
                                                    BorderRadius.circular(
                                                        MediaQuery.of(context)
                                                                .size
                                                                .width *
                                                            0.180),
                                                child: CachedNetworkImage(
                                                  imageUrl: products[index]
                                                      ['img_link'],
                                                  fit: BoxFit.cover,
                                                  progressIndicatorBuilder:
                                                      (context, url,
                                                              downloadProgress) =>
                                                          Center(
                                                    child: SizedBox(
                                                      height:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .width *
                                                              0.0972,
                                                      width:
                                                          MediaQuery.of(context)
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
                                                          value:
                                                              downloadProgress
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
                                            products[index]['price']
                                                        .runtimeType ==
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
                            else
                              return Container();
                          },
                        ),
                      ),
                    ),
                  )
          ],
        ),
      ),
    );
  }
}

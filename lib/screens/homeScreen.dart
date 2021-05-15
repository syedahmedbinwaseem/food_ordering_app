import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:food_ordering_app/screens/allProducts.dart';
import 'package:food_ordering_app/screens/productScreen.dart';
import 'package:food_ordering_app/user/localUser.dart';
import 'package:food_ordering_app/utils/colors.dart';
import 'package:hive/hive.dart';
import 'package:tab_indicator_styler/tab_indicator_styler.dart';

// ignore: must_be_immutable
class HomePage extends StatefulWidget {
  String name;
  String gender;
  DocumentSnapshot user;
  HomePage({@required this.name, @required this.gender, this.user});
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with TickerProviderStateMixin {
  TabController _tabController;

  Box cart;

  void openBox() async {
    await Hive.openBox('cart').then((value) {
      setState(() {
        cart = value;
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
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        automaticallyImplyLeading: false,
        // leading: Container(
        //   padding: EdgeInsets.fromLTRB(10, 19, 19, 19),
        //   child: Image.asset('assets/images/four-dots.png'),
        // ),
        actions: [
          LocalUser.userData.image == null
              ? Container(
                  padding: EdgeInsets.only(top: 15, left: 5),
                  decoration: BoxDecoration(
                      color: primaryGreen,
                      borderRadius:
                          BorderRadius.only(bottomLeft: Radius.circular(30))),
                  height: 1000,
                  width: 50,
                  child: ClipRRect(
                    borderRadius:
                        BorderRadius.only(bottomLeft: Radius.circular(30)),
                    child: Image.asset(LocalUser.userData.gender == 'male'
                        ? 'assets/images/man.png'
                        : 'assets/images/woman.png'),
                  ),
                )
              : Container(
                  // padding: EdgeInsets.only(top: 15, left: 5),
                  decoration: BoxDecoration(
                      color: primaryGreen,
                      borderRadius:
                          BorderRadius.only(bottomLeft: Radius.circular(30))),
                  height: 1000,
                  width: 50,
                  child: ClipRRect(
                    borderRadius:
                        BorderRadius.only(bottomLeft: Radius.circular(30)),
                    // child: Image.asset(LocalUser.userData.gender == 'male'
                    //     ? 'assets/images/man.png'
                    //     : 'assets/images/woman.png'),

                    child: CachedNetworkImage(
                      imageUrl: LocalUser.userData.image,
                      fit: BoxFit.cover,
                      progressIndicatorBuilder:
                          (context, url, downloadProgress) => Center(
                        child: SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                              backgroundColor: Colors.white,
                              valueColor:
                                  AlwaysStoppedAnimation<Color>(primaryGreen),
                              strokeWidth: 3,
                              value: downloadProgress.progress),
                        ),
                      ),
                      errorWidget: (context, url, error) => Icon(Icons.error),
                    ),
                  ),
                ),
        ],
      ),
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.fromLTRB(14, 20, 14, 10),
        child: GestureDetector(
          onTap: () {
            FocusScope.of(context).unfocus();
          },
          child: Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            color: Colors.white,
            child: ScrollConfiguration(
              behavior: MyBehavior(),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    StreamBuilder(
                      stream: FirebaseFirestore.instance
                          .collection('user')
                          .doc(LocalUser.userData.email)
                          .snapshots(),
                      builder:
                          (context, AsyncSnapshot<DocumentSnapshot> snapshot) {
                        return !snapshot.hasData
                            ? Text(
                                'Loading',
                                style: TextStyle(
                                    fontFamily: 'Sofia',
                                    fontSize:
                                        MediaQuery.of(context).size.width *
                                            0.0549,
                                    fontWeight: FontWeight.w100,
                                    color: darkGreen),
                              )
                            : Text(
                                'Hello, ${snapshot.data['firstName']}',
                                style: TextStyle(
                                    fontFamily: 'Sofia',
                                    fontSize:
                                        MediaQuery.of(context).size.width *
                                            0.0549,
                                    fontWeight: FontWeight.w100,
                                    color: darkGreen),
                              );
                      },
                    ),
                    SizedBox(height: 7),
                    Text(
                      'Today\'s Special',
                      style: TextStyle(
                          fontFamily: 'Sofia',
                          fontSize: MediaQuery.of(context).size.width * 0.06868,
                          fontWeight: FontWeight.bold,
                          color: darkGreen),
                    ),
                    SizedBox(height: 15),
                    Text(
                      'Find your food',
                      style: TextStyle(
                          fontFamily: 'Sofia',
                          fontSize: MediaQuery.of(context).size.width * 0.03571,
                          fontWeight: FontWeight.w300,
                          color: lightBlue),
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.width * 0.0549,
                    ),
                    Container(
                      height: 50,
                      width: MediaQuery.of(context).size.width,
                      child: Row(
                        children: [
                          Container(
                            padding: EdgeInsets.only(left: 5),
                            width: MediaQuery.of(context).size.width * 0.75,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: Colors.grey.withOpacity(0.2),
                            ),
                            child: TextField(
                              textCapitalization: TextCapitalization.sentences,
                              style: TextStyle(fontFamily: 'Sofia'),
                              decoration: InputDecoration(
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
                          SizedBox(
                              width:
                                  MediaQuery.of(context).size.width * 0.02747),
                          Expanded(
                            // ignore: deprecated_member_use
                            child: FlatButton(
                              color: primaryGreen,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10)),
                              onPressed: () {},
                              child: Container(
                                child: Center(
                                  child:
                                      Image.asset('assets/images/filter.png'),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                        height: MediaQuery.of(context).size.width * 0.02747),
                    Container(
                      height: 400,
                      child: StreamBuilder(
                          stream: FirebaseFirestore.instance
                              .collection('products')
                              .doc('category')
                              .snapshots(),
                          builder: (context, snapshot1) {
                            !snapshot1.hasData
                                // ignore: unnecessary_statements
                                ? null
                                : _tabController = new TabController(
                                    vsync: this,
                                    length: snapshot1.data['types'].length);

                            return !snapshot1.hasData
                                ? Center(
                                    child: CircularProgressIndicator(),
                                  )
                                : DefaultTabController(
                                    length: snapshot1.data['types'].length,
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Container(
                                          child: TabBar(
                                              controller: _tabController,
                                              isScrollable: true,
                                              labelStyle: TextStyle(
                                                fontFamily: 'Sofia',
                                                fontWeight: FontWeight.bold,
                                              ),
                                              unselectedLabelStyle: TextStyle(
                                                  fontFamily: 'Sofia',
                                                  fontWeight: FontWeight.w600,
                                                  color: lightBlue),
                                              indicator: DotIndicator(
                                                  distanceFromCenter: 13,
                                                  color: primaryGreen),
                                              tabs: <Widget>[
                                                for (int i = 0;
                                                    i <
                                                        snapshot1.data['types']
                                                            .length;
                                                    i++)
                                                  Tab(
                                                    child: Text(snapshot1
                                                        .data['types'][i]),
                                                  )
                                              ]),
                                        ),
                                        Container(
                                          height: 340,
                                          child: TabBarView(
                                            controller: _tabController,
                                            physics:
                                                NeverScrollableScrollPhysics(),
                                            children: List<Widget>.generate(
                                                snapshot1.data['types'].length,
                                                (index) {
                                              return Container(
                                                child: StreamBuilder(
                                                  stream: FirebaseFirestore
                                                      .instance
                                                      .collection('products')
                                                      .doc('category')
                                                      .collection(snapshot1
                                                          .data['types'][index])
                                                      .snapshots(),
                                                  builder: (context,
                                                      AsyncSnapshot<
                                                              QuerySnapshot>
                                                          snapshot) {
                                                    return !snapshot.hasData
                                                        ? Center(
                                                            child:
                                                                CircularProgressIndicator())
                                                        : snapshot.data.docs
                                                                .isEmpty
                                                            ? Center(
                                                                child: Text(
                                                                'Some amazing products are coming your way!',
                                                                style: TextStyle(
                                                                    fontFamily:
                                                                        'Sofia',
                                                                    fontSize:
                                                                        15),
                                                              ))
                                                            : ScrollConfiguration(
                                                                behavior:
                                                                    MyBehavior(),
                                                                child:
                                                                    CustomScrollView(
                                                                  scrollDirection:
                                                                      Axis.horizontal,
                                                                  slivers: [
                                                                    SliverFixedExtentList(
                                                                        delegate:
                                                                            SliverChildBuilderDelegate(
                                                                          (context,
                                                                              index) {
                                                                            return Padding(
                                                                                padding: const EdgeInsets.all(8.0),
                                                                                child: GestureDetector(
                                                                                  onTap: () {
                                                                                    Navigator.of(context, rootNavigator: true).push(MaterialPageRoute(
                                                                                      builder: (context) => ProductScreen(
                                                                                        product: snapshot.data.docs[index],
                                                                                        category: snapshot1.data['types'][_tabController.index],
                                                                                      ),
                                                                                    ));
                                                                                  },
                                                                                  child: Container(
                                                                                      decoration: BoxDecoration(
                                                                                        color: primaryGreen.withOpacity(0.3),
                                                                                        borderRadius: BorderRadius.circular(15),
                                                                                      ),
                                                                                      child: Padding(
                                                                                        padding: const EdgeInsets.only(left: 20, right: 20, bottom: 15),
                                                                                        child: Column(
                                                                                          crossAxisAlignment: CrossAxisAlignment.start,
                                                                                          children: [
                                                                                            SizedBox(height: 10),
                                                                                            Align(
                                                                                              alignment: Alignment.center,
                                                                                              child: Hero(
                                                                                                tag: snapshot.data.docs[index].id,
                                                                                                child: Container(
                                                                                                  height: 150,
                                                                                                  width: 150,
                                                                                                  decoration: BoxDecoration(
                                                                                                    borderRadius: BorderRadius.circular(75),
                                                                                                  ),
                                                                                                  child: ClipRRect(
                                                                                                    borderRadius: BorderRadius.circular(75),
                                                                                                    child: CachedNetworkImage(
                                                                                                      imageUrl: snapshot.data.docs[index]['img_link'],
                                                                                                      fit: BoxFit.cover,
                                                                                                      progressIndicatorBuilder: (context, url, downloadProgress) => Center(
                                                                                                        child: SizedBox(
                                                                                                          height: 35,
                                                                                                          width: 35,
                                                                                                          child: CircularProgressIndicator(backgroundColor: Colors.white, valueColor: AlwaysStoppedAnimation<Color>(primaryGreen), strokeWidth: 3, value: downloadProgress.progress),
                                                                                                        ),
                                                                                                      ),
                                                                                                      errorWidget: (context, url, error) => Icon(Icons.error),
                                                                                                    ),
                                                                                                  ),
                                                                                                ),
                                                                                              ),
                                                                                            ),
                                                                                            SizedBox(height: 25),
                                                                                            Text(
                                                                                              snapshot.data.docs[index]['name'],
                                                                                              style: TextStyle(fontFamily: 'Sofia', fontSize: 25, color: darkGreen),
                                                                                            ),
                                                                                            SizedBox(height: 5),
                                                                                            Container(
                                                                                              // color: Colors.pink,
                                                                                              height: 50,
                                                                                              child: Text(
                                                                                                snapshot.data.docs[index]['description'],
                                                                                                overflow: TextOverflow.ellipsis,
                                                                                                maxLines: 3,
                                                                                                style: TextStyle(
                                                                                                  fontFamily: 'Sofia',
                                                                                                  fontSize: snapshot.data.docs[index]['price'].runtimeType == int ? 14 : 13,
                                                                                                ),
                                                                                              ),
                                                                                            ),
                                                                                            snapshot.data.docs[index]['price'].runtimeType == int ? Container() : SizedBox(height: 0),
                                                                                            Flexible(
                                                                                              child: Hero(
                                                                                                tag: snapshot.data.docs[index]['price'],
                                                                                                child: Align(
                                                                                                  alignment: Alignment.bottomLeft,
                                                                                                  child: Text(
                                                                                                    snapshot.data.docs[index]['price'].runtimeType == int ? 'Rs. ${snapshot.data.docs[index]['price']}' : 'From Rs. ${snapshot.data.docs[index]['price'][0]}',
                                                                                                    style: TextStyle(fontFamily: 'Sofia', fontSize: snapshot.data.docs[index]['price'].runtimeType == int ? 23 : 20),
                                                                                                  ),
                                                                                                ),
                                                                                              ),
                                                                                            )
                                                                                          ],
                                                                                        ),
                                                                                      )),
                                                                                ));
                                                                          },
                                                                          childCount: snapshot.data.docs.length == 1
                                                                              ? 1
                                                                              : snapshot.data.docs.length == 2
                                                                                  ? 2
                                                                                  : snapshot.data.docs.length > 2
                                                                                      ? 2
                                                                                      : 2,
                                                                        ),
                                                                        itemExtent:
                                                                            220),
                                                                    SliverFillRemaining(
                                                                      hasScrollBody:
                                                                          false,
                                                                      child: snapshot.data.docs.length >
                                                                              2
                                                                          ? Align(
                                                                              alignment: Alignment.center,
                                                                              child: Column(
                                                                                mainAxisAlignment: MainAxisAlignment.center,
                                                                                children: [
                                                                                  Padding(
                                                                                      padding: const EdgeInsets.fromLTRB(20, 0, 20, 10),
                                                                                      child: Hero(
                                                                                        tag: 'all',
                                                                                        child: ClipOval(
                                                                                          child: Material(
                                                                                            color: primaryGreen.withOpacity(0.3),
                                                                                            child: InkWell(
                                                                                              splashColor: blue,
                                                                                              child: SizedBox(
                                                                                                  width: 56,
                                                                                                  height: 56,
                                                                                                  child: Icon(
                                                                                                    Icons.arrow_forward_ios_outlined,
                                                                                                    color: darkGreen,
                                                                                                    size: 20,
                                                                                                  )),
                                                                                              onTap: () {
                                                                                                Navigator.of(context, rootNavigator: true).push(MaterialPageRoute(
                                                                                                    builder: (context) => AllProducts(
                                                                                                          category: snapshot1.data['types'][_tabController.index],
                                                                                                          user: widget.user,
                                                                                                        )));
                                                                                              },
                                                                                            ),
                                                                                          ),
                                                                                        ),
                                                                                      )),
                                                                                  Text(
                                                                                    'See all',
                                                                                    style: TextStyle(fontFamily: 'Sofia'),
                                                                                  )
                                                                                ],
                                                                              ))
                                                                          : Container(),
                                                                    )
                                                                  ],
                                                                ),
                                                              );
                                                  },
                                                ),
                                              );
                                            }),
                                          ),
                                        )
                                      ],
                                    ),
                                  );
                          }),
                    )
                  ],
                ),
              ),
            ),
          ),
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

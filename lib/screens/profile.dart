import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:food_ordering_app/screens/authScreen.dart';
import 'package:food_ordering_app/screens/bottomNavigator.dart';
import 'package:food_ordering_app/screens/homeScreen.dart';
import 'package:food_ordering_app/screens/signUp.dart';
import 'package:food_ordering_app/user/localUser.dart';
import 'package:food_ordering_app/utils/colors.dart';
import 'package:food_ordering_app/utils/toast.dart';
import 'package:hive/hive.dart';
import 'package:image_picker/image_picker.dart';

// ignore: must_be_immutable
class Profile extends StatefulWidget {
  DocumentSnapshot user;

  Profile({this.user});
  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  Box cart;

  Future openBox() async {
    await Hive.openBox('cart').then((value) {
      setState(() {
        cart = value;
      });
    });
  }

  GlobalKey<FormState> fKey = GlobalKey<FormState>();
  BottomNavigator bottom = BottomNavigator();
  final picker = ImagePicker();

  bool imageValue = false;
  final _mobileFormatter = PhoneNumberTextInputFormatter();
  bool isLoading = false;
  FToast fToast;
  File _image;
  bool added = false;
  String imagePath;

  Future uploadFile() async {
    if (_image == null) {
      return 'as';
    } else {
      try {
        Reference storageReference = FirebaseStorage.instance
            .ref()
            .child('User Images/${Timestamp.now().toString()}');
        UploadTask uploadTask = storageReference.putFile(_image);
        await uploadTask.whenComplete(() async {
          await storageReference.getDownloadURL().then((value) {
            imagePath = value;
          });
        });
        LocalUser.userData.image = imagePath;
      } catch (e) {
        Fluttertoast.showToast(
          msg: 'not',
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 3,
          backgroundColor: Colors.red[400],
          textColor: Colors.white,
          fontSize: 15,
        );
      }
    }
  }

  Future getImage() async {
    final pickedFile = await picker.getImage(source: ImageSource.gallery);

    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
        setState(() {
          added = true;
        });
      } else {
        fToast.showToast(
          child: ToastWidget.toast(
              'Cannot add image', Icon(Icons.error, size: 20)),
          toastDuration: Duration(seconds: 2),
          gravity: ToastGravity.CENTER,
        );
      }
    });
  }

  @override
  void initState() {
    super.initState();
    fToast = FToast();
    fToast.init(context);
    openBox();
  }

  generateBottomSheet(double height, double width) {
    TextEditingController fname =
        TextEditingController(text: LocalUser.userData.firstName);
    TextEditingController lname =
        TextEditingController(text: LocalUser.userData.lastName);
    TextEditingController phone =
        TextEditingController(text: LocalUser.userData.phone);

    showModalBottomSheet(
        useRootNavigator: true,
        isScrollControlled: true,
        context: context,
        builder: (context) {
          return StatefulBuilder(
            builder: (context, setState) {
              return AnimatedPadding(
                padding: MediaQuery.of(context).viewInsets,
                duration: const Duration(milliseconds: 100),
                curve: Curves.decelerate,
                child: GestureDetector(
                  onTap: () {
                    FocusScope.of(context).unfocus();
                  },
                  child: Stack(
                    children: [
                      SingleChildScrollView(
                        child: Container(
                          padding: EdgeInsets.all(20),
                          color: Colors.white,
                          height: MediaQuery.of(context).size.height - height,
                          child: Form(
                            key: fKey,
                            child: SingleChildScrollView(
                              child: Column(
                                children: [
                                  SizedBox(height: 20),
                                  Center(
                                    child: Stack(
                                      children: [
                                        Center(
                                          child: Container(
                                            height: width * 0.2777777,
                                            width: width * 0.2777777,

                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(
                                                      width * 0.138888),
                                              color:
                                                  primaryGreen.withOpacity(0.3),
                                            ),
                                            // ignore: deprecated_member_use
                                            child: FlatButton(
                                              padding:
                                                  LocalUser.userData.image ==
                                                              null &&
                                                          added == false &&
                                                          _image == null
                                                      ? EdgeInsets.all(10)
                                                      : EdgeInsets.all(0),
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(
                                                        width * 0.138888),
                                              ),
                                              onHighlightChanged: (value) {
                                                setState(() {
                                                  imageValue = value;
                                                });
                                              },
                                              onPressed: () {
                                                getImage().then((value) {
                                                  setState(() {});
                                                });
                                              },
                                              child: ClipRRect(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          width * 0.138888),
                                                  child: Center(
                                                      child: LocalUser.userData
                                                                      .image !=
                                                                  null &&
                                                              added == false
                                                          ? CachedNetworkImage(
                                                              imageUrl:
                                                                  LocalUser
                                                                      .userData
                                                                      .image,
                                                              fit: BoxFit.fill,
                                                              progressIndicatorBuilder:
                                                                  (context, url,
                                                                          downloadProgress) =>
                                                                      Center(
                                                                child: SizedBox(
                                                                  height: width *
                                                                      0.09722,
                                                                  width: width *
                                                                      0.09722,
                                                                  child: CircularProgressIndicator(
                                                                      backgroundColor:
                                                                          Colors
                                                                              .white,
                                                                      valueColor:
                                                                          AlwaysStoppedAnimation<Color>(
                                                                              primaryGreen),
                                                                      strokeWidth:
                                                                          3,
                                                                      value: downloadProgress
                                                                          .progress),
                                                                ),
                                                              ),
                                                              errorWidget: (context,
                                                                      url,
                                                                      error) =>
                                                                  Icon(Icons
                                                                      .error),
                                                            )
                                                          : _image == null ||
                                                                  _image.toString() ==
                                                                      ''
                                                              ? Image.asset(LocalUser
                                                                          .userData
                                                                          .gender ==
                                                                      "male"
                                                                  ? 'assets/images/man.png'
                                                                  : 'assets/images/woman.png')
                                                              : Image.file(
                                                                  _image,
                                                                  fit: BoxFit
                                                                      .fill,
                                                                ))),
                                            ),
                                          ),
                                        ),
                                        imageValue == true
                                            ? Center(
                                                child: Container(
                                                  height: width * 0.2777777,
                                                  width: width * 0.2777777,
                                                  color: Colors.white
                                                      .withOpacity(0.3),
                                                  child: Center(
                                                      child: Icon(Icons.edit)),
                                                ),
                                              )
                                            : Container()
                                      ],
                                    ),
                                  ),
                                  SizedBox(height: 20),
                                  SizedBox(width: width * 0.04166),
                                  Text(
                                    LocalUser.userData.email,
                                    style: TextStyle(
                                        fontFamily: 'Sofia',
                                        fontSize: width * 0.04166),
                                  ),
                                  SizedBox(height: 20),
                                  TextFormField(
                                    textCapitalization:
                                        TextCapitalization.sentences,
                                    keyboardType: TextInputType.text,
                                    textInputAction: TextInputAction.next,
                                    style: TextStyle(fontFamily: 'Sofia'),
                                    validator: (value) {
                                      return value.isEmpty
                                          ? 'First name is required'
                                          : null;
                                    },
                                    controller: fname,
                                    decoration: InputDecoration(
                                      errorStyle: TextStyle(
                                          fontFamily: 'Sofia',
                                          color: Colors.red,
                                          fontSize: 14),
                                      labelText: 'First Name',
                                      labelStyle: TextStyle(
                                          fontFamily: 'Sofia',
                                          color: Colors.black,
                                          fontSize: 14),
                                    ),
                                  ),
                                  TextFormField(
                                    textCapitalization:
                                        TextCapitalization.sentences,
                                    keyboardType: TextInputType.text,
                                    textInputAction: TextInputAction.next,
                                    style: TextStyle(fontFamily: 'Sofia'),
                                    validator: (value) {
                                      return value.isEmpty
                                          ? 'Last name is required'
                                          : null;
                                    },
                                    controller: lname,
                                    decoration: InputDecoration(
                                      errorStyle: TextStyle(
                                          fontFamily: 'Sofia',
                                          color: Colors.red,
                                          fontSize: 14),
                                      labelText: 'Last Name',
                                      labelStyle: TextStyle(
                                          fontFamily: 'Sofia',
                                          color: Colors.black,
                                          fontSize: 14),
                                    ),
                                  ),
                                  TextFormField(
                                    textInputAction: TextInputAction.done,
                                    inputFormatters: <TextInputFormatter>[
                                      FilteringTextInputFormatter.digitsOnly,
                                      _mobileFormatter,
                                      LengthLimitingTextInputFormatter(12),
                                    ],
                                    keyboardType:
                                        TextInputType.numberWithOptions(),
                                    style: TextStyle(fontFamily: 'Sofia'),
                                    validator: (value) {
                                      return value.isEmpty
                                          ? 'Number is required'
                                          : value.length < 12
                                              ? 'Invalid number'
                                              : null;
                                    },
                                    controller: phone,
                                    decoration: InputDecoration(
                                      errorStyle: TextStyle(
                                          fontFamily: 'Sofia',
                                          color: Colors.red,
                                          fontSize: 14),
                                      labelText: 'Phone',
                                      labelStyle: TextStyle(
                                          fontFamily: 'Sofia',
                                          color: Colors.black,
                                          fontSize: 14),
                                    ),
                                  ),
                                  SizedBox(height: 20),
                                  // ignore: deprecated_member_use
                                  FlatButton(
                                    onPressed: () async {
                                      FocusScope.of(context).unfocus();
                                      setState(() {
                                        isLoading = true;
                                      });
                                      if (fKey.currentState.validate()) {
                                        // logIn();
                                        LocalUser.userData.firstName =
                                            fname.text;
                                        LocalUser.userData.lastName =
                                            lname.text;
                                        LocalUser.userData.phone = phone.text;
                                        await uploadFile().then((value) {
                                          // imagePath == null
                                          //     ? null
                                          //     : LocalUser.userData.image =
                                          //         imagePath;

                                          FirebaseFirestore.instance
                                              .collection('user')
                                              .doc(LocalUser.userData.email)
                                              .update({
                                            'firstName': fname.text,
                                            'lastName': lname.text,
                                            'phone': phone.text,
                                            // imagePath == null ? null : 'image':
                                            //     imagePath
                                            'image': imagePath == null
                                                ? LocalUser.userData.image
                                                : imagePath
                                          });
                                          fToast.showToast(
                                            child: ToastWidget.toast(
                                                'Profile updated',
                                                Icon(Icons.done, size: 20)),
                                            toastDuration: Duration(seconds: 2),
                                            gravity: ToastGravity.BOTTOM,
                                          );
                                          setState(() {
                                            isLoading = false;
                                          });
                                          Navigator.pop(context);
                                        });
                                      } else {
                                        setState(() {
                                          isLoading = false;
                                        });
                                      }
                                    },
                                    height: 40,
                                    color: primaryGreen,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(5),
                                    ),
                                    child: Center(
                                      child: isLoading == true
                                          ? Container(
                                              height: 40,
                                              width: 40,
                                              padding: EdgeInsets.all(10),
                                              child: CircularProgressIndicator(
                                                valueColor:
                                                    AlwaysStoppedAnimation<
                                                        Color>(Colors.white),
                                              ),
                                            )
                                          : Text(
                                              'SAVE',
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
                          ),
                        ),
                      ),
                      isLoading == true
                          ? Container(
                              height:
                                  MediaQuery.of(context).size.height - height,
                              width: MediaQuery.of(context).size.width,
                              color: Colors.transparent)
                          : Container(
                              height:
                                  MediaQuery.of(context).size.height - height,
                            ),
                    ],
                  ),
                ),
              );
            },
          );
        }).then((value) {
      setState(() {
        isLoading = false;
        added = false;
        _image = null;
        imagePath = null;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double app = AppBar().preferredSize.height;
    double total = app + MediaQuery.of(context).padding.top;
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          title: Padding(
            padding: const EdgeInsets.only(top: 5),
            child: Text(
              'Profile',
              style: TextStyle(fontFamily: 'Sofia', fontSize: 22),
            ),
          ),
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
          actions: [
            IconButton(
                icon: Icon(
                  Icons.edit,
                  color: blue,
                ),
                onPressed: () {
                  generateBottomSheet(total, width);
                })
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.only(bottom: 10),
          child: StreamBuilder(
            stream: FirebaseFirestore.instance
                .collection('user')
                .doc(LocalUser.userData.email)
                .snapshots(),
            builder: (context, AsyncSnapshot<DocumentSnapshot> snapshot) {
              return !snapshot.hasData
                  ? Center(
                      child: CircularProgressIndicator(),
                    )
                  : ScrollConfiguration(
                      behavior: MyBehavior(),
                      child: ListView(
                        children: [
                          Padding(
                            padding: EdgeInsets.fromLTRB(20, 8, 20, 0),
                            child: Container(
                              height: width * 0.46,
                              width: width,
                              // color: Colors.pink,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Container(
                                        height: width * 0.222222,
                                        width: width * 0.222222,
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(
                                              width * 0.111111),
                                          color: primaryGreen.withOpacity(0.3),
                                        ),
                                        padding: snapshot.data
                                                        .data()
                                                        .containsKey('image') ==
                                                    true &&
                                                snapshot.data['image'] != null
                                            ? EdgeInsets.all(0)
                                            : EdgeInsets.all(10),
                                        child: ClipRRect(
                                            borderRadius: BorderRadius.circular(
                                                width * 0.111111),
                                            child: snapshot.data
                                                            .data()
                                                            .containsKey(
                                                                'image') ==
                                                        true &&
                                                    snapshot.data['image'] !=
                                                        null
                                                ? CachedNetworkImage(
                                                    imageUrl:
                                                        snapshot.data['image'],
                                                    fit: BoxFit.cover,
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
                                                            value:
                                                                downloadProgress
                                                                    .progress),
                                                      ),
                                                    ),
                                                    errorWidget:
                                                        (context, url, error) =>
                                                            Icon(Icons.error),
                                                  )
                                                : Image.asset(snapshot
                                                            .data['gender'] ==
                                                        "male"
                                                    ? 'assets/images/man.png'
                                                    : 'assets/images/woman.png')),
                                      ),
                                      SizedBox(width: width * 0.0555),
                                      Text(
                                        snapshot.data['firstName'] +
                                            ' ' +
                                            snapshot.data['lastName'],
                                        style: TextStyle(
                                            fontFamily: 'Sofia',
                                            fontWeight: FontWeight.bold,
                                            fontSize: width * 0.06111),
                                      )
                                    ],
                                  ),
                                  SizedBox(height: width * 0.0555),
                                  Row(
                                    children: [
                                      SizedBox(width: width * 0.01388),
                                      Icon(
                                        Icons.phone,
                                        color: blue,
                                        size: 20,
                                      ),
                                      SizedBox(width: width * 0.04166),
                                      Text(
                                        snapshot.data['phone'],
                                        style: TextStyle(
                                            fontFamily: 'Sofia', fontSize: 15),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: width * 0.0277),
                                  Row(
                                    children: [
                                      SizedBox(width: 5),
                                      Icon(
                                        Icons.email_outlined,
                                        color: blue,
                                        size: width * 0.0555,
                                      ),
                                      SizedBox(width: width * 0.04166),
                                      Text(
                                        snapshot.data['email'],
                                        style: TextStyle(
                                            fontFamily: 'Sofia', fontSize: 15),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Divider(
                            color: blue.withOpacity(0.3),
                            thickness: 1,
                            indent: 0,
                            height: 0,
                          ),
                          Container(
                            height: width * 0.180,
                            // color: Colors.yellow,
                            width: width,
                            child: Row(
                              // mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Expanded(
                                  // ignore: deprecated_member_use
                                  child: FlatButton(
                                    splashColor: primaryGreen.withOpacity(0.3),
                                    focusColor: primaryGreen.withOpacity(0.3),
                                    highlightColor:
                                        primaryGreen.withOpacity(0.3),
                                    onPressed: () {},
                                    child: Container(
                                      // color: Colors.pink,
                                      child: Center(
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Text(
                                              'Rs. ${snapshot.data['walletAmount']}',
                                              style: TextStyle(
                                                  fontFamily: 'Sofia',
                                                  fontSize: width * 0.04,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            SizedBox(height: width * 0.01388),
                                            Text(
                                              'Wallet',
                                              style: TextStyle(
                                                  fontFamily: 'Sofia',
                                                  fontWeight:
                                                      FontWeight.normal),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                Align(
                                  alignment: Alignment.center,
                                  child: VerticalDivider(
                                    width: 0,
                                    color: blue.withOpacity(0.3),
                                    thickness: 1,
                                    indent: 0,
                                  ),
                                ),
                                Expanded(
                                  // ignore: deprecated_member_use
                                  child: FlatButton(
                                    splashColor: primaryGreen.withOpacity(0.3),
                                    focusColor: primaryGreen.withOpacity(0.3),
                                    highlightColor:
                                        primaryGreen.withOpacity(0.3),
                                    onPressed: () {},
                                    child: Container(
                                      // color: Colors.pink,
                                      child: Center(
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Text(
                                              '${snapshot.data['orders']}',
                                              style: TextStyle(
                                                  fontFamily: 'Sofia',
                                                  fontSize: width * 0.04,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            SizedBox(height: width * 0.01388),
                                            Text(
                                              'Orders',
                                              style: TextStyle(
                                                  fontFamily: 'Sofia',
                                                  fontWeight:
                                                      FontWeight.normal),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Divider(
                            height: 0,
                            color: blue.withOpacity(0.3),
                            thickness: 1,
                            indent: 0,
                          ),
                          SizedBox(height: width * 0.02777),
                          // ignore: deprecated_member_use
                          FlatButton(
                            onPressed: () {},
                            splashColor: primaryGreen.withOpacity(0.3),
                            focusColor: primaryGreen.withOpacity(0.3),
                            highlightColor: primaryGreen.withOpacity(0.3),
                            child: Container(
                              height: width * 0.13888,
                              width: width,
                              // color: Colors.pink,
                              padding: EdgeInsets.only(left: 10),
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.favorite_outline,
                                    color: blue,
                                  ),
                                  SizedBox(width: width * 0.02777),
                                  Text(
                                    'Your Favorites',
                                    style: TextStyle(
                                        fontFamily: 'Sofia',
                                        fontSize: width * 0.04722),
                                  )
                                ],
                              ),
                            ),
                          ),
                          // ignore: deprecated_member_use
                          FlatButton(
                            onPressed: () {},
                            splashColor: primaryGreen.withOpacity(0.3),
                            focusColor: primaryGreen.withOpacity(0.3),
                            highlightColor: primaryGreen.withOpacity(0.3),
                            child: Container(
                              height: width * 0.13888,
                              width: width,
                              // color: Colors.pink,
                              padding: EdgeInsets.only(left: 10),
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.shopping_basket_outlined,
                                    color: blue,
                                  ),
                                  SizedBox(width: width * 0.02777),
                                  Text(
                                    'Order History',
                                    style: TextStyle(
                                        fontFamily: 'Sofia',
                                        fontSize: width * 0.04722),
                                  )
                                ],
                              ),
                            ),
                          ),
                          // ignore: deprecated_member_use
                          FlatButton(
                            onPressed: () {
                              // pushNewScreenWithRouteSettings(context,
                              //     settings: RouteSettings(name: '/home'),
                              //     screen: BottomNavigator(
                              //       initIndex: 2,
                              //     ),
                              //     pageTransitionAnimation:
                              //         PageTransitionAnimation.slideRight,
                              //     withNavBar: false);
                              Navigator.of(context, rootNavigator: true)
                                  .pushReplacement(MaterialPageRoute(
                                      builder: (context) => BottomNavigator(
                                            initIndex: 2,
                                          )));
                            },
                            splashColor: primaryGreen.withOpacity(0.3),
                            focusColor: primaryGreen.withOpacity(0.3),
                            highlightColor: primaryGreen.withOpacity(0.3),
                            child: Container(
                              height: width * 0.13888,
                              width: width,
                              // color: Colors.pink,
                              padding: EdgeInsets.only(left: 10),
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.account_balance_wallet_outlined,
                                    color: blue,
                                  ),
                                  SizedBox(width: width * 0.02777),
                                  Text(
                                    'Manage Wallet',
                                    style: TextStyle(
                                        fontFamily: 'Sofia',
                                        fontSize: width * 0.04722),
                                  )
                                ],
                              ),
                            ),
                          ),
                          Align(
                            alignment: Alignment.bottomCenter,
                            // ignore: deprecated_member_use
                            child: FlatButton(
                              onPressed: () async {
                                try {
                                  await FirebaseAuth.instance.signOut();
                                } catch (e) {}
                                cart.clear();
                                Navigator.of(context, rootNavigator: true)
                                    .pushReplacement(MaterialPageRoute(
                                        builder: (context) => AuthScreen(
                                              index: 0,
                                            )));
                              },
                              splashColor: Colors.red.withOpacity(0.3),
                              highlightColor: Colors.red.withOpacity(0.3),
                              child: Container(
                                height: width * 0.13888,
                                width: width,
                                padding: EdgeInsets.only(left: 10),
                                child: Row(
                                  children: [
                                    Icon(
                                      Icons.power_settings_new_outlined,
                                      color: Colors.red,
                                    ),
                                    SizedBox(width: width * 0.02777),
                                    Text(
                                      'Log out',
                                      style: TextStyle(
                                          fontFamily: 'Sofia',
                                          color: Colors.red,
                                          fontSize: width * 0.04722),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
            },
          ),
        ));
  }
}

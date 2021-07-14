import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:food_ordering_app/screens/cart.dart';
import 'package:food_ordering_app/screens/homeScreen.dart';
import 'package:food_ordering_app/screens/profile.dart';
import 'package:food_ordering_app/screens/wallet.dart';
import 'package:food_ordering_app/utils/colors.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';

// ignore: must_be_immutable
class BottomNavigator extends StatefulWidget {
  String fName;
  String gender;
  DocumentSnapshot userDetails;
  int initIndex;

  BottomNavigator(
      {Key key, this.fName, this.gender, this.userDetails, this.initIndex})
      : super(key: key);
  @override
  _BottomNavigatorState createState() => _BottomNavigatorState();
}

class _BottomNavigatorState extends State<BottomNavigator> {
  final PersistentTabController _controller =
      PersistentTabController(initialIndex: 0);
  int index;
  List<Widget> _buildScreens() {
    return [
      HomePage(
        name: widget.fName,
        gender: widget.gender,
        user: widget.userDetails,
      ),
      Cart(),
      Wallet(),
      Profile(user: widget.userDetails)
    ];
  }

  List<PersistentBottomNavBarItem> _navBarsItems() {
    return [
      PersistentBottomNavBarItem(
        icon: Icon(Icons.home),
        title: ("Home"),
        textStyle: TextStyle(color: Colors.black, fontFamily: 'Sofia'),
        activeColorPrimary: primaryGreen,
        inactiveColorPrimary: lightBlue,
      ),
      PersistentBottomNavBarItem(
        icon: Icon(Icons.shopping_cart),
        title: ("Cart"),
        activeColorPrimary: primaryGreen,
        textStyle: TextStyle(color: Colors.black, fontFamily: 'Sofia'),
        inactiveColorPrimary: lightBlue,
      ),
      PersistentBottomNavBarItem(
        icon: Icon(Icons.account_balance_wallet),
        title: ("Wallet"),
        activeColorPrimary: primaryGreen,
        textStyle: TextStyle(color: Colors.black, fontFamily: 'Sofia'),
        inactiveColorPrimary: lightBlue,
      ),
      PersistentBottomNavBarItem(
        icon: Icon(Icons.person),
        title: ("Profile"),
        activeColorPrimary: primaryGreen,
        textStyle: TextStyle(color: Colors.black, fontFamily: 'Sofia'),
        inactiveColorPrimary: lightBlue,
      ),
    ];
  }

  @override
  void initState() {
    super.initState();
    setState(() {
      index = widget.initIndex;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (index == null) {
    } else {
      _controller.jumpToTab(index);
      setState(() {
        index = null;
      });
    }
    return PersistentTabView(
      context,
      controller: _controller,
      screens: _buildScreens(),
      items: _navBarsItems(),
      confineInSafeArea: true,
      backgroundColor: Colors.white,
      handleAndroidBackButtonPress: true,
      resizeToAvoidBottomInset:
          true, // This needs to be true if you want to move up the screen when keyboard appears.
      stateManagement: false,
      hideNavigationBarWhenKeyboardShows:
          true, // Recommended to set 'resizeToAvoidBottomInset' as true while using this argument.
      decoration: NavBarDecoration(
        borderRadius: BorderRadius.circular(10.0),
        colorBehindNavBar: Colors.white,
      ),
      popAllScreensOnTapOfSelectedTab: true,
      popActionScreens: PopActionScreensType.all,
      itemAnimationProperties: ItemAnimationProperties(
        // Navigation Bar's items animation properties.
        duration: Duration(milliseconds: 200),
        curve: Curves.ease,
      ),
      screenTransitionAnimation: ScreenTransitionAnimation(
        // Screen transition animation on change of selected tab.
        animateTabTransition: true,
        curve: Curves.ease,
        duration: Duration(milliseconds: 200),
      ),
      navBarStyle:
          NavBarStyle.style9, // Choose the nav bar style with this property.
    );
  }
}

class _messageHandler {}

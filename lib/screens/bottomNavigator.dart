import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:food_ordering_app/screens/cart.dart';
import 'package:food_ordering_app/screens/homeScreen.dart';
import 'package:food_ordering_app/screens/profile.dart';
import 'package:food_ordering_app/screens/wallet.dart';
import 'package:food_ordering_app/utils/colors.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';

// ignore: must_be_immutable
class BottomNavigator extends StatelessWidget {
  String fName;
  String gender;
  BottomNavigator({Key key, this.fName, this.gender}) : super(key: key);
  final PersistentTabController _controller =
      PersistentTabController(initialIndex: 0);

  List<Widget> _buildScreens() {
    return [
      HomePage(
        name: fName,
        gender: gender,
      ),
      Cart(),
      Wallet(),
      Profile()
    ];
  }

  List<PersistentBottomNavBarItem> _navBarsItems() {
    return [
      PersistentBottomNavBarItem(
        icon: Icon(Icons.home),
        title: ("Home"),
        textStyle: TextStyle(color: Colors.black, fontFamily: 'Sofia'),
        activeColor: primaryGreen,
        inactiveColor: lightBlue,
      ),
      PersistentBottomNavBarItem(
        icon: Icon(Icons.shopping_cart),
        title: ("Cart"),
        activeColor: primaryGreen,
        textStyle: TextStyle(color: Colors.black, fontFamily: 'Sofia'),
        inactiveColor: lightBlue,
      ),
      PersistentBottomNavBarItem(
        icon: Icon(Icons.account_balance_wallet),
        title: ("Wallet"),
        activeColor: primaryGreen,
        textStyle: TextStyle(color: Colors.black, fontFamily: 'Sofia'),
        inactiveColor: lightBlue,
      ),
      PersistentBottomNavBarItem(
        icon: Icon(Icons.person),
        title: ("Profile"),
        activeColor: primaryGreen,
        textStyle: TextStyle(color: Colors.black, fontFamily: 'Sofia'),
        inactiveColor: lightBlue,
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
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
      stateManagement: true,
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

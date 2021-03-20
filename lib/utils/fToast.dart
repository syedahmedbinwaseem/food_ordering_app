import 'package:flutter/material.dart';

class MyToast1 {
  static Container toast(String text) {
    return Container(
      color: Colors.black,
      padding: EdgeInsets.all(8),
      child: Center(
        child: Text(
          text,
          style: TextStyle(color: Colors.white),
        ),
      ),
    );
  }
}

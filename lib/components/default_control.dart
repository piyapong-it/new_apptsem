import 'package:flutter/material.dart';

class DefaultControl {
  static Widget headerText({String headText}){
    return Text(headText,style: TextStyle(
        fontSize: 20.0,
        fontWeight: FontWeight.normal,
        color: Colors.black
    ));
  }
}

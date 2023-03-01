
import 'package:flutter/material.dart';
import 'package:vetfindapp/Style/_custom_color.dart';

ButtonStyle buttonStyleA(double width,double hieght,double radius,Color color){
  return ButtonStyle(
    fixedSize: MaterialStateProperty.all(Size(width, hieght)),
    backgroundColor: MaterialStateProperty.all(color),
    shape: MaterialStateProperty.all(
        RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(radius)
      )
    )
  );
}
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:vetfindapp/Style/library_style_and_constant.dart';
import 'package:vetfindapp/Utils/SharedPreferences.dart';

class LoadingScreen extends StatefulWidget {
  const LoadingScreen({ Key? key }) : super(key: key);

  @override
  State<LoadingScreen> createState() => _LoadingScreenState();
}

class _LoadingScreenState extends State<LoadingScreen> {

  @override
  initState() {
    super.initState();
    setState(() {
      Timer(Duration(seconds: 1), ()=> getRoute());
    });
  }

  getRoute() async {
    Navigator.popAndPushNamed(context, await DataStorage.isInStorage('id') == true ? "/dashboard" : "/login");
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Container(
      height: size.height,
      decoration: BoxDecoration(
        color: secondaryColor
      ),
      child: Center(
        child: CircularProgressIndicator(
          color: text5Color,
        ),
      ),
    );
  }
}

class LoadingScreen1 {
  static showLoading(BuildContext context, msg) async {
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder:(BuildContext context)=>AlertDialog(
        elevation: 5,
        content: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              margin: EdgeInsets.all(15),
              child: Text(msg),
            ),
            Container(
              child: CircularProgressIndicator(),
            ),
          ],
        ),
      ) 
    );
  }

  static showLoadingNoMsg(BuildContext context) async {
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder:(BuildContext context)=>Center(
        child: CircularProgressIndicator(),
      ),
    );
  }

  static Future showResultDialog(BuildContext context, String msg, double fsize) {
    return showDialog(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) {
      return AlertDialog(
        elevation: 5.0,
        content: Container(
            height: MediaQuery.of(context).size.height * .05,
            child: Center(
                child: Text(
              msg,
              style: TextStyle(fontSize: fsize),
            ))),
        actions: <Widget>[
          ElevatedButton(
            child: Container(
              child: Text('Ok'),
            ),
            onPressed: () {
              Navigator.pop(context,true);
            },
          ),
        ],
      );
    });
  }
  
  static Future showAlertDialog(BuildContext context, String msg, double fsize) {
    return showDialog(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) {
      return AlertDialog(
        elevation: 5.0,
        content: Container(
            height: MediaQuery.of(context).size.height * .05,
            child: Center(
                child: Text(
              msg,
              style: TextStyle(fontSize: fsize),
            ))),
        actions: <Widget>[
          TextButton(
            child: Container(
              child: Text('Cancel'),
            ),
            onPressed: () {
              Navigator.pop(context,false);
            },
          ),
          TextButton(
            child: Container(
              child: Text('Ok'),
            ),
            onPressed: () {
              Navigator.pop(context,true);
            },
          ),
        ],
      );
    });
  }
  
  static showAlertDialog1(BuildContext context, String msg, double fsize) {
    return showDialog(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) {
      return AlertDialog(
        elevation: 5.0,
        content: Container(
            height: MediaQuery.of(context).size.height * .05,
            child: Center(
                child: Text(
              msg,
              style: TextStyle(fontSize: fsize),
            ))),
        actions: <Widget>[
          TextButton(
            child: Container(
              child: Text('No'),
            ),
            onPressed: () {
              Navigator.pop(context,false);
            },
          ),
          TextButton(
            child: Container(
              child: Text('Yes'),
            ),
            onPressed: () {
              Navigator.pop(context,true);
            },
          ),
        ],
      );
    });
  }
}

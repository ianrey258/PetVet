
import 'dart:convert';

import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:cherry_toast/cherry_toast.dart';
import 'package:cherry_toast/resources/arrays.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:vetfindapp/Style/library_style_and_constant.dart';

class FirebaseMessagingService{
  static final String _accessToken = "pk.eyJ1IjoiaWFucmV5MjU4IiwiYSI6ImNrYjI3eXF0cTA4bjgyd28yeGJta2dtNmQifQ.LtqueENclx7vVAp6IfEusA";
  static final String _typeMap = "mapbox.mapbox-streets-v8";

  FirebaseMessagingService();

  static Future initPermission() async {
    FirebaseMessaging messaging = FirebaseMessaging.instance;
    NotificationSettings settings = await messaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );

    if(settings.authorizationStatus == AuthorizationStatus.authorized){
      print('Granted Permission');
    }else if(settings.authorizationStatus == AuthorizationStatus.provisional){
      print('Granted Provisional Permission');
    }else{
      print('Declined and Not Accepted Permission');
    }
  }
  
  static Future initListenerForground(BuildContext context) async {
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      // print(ModalRoute.of(context)?.settings.name);
      AwesomeNotifications().createNotification(
        content: NotificationContent(
          id: 123, 
          channelKey: 'notification',
          title: message.data['sender'],
          body: message.data['body'],
          category: NotificationCategory.Message,
          wakeUpScreen: true,
          fullScreenIntent: true,
          backgroundColor: secondaryColor
        ),
        // actionButtons: [
        //   NotificationActionButton(key: 'go_to_apointments', label: 'OPEN',color: primaryColor),
        //   NotificationActionButton(key: 'close', label: 'CLOSE',color: primaryColor)
        // ]
      );
    });
  }

  static void awesomeNotificationButtonListener(BuildContext context){
    AwesomeNotifications().actionStream.listen((event) { 
      print("Pressing => ${event.buttonKeyPressed}");
      if(event.buttonKeyPressed=='go_to_apointments'){
        Navigator.pushNamed(context,'/apointments');
      }
    });
  }


  static Future<String> getFCMToken() async {
    return await FirebaseMessaging.instance.getToken()??'';
  } 
  
  static sendMessageNotification(String type,String sender,String title,String message,List ids){
    final key = 'AAAAcAW6AXI:APA91bHl44pqkKGjvaZ-xUND3kzK7_v5A54s-ThTwf2guQox8O67HMm5R1RbU9eIoplM6hmTauk073diYooQ2EWbHYKNaj6s6XEc6_I4lQyyvWBJJovQzDk-SgK4UD8r0rlNUPJXUSF-';
    try{
      ids.forEach((token) async { 
        await http.post(
        Uri.parse('https://fcm.googleapis.com/fcm/send'),
        headers: <String,String>{
          'Content-Type':'application/json',
          'Authorization':'key=${key}'
        },
        body: jsonEncode(<String,dynamic>{
          'priority':'high',
          'data':<String,dynamic>{
            'status':'done',
            'title': title,
            'body': message,
            'type': type,
            'sender': sender
          },
          'notification':<String,dynamic>{
            'title': title,
            'body': message,
            'type': type,
            'sender': sender
          },
          'to':token
        })
      );
      });
      
    }catch(e){
      print('Error on ${e}');
    }
  }

}
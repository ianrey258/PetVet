
import 'dart:convert';
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:cherry_toast/cherry_toast.dart';
import 'package:cherry_toast/resources/arrays.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:http/http.dart' as http;
import 'package:vetfindapp/Controller/ApointmentController.dart';
import 'package:vetfindapp/Controller/ClinicController.dart';
import 'package:vetfindapp/Model/clinicModel.dart';
import 'package:vetfindapp/Style/library_style_and_constant.dart';
import 'package:flutter_dynamic_icon/flutter_dynamic_icon.dart';
import 'package:vetfindapp/Utils/SharedPreferences.dart';

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

  static Future<void> initListenerBackground(RemoteMessage message) async {
  // String? title = message.notification!.title;
  // String? body = message.notification!.body;
  print('Handling a background message ${message}');
  Firebase.initializeApp();

  if(await FlutterDynamicIcon.supportsAlternateIcons){
    if(await DataStorage.isInStorage('id')){
      List user_appointment_list = await ApointmentController.getUnreadApointments();
      if(user_appointment_list.length > 0){
        await FlutterDynamicIcon.setApplicationIconBadgeNumber(user_appointment_list.length);
      }
    }
  }
  
  Map<String,dynamic> payload = json.decode(message.data['payload']);
  AwesomeNotifications().createNotification(
    content: NotificationContent(
      id: 123, 
      channelKey: message.data['channel_key'],
      title: message.data['sender'],
      body: message.data['body'],
      payload: payload.map((key,value) => MapEntry(key, value.toString())),
      // payload: {},
      category: NotificationCategory.Message,
      wakeUpScreen: true,
      fullScreenIntent: true,
      backgroundColor: secondaryColor
    ),
    // actionButtons: [
    //   NotificationActionButton(key: 'go_to_apointments', label: 'OPEN',color: primaryColor, buttonType: ActionButtonType.Default),
    //   NotificationActionButton(key: 'close', label: 'CLOSE',color: primaryColor)
    // ]
  );
}
  
  static Future initListenerForground(BuildContext context) async {
    try{
      FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
        // print(ModalRoute.of(context)?.settings.name);
        Map<String,dynamic> payload = json.decode(message.data['payload']);
        debugPrint(payload.toString());
        AwesomeNotifications().createNotification(
          content: NotificationContent(
            id: 123, 
            channelKey: message.data['channel_key'],
            title: message.data['sender'],
            body: message.data['body'],
            payload: payload.map((key,value) => MapEntry(key, value.toString())),
            // payload: {},
            category: NotificationCategory.Message,
            wakeUpScreen: true,
            fullScreenIntent: true,
            backgroundColor: secondaryColor
          ),
        );

        if(await FlutterDynamicIcon.supportsAlternateIcons){
          if(await DataStorage.isInStorage('id')){
            List user_appointment_list = await ApointmentController.getUnreadApointments();
            if(user_appointment_list.length > 0){
              await FlutterDynamicIcon.setApplicationIconBadgeNumber(user_appointment_list.length);
            }
          }
        }
      });
    }catch(e){}
  }

  static void awesomeNotificationButtonListener(BuildContext context) {
    try{
      AwesomeNotifications().actionStream.listen((event) async { 
        Map<String,dynamic>? payload = event.payload;
        if(event.channelKey == notification_type[1]){
          Navigator.pushNamed(context,'/apointments');
        }
        if(event.channelKey == notification_type[0]){
          ClinicModel clinic = await ClinicController.getClinic(payload!['id']);
          Navigator.pushNamed(context, '/message',arguments: clinic);
        }
      });
    }catch(e){}
  }

  static Future<String> getFCMToken() async {
    return await FirebaseMessaging.instance.getToken()??'';
  } 
  
  static sendMessageNotification(String type,String sender,String title,String message,List ids,Map payload){
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
            'sender': sender,
            'payload': payload,
            'channel_key': type,
          },
          // 'notification':<String,dynamic>{
          //   'title': title,
          //   'body': message,
          //   'type': type,
          //   'sender': sender
          // },
          'to':token
        })
      );
      });
      
    }catch(e){
      print('Error on ${e}');
    }
  }

}
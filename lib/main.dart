// ignore_for_file: prefer_const_constructors
import 'dart:convert';
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:face_camera/face_camera.dart';
import 'package:fast_cached_network_image/fast_cached_network_image.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dynamic_icon/flutter_dynamic_icon.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:vetfindapp/Pages/LoadingScreen/LoadingScreen.dart';
import 'package:vetfindapp/Pages/apointment/apointmets.dart';
import 'package:vetfindapp/Pages/apointment/show_appointment.dart';
import 'package:vetfindapp/Pages/chat_messages/messages.dart';
import 'package:vetfindapp/Pages/clinic/message.dart';
import 'package:vetfindapp/Pages/clinic/vet_clinic.dart';
import 'package:vetfindapp/Pages/clinic/video_call.dart';
import 'package:vetfindapp/Pages/dashboard/dashboard.dart';
import 'package:vetfindapp/Pages/forgot_password/forgot_password.dart';
import 'package:vetfindapp/Pages/forgot_password/reset_password.dart';
import 'package:vetfindapp/Pages/login/OTP.dart';
import 'package:vetfindapp/Pages/login/login.dart';
import 'package:vetfindapp/Pages/map_clinic/map_clinic.dart';
import 'package:vetfindapp/Pages/pets/pets.dart';
import 'package:vetfindapp/Pages/profile/user_profile.dart';
import 'package:vetfindapp/Pages/register/register.dart';
import 'package:vetfindapp/Services/firebase_messaging.dart';
import 'package:vetfindapp/Style/_custom_color.dart';

void initAwesomeNotification(){
  AwesomeNotifications().initialize(null, [
    NotificationChannel(
      channelKey: 'notification', 
      channelName: 'notification', 
      channelDescription: 'Notification',
      importance: NotificationImportance.High,
    ),
    NotificationChannel(
      channelKey: 'appointment', 
      channelName: 'appointment', 
      channelDescription: 'Appointment',
      importance: NotificationImportance.High,
    ),
    NotificationChannel(
      channelKey: 'message', 
      channelName: 'message', 
      channelDescription: 'Message',
      importance: NotificationImportance.High,
    )
  ]);
}

final FlutterLocalNotificationsPlugin fln = FlutterLocalNotificationsPlugin();
void main() async {
  WidgetsFlutterBinding.ensureInitialized(); 

  await FaceCamera.initialize(); 
  initAwesomeNotification();
  Firebase.initializeApp(); 
  FirebaseMessaging.onBackgroundMessage(FirebaseMessagingService.initListenerBackground);
  await FastCachedImageConfig.init(clearCacheAfter: const Duration(days: 15));

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'PetVet Finder',
      theme: ThemeData(
        textTheme: TextTheme(
          bodyText1: TextStyle(color: text1Color),
          bodyText2: TextStyle(color: text1Color),
        ),
        primaryColor: primaryColor,
        scaffoldBackgroundColor: secondaryColor,
        backgroundColor: secondaryColor,
        appBarTheme: AppBarTheme(
          backgroundColor: secondaryColor
        ),
        buttonColor: primaryColor,
        bottomSheetTheme: BottomSheetThemeData(
          backgroundColor:secondaryColor
        ) 
      ),
      routes: {
        '/login': (context) => const Login(),
        '/register': (context) => const Register(),
        '/forgot_password': (context) => const ForgotPassword(),
        '/reset_password': (context) => const ResetPassword(),
        '/dashboard': (context) => const Dashboard(),
        '/vet_clinic': (context) => const VetClinic(),
        '/map_clinic': (context) => const MapClinic(),
        '/message': (context) => const MessageChat(),
        '/messages': (context) => const Messages(),
        '/video_call': (context) => const VideoCall(),
        '/loading_screen': (context) => const LoadingScreen(),
        '/user_profile': (context) => const UserProfile(),
        '/pets': (context) => const Pets(),
        '/apointments': (context) => const Apointments(),
        '/show_apointment': (context) => const ShowAppointment(),
        '/otp': (context) => const OTP(),
      },
      initialRoute: '/loading_screen',
      // home: const LoginPage(),
    );
  }
}

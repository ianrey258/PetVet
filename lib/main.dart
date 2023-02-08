// ignore_for_file: prefer_const_constructors

import 'package:face_camera/face_camera.dart';
import 'package:flutter/material.dart';
import 'package:vetfindapp/Pages/clinic/message.dart';
import 'package:vetfindapp/Pages/clinic/vet_clinic.dart';
import 'package:vetfindapp/Pages/clinic/video_call.dart';
import 'package:vetfindapp/Pages/dashboard/dashboard.dart';
import 'package:vetfindapp/Pages/forgot_password/forgot_password.dart';
import 'package:vetfindapp/Pages/forgot_password/reset_password.dart';
import 'package:vetfindapp/Pages/login/login.dart';
import 'package:vetfindapp/Pages/map_clinic/map_clinic.dart';
import 'package:vetfindapp/Pages/register/register.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized(); 
  await FaceCamera.initialize(); 
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
          bodyText1: TextStyle(color: Colors.white),
          bodyText2: TextStyle(color: Colors.white),
        ),
        primaryColor: Colors.blue,
        scaffoldBackgroundColor: Color.fromRGBO(66,74,109, 1),
        backgroundColor: Color.fromRGBO(66,74,109, 1),
        appBarTheme: AppBarTheme(
          backgroundColor: Color.fromRGBO(66,74,109, 1)
        ),
        buttonColor: Color.fromRGBO(0,207,253,1),
        bottomSheetTheme: BottomSheetThemeData(
          backgroundColor:Color.fromRGBO(66,74,109, 1)
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
        '/message': (context) => const Message(),
        '/video_call': (context) => const VideoCall(),
      },
      initialRoute: '/login',
      // home: const LoginPage(),
    );
  }
}

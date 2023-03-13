// ignore_for_file: prefer_const_constructors
import 'package:face_camera/face_camera.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:vetfindapp/Pages/LoadingScreen/LoadingScreen.dart';
import 'package:vetfindapp/Pages/apointment/apointmets.dart';
import 'package:vetfindapp/Pages/apointment/show_appointment.dart';
import 'package:vetfindapp/Pages/clinic/message.dart';
import 'package:vetfindapp/Pages/clinic/vet_clinic.dart';
import 'package:vetfindapp/Pages/clinic/video_call.dart';
import 'package:vetfindapp/Pages/dashboard/dashboard.dart';
import 'package:vetfindapp/Pages/forgot_password/forgot_password.dart';
import 'package:vetfindapp/Pages/forgot_password/reset_password.dart';
import 'package:vetfindapp/Pages/login/login.dart';
import 'package:vetfindapp/Pages/map_clinic/map_clinic.dart';
import 'package:vetfindapp/Pages/pets/pets.dart';
import 'package:vetfindapp/Pages/profile/user_profile.dart';
import 'package:vetfindapp/Pages/register/register.dart';
import 'package:vetfindapp/Style/_custom_color.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized(); 
  await FaceCamera.initialize(); 
  Firebase.initializeApp(); 
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
        '/message': (context) => const Message(),
        '/video_call': (context) => const VideoCall(),
        '/loading_screen': (context) => const LoadingScreen(),
        '/user_profile': (context) => const UserProfile(),
        '/pets': (context) => const Pets(),
        '/apointments': (context) => const Apointments(),
        '/show_apointment': (context) => const ShowAppointment(),
      },
      initialRoute: '/loading_screen',
      // home: const LoginPage(),
    );
  }
}

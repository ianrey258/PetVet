// ignore_for_file: prefer_const_constructors
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:face_camera/face_camera.dart';
import 'package:fast_cached_network_image/fast_cached_network_image.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:vetfindapp/Controller/ClinicController.dart';
import 'package:vetfindapp/Pages/LoadingScreen/LoadingScreen.dart';
import 'package:vetfindapp/Pages/apointment/apointmets.dart';
import 'package:vetfindapp/Pages/apointment/show_appointment.dart';
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
import 'package:vetfindapp/Style/_custom_color.dart';

// Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
//   await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
//   await setupFlutterNotifications();
//   showFlutterNotification(message);
//   // If you're going to use other Firebase services in the background, such as Firestore,
//   // make sure you call `initializeApp` before using other Firebase services.
//   print('Handling a background message ${message}');
// }

Future<void> backgroundHandler(RemoteMessage message) async {
  String? title = message.notification!.title;
  String? body = message.notification!.body;
  print('Handling a background message ${message}');

  await Firebase.initializeApp();
  // AwesomeNotifications().createNotification(
  //   content: NotificationContent(
  //     id: 123, 
  //     channelKey: 'notification',
  //     title: title,
  //     body: body,
  //     category: NotificationCategory.Message,
  //     wakeUpScreen: true,
  //     fullScreenIntent: true,
  //     backgroundColor: secondaryColor
  //   ),
  //   actionButtons: [
  //     NotificationActionButton(key: 'open', label: 'OPEN',color: primaryColor),
  //     NotificationActionButton(key: 'close', label: 'CLOSE',color: primaryColor)
  //   ]
  // );
}

void initAwesomeNotification(){
  AwesomeNotifications().initialize(null, [
    NotificationChannel(
      channelKey: 'notification', 
      channelName: 'notification', 
      channelDescription: 'Notification'
      )
  ]);
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized(); 

  await FaceCamera.initialize(); 
  initAwesomeNotification();
  await Firebase.initializeApp(); 
  FirebaseMessaging.onBackgroundMessage(backgroundHandler);
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
        '/message': (context) => const Message(),
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

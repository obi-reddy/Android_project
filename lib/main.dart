import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'screens/auth/LogIn.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'screens/home/homescreen.dart';
import 'dart:async';
import 'fcmservices/fcmservices.dart';

void configLoading() {
  EasyLoading.instance
    ..displayDuration = const Duration(milliseconds: 2000)
    ..indicatorType = EasyLoadingIndicatorType.fadingCircle
    ..loadingStyle = EasyLoadingStyle.dark
    ..indicatorSize = 45.0
    ..radius = 10.0
    ..progressColor = Colors.yellow
    ..backgroundColor = Colors.green
    ..indicatorColor = Colors.yellow
    ..textColor = Colors.yellow
    ..maskColor = Colors.blue.withOpacity(0.5)
    ..userInteractions = true
    ..dismissOnTap = false;
}
void main() async{
   WidgetsFlutterBinding.ensureInitialized();
   await Firebase.initializeApp();
   // await fcmservices.initNotifications();
 //  await fcmservices.initlocalnotificaionplugin();
 //  await fcmservices.initvariables();
  //  FirebaseMessaging.onBackgroundMessage(fcmservices.firebaseMessagingBackgroundHandler);
   //
   // if (!kIsWeb) {
   //   await setupFlutterNotifications();
   // }
  runApp(const MyApp());
  configLoading();
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    var user=FirebaseAuth.instance.currentUser;
    return GetMaterialApp(
      title: 'Unexpiry',
      theme: ThemeData(

        primarySwatch: Colors.blue,
        backgroundColor: Colors.red
      ),
      home: (user!=null)?homescreen():LogIn(),
      debugShowCheckedModeBanner: false,
      builder: EasyLoading.init(),
    );
  }
}



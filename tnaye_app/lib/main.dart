import 'package:flutter/material.dart';
import 'package:tnaye_app/pages/Health_prof_detail.dart';
import 'package:tnaye_app/pages/booking.dart';
import 'package:tnaye_app/pages/home.dart';
import 'package:tnaye_app/pages/login.dart';
import 'package:tnaye_app/pages/onboarding.dart';
import 'package:tnaye_app/pages/signup.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    if (Firebase.apps.isEmpty) {
      await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      );
      //print('Firebase initialized successfully');
    } else {
      //print('Firebase already initialized');
    }
  } catch (e) {
   // print('Firebase initialization failed: $e');
  }
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Tenaye',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      
      //home: Onboarding(),
       // home: Home(),
      //home: Booking( service: "psychologist"),
      //home: LogIn(),
    home: SignUp(),
    // home: HealthProfDetail()
    );
  }
}

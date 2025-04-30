import 'package:flutter/material.dart';
import 'package:tnaye_app/pages/booking.dart';
import 'package:tnaye_app/pages/home.dart';
import 'package:tnaye_app/pages/onboarding.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
    //home:Onboarding()
      // home: Home(),
      home: Booking( service: "psychologist"),
    );
  }
}
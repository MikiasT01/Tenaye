import 'package:flutter/material.dart';
import 'package:tnaye_app/pages/login.dart';

class Onboarding extends StatefulWidget {
  const Onboarding({super.key});

  @override
  State<Onboarding> createState() => _OnboardingState();
}

class _OnboardingState extends State<Onboarding> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(color: Colors.white),
        child: Column(
          children: [
            SizedBox(height: 30.0),
            Text(
              "Welcome to Tenaye",
              style: TextStyle(
                color: const Color.fromARGB(255, 89, 57, 127),
                fontSize: 30.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 20.0),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  flex: 1,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 30.0),
                    child: Text(
                      " \"Your health, \nour priority\"",
                      // "An app designed to manage your \n healthcare needs and connect with \n your doctor online",
                      style: TextStyle(
                        color: const Color.fromARGB(255, 89, 57, 127),
                        fontSize: 28.0,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Roboto',
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  ),
                ),
                Image.asset(
                  "images/landing_page.jpg",
                  width: 300, // set your desired width
                  height: 400, // set your desired height
                  fit: BoxFit.cover, // optional, controls how the image fits
                ),
              ],
            ),
            SizedBox(height: 50.0),
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 24.0,
                vertical: 8.0,
              ),
              child: Text(
                "An app designed to manage your \nhealthcare needs and connect with \nyour doctor online",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: const Color.fromARGB(255, 89, 57, 127),
                  fontSize: 22.0,
                  fontWeight: FontWeight.w500,
                  height: 1.4, // line height for better readability
                ),
              ),
            ),
            SizedBox(height: 30.0),
            GestureDetector(
              child: GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => LogIn()),
                  );
                },
                child: Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 20.0,
                    vertical: 20.0,
                  ),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Color.fromARGB(255, 89, 57, 127),
                        Color.fromARGB(255, 21, 70, 95),
                        Color.fromARGB(255, 89, 57, 127),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    "Consult our Health experts",
                    style: TextStyle(
                      color: const Color.fromARGB(255, 239, 239, 241),
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(height: 40.0),
            GestureDetector(
              child: GestureDetector(
                onTap: () {
                  // Navigator.push(
                  //   context,
                  //   MaterialPageRoute(builder: (context) => Home()),
                  // );
                },
                child: Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 20.0,
                    vertical: 20.0,
                  ),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Color.fromARGB(255, 89, 57, 127),
                        Color.fromARGB(255, 21, 70, 95),
                        Color.fromARGB(255, 89, 57, 127),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    "Register as a Health professional",
                    style: TextStyle(
                      color: const Color.fromARGB(255, 239, 239, 241),
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

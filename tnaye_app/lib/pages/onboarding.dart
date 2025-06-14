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
        child: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(height: 20.0), // Reduced from 30.0
              Text(
                "Welcome to Tenaye",
                style: TextStyle(
                  color: const Color.fromARGB(255, 89, 57, 127),
                  fontSize: 21.0, // Reduced from 30.0
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 15.0), // Reduced from 20.0
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    flex: 1,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 20.0), // Reduced from 30.0
                      child: Text(
                        " \"Your health, \nour priority\"",
                        style: TextStyle(
                          color: const Color.fromARGB(255, 89, 57, 127),
                          fontSize: 20.0, // Reduced from 28.0
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Roboto',
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                    ),
                  ),
                  Image.asset(
                    "images/landing_page.jpg",
                    width: 200, // Reduced from 300
                    height: 250, // Reduced from 400
                    fit: BoxFit.cover,
                  ),
                ],
              ),
              const SizedBox(height: 35.0), // Reduced from 50.0
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16.0, // Reduced from 24.0
                  vertical: 5.0, // Reduced from 8.0
                ),
                child: Text(
                  "An app designed to manage your \nhealthcare needs and connect with \nyour doctor online",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: const Color.fromARGB(255, 89, 57, 127),
                    fontSize: 15.0, // Reduced from 22.0
                    fontWeight: FontWeight.w500,
                    height: 1.4,
                  ),
                ),
              ),
              const SizedBox(height: 50.0), // Reduced from 30.0
              GestureDetector(
                child: GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => LogIn()),
                    );
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 15.0, // Slightly reduced from 20.0
                      vertical: 15.0, // Slightly reduced from 20.0
                    ),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [
                          Color.fromARGB(255, 89, 57, 127),
                          Color.fromARGB(255, 21, 70, 95),
                          Color.fromARGB(255, 89, 57, 127),
                        ],
                      ),
                      borderRadius: BorderRadius.circular(15), // Reduced from 20
                    ),
                    child: Text(
                      "Consult our Health experts",
                      style: TextStyle(
                        color: const Color.fromARGB(255, 239, 239, 241),
                        fontSize: 14.0, // Reduced from 20.0
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 30.0), // Reduced from 40.0
              // GestureDetector(
              //   child: GestureDetector(
              //     onTap: () {
              //       // Navigator.push(
              //       //   context,
              //       //   MaterialPageRoute(builder: (context) => Home()),
              //       // );
              //     },
              //     child: Container(
              //       padding: const EdgeInsets.symmetric(
              //         horizontal: 15.0, // Slightly reduced from 20.0
              //         vertical: 15.0, // Slightly reduced from 20.0
              //       ),
              //       decoration: BoxDecoration(
              //         gradient: const LinearGradient(
              //           colors: [
              //             Color.fromARGB(255, 89, 57, 127),
              //             Color.fromARGB(255, 21, 70, 95),
              //             Color.fromARGB(255, 89, 57, 127),
              //           ],
              //         ),
              //         borderRadius: BorderRadius.circular(15), // Reduced from 20
              //       ),
              //       child: Text(
              //         "Register as a Health professional",
              //         style: TextStyle(
              //           color: const Color.fromARGB(255, 239, 239, 241),
              //           fontSize: 14.0, // Reduced from 20.0
              //           fontWeight: FontWeight.bold,
              //         ),
              //       ),
              //     ),
              //   ),
              // ),
            ],
          ),
        ),
      ),
    );
  }
}
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
              const SizedBox(height: 30.0), 
              Text(
                "Welcome to Tenaye",
                style: TextStyle(
                  color: const Color.fromARGB(255, 89, 57, 127),
                  fontSize: 21.0, 
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 15.0), 
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    flex: 1,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 20.0), 
                      child: Text(
                        " \"Your health, \nour priority\"",
                        style: TextStyle(
                          color: const Color.fromARGB(255, 89, 57, 127),
                          fontSize: 20.0,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Roboto',
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                    ),
                  ),
                  Image.asset(
                    "images/landing_page.jpg",
                    width: 200, 
                    height: 250, 
                    fit: BoxFit.cover,
                  ),
                ],
              ),
              const SizedBox(height: 35.0), 
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16.0, 
                  vertical: 5.0, 
                ),
                child: Text(
                  "An app designed to manage your healthcare needs and connect with your doctor online",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                  color: const Color.fromARGB(255, 89, 57, 127),
                  fontSize: 15.0, 
                  fontWeight: FontWeight.w500,
                  height: 1.4,
                  fontStyle: FontStyle.italic,
                  ),
                ),
              ),
              const SizedBox(height: 50.0), 
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
                      horizontal: 15.0, 
                      vertical: 15.0,
                    ),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [
                          Color.fromARGB(255, 89, 57, 127),
                          Color.fromARGB(255, 21, 70, 95),
                          Color.fromARGB(255, 89, 57, 127),
                        ],
                      ),
                      borderRadius: BorderRadius.circular(15), 
                    ),
                    child: Text(
                      "Consult our Health experts",
                      style: TextStyle(
                        color: const Color.fromARGB(255, 239, 239, 241),
                        fontSize: 14.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 30.0), 



              // another logic for the doctor interface 

              
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
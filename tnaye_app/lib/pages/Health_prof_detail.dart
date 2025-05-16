import 'package:flutter/material.dart';
import 'package:tnaye_app/pages/booking.dart';
import 'package:tnaye_app/services/shared_pref.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class HealthProfDetail extends StatefulWidget {
  String service;
  HealthProfDetail({super.key, required this.service});

  @override
  State<HealthProfDetail> createState() => _HealthProffDetailState();
}

class _HealthProffDetailState extends State<HealthProfDetail> {
 
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.lightBlue,
      body: Container(
        margin: EdgeInsets.only(top: 50.0, left: 20.0, right: 20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,

          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Hello, ",
                      style: TextStyle(
                        color: const Color.fromARGB(255, 217, 217, 218),
                        fontSize: 24.0,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Text(
                     // name!,
                      "User",
                      style: TextStyle(
                        color: const Color.fromARGB(255, 241, 240, 244),
                        fontSize: 24.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                ClipRRect(
                  borderRadius: BorderRadius.circular(50.0),
                  child: Image.asset(
                    "images/user_image.png",
                    width: 60.0,
                    height: 60.0,
                    fit: BoxFit.cover,
                  ),
                ),
              ],
            ),
            SizedBox(height: 20.0),
            Divider(color: Colors.white70),
            SizedBox(height: 20.0),
            Text(
               widget.service ,
              style: TextStyle(
                color: const Color.fromARGB(255, 241, 240, 244),
                fontSize: 24.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 20.0),
            Row(
              children: [
                Flexible(
                  fit: FlexFit.tight,
                  child: GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder:
                              (context) => Booking(service: "name of Doctor"),
                        ),
                      );
                    },
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 10.0),
                      height: 170.0,
                      width: 150.0,
                      decoration: BoxDecoration(
                        color: Color.fromARGB(255, 68, 141, 178),
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset(
                            "images/general_practitioner_icon.jpg",
                            height: 120,
                            width: 140,
                            fit: BoxFit.cover,
                          ),
                          SizedBox(height: 10.0),
                          Text(
                            "General practitioner",
                            style: TextStyle(
                              color: const Color.fromARGB(255, 241, 240, 244),
                              fontSize: 20.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 20.0),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

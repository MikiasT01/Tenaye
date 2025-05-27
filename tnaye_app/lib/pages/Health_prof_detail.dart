import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:tnaye_app/pages/booking.dart';
import 'package:tnaye_app/read%20data/GetData.dart';
import 'package:tnaye_app/services/shared_pref.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class HealthProfDetail extends StatefulWidget {
  var service;

  HealthProfDetail({super.key, required this.service});

  @override
  State<HealthProfDetail> createState() => _HealthProffDetailState();
}

class _HealthProffDetailState extends State<HealthProfDetail> {
  List<Map<String, dynamic>> healthProfessionals = [];
  late String doctor_type;

  Future<void> _loadHealthProffData() async {
    try {
      final snapshot =
          await FirebaseFirestore.instance
              .collection(doctor_type)
              //isEqualTo: widget.service.toLowerCase(),
              //.where('Speciality', isEqualTo: widget.service)
              .get();

      healthProfessionals = snapshot.docs.map((doc) => doc.data()).toList();
    } catch (e) {
      print("Error loading health professionals: $e");
    }
    print(doctor_type);
  }

  @override
  void initState() {
   doctor_type = "Health_professional_" +
    (widget.service.toString().substring(0, 1).toUpperCase() +
     widget.service.toString().substring(1));
   // doctor_type = "Health_professional_"+widget.service.toString();

    _loadHealthProffData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.lightBlue,
      body: Container(
        margin: EdgeInsets.only(top: 50.0, left: 20.0, right: 20.0),

        child: Column(
          children: [
            Expanded(
              child: FutureBuilder(
                future: _loadHealthProffData(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  }

                  return ListView.builder(
                    itemCount: healthProfessionals.length,
                    itemBuilder: (context, index) {
                      final doctor = healthProfessionals[index];
                      return GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder:
                                  (context) => Booking(service: doctor['Name']),
                            ),
                          );
                        },
                        child: Container(
                          margin: EdgeInsets.symmetric(vertical: 10),
                          padding: EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Color.fromARGB(255, 68, 141, 178),
                            borderRadius: BorderRadius.circular(20.0),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Name: ${doctor['Name']}",
                                style: TextStyle(
                                  fontSize: 20,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(height: 8),
                              Text(
                                "Age: ${doctor['Age']}",
                                style: TextStyle(color: Colors.white),
                              ),
                              Text(
                                "Speciality: ${doctor['Speciality']}",
                                style: TextStyle(color: Colors.white),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
        ////////////////check chat gpt and how to add the retruved date to the layout
        // Column(
        //   crossAxisAlignment: CrossAxisAlignment.start,

        //   children: [
        //     Row(
        //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
        //       children: [
        //         Column(
        //           crossAxisAlignment: CrossAxisAlignment.start,
        //           children: [
        //             Text(
        //               "Hello, ",
        //               style: TextStyle(
        //                 color: const Color.fromARGB(255, 217, 217, 218),
        //                 fontSize: 24.0,
        //                 fontWeight: FontWeight.w500,
        //               ),
        //             ),
        //             Text(
        //               // name!,
        //               "User",
        //               style: TextStyle(
        //                 color: const Color.fromARGB(255, 241, 240, 244),
        //                 fontSize: 24.0,
        //                 fontWeight: FontWeight.bold,
        //               ),
        //             ),
        //           ],
        //         ),
        //         ClipRRect(
        //           borderRadius: BorderRadius.circular(50.0),
        //           child: Image.asset(
        //             "images/user_image.png",
        //             width: 60.0,
        //             height: 60.0,
        //             fit: BoxFit.cover,
        //           ),
        //         ),
        //       ],
        //     ),
        //     SizedBox(height: 20.0),
        //     Divider(color: Colors.white70),
        //     SizedBox(height: 20.0),
        //     Text(
        //       widget.service,
        //       style: TextStyle(
        //         color: const Color.fromARGB(255, 241, 240, 244),
        //         fontSize: 24.0,
        //         fontWeight: FontWeight.bold,
        //       ),
        //     ),
        //     SizedBox(height: 20.0),
        //     Row(
        //       children: [
        //         Flexible(
        //           fit: FlexFit.tight,
        //           child: GestureDetector(
        //             onTap: () {
        //               Navigator.push(
        //                 context,
        //                 MaterialPageRoute(
        //                   builder:
        //                       (context) => Booking(service: "name of Doctor"),
        //                 ),
        //               );
        //             },
        //             child: Container(
        //               padding: EdgeInsets.symmetric(horizontal: 10.0),
        //               height: 170.0,
        //               width: 150.0,
        //               decoration: BoxDecoration(
        //                 color: Color.fromARGB(255, 68, 141, 178),
        //                 borderRadius: BorderRadius.circular(20.0),
        //               ),
        //               child: Column(
        //                 mainAxisAlignment: MainAxisAlignment.center,
        //                 children: [
        //                   Image.asset(
        //                     "images/general_practitioner_icon.jpg",
        //                     height: 120,
        //                     width: 140,
        //                     fit: BoxFit.cover,
        //                   ),
        //                   SizedBox(width: 10.0),

        //                   ListTile(title:GetData(documentId:HealthProffDetail[] )),
        //                   Text(
        //                     "General practitioner",
        //                     style: TextStyle(
        //                       color: const Color.fromARGB(255, 241, 240, 244),
        //                       fontSize: 20.0,
        //                       fontWeight: FontWeight.bold,
        //                     ),
        //                   ),
        //                 ],
        //               ),
        //             ),
        //           ),
        //         ),
        //         SizedBox(height: 20.0),

        //       ],
        //     ),
        //   ],

        // ),
      ),
    );
  }
}

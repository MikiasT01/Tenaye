import 'package:flutter/material.dart';
import 'package:tnaye_app/pages/Health_prof_detail.dart';
import 'package:tnaye_app/services/shared_pref.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tnaye_app/services/database.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  String? name, image;

  // Fetch data from SharedPreferences and Firestore if needed
  Future<String?> _getUserData() async {
    // Try to get the username from SharedPreferences
    image = await SharedPreferencesHelper().getUserImage();
    name = await SharedPreferencesHelper().getUserName();
    // If username is not in SharedPreferences, fetch from Firestore
    if (name == null) {
      String? userId = await SharedPreferencesHelper().getUserId();
      if (userId != null) {
        DocumentSnapshot userDoc =
            await FirebaseFirestore.instance
                .collection('users')
                .doc(userId)
                .get();

        if (userDoc.exists) {
          name = userDoc.get('Name') as String?;
          if (name != null) {
            await SharedPreferencesHelper().saveUserName(name!);
          }
        }
      }
    }
    return name;
  }

  @override
  void initState() {
    super.initState();
    // Pre-load data (optional, as FutureBuilder will handle it)
    _getUserData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          color: Color.fromARGB(255, 103, 61, 172),
        ),
        child: Container(
          margin: EdgeInsets.only(top: 50.0, left: 50.0, right: 50.0),

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
                      FutureBuilder<String?>(
                        future: _getUserData(),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return Text(
                              "Loading...",
                              style: TextStyle(
                                color: const Color.fromARGB(255, 241, 240, 244),
                                fontSize: 24.0,
                                fontWeight: FontWeight.bold,
                              ),
                            );
                          }
                          if (snapshot.hasError || snapshot.data == null) {
                            return Text(
                              "Unknown User",
                              style: TextStyle(
                                color: const Color.fromARGB(255, 241, 240, 244),
                                fontSize: 24.0,
                                fontWeight: FontWeight.bold,
                              ),
                            );
                          }
                          return Text(
                            snapshot.data!,
                            style: TextStyle(
                              color: const Color.fromARGB(255, 241, 240, 244),
                              fontSize: 24.0,
                              fontWeight: FontWeight.bold,
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(50.0),
                    child: Image.asset(
                      image ?? "images/user_image.png",
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
                "Services",
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
                                (context) => HealthProfDetail(
                                  service: "General Practitioner",
                                ),
                          ),
                        );
                      },
                      child:  Column(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(
                                20,
                              ), // Adjust the radius as needed
                              child: Image.asset(
                                "images/General Practitioner.jpg",
                                height: 200,
                                width: 220,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ],
                        
                      ),
                    ),
                  ),
                  SizedBox(width: 20.0),

                  Flexible(
                    fit: FlexFit.tight,
                    child: GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder:
                                (context) =>
                                    HealthProfDetail(service: "Psychologist"),
                          ),
                        );
                      },
                      child:  Column(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(
                                20,
                              ), // Adjust the radius as needed
                              child: Image.asset(
                                "images/psychologist.jpg",
                                height: 200,
                                width: 220,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ],
                      ),
                    ),
                  ),
                ],
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
                                (context) =>
                                    HealthProfDetail(service: "Chiropractor"),
                          ),
                        );
                      },
                      child:  Column(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(
                                20,
                              ), // Adjust the radius as needed
                              child: Image.asset(
                                "images/chiropractor.jpg",
                                height: 200,
                                width: 220,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ],
                      )
                    ),
                  ),
                  SizedBox(width: 20.0),

                  Flexible(
                    fit: FlexFit.tight,
                    child: GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder:
                                (context) =>
                                    HealthProfDetail(service: "Dentist"),
                          ),
                        );
                      },
                      child:  Column(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(
                                20,
                              ), // Adjust the radius as needed
                              child: Image.asset(
                                "images/dentist.jpg",
                                height: 200,
                                width: 220,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ],
                        
                    ),
                  ),
                  )
                ],
              ),

              SizedBox(height: 20.0),
              //////////////////////////
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
                                (context) =>
                                    HealthProfDetail(service: "Pharmacist"),
                          ),
                        );
                      },
                      child:  Column(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(
                                20,
                              ), // Adjust the radius as needed
                              child: Image.asset(
                                "images/pharmacist.jpg",
                                height: 200,
                                width: 220,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ],
                        )
                    ),
                  ),
                  SizedBox(width: 20.0),

                  Flexible(
                    fit: FlexFit.tight,
                    child: GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder:
                                (context) => HealthProfDetail(service: "Nurse"),
                          ),
                        );
                      },
                      child:  Column(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(
                                20,
                              ), // Adjust the radius as needed
                              child: Image.asset(
                                "images/nurse.jpg",
                                height: 200,
                                width: 220,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ],
                        )
                      
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

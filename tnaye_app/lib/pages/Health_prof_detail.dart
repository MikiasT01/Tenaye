import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tnaye_app/pages/booking.dart';

class HealthProfDetail extends StatefulWidget {
  final String service;

  const HealthProfDetail({super.key, required this.service});

  @override
  State<HealthProfDetail> createState() => _HealthProffDetailState();
}

class _HealthProffDetailState extends State<HealthProfDetail> {
  List<Map<String, dynamic>> healthProfessionals = [];
  late String doctor_type;
  bool isLoading = true;

  Future<void> _loadHealthProffData() async {
    try {
      final snapshot = await FirebaseFirestore.instance
          .collection(doctor_type)
          .get();
      setState(() {
        healthProfessionals = snapshot.docs.map((doc) => doc.data() as Map<String, dynamic>).toList();
        isLoading = false;
      });
    } catch (e) {
      print("Error loading health professionals: $e");
      setState(() {
        isLoading = false;
      });
      
    }
  }

  @override
  void initState() {
    super.initState();
    doctor_type = "Health_professional_" +
        (widget.service.substring(0, 1).toUpperCase() + widget.service.substring(1));
    _loadHealthProffData();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.pop(context);
        return true;
      },
      child: Scaffold(
        body: Container(
          decoration: const BoxDecoration(
           
          color: Color.fromARGB(255, 103, 61, 172),

            
          ),
          child: CustomScrollView(
            slivers: [
              SliverPadding(
                padding: const EdgeInsets.only(
                  top: 50.0,
                  left: 50.0,
                  right: 50.0,
                ),
                sliver: SliverToBoxAdapter(
                  child: Text(
                 "Trusted Care from our expert\n"+ (widget.service.substring(0, 1).toUpperCase() + widget.service.substring(1))+"s",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              SliverPadding(
                padding: const EdgeInsets.only(
                  top: 20.0,
                  left: 20.0,
                  right: 20.0,
                ),
                sliver: isLoading
                    ? SliverToBoxAdapter(
                        child: Center(
                          child: CircularProgressIndicator(),
                        ),
                      )
                    : healthProfessionals.isEmpty
                        ? SliverToBoxAdapter(
                            child: Center(
                              child: Text(
                                "No health professionals are currently available.",
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                          )
                        : SliverList(
                            delegate: SliverChildBuilderDelegate(
                              (context, index) {
                                final doctor = healthProfessionals[index];
                                return GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            Booking(service: doctor['Name'],
                                            imageUrl: doctor['ImageUrl'] ?? '', // Assuming you have an image URL field),
                                            bio: doctor['Bio'] ?? '',
                                            age: doctor['Age'] ?? '',
                                            speciality: doctor['Speciality'] ?? '',)
                                      ),
                                    );
                                  },
                                  child: Container(
                                    margin: const EdgeInsets.symmetric(vertical: 10),
                                    padding: const EdgeInsets.all(16),
                                    decoration: BoxDecoration(
                                      color:Color.fromARGB(255, 74, 172, 218),

                                      borderRadius: BorderRadius.circular(50),

                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black26,
                                          blurRadius: 10,
                                          offset: Offset(0, 5),
                                        ),
                                      ],
                                    ),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children: [
                                        Text(
                                          " Dr ${doctor['Name'] ?? ''}",
                                          style: const TextStyle(
                                            fontSize: 20,
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        const SizedBox(height: 8),
                                        Text(
                                          "Age: ${doctor['Age'] ?? ''}",
                                          style: const TextStyle(color: Colors.white),
                                        ),
                                        Text(
                                          "Speciality: ${doctor['Speciality'] ?? ''}",
                                          style: const TextStyle(color: Colors.white),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              },
                              childCount: healthProfessionals.length,
                            ),
                          ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
        
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
     
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tnaye_app/pages/Alldoctorespage.dart';
import 'package:tnaye_app/pages/Booking.dart';
import 'package:tnaye_app/pages/Health_prof_detail.dart';
import 'base_scaffold.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  Future<List<Map<String, dynamic>>> _fetchBestDoctors() async {
    final collections = [
      'Health_professional_Dentist',
      'Health_professional_General Practitioner',
      'Health_professional_Psychologist',
      'Health_professional_Chiropractor',
      'Health_professional_Pharmacist',
      'Health_professional_Nurse',
    ];
    List<Map<String, dynamic>> allDoctors = [];

    for (var collection in collections) {
      final snapshot = await FirebaseFirestore.instance
          .collection(collection)
          .orderBy('averageRating', descending: true)
          .limit(5) // Limit per collection to avoid exceeding 5 total
          .get();
      allDoctors.addAll(snapshot.docs.map((doc) => {
            ...doc.data() as Map<String, dynamic>,
            'id': doc.id,
          }));
    }

    // Sort by averageRating and limit to top 5
    allDoctors.sort((a, b) => (b['averageRating'] ?? 0.0).compareTo(a['averageRating'] ?? 0.0));
    return allDoctors.take(5).toList(); // Limit to 5 doctors total
  }

  @override
  Widget build(BuildContext context) {
    return BaseScaffold(
      body: Container(
        margin: const EdgeInsets.symmetric(horizontal: 15.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 15.0),
              const Text(
                "Categories",
                style: TextStyle(
                  color: Color.fromARGB(255, 89, 57, 127),
                  fontSize: 18.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 15.0),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    _buildCategoryCard(context, "General Practitioner", "images/General practitioner.jpg"),
                    _buildCategoryCard(context, "psychologist", "images/psychologist.jpg"),
                    _buildCategoryCard(context, "chiropractor", "images/Chiropractor.jpg"),
                    _buildCategoryCard(context, "dentist", "images/dentist.jpg"),
                    _buildCategoryCard(context, "Pharmacist", "images/Pharmacist.jpg"),
                    _buildCategoryCard(context, "Nurse", "images/nurse.jpg"),
                  ],
                ),
              ),
              const SizedBox(height: 20.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "Best Doctors",
                    style: TextStyle(
                      color: Color.fromARGB(255, 89, 57, 127),
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20.0),
              SizedBox(
                height: 150,
                child: FutureBuilder<List<Map<String, dynamic>>>(
                  future: _fetchBestDoctors(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(
                          child: CircularProgressIndicator(
                              color: Color.fromARGB(255, 89, 57, 127)));
                    }
                    if (snapshot.hasError || !snapshot.hasData || snapshot.data!.isEmpty) {
                      return const Text(
                        'No doctors available',
                        style: TextStyle(
                            color: Color.fromARGB(255, 89, 57, 127), fontSize: 12.0),
                      );
                    }
                    final doctors = snapshot.data!;
                    return SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: doctors.map((doctor) {
                          int age = 0;
                          try {
                            age = doctor['Age'] is String
                                ? int.parse(doctor['Age'])
                                : (doctor['Age'] as int? ?? 0);
                          } catch (e) {
                            print('Error parsing Age for doctor ${doctor['Name']}: $e');
                          }
                          return _buildDoctorCard(
                            context,
                            doctor['Name'],
                            doctor['Speciality'] ?? '',
                            doctor['imageurl'] ?? '',
                            doctor['averageRating']?.toDouble() ?? 0.0,
                            age,
                            doctor['Bio'] ?? '',
                          );
                        }).toList(),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 20.0),
              Center(
                child: GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => AllDoctorspage()),
                    );
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
                    margin: EdgeInsets.all(10.0),
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
                    child: const Text(
                      "View all",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 12.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      currentIndex: 0,
    );
  }

  Widget _buildCategoryCard(BuildContext context, String service, String imagePath) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => HealthProfDetail(service: service)),
        );
      },
      child: Container(
        margin: const EdgeInsets.only(right: 10.0),
        child: Column(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(15.0),
              child: Image.asset(
                imagePath,
                height: 150,
                width: 160,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    height: 150,
                    width: 160,
                    color: Colors.grey,
                    child: const Icon(Icons.error, color: Colors.red),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDoctorCard(
    BuildContext context,
    String name,
    String specialty,
    String imageUrl,
    double rating,
    int age,
    String bio,
  ) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => Booking(
              service: name,
              imageUrl: imageUrl,
              bio: bio,
              age: age,
              speciality: specialty,
            ),
          ),
        );
      },
      child: Container(
        width: 200,
        margin: const EdgeInsets.only(right: 10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(15.0),
              child: imageUrl.isNotEmpty
                    ? Image.network(
                      imageUrl,
                      height: 80,
                      width: 120,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        print('Error loading image for $name: $error');
                        return Container(
                          height: 80,
                          width: 120,
                          color: Colors.grey,
                          child: const Icon(Icons.error, color: Colors.red),
                        );
                      },
                      loadingBuilder: (context, child, loadingProgress) {
                        if (loadingProgress == null) return child;
                        return Container(
                          height: 120,
                          width: 120,
                          color: Colors.grey[200],
                          child: const Center(child: CircularProgressIndicator()),
                        );
                      },
                    )
                  : Container(
                      height: 80,
                      width: 120,
                      color: Colors.grey,
                      child: const Icon(Icons.person, color: Colors.white),
                    ),
            ),
            const SizedBox(height: 10.0),
            Text(
              name,
              style: const TextStyle(
                color: Color.fromARGB(255, 89, 57, 127),
                fontSize: 10.0,
                fontWeight: FontWeight.w500,
              ),
              overflow: TextOverflow.ellipsis,
            ),
            Row(
              children: [
                Expanded(
                  child: Text(
                    specialty,
                    style: TextStyle(
                        color: Color.fromARGB(255, 89, 57, 127).withOpacity(0.6),
                        fontSize: 10.0),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                const SizedBox(width: 5.0),
                Row(
                  children: [
                    const Icon(Icons.star,
                        color: Color.fromARGB(255, 244, 240, 3), size: 12.0),
                    const SizedBox(width: 3.0),
                    Text(
                      rating.toStringAsFixed(1),
                      style: const TextStyle(
                        color: Color.fromARGB(255, 89, 57, 127),
                        fontSize: 10.0,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
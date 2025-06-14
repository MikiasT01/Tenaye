import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tnaye_app/pages/Booking.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:tnaye_app/services/shared_pref.dart';
import 'base_scaffold.dart';

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
  double? userRating;
  String? userId;

  Future<void> _loadHealthProffData() async {
    try {
      final snapshot = await FirebaseFirestore.instance
          .collection(doctor_type)
          .orderBy('averageRating', descending: true)
          .get();
      setState(() {
        healthProfessionals = snapshot.docs.map((doc) => {
              ...doc.data() as Map<String, dynamic>,
              'id': doc.id,
            }).toList();
        isLoading = false;
      });
    } catch (e) {
      print("Error loading health professionals: $e");
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> _loadUserId() async {
    userId = await SharedPreferencesHelper().getUserId();
    setState(() {});
  }

  Future<void> _submitRating(String doctorId) async {
    if (userRating == null || userId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select a rating')),
      );
      return;
    }

    final doctorRef = FirebaseFirestore.instance.collection(doctor_type).doc(doctorId);
    final ratingRef = doctorRef.collection('ratings').doc(userId);

    final existingRating = await ratingRef.get();
    if (existingRating.exists) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('You have already rated this doctor!')),
      );
      return;
    }

    await ratingRef.set({
      'userId': userId,
      'rating': userRating,
      'timestamp': FieldValue.serverTimestamp(),
    });

    await _updateAverageRating(doctorRef);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Rating submitted successfully!')),
    );

    await _loadHealthProffData();
  }

  Future<void> _updateAverageRating(DocumentReference doctorRef) async {
    final ratingsSnapshot = await doctorRef.collection('ratings').get();
    if (ratingsSnapshot.docs.isEmpty) {
      await doctorRef.update({
        'averageRating': 0.0,
        'ratingCount': 0,
      });
      return;
    }

    double totalRating = 0;
    for (var doc in ratingsSnapshot.docs) {
      totalRating += doc['rating'] as double;
    }
    double averageRating = totalRating / ratingsSnapshot.docs.length;

    await doctorRef.update({
      'averageRating': averageRating,
      'ratingCount': ratingsSnapshot.docs.length,
    });
  }

  @override
  void initState() {
    super.initState();
    doctor_type =
        "Health_professional_${widget.service.substring(0, 1).toUpperCase() + widget.service.substring(1)}";
    _loadHealthProffData();
    _loadUserId();
  }

  @override
  Widget build(BuildContext context) {
    return BaseScaffold(
      body: Container(
        margin: const EdgeInsets.symmetric(horizontal: 15.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 15.0),
            Row(
              children: [
                GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: const Icon(
                    Icons.arrow_back_ios_new_rounded,
                    color: Color.fromARGB(255, 89, 57, 127),
                    size: 25.0,
                  ),
                ),
                const SizedBox(width: 10.0),
                Expanded(
                  child: Text(
                    "Trusted Care from our expert ${widget.service.substring(0, 1).toUpperCase() + widget.service.substring(1)}s",
                    style: const TextStyle(
                      color: Color.fromARGB(255, 89, 57, 127),
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 15.0),
            isLoading
                ? const Center(child: CircularProgressIndicator(color: Color.fromARGB(255, 89, 57, 127)))
                : healthProfessionals.isEmpty
                    ? const Center(
                        child: Text(
                          "No health professionals are currently available.",
                          style: TextStyle(color: Color.fromARGB(255, 89, 57, 127), fontSize: 12.0),
                        ),
                      )
                    : Column(
                        children: healthProfessionals.asMap().entries.map((entry) {
                          final index = entry.key;
                          final doctor = entry.value;
                          return _buildProfessionalCard(
                            doctor,
                            index,
                          );
                        }).toList(),
                      ),
            const SizedBox(height: 60.0),
          ],
        ),
      ),
      currentIndex: 0,
    );
  }

  Widget _buildProfessionalCard(Map<String, dynamic> doctor, int index) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => Booking(
              service: doctor['Name'],
              imageUrl: doctor['imageurl'] ?? '', // Use 'imageurl' field
              bio: doctor['Bio'] ?? '',
              age: doctor['Age'] ?? 0,
              speciality: doctor['Speciality'] ?? '',
            ),
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 10),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
          boxShadow: const [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 6.0,
              offset: Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(15.0),
                  child: doctor['imageurl'] != null && doctor['imageurl'].isNotEmpty
                      ? Image.network(
                          doctor['imageurl'],
                          height: 90,
                          width: 90,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return Container(
                              height: 90,
                              width: 90,
                              color: Colors.grey,
                              child: const Icon(Icons.error, color: Colors.red),
                            );
                          },
                          loadingBuilder: (context, child, loadingProgress) {
                            if (loadingProgress == null) return child;
                            return Container(
                              height: 90,
                              width: 90,
                              color: Colors.grey[200],
                              child: const Center(child: CircularProgressIndicator()),
                            );
                          },
                        )
                      : Container(
                          height: 90,
                          width: 90,
                          color: Colors.grey,
                          child: const Icon(Icons.person, color: Colors.white),
                        ),
                ),
                const SizedBox(width: 15.0),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Dr ${doctor['Name'] ?? ''}",
                        style: const TextStyle(
                          fontSize: 16,
                          color: Color.fromARGB(255, 89, 57, 127),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 5),
                      Text(
                        "Age: ${doctor['Age'] ?? ''}",
                        style: TextStyle(
                          color: Color.fromARGB(255, 89, 57, 127).withOpacity(0.6),
                          fontSize: 12,
                        ),
                      ),
                      Text(
                        "Speciality: ${doctor['Speciality'] ?? ''}",
                        style: TextStyle(
                          color: Color.fromARGB(255, 89, 57, 127).withOpacity(0.6),
                          fontSize: 12,
                        ),
                      ),
                      Row(
                        children: [
                          const Icon(Icons.star,
                              color: Color.fromARGB(255, 244, 240, 3), size: 16.0),
                          const SizedBox(width: 5.0),
                          Text(
                            "${doctor['averageRating']?.toStringAsFixed(1) ?? 'N/A'} (${doctor['ratingCount'] ?? 0} reviews)",
                            style: const TextStyle(
                              color: Color.fromARGB(255, 89, 57, 127),
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            RatingBar.builder(
              initialRating: 0,
              minRating: 1,
              direction: Axis.horizontal,
              allowHalfRating: true,
              itemCount: 5,
              itemSize: 25.0,
              itemPadding: const EdgeInsets.symmetric(horizontal: 4.0),
              itemBuilder: (context, _) => const Icon(
                Icons.star,
                color: Colors.amber,
              ),
              onRatingUpdate: (rating) {
                setState(() {
                  userRating = rating;
                });
              },
            ),
            const SizedBox(height: 10),
            Align(
              alignment: Alignment.center,
              child: ElevatedButton(
                onPressed: () => _submitRating(doctor['id']),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromARGB(255, 89, 57, 127),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
                child: const Text('Submit Rating'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
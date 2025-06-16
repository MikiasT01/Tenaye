import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:tnaye_app/pages/home.dart';
import 'package:tnaye_app/services/shared_pref.dart';
import 'base_scaffold.dart';

class NotificationPage extends StatefulWidget {
  const NotificationPage({super.key});

  @override
  State<NotificationPage> createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
  int _currentIndex = 1; // Set to 1 for Notifications tab
  String? userName;
  String? userId;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    userName = await SharedPreferencesHelper().getUserName();
    userId = await SharedPreferencesHelper().getUserId();
    setState(() {});
  }

  Stream<QuerySnapshot> _fetchBookings() {
    return FirebaseFirestore.instance
        .collection('Bookings')
        .where('userName', isEqualTo: userName ?? '')
        .orderBy('timestamp', descending: true)
        .snapshots();
  }

  Future<void> _submitRating(String specialty, String doctorId, double rating, String bookingId) async {
    if (userId == null || !mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('User ID not found or widget disposed')),
      );
      return;
    }

    final doctorRef = FirebaseFirestore.instance
        .collection('Health_professional_${specialty ?? 'Unknown'}')
        .doc(doctorId);
    final ratingRef = doctorRef.collection('ratings').doc(userId);

    final existingRating = await ratingRef.get();
    if (existingRating.exists) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('You have already rated this doctor!')),
      );
      return;
    }

    try {
      await ratingRef.set({
        'userId': userId,
        'rating': rating,
        'timestamp': FieldValue.serverTimestamp(),
      });

      await _updateAverageRating(doctorRef);

      // Delete the booking notification after rating submission
      await FirebaseFirestore.instance.collection('Bookings').doc(bookingId).delete();

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Rating submitted successfully!')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error submitting rating: $e')),
        );
      }
    }
  }

  Future<void> _updateAverageRating(DocumentReference doctorRef) async {
    try {
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
    } catch (e) {
      print('Error updating average rating: $e');
    }
  }

  Future<bool> _hasUserRated(String specialty, String doctorId) async {
    if (userId == null) return false;
    final doctorRef = FirebaseFirestore.instance
        .collection('Health_professional_${specialty ?? 'Unknown'}')
        .doc(doctorId);
    final ratingRef = doctorRef.collection('ratings').doc(userId);
    final snapshot = await ratingRef.get();
    return snapshot.exists;
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
            const Text(
              "Notifications",
              style: TextStyle(
                color: Color.fromARGB(255, 89, 57, 127),
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 15.0),
            SizedBox(
              height: MediaQuery.of(context).size.height - kToolbarHeight - kBottomNavigationBarHeight - 50.0,
              child: SingleChildScrollView(
                child: StreamBuilder<QuerySnapshot>(
                  stream: _fetchBookings(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator(color: Color.fromARGB(255, 89, 57, 127)));
                    }
                    if (snapshot.hasError) {
                      return Center(
                        child: Text(
                          "Error loading notifications ${snapshot.error}",
                          style: const TextStyle(color: Color.fromARGB(255, 89, 57, 127), fontSize: 12.0),
                        ),
                      );
                    }
                    if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                      return const Center(
                        child: Text(
                          "No notifications available",
                          style: TextStyle(color: Color.fromARGB(255, 89, 57, 127), fontSize: 18.0),
                        ),
                      );
                    }

                    final bookings = snapshot.data!.docs;
                    return ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: bookings.length,
                      itemBuilder: (context, index) {
                        final booking = bookings[index].data() as Map<String, dynamic>;
                        final selectedDate = (booking['selectedDate'] as Timestamp).toDate();
                        final imageUrl = booking['imageUrl']?.toString() ?? '';
                        final doctorId = booking['id']?.toString() ?? 'unknown';
                        final specialty = booking['speciality']?.toString() ?? 'Unknown';
                        final bookingId = bookings[index].id;
                        return FutureBuilder<bool>(
                          future: _hasUserRated(specialty, doctorId),
                          builder: (context, ratingSnapshot) {
                            if (ratingSnapshot.connectionState == ConnectionState.waiting) {
                              return Container(
                                margin: const EdgeInsets.only(bottom: 20.0),
                                padding: const EdgeInsets.all(16.0),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(20.0),
                                  boxShadow: const [
                                    BoxShadow(
                                      color: Colors.black12,
                                      blurRadius: 8.0,
                                      offset: Offset(0, 4),
                                    ),
                                  ],
                                ),
                                child: const Center(child: CircularProgressIndicator()),
                              );
                            }
                            final hasRated = ratingSnapshot.data ?? false;
                            return Container(
                              margin: const EdgeInsets.only(bottom: 20.0),
                              padding: const EdgeInsets.all(16.0),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(20.0),
                                boxShadow: const [
                                  BoxShadow(
                                    color: Colors.black12,
                                    blurRadius: 8.0,
                                    offset: Offset(0, 4),
                                  ),
                                ],
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      ClipRRect(
                                        borderRadius: BorderRadius.circular(10.0),
                                        child: imageUrl.isNotEmpty
                                            ? Image.network(
                                                imageUrl,
                                                width: 80,
                                                height: 80,
                                                fit: BoxFit.cover,
                                                errorBuilder: (context, error, stackTrace) {
                                                  print("Network image load error: $error");
                                                  return Image.asset(
                                                    "images/user_image.png",
                                                    width: 80,
                                                    height: 80,
                                                    fit: BoxFit.cover,
                                                    errorBuilder: (context, error, stackTrace) {
                                                      print("Asset image load error: $error");
                                                      return const Icon(
                                                        Icons.person,
                                                        size: 80,
                                                        color: Color.fromARGB(255, 89, 57, 127),
                                                      );
                                                    },
                                                  );
                                                },
                                              )
                                            : Image.asset(
                                                "images/user_image.png",
                                                width: 80,
                                                height: 80,
                                                fit: BoxFit.cover,
                                                errorBuilder: (context, error, stackTrace) {
                                                  print("Default asset load error: $error");
                                                  return const Icon(
                                                    Icons.person,
                                                    size: 80,
                                                    color: Color.fromARGB(255, 89, 57, 127),
                                                  );
                                                },
                                              ),
                                      ),
                                      const SizedBox(width: 16.0),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              "Booking Confirmed: ${booking['doctorName'] ?? 'Unknown'}",
                                              style: const TextStyle(
                                                color: Color.fromARGB(255, 89, 57, 127),
                                                fontSize: 18.0,
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                            Text(
                                              "Speciality: $specialty",
                                              style: TextStyle(
                                                color: Color.fromARGB(255, 89, 57, 127).withOpacity(0.6),
                                                fontSize: 14.0,
                                              ),
                                            ),
                                            Text(
                                              "Age: ${booking['age']?.toString() ?? 'Unknown'}",
                                              style: TextStyle(
                                                color: Color.fromARGB(255, 89, 57, 127).withOpacity(0.6),
                                                fontSize: 14.0,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 10.0),
                                  Text(
                                    "Date: ${DateFormat('dd/MM/yyyy').format(selectedDate)}",
                                    style: const TextStyle(
                                      color: Color.fromARGB(255, 89, 57, 127),
                                      fontSize: 14.0,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  Text(
                                    "Time: ${booking['selectedTime'] ?? 'Unknown'}",
                                    style: const TextStyle(
                                      color: Color.fromARGB(255, 89, 57, 127),
                                      fontSize: 14.0,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  if (!hasRated) ...[
                                    const SizedBox(height: 10.0),
                                    ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: const Color.fromARGB(255, 89, 57, 127),
                                      ),
                                      onPressed: () async {
                                        double? rating;
                                        await showDialog(
                                          context: context,
                                          builder: (context) => AlertDialog(
                                            title: const Text('Rate Your Experience'),
                                            content: Column(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                RatingBar.builder(
                                                  initialRating: 0,
                                                  minRating: 1,
                                                  direction: Axis.horizontal,
                                                  allowHalfRating: true,
                                                  itemCount: 5,
                                                  itemSize: 30.0,
                                                  itemPadding: const EdgeInsets.symmetric(horizontal: 4.0),
                                                  itemBuilder: (context, _) => const Icon(
                                                    Icons.star,
                                                    color: Colors.amber,
                                                  ),
                                                  onRatingUpdate: (value) {
                                                    rating = value;
                                                  },
                                                ),
                                                const SizedBox(height: 20.0),
                                                ElevatedButton(
                                                  style: ElevatedButton.styleFrom(
                                                    backgroundColor: const Color.fromARGB(255, 89, 57, 127),
                                                  ),
                                                  onPressed: () {
                                                    if (rating != null) {
                                                      Navigator.pop(context, rating);
                                                    } else {
                                                      ScaffoldMessenger.of(context).showSnackBar(
                                                        const SnackBar(content: Text('Please select a rating')),
                                                      );
                                                    }
                                                  },
                                                  child: const Text('Submit Rating', style: TextStyle(color: Colors.white)),
                                                ),
                                              ],
                                            ),
                                            actions: [
                                              TextButton(
                                                onPressed: () => Navigator.pop(context),
                                                child: const Text('Cancel'),
                                              ),
                                            ],
                                          ),
                                        );
                                        if (rating != null && mounted) {
                                          await _submitRating(specialty, doctorId, rating!, bookingId);
                                        }
                                      },
                                      child: const Text('Session Completed', style: TextStyle(color: Colors.white)),
                                    ),
                                  ],
                                ],
                              ),
                            );
                          },
                        );
                      },
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
      currentIndex: _currentIndex,
    );
  }

  // Placeholder for _confirmLogout (assumed from BaseScaffold)
  Future<void> _confirmLogout(BuildContext context) async {
    bool confirm = await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirm Logout', style: TextStyle(color: Color.fromARGB(255, 89, 57, 127), fontSize: 16.0)),
        content: const Text('Are you sure you want to log out?', style: TextStyle(color: Color.fromARGB(255, 89, 57, 127), fontSize: 14.0)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel', style: TextStyle(color: Color.fromARGB(255, 89, 57, 127), fontSize: 14.0)),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Logout', style: TextStyle(color: Color.fromARGB(255, 89, 57, 127), fontSize: 14.0)),
          ),
        ],
      ),
    ) ?? false;

    if (confirm) {
      await SharedPreferencesHelper().clearUserData();
      Navigator.pushReplacementNamed(context, '/login');
    }
  }
}
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
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

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    userName = await SharedPreferencesHelper().getUserName();
    setState(() {});
  }

  Stream<QuerySnapshot> _fetchBookings() {
    return FirebaseFirestore.instance
        .collection('Bookings')
        .where('userName', isEqualTo: userName ?? '')
        .orderBy('timestamp', descending: true)
        .snapshots();
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
              height: MediaQuery.of(context).size.height - kToolbarHeight - kBottomNavigationBarHeight - 50.0, // Adjusted for minimal header
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
                                          "Booking Confirmed: ${booking['service']}",
                                          style: const TextStyle(
                                            color: Color.fromARGB(255, 89, 57, 127),
                                            fontSize: 18.0,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                        Text(
                                          "Speciality: ${booking['speciality']}",
                                          style: TextStyle(
                                            color: Color.fromARGB(255, 89, 57, 127).withOpacity(0.6),
                                            fontSize: 14.0,
                                          ),
                                        ),
                                        Text(
                                          "Age: ${booking['age']}",
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
                                "Time: ${booking['selectedTime']}",
                                style: const TextStyle(
                                  color: Color.fromARGB(255, 89, 57, 127),
                                  fontSize: 14.0,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
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
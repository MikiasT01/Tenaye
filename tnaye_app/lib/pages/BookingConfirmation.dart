import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:tnaye_app/pages/Noticifications.dart';
import 'package:tnaye_app/pages/home.dart';

class BookingConfirmation extends StatefulWidget {
  final String service;
  final String imageUrl;
  final int age;
  final String speciality;
  final DateTime selectedDate;
  final TimeOfDay selectedTime;

  const BookingConfirmation({
    super.key,
    required this.service,
    required this.imageUrl,
    required this.age,
    required this.speciality,
    required this.selectedDate,
    required this.selectedTime,
  });

  @override
  State<BookingConfirmation> createState() => _BookingConfirmationState();
}

class _BookingConfirmationState extends State<BookingConfirmation> {
  int _currentIndex = 0; // Track the selected bottom navigation item

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 103, 61, 172),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header (User Greeting)
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Text(
                          "Hello, ",
                          style: TextStyle(
                            color: Color.fromARGB(255, 217, 217, 218),
                            fontSize: 24.0,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        Text(
                          "User", // Replace with dynamic name if available
                          style: TextStyle(
                            color: Color.fromARGB(255, 241, 240, 244),
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
                        errorBuilder: (context, error, stackTrace) {
                          print("Header image error: $error"); // Debug log
                          return const Icon(
                            Icons.person,
                            size: 60.0,
                            color: Colors.grey,
                          );
                        },
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20.0),
                const Divider(color: Colors.white70),
                const SizedBox(height: 20.0),

                // Booking Confirmation Content
                Container(
                  padding: const EdgeInsets.all(16.0),
                  decoration: BoxDecoration(
                    color: const Color.fromARGB(255, 237, 241, 240),
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
                      const Text(
                        "Booking Confirmed!",
                        style: TextStyle(
                          color: Color.fromARGB(255, 103, 61, 172),
                          fontSize: 24.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 20.0),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(10.0),
                            child: Image.network(
                              widget.imageUrl,
                              width: 100,
                              height: 100,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) {
                                return Image.asset(
                                  "images/user_image.png",
                                  width: 100,
                                  height: 100,
                                  fit: BoxFit.cover,
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
                                  widget.service,
                                  style: const TextStyle(
                                    color: Color.fromARGB(255, 103, 61, 172),
                                    fontSize: 20.0,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                Text(
                                  "Dr. ${widget.service.split(' ').last}",
                                  style: const TextStyle(
                                    color: Color.fromARGB(255, 136, 67, 67),
                                    fontSize: 18.0,
                                  ),
                                ),
                                Text(
                                  "Age: ${widget.age}",
                                  style: const TextStyle(
                                    color: Color.fromARGB(255, 184, 92, 92),
                                  ),
                                ),
                                Text(
                                  widget.speciality,
                                  style: const TextStyle(
                                    color: Color.fromARGB(255, 190, 67, 67),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20.0),
                      Text(
                        "Date: ${DateFormat('dd/MM/yyyy').format(widget.selectedDate)}",
                        style: const TextStyle(
                          fontSize: 16.0,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      Text(
                        "Time: ${widget.selectedTime.format(context)}",
                        style: const TextStyle(
                          fontSize: 16.0,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                     
                    ],
                  ),
                ),
                const SizedBox(height: 20.0),
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const Home(), // Return to Home
                      ),
                    );
                  },
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(vertical: 12.0),
                    decoration: BoxDecoration(
                      color: const Color.fromARGB(255, 81, 50, 136),
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: const [
                        BoxShadow(
                          color: Colors.black12,
                          blurRadius: 8.0,
                          offset: Offset(0, 4),
                        ),
                      ],
                    ),
                    child: const Center(
                      child: Text(
                        "Back to Home",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20.0,
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
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: const Color.fromARGB(255, 87, 25, 180),
        selectedItemColor: const Color.fromARGB(255, 202, 36, 36),
        unselectedItemColor: const Color.fromARGB(179, 155, 33, 153),
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
          switch (index) {
            case 0:
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const Home()),
              );
              break;
            case 1:
              Navigator.pushReplacement(
               
                context,
                MaterialPageRoute(
                  builder: (context) => NotificationPage(
                    ),
                ),
              );
              break;
            case 2:
              // Navigate to Messages
              break;
            case 3:
              // Navigate to Profile
              break;
          }
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(
            icon: Icon(Icons.notifications),
            label: 'Notifications',
          ),
          BottomNavigationBarItem(icon: Icon(Icons.message), label: 'Messages'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
      ),
    );
  }
}
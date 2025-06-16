import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:tnaye_app/pages/BookingConfirmation.dart';
import 'package:tnaye_app/services/shared_pref.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'base_scaffold.dart';

class Booking extends StatefulWidget {
  final String service;
  final String imageUrl;
  final String bio;
  final int age;
  final String speciality;

  const Booking({
    super.key,
    required this.service,
    required this.imageUrl,
    required this.bio,
    required this.age,
    required this.speciality,
  });

  @override
  State<Booking> createState() => _BookingState();
}

class _BookingState extends State<Booking> {
  DateTime _selectedDate = DateTime.now();
  TimeOfDay _selectedTime = TimeOfDay.now();
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

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: Color.fromARGB(255, 103, 61, 172),
              onPrimary: Colors.white,
              surface: Colors.white,
              onSurface: Colors.black,
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: _selectedTime,
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: Color.fromARGB(255, 112, 81, 161),
              onPrimary: Colors.white,
              surface: Colors.white,
              onSurface: Colors.black,
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null && picked != _selectedTime) {
      setState(() {
        _selectedTime = picked;
      });
    }
  }

  void _confirmBooking(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirm Booking'),
        content: Text(
          'Booking for ${widget.service} on '
          '${DateFormat('dd/MM/yyyy').format(_selectedDate)} at '
          '${_selectedTime.format(context)}.\nProceed?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              Map<String, dynamic> bookingData = {
                'doctorName': widget.service, // Explicitly save doctor's name
                'imageUrl': widget.imageUrl,
                'speciality': widget.speciality,
                'age': widget.age,
                'selectedDate': Timestamp.fromDate(_selectedDate),
                'selectedTime': _selectedTime.format(context),
                'userName': userName ?? 'Unknown User',
                'timestamp': Timestamp.now(),
              };

              try {
                await FirebaseFirestore.instance.collection('Bookings').add(bookingData);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Booking confirmed for ${widget.service}!'),
                    backgroundColor: const Color.fromARGB(255, 110, 214, 183),
                  ),
                );
              } catch (e) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Failed to save booking. Please try again.'),
                    backgroundColor: Colors.red,
                  ),
                );
                print("Error saving booking: $e");
              }

              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => BookingConfirmation(
                    service: widget.service,
                    imageUrl: widget.imageUrl,
                    age: widget.age,
                    speciality: widget.speciality,
                    selectedDate: _selectedDate,
                    selectedTime: _selectedTime,
                  ),
                ),
              );
            },
            child: const Text('Confirm'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BaseScaffold(
      body: SingleChildScrollView(
        child: Container(
          margin: EdgeInsets.symmetric(
            horizontal: MediaQuery.of(context).size.width * 0.05,
            vertical: 20.0,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: const Padding(
                      padding: EdgeInsets.only(top: 20.0),
                      child: Icon(
                        Icons.arrow_back_ios_new_rounded,
                        color: Color.fromARGB(255, 78, 39, 39),
                        size: 35.0,
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      "Book your Appointment",
                      style: const TextStyle(
                        color: Color.fromARGB(255, 89, 57, 127),
                        fontSize: 15.0,
                        fontWeight: FontWeight.w500,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20.0),
              Container(
                padding: const EdgeInsets.all(16.0),
                constraints: BoxConstraints(
                  maxWidth: MediaQuery.of(context).size.width * 0.9,
                ),
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
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Column(
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
                                errorBuilder: (context, error, stackTrace) {
                                  return const Icon(
                                    Icons.person,
                                    size: 100.0,
                                    color: Colors.grey,
                                  );
                                },
                              );
                            },
                          ),
                        ),
                        const SizedBox(height: 10.0),
                        Text(
                          "Dr. ${widget.service.split(' ').last}",
                          style: const TextStyle(
                            color: Color.fromARGB(255, 136, 67, 67),
                            fontSize: 15.0,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        widget.speciality.trim().contains(' ')
                          ? Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: widget.speciality
                              .split(' ')
                              .map((word) => Text(
                                  word,
                                  style: const TextStyle(
                                  color: Color.fromARGB(255, 190, 67, 67),
                                  fontSize: 10.0,
                                  fontWeight: FontWeight.w400,
                                  ),
                                ))
                              .toList(),
                            )
                          : Text(
                            widget.speciality,
                            style: const TextStyle(
                              color: Color.fromARGB(255, 190, 67, 67),
                              fontSize: 10.0,
                              fontWeight: FontWeight.w400,
                            ),
                            ),
                        const SizedBox(height: 5.0),
                        Text(
                          "Age: ${widget.age}",
                          style: const TextStyle(
                            color: Color.fromARGB(255, 184, 92, 92),
                            fontSize: 10.0,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        const SizedBox(height: 10.0),
                      ],
                    ),
                    const SizedBox(width: 16.0),
                    Expanded(
                      child: SizedBox(
                        height: 150.0,
                        child: SingleChildScrollView(
                          child: Text(
                            widget.bio,
                            style: const TextStyle(
                              color: Color.fromARGB(233, 56, 48, 73),
                              fontSize: .0,
                            ),
                            overflow: TextOverflow.ellipsis,
                            maxLines: 15,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.all(10.0),
                    width: MediaQuery.of(context).size.width * 0.4,
                    decoration: BoxDecoration(
                      color: const Color.fromARGB(255, 227, 236, 234),
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                    child: Column(
                      children: [
                        const Text(
                          "Select Date",
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 12.0,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 10.0),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            GestureDetector(
                              onTap: () => _selectDate(context),
                              child: const Icon(
                                Icons.calendar_month_rounded,
                                color: Colors.black,
                                size: 15.0,
                              ),
                            ),
                            const SizedBox(width: 5.0),
                            Text(
                              DateFormat('dd/MM/yyyy').format(_selectedDate),
                              style: const TextStyle(
                                color: Colors.black,
                                fontSize: 10.0,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 20.0),
                  Container(
                    padding: const EdgeInsets.all(10.0),
                    width: MediaQuery.of(context).size.width * 0.4,
                    decoration: BoxDecoration(
                      color: const Color.fromARGB(255, 227, 236, 234),
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                    child: Column(
                      children: [
                        const Text(
                          "Select Time",
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 12.0,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 10.0),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            GestureDetector(
                              onTap: () => _selectTime(context),
                              child: const Icon(
                                Icons.access_time_rounded,
                                color: Color.fromARGB(255, 32, 1, 1),
                                size: 12.0,
                              ),
                            ),
                            const SizedBox(width: 5.0),
                            Text(
                              _selectedTime.format(context),
                              style: const TextStyle(
                                color: Colors.black,
                                fontSize: 12.0,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20.0),
              GestureDetector(
                onTap: () => _confirmBooking(context),
                child: Container(
                  width: MediaQuery.of(context).size.width * 0.9,
                  padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 12.0),
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
                      "Confirm Appointment",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 15.0,
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
}
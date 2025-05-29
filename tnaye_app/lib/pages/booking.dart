import 'package:flutter/material.dart';
import 'package:intl/intl.dart';


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

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime.now(), // 1 year before today
      lastDate: DateTime.now().add(Duration(days: 365)), // 1 year after today
    builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: Color.fromARGB(255, 103, 61, 172), // Matches background
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
              primary: Color.fromARGB(255, 112, 81, 161), // Matches background
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
            onPressed: () {
              // TODO: Implement actual booking logic (e.g., API call)
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Booking confirmed for ${widget.service}!'),
                  backgroundColor: const Color.fromARGB(255, 110, 214, 183),
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
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 83, 135, 165),

      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            margin: EdgeInsets.only(top: 50.0, left: 50.0, right: 50.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: Padding(
                        padding: const EdgeInsets.only(top: 20.0),
                        child: Icon(
                          Icons.arrow_back_ios_new_rounded,
                          color: Colors.white,
                          size: 35.0,
                        ),
                      ),
                    ),
                  const  SizedBox(width: 20),
                    Text(
                      "Book your appointment",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20.0,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
          
                   const Spacer(),
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
                const SizedBox(height: 30.0),
                Container(
                  padding: const EdgeInsets.all(16.0),
                  constraints: BoxConstraints(
                    minHeight:
                        200, // Minimum height is 200, grows if content is larger
                  ),
                  decoration: BoxDecoration(
                    color: const Color.fromARGB(255, 237, 241, 240),
                    borderRadius: BorderRadius.circular(20.0),
                    boxShadow: const [ // ADDED: Subtle shadow for depth
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
                      // Image form thhe DB Url
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(10.0),
                            child: Image.network(
                              widget.imageUrl, // Use the passed image URL
                              width: 100,
                              height: 100,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) {
                                return Image.asset(
                                  "images/user_image.png", // Fallback image
                                  width: 100,
                                  height: 100,
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) {
                                  return const Icon(Icons.person,
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
                            widget.service, // ADJUSTED: Use full service name for clarity
                            style: const TextStyle(
                              color: Color.fromARGB(255, 103, 61, 172), // ADJUSTED: Match theme color
                              fontSize: 20.0,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          Text(
                            "Dr. ${widget.service.split(' ').last}", // Simplified, adjust as needed
                            style: const TextStyle(
                              color: Color.fromARGB(255, 136, 67, 67),
                              fontSize: 20.0,
                              fontWeight: FontWeight.w500,
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
                          const SizedBox(height: 10.0),
                        ],
                      ),
                      const SizedBox(width: 16.0),
                      Expanded(
                        child: Text(
                          widget.bio,
                          style: const TextStyle(
                            color:  Colors.black87, 
                            fontSize: 14.0                            
                          ),
                          textAlign: TextAlign.left,
                        ),
                      ),
                    ],
                  ),
                ),
          
            const   SizedBox(height: 20.0),
          
                Row(
                  children: [
                    Container(
                      padding: EdgeInsets.all(10.0),
                      decoration: BoxDecoration(
                        color: const Color.fromARGB(255, 227, 236, 234),
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                      // width: MediaQuery.of(context).size.width,
                      child: Column(
                        children: [
                          Text(
                            "Select Date",
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 18.0,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(height: 10.0),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              GestureDetector(
                                onTap: () =>
                                  _selectDate(context),
                                
                                child: Icon(
                                  Icons.calendar_month_rounded,
                              color: Colors.black,
                                  size: 30.0,
                                ),
                              ),
                              const SizedBox(width: 20.0),
                              Text(
                                  DateFormat('dd/MM/yyyy').format(_selectedDate),              
                                   style: const TextStyle(
                              color: Colors.black,
                                  fontSize: 24.0,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    SizedBox(width: 20.0),
                    Container(
                      padding: EdgeInsets.all(10.0),
                      decoration: BoxDecoration(
                        color: const Color.fromARGB(255, 248, 250, 249),
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                      // width: MediaQuery.of(context).size.width,
                      child: Column(
                        children: [
                          Text(
                            "Select Time",
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 18.0,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(height: 10.0),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              GestureDetector(
                                onTap: () {
                                  _selectTime(context);
                                },
                                child: Icon(
                                  Icons.access_time_rounded,
                                  color: const Color.fromARGB(255, 32, 1, 1),
                                  size: 25.0,
                                ),
                              ),
                              SizedBox(width: 20.0),
                              Text(
                                _selectedTime.format(context),
                                style: TextStyle(
                              color: Colors.black,
                                  fontSize: 25.0,
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
                SizedBox(height: 20.0),
                GestureDetector(
                  onTap: () => _confirmBooking(context),
                  child: Container(
                    width: double.infinity,
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
    );
  }
}

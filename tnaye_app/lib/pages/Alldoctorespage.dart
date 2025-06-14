import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tnaye_app/pages/Booking.dart';
import 'base_scaffold.dart';

class AllDoctorspage extends StatefulWidget {
  const AllDoctorspage({super.key});

  @override
  State<AllDoctorspage> createState() => _AllDoctorspageState();
}

class _AllDoctorspageState extends State<AllDoctorspage> {
  final TextEditingController _searchController = TextEditingController();
  List<Map<String, dynamic>> _allDoctors = [];
  List<Map<String, dynamic>> _filteredDoctors = [];
  String? _selectedCategory;
  int? _selectedAge;
  String? _selectedGender;

  @override
  void initState() {
    super.initState();
    _fetchAllDoctors();
    _searchController.addListener(_filterDoctors);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _fetchAllDoctors() async {
    final specialties = [
      'Dentist',
      'General Practitioner',
      'Psychologist',
      'Chiropractor',
      'Pharmacist',
      'Nurse',
    ];
    List<Map<String, dynamic>> allDoctors = [];

    for (var specialty in specialties) {
      final collection = 'Health_professional_$specialty';
      final snapshot = await FirebaseFirestore.instance
          .collection(collection)
          .orderBy('averageRating', descending: true)
          .get();
      allDoctors.addAll(snapshot.docs.map((doc) => {
            ...doc.data() as Map<String, dynamic>,
            'id': doc.id,
            'specialty': specialty,
          }));
    }

    allDoctors.sort((a, b) => (b['averageRating'] ?? 0.0).compareTo(a['averageRating'] ?? 0.0));
    setState(() {
      _allDoctors = allDoctors;
      _filteredDoctors = allDoctors; // Initialize with all doctors
    });
  }

  void _filterDoctors() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      _filteredDoctors = _allDoctors.where((doctor) {
        final name = doctor['Name']?.toLowerCase() ?? '';
        return name.contains(query);
      }).toList();

      // Apply additional filters if set
      if (_selectedCategory != null) {
        _filteredDoctors = _filteredDoctors.where((doctor) => doctor['specialty'] == _selectedCategory).toList();
      }
      if (_selectedAge != null) {
        _filteredDoctors = _filteredDoctors.where((doctor) {
          int age = 0;
          try {
            age = doctor['Age'] is String ? int.parse(doctor['Age']) : (doctor['Age'] as int? ?? 0);
          } catch (e) {
            print('Error parsing Age for doctor ${doctor['Name']}: $e');
          }
          return age == _selectedAge;
        }).toList();
      }
      if (_selectedGender != null) {
        _filteredDoctors = _filteredDoctors.where((doctor) => doctor['Gender']?.toLowerCase() == _selectedGender?.toLowerCase()).toList();
      }
    });
  }

  void _showFilterDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Filter Doctors', style: TextStyle(color: Color.fromARGB(255, 89, 57, 127), fontSize: 18.0)),
          content: StatefulBuilder(
            builder: (context, setState) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  DropdownButton<String>(
                    hint: const Text('Select Category', style: TextStyle(color: Color.fromARGB(255, 89, 57, 127))),
                    value: _selectedCategory,
                    items: [
                      'Dentist',
                      'General Practitioner',
                      'Psychologist',
                      'Chiropractor',
                      'Pharmacist',
                      'Nurse',
                    ].map((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value, style: const TextStyle(color: Color.fromARGB(255, 89, 57, 127))),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        _selectedCategory = value;
                      });
                      _filterDoctors();
                      Navigator.pop(context);
                    },
                  ),
                  DropdownButton<int>(
                    hint: const Text('Select Age', style: TextStyle(color: Color.fromARGB(255, 89, 57, 127))),
                    value: _selectedAge,
                    items: [25, 30, 35, 40, 45, 50].map((int value) {
                      return DropdownMenuItem<int>(
                        value: value,
                        child: Text(value.toString(), style: const TextStyle(color: Color.fromARGB(255, 89, 57, 127))),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        _selectedAge = value;
                      });
                      _filterDoctors();
                      Navigator.pop(context);
                    },
                  ),
                  DropdownButton<String>(
                    hint: const Text('Select Gender', style: TextStyle(color: Color.fromARGB(255, 89, 57, 127))),
                    value: _selectedGender,
                    items: ['Male', 'Female', 'Other'].map((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value, style: const TextStyle(color: Color.fromARGB(255, 89, 57, 127))),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        _selectedGender = value;
                      });
                      _filterDoctors();
                      Navigator.pop(context);
                    },
                  ),
                ],
              );
            },
          ),
          actions: [
            TextButton(
              onPressed: () {
                setState(() {
                  _selectedCategory = null;
                  _selectedAge = null;
                  _selectedGender = null;
                });
                _filterDoctors();
                Navigator.pop(context);
              },
              child: const Text('Clear Filters', style: TextStyle(color: Color.fromARGB(255, 89, 57, 127), fontSize: 14.0)),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Close', style: TextStyle(color: Color.fromARGB(255, 89, 57, 127), fontSize: 14.0)),
            ),
          ],
        );
      },
    );
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
              "All Doctors",
              style: TextStyle(
                color: Color.fromARGB(255, 89, 57, 127),
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 15.0),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 15.0),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8.0),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 6.0,
                    offset: Offset(0, 3),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _searchController,
                      decoration: InputDecoration(
                        hintText: "Search by doctor name",
                        hintStyle: const TextStyle(color: Color.fromARGB(255, 89, 57, 127), fontSize: 12.0),
                        prefixIcon: const Icon(Icons.search, color: Color.fromARGB(255, 89, 57, 127), size: 18.0),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8.0),
                          borderSide: BorderSide.none,
                        ),
                        contentPadding: const EdgeInsets.symmetric(vertical: 10.0),
                      ),
                      onChanged: (value) {
                        _filterDoctors();
                      },
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.filter_list, color: Color.fromARGB(255, 89, 57, 127), size: 18.0),
                    onPressed: _showFilterDialog,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 15.0),
            SizedBox(
              height: MediaQuery.of(context).size.height - kToolbarHeight - kBottomNavigationBarHeight - 100.0,
              child: SingleChildScrollView(
                child: _filteredDoctors.isEmpty
                    ? const Center(
                        child: Text(
                          'No doctors found',
                          style: TextStyle(color: Color.fromARGB(255, 89, 57, 127), fontSize: 18.0),
                        ),
                      )
                    : GridView.builder(
                        padding: EdgeInsets.only(bottom: kBottomNavigationBarHeight + 10.0),
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 10.0,
                          mainAxisSpacing: 10.0,
                          childAspectRatio: 0.75,
                        ),
                        itemCount: _filteredDoctors.length,
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemBuilder: (context, index) {
                          final doctor = _filteredDoctors[index];
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
                            doctor['specialty'] ?? doctor['Speciality'],
                            doctor['imageurl'] ?? '',
                            doctor['averageRating']?.toDouble() ?? 0.0,
                            age,
                            doctor['Bio'] ?? '',
                          );
                        },
                      ),
              ),
            ),
          ],
        ),
      ),
      currentIndex: 0,
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
        margin: const EdgeInsets.only(bottom: 10.0),
        padding: const EdgeInsets.all(8.0),
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
            ClipRRect(
              borderRadius: BorderRadius.circular(15.0),
              child: imageUrl.isNotEmpty
                  ? Image.network(
                      imageUrl,
                      height: 100,
                      width: double.infinity,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          height: 100,
                          width: double.infinity,
                          color: Colors.grey,
                          child: const Icon(Icons.error, color: Colors.red),
                        );
                      },
                      loadingBuilder: (context, child, loadingProgress) {
                        if (loadingProgress == null) return child;
                        return Container(
                          height: 100,
                          width: double.infinity,
                          color: Colors.grey[200],
                          child: const Center(child: CircularProgressIndicator()),
                        );
                      },
                    )
                  : Container(
                      height: 100,
                      width: double.infinity,
                      color: Colors.grey,
                      child: const Icon(Icons.person, color: Colors.white),
                    ),
            ),
            const SizedBox(height: 6.0),
            Text(
              name,
              style: const TextStyle(
                color: Color.fromARGB(255, 89, 57, 127),
                fontSize: 12.0,
                fontWeight: FontWeight.w500,
              ),
              overflow: TextOverflow.ellipsis,
            ),
            Text(
              specialty,
              style: TextStyle(
                  color: Color.fromARGB(255, 89, 57, 127).withOpacity(0.6),
                  fontSize: 10.0),
              overflow: TextOverflow.ellipsis,
            ),
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
      ),
    );
  }
}
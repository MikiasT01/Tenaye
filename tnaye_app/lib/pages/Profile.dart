import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:tnaye_app/pages/home.dart'; // Import for BaseScaffold navigation
import 'base_scaffold.dart'; // Import BaseScaffold

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _ageController = TextEditingController();
  final _imageController = TextEditingController();
  String? _gender;
  bool _isEditing = false;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      try {
        final doc = await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .get();
        final data = doc.data() ?? {};
        setState(() {
          _nameController.text = data['name'] ?? '';
          _emailController.text = data['email'] ?? '';
          _passwordController.text = data['password'] ?? '';
          _ageController.text = data['age']?.toString() ?? '';
          _imageController.text = data['image'] ?? '';
          _gender = data['gender'];
        });
      } catch (e) {
        print("Error loading user data: $e");
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Error loading profile data')),
        );
      }
    }
  }

  Future<void> _saveUserData() async {
    if (_formKey.currentState!.validate()) {
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        try {
          await FirebaseFirestore.instance
              .collection('users')
              .doc(user.uid)
              .set({
                'name': _nameController.text,
                'email': _emailController.text,
                'password': _passwordController.text,
                'age': int.tryParse(_ageController.text) ?? 0,
                'image': _imageController.text,
                'gender': _gender,
                'updatedAt': FieldValue.serverTimestamp(),
              }, SetOptions(merge: true));
          setState(() {
            _isEditing = false;
          });
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Profile updated successfully')),
          );
        } catch (e) {
          print("Error saving user data: $e");
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Error updating profile')),
          );
        }
      }
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _ageController.dispose();
    _imageController.dispose();
    super.dispose();
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
              "Profile",
              style: TextStyle(
                color: Color.fromARGB(255, 89, 57, 127),
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 15.0),
            Card(
              elevation: 6.0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15.0),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TextFormField(
                        controller: _nameController,
                        enabled: _isEditing,
                        decoration: InputDecoration(
                          labelText: 'Name: ${_nameController.text.isNotEmpty ? _nameController.text : "Not set"}',
                          labelStyle: const TextStyle(color: Color.fromARGB(255, 89, 57, 127)),
                          border: const OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(8.0)),
                          ),
                        ),
                        validator: (value) {
                          if (_isEditing && (value == null || value.isEmpty)) {
                            return 'Please enter your name';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 15.0),
                      TextFormField(
                        controller: _emailController,
                        enabled: _isEditing,
                        decoration: InputDecoration(
                          labelText: 'Email: ${_emailController.text.isNotEmpty ? _emailController.text : "Not set"}',
                          labelStyle: const TextStyle(color: Color.fromARGB(255, 89, 57, 127)),
                          border: const OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(8.0)),
                          ),
                        ),
                        validator: (value) {
                          if (_isEditing && (value == null || value.isEmpty || !value.contains('@'))) {
                            return 'Please enter a valid email';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 15.0),
                      TextFormField(
                        controller: _passwordController,
                        enabled: _isEditing,
                        obscureText: true,
                        decoration: InputDecoration(
                          labelText: 'Password: ${_passwordController.text.isNotEmpty ? '****' : "Not set"}',
                          labelStyle: const TextStyle(color: Color.fromARGB(255, 89, 57, 127)),
                          border: const OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(8.0)),
                          ),
                        ),
                        validator: (value) {
                          if (_isEditing && (value == null || value.length < 6)) {
                            return 'Password must be at least 6 characters';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 15.0),
                      TextFormField(
                        controller: _ageController,
                        enabled: _isEditing,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          labelText: 'Age: ${_ageController.text.isNotEmpty ? _ageController.text : "Not set"}',
                          labelStyle: const TextStyle(color: Color.fromARGB(255, 89, 57, 127)),
                          border: const OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(8.0)),
                          ),
                        ),
                        validator: (value) {
                          if (_isEditing && (value == null || value.isEmpty)) {
                            return 'Please enter your age';
                          }
                          if (_isEditing) {
                            final age = int.tryParse(value ?? '');
                            if (age == null || age < 0 || age > 120) {
                              return 'Please enter a valid age';
                            }
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 15.0),
                      TextFormField(
                        controller: _imageController,
                        enabled: _isEditing,
                        decoration: InputDecoration(
                          labelText: 'Image URL: ${_imageController.text.isNotEmpty ? _imageController.text : "Not set"}',
                          labelStyle: const TextStyle(color: Color.fromARGB(255, 89, 57, 127)),
                          border: const OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(8.0)),
                          ),
                        ),
                        validator: (value) {
                          if (_isEditing && value != null && value.isNotEmpty && !value.startsWith('http')) {
                            return 'Please enter a valid URL';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 15.0),
                      DropdownButtonFormField<String>(
                        value: _gender,
                        hint: const Text(
                          'Select Gender',
                          style: TextStyle(color: Color.fromARGB(255, 89, 57, 127)),
                        ),
                        items: ['Male', 'Female', 'Other'].map((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(
                              value,
                              style: const TextStyle(color: Color.fromARGB(255, 89, 57, 127)),
                            ),
                          );
                        }).toList(),
                        onChanged: _isEditing
                            ? (value) {
                                setState(() {
                                  _gender = value;
                                });
                              }
                            : null,
                        decoration: InputDecoration(
                          labelText: 'Gender: ${_gender ?? "Not set"}',
                          labelStyle: const TextStyle(color: Color.fromARGB(255, 89, 57, 127)),
                          border: const OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(8.0)),
                          ),
                        ),
                        validator: (value) {
                          if (_isEditing && value == null) {
                            return 'Please select a gender';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 20.0),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          if (!_isEditing)
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color.fromARGB(255, 89, 57, 127),
                              ),
                              onPressed: () {
                                setState(() {
                                  _isEditing = true;
                                });
                              },
                              child: const Text('Edit', style: TextStyle(color: Colors.white)),
                            ),
                          if (_isEditing)
                            Row(
                              children: [
                                ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: const Color.fromARGB(255, 89, 57, 127),
                                  ),
                                  onPressed: _saveUserData,
                                  child: const Text('Save', style: TextStyle(color: Colors.white)),
                                ),
                                const SizedBox(width: 10.0),
                                ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.grey,
                                  ),
                                  onPressed: () {
                                    setState(() {
                                      _isEditing = false;
                                    });
                                  },
                                  child: const Text('Cancel', style: TextStyle(color: Colors.white)),
                                ),
                              ],
                            ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
            ],
          ),
        ),
      currentIndex: 2, // Set to 2 for Profile tab
    );
  }
}
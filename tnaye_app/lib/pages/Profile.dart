import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:tnaye_app/pages/home.dart';
import 'package:tnaye_app/pages/login.dart';
import 'base_scaffold.dart';
import 'package:tnaye_app/services/shared_pref.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _ageController = TextEditingController();
  final _imageController = TextEditingController();
  String? _gender;
  bool _isEditing = false;
  bool _isLoading = true;

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
          _nameController.text = data['Name'] ?? '';
          _emailController.text = data['Email'] ?? '';
          _ageController.text = data['age']?.toString() ?? '';
          _imageController.text = data['Image'] ?? '';
          _gender = data['gender'];
          _isLoading = false;
        });
      } catch (e) {
        print("Error loading user data: $e");
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Error loading profile data')),
        );
        setState(() {
          _isLoading = false;
        });
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
                'Name': _nameController.text,
                'Email': _emailController.text,
                'age': int.tryParse(_ageController.text) ?? 0,
                'Image': _imageController.text,
                'gender': _gender,
                'updatedAt': FieldValue.serverTimestamp(),
              }, SetOptions(merge: true));
          setState(() {
            _isEditing = false;
          });
          // Save updated image URL to SharedPreferences
          await SharedPreferencesHelper().saveUserImage(_imageController.text.isNotEmpty ? _imageController.text : null);
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Profile updated successfully')),
          );
          // Refresh the page to reflect the new image
          await _loadUserData(); // Reload data to update the image
        } catch (e) {
          print("Error saving user data: $e");
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Error updating profile')),
          );
        }
      }
    }
  }

  Future<void> _changePassword() async {
    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Reset Password'),
        content: const Text(
          'A password reset link will be sent to your email. Follow the link to create a new password.',
        ),
        actions: [
          TextButton(
            onPressed: () async {
              try {
                await FirebaseAuth.instance.sendPasswordResetEmail(
                  email: _emailController.text,
                );
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Password reset email sent! Check your inbox.')),
                );
              } on FirebaseAuthException catch (e) {
                String errorMessage = 'An error occurred. Please try again.';
                if (e.code == 'invalid-email') {
                  errorMessage = 'The email address is not valid.';
                } else if (e.code == 'user-not-found') {
                  errorMessage = 'No user found with this email.';
                }
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(errorMessage)),
                );
              } catch (e) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('An unexpected error occurred.')),
                );
                print("Error sending password reset email: $e");
              }
            },
            child: const Text('Send Reset Email'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
        ],
      ),
    );
  }

  Future<void> _deleteAccount() async {
    // Step 1: Show confirmation dialog first
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirm Deletion'),
        content: const Text('Are you sure you want to delete your account? This action cannot be undone.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('No'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Yes'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      // Step 2: Show password verification dialog if confirmed
      final _passwordController = TextEditingController();
      final _formKeyDelete = GlobalKey<FormState>();

      await showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Delete Account'),
          content: Form(
            key: _formKeyDelete,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  controller: _passwordController,
                  obscureText: true,
                  decoration: const InputDecoration(labelText: 'Password'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your password';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20.0),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(backgroundColor: const Color.fromARGB(255, 89, 57, 127)),
                  onPressed: () async {
                    if (_formKeyDelete.currentState!.validate()) {
                      try {
                        final user = FirebaseAuth.instance.currentUser;
                        if (user != null) {
                          final credential = EmailAuthProvider.credential(
                            email: _emailController.text,
                            password: _passwordController.text,
                          );
                          await user.reauthenticateWithCredential(credential);
                          await FirebaseFirestore.instance.collection('users').doc(user.uid).delete();
                          await user.delete();
                          await SharedPreferencesHelper().clearUserData(); 
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(builder: (context) => const LogIn()),
                          );
                        }
                      } on FirebaseAuthException catch (e) {
                        String errorMessage = 'An error occurred. Please try again.';
                        if (e.code == 'wrong-password') {
                          errorMessage = 'Incorrect password.';
                        }
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text(errorMessage)),
                        );
                      } catch (e) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('An unexpected error occurred.')),
                        );
                        print("Error deleting account: $e");
                      }
                    }
                  },
                  child: const Text('Verify Password', style: TextStyle(color: Colors.white)),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
          ],
        ),
      );
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _ageController.dispose();
    _imageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BaseScaffold(
      body: _isLoading
          ? const Center(child: CircularProgressIndicator(color: Color.fromARGB(255, 89, 57, 127)))
          : Container(
              margin: const EdgeInsets.symmetric(horizontal: 15.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Circular image at the top
                  Container(
                    margin: const EdgeInsets.only(top: 15.0),
                    child: CircleAvatar(
                      radius: 50.0,
                      backgroundImage: _imageController.text.isNotEmpty
                          ? NetworkImage(_imageController.text)
                          : const AssetImage('images/user_image.png') as ImageProvider,
                      backgroundColor: Colors.grey[200],
                      child: _imageController.text.isEmpty
                          ? const Icon(Icons.person, size: 50.0, color: Colors.grey)
                          : null,
                    ),
                  ),
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
                            const SizedBox(height: 20.0),
                          ],
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 20.0),
                  const Text(
                    "Account Actions",
                    style: TextStyle(
                      color: Color.fromARGB(255, 89, 57, 127),
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 10.0),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color.fromARGB(255, 89, 57, 127),
                        ),
                        onPressed: _changePassword,
                        child: const Text('Change Password', style: TextStyle(color: Colors.white)),
                      ),
                      SizedBox(height: 10.0),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color.fromARGB(255, 200, 22, 10),
                        ),
                        onPressed: _deleteAccount,
                        child: const Text('Delete Account', style: TextStyle(color: Colors.white)),
                      ),
                    ],
                  ),
                ],
              ),
            ),
      currentIndex: 2,
    );
  }
}
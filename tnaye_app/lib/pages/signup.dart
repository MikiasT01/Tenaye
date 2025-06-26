import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:tnaye_app/pages/home.dart';
import 'package:tnaye_app/pages/login.dart';
import 'package:tnaye_app/services/database.dart';
import 'package:tnaye_app/services/shared_pref.dart';

class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _nameFieldController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();

  bool _isPasswordVisible = false; // State for password visibility
  bool _isConfirmPasswordVisible = false;

  @override
  void dispose() {
    _nameFieldController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> registration() async {
    if (_formKey.currentState!.validate()) {
      try {
        // Create user with Firebase Authentication
        UserCredential userCredential =
            await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: _emailController.text.trim(),
          password: _passwordController.text.trim(),
        );

        // Use Firebase Authentication UID as userId
        String userId = userCredential.user!.uid;

        // Save user data to SharedPreferences
        await SharedPreferencesHelper().saveUserId(userId);
        await SharedPreferencesHelper().saveUserName(_nameFieldController.text.trim());
        await SharedPreferencesHelper().saveUserEmail(_emailController.text.trim());
        await SharedPreferencesHelper().saveUserImage(""); 

        // Save user data to Firestore
        Map<String, dynamic> userInfoMap = {
          "Name": _nameFieldController.text.trim(),
          "Email": _emailController.text.trim(),
          "Id": userId,
          "Image": "",
        };
        await DatabaseMethods().addUserDetails(userInfoMap, userId);

        // Show success message and navigate to Home page
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              "Registration successful",
              style: TextStyle(fontSize: 14.0), 
            ),
            duration: Duration(seconds: 2),
          ),
        );
        await Future.delayed(const Duration(seconds: 2));
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const LogIn()),
        );
      } on FirebaseAuthException catch (e) {
        String errorMessage;
        switch (e.code) {
          case 'weak-password':
            errorMessage = "The password provided is too weak.";
            break;
          case 'email-already-in-use':
            errorMessage = "The account already exists for that email.";
            break;
          case 'invalid-email':
            errorMessage = "The email address is not valid.";
            break;
          default:
            errorMessage = "An error occurred. Please try again.";
        }
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              errorMessage,
              style: const TextStyle(fontSize: 14.0), 
            ),
          ),
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              "An unexpected error occurred. Please try again.",
              style: TextStyle(fontSize: 14.0), 
            ),
          ),
        );
        print("Unexpected error during registration: $e");
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        scrollDirection: Axis.horizontal, 
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical, 
          child: Container(
            width: MediaQuery.of(context).size.width, 
            child: Stack(
              children: [
                Container(
                  padding: const EdgeInsets.only(top: 35.0, left: 15.0), 
                  height: MediaQuery.of(context).size.height / 2.5, 
                  width: MediaQuery.of(context).size.width,
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                     colors: [
                        Color.fromARGB(255, 161, 130, 167),
                        Color.fromARGB(255, 144, 125, 168),
                        Color.fromARGB(255, 161, 130, 167),
                      ],
                    ),
                  ),
                  child: const Text(
                    "Hello \nCreate an account",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 21.0, // Reduced from 30.0
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.only(
                    top: 20.0, 
                    left: 15.0, 
                    right: 15.0, 
                    bottom: 15.0, 
                  ),
                  margin: EdgeInsets.only(
                    top: MediaQuery.of(context).size.height / 6, 
                  ),
                  height: MediaQuery.of(context).size.height,
                  width: MediaQuery.of(context).size.width,
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(35.0), 
                      topRight: Radius.circular(35.0), 
                    ),
                  ),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "Full Name",
                          style: TextStyle(
                            color: Color.fromARGB(255, 87, 113, 126),
                            fontSize: 14.0, 
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        TextFormField(
                          controller: _nameFieldController,
                          decoration: InputDecoration(
                            hintText: "Enter your Name",
                            prefixIcon: const Icon(
                              Icons.person_2_sharp,
                              color: Colors.grey,
                              size: 18.0,
                            ),
                            hintStyle: const TextStyle(color: Colors.grey, fontSize: 12.0), 
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15.0), 
                              borderSide: const BorderSide(
                                color: Color.fromARGB(255, 197, 196, 196),
                              ),
                            ),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your name';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 15.0), 
                        const Text(
                          "Email",
                          style: TextStyle(
                            color: Color.fromARGB(255, 144, 125, 168),
                            fontSize: 14.0, 
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        TextFormField(
                          controller: _emailController,
                          decoration: InputDecoration(
                            hintText: "Enter your email",
                            prefixIcon: const Icon(Icons.email, color: Colors.grey, size: 18.0), 
                            hintStyle: const TextStyle(color: Colors.grey, fontSize: 12.0), 
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15.0), 
                              borderSide: const BorderSide(
                                color: Color.fromARGB(255, 197, 196, 196),
                              ),
                            ),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your email';
                            }
                            if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$')
                                .hasMatch(value)) {
                              return 'Please enter a valid email';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 15.0),
                        const Text(
                          "Password",
                          style: TextStyle(
                            color: Color.fromARGB(255, 144, 125, 168),
                            fontSize: 14.0, 
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        TextFormField(
                          controller: _passwordController,
                          decoration: InputDecoration(
                            hintText: "Enter your Password",
                            prefixIcon: const Icon(Icons.key, color: Colors.grey, size: 18.0), 
                            suffixIcon: IconButton(
                              icon: Icon(
                                _isPasswordVisible ? Icons.visibility : Icons.visibility_off,
                                color: const Color.fromARGB(255, 238, 165, 228),
                                size: 18.0, 
                              ),
                              onPressed: () {
                                setState(() {
                                  _isPasswordVisible = !_isPasswordVisible;
                                });
                              },
                            ),
                            hintStyle: const TextStyle(color: Colors.grey, fontSize: 12.0),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15.0), 
                              borderSide: const BorderSide(
                                color: Color.fromARGB(255, 197, 196, 196),
                              ),
                            ),
                          ),
                          obscureText: !_isPasswordVisible,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your password';
                            }
                            if (value.length < 6) {
                              return 'Password must be at least 6 characters';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 15.0), 
                        const Text(
                          "Confirm Password",
                          style: TextStyle(
                            color: Color.fromARGB(255, 144, 125, 168),
                            fontSize: 14.0, 
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        TextFormField(
                          controller: _confirmPasswordController,
                          decoration: InputDecoration(
                            hintText: "Confirm your Password",
                            prefixIcon: const Icon(Icons.key, color: Colors.grey, size: 18.0), 
                            suffixIcon: IconButton(
                              icon: Icon(
                                _isConfirmPasswordVisible
                                    ? Icons.visibility
                                    : Icons.visibility_off,
                                color: Colors.grey,
                                size: 18.0, 
                              ),
                              onPressed: () {
                                setState(() {
                                  _isConfirmPasswordVisible = !_isConfirmPasswordVisible;
                                });
                              },
                            ),
                            hintStyle: const TextStyle(color: Colors.grey, fontSize: 12.0), 
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15.0), 
                              borderSide: const BorderSide(
                                color: Color.fromARGB(255, 197, 196, 196),
                              ),
                            ),
                          ),
                          obscureText: !_isConfirmPasswordVisible,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please confirm your password';
                            }
                            if (value != _passwordController.text) {
                              return 'Passwords do not match';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 20.0), 
                        GestureDetector(
                          onTap: () async {
                            if (_formKey.currentState!.validate()) {
                              await registration();
                            }
                          },
                          child: Container(
                            width: MediaQuery.of(context).size.width,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10.0, 
                              vertical: 10.0, 
                            ),
                            decoration: BoxDecoration(
                              gradient: const LinearGradient(
                                 colors: [
                                  Color.fromARGB(255, 89, 57, 127),
                                  Color.fromARGB(255, 21, 70, 95),
                                  Color.fromARGB(255, 89, 57, 127),
                                ],
                              ),
                              borderRadius: BorderRadius.circular(35.0), 
                            ),
                            child: const Center(
                              child: Text(
                                "Sign up",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 18.0, 
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 15.0), 
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text(
                              "Already have an account?",
                              style: TextStyle(
                                color: Color.fromARGB(255, 58, 95, 114),
                                fontSize: 10.0, 
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(width: 5.0), 
                            GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (context) => const LogIn()),
                                );
                              },
                              child: const Text(
                                "Log in",
                                style: TextStyle(
                                  color: Color.fromARGB(255, 101, 61, 109),
                                  fontSize: 18.0, 
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
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
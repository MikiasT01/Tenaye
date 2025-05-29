import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:tnaye_app/pages/home.dart';
import 'package:tnaye_app/pages/signup.dart';
import 'package:tnaye_app/services/database.dart';
import 'package:tnaye_app/services/shared_pref.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class LogIn extends StatefulWidget {
  const LogIn({super.key});

  @override
  State<LogIn> createState() => _LogInState();
}

class _LogInState extends State<LogIn> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool _isPasswordVisible = false; // State for password visibility
  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> loginUser() async {
    if (_formKey.currentState!.validate()) {
      try {
        // Attempt to sign in with Firebase Authentication
        UserCredential userCredential = await FirebaseAuth.instance
            .signInWithEmailAndPassword(
              email: _emailController.text.trim(),
              password: _passwordController.text.trim(),
            );

        // Get the user's UID from Firebase Authentication
        String userId = userCredential.user!.uid;

        // Check if the user exists in Firestore
        DocumentSnapshot userDoc =
            await FirebaseFirestore.instance
                .collection('users')
                .doc(userId)
                .get();

        if (!userDoc.exists) {
          // If user does not exist in Firestore, show error
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text(
                "User does not exist in the database.",
                style: TextStyle(fontSize: 20.0),
              ),
            ),
          );
          // Optionally, sign out the user from Firebase Authentication
          await FirebaseAuth.instance.signOut();
          return;
        }

        // User exists, retrieve their data
        String userName = userDoc.get('Name') as String;
        String userEmail = userDoc.get('Email') as String;
        String? userImage = userDoc.get('Image') as String?;

        // Save user data to SharedPreferences
        await SharedPreferencesHelper().saveUserId(userId);
        await SharedPreferencesHelper().saveUserName(userName);
        await SharedPreferencesHelper().saveUserEmail(userEmail);
        if (userImage != null && userImage.isNotEmpty) {
          await SharedPreferencesHelper().saveUserImage(userImage);
        } else {
          await SharedPreferencesHelper().saveUserImage("");
        }

        // Show success message and navigate to Home page
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              "Login successful! Redirecting to Home...",
              style: TextStyle(fontSize: 20.0),
            ),
            duration: Duration(seconds: 2),
          ),
        );
        await Future.delayed(const Duration(seconds: 2));
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const Home()),
        );
      } on FirebaseAuthException catch (e) {
        String errorMessage;
        switch (e.code) {
          case 'user-not-found':
            errorMessage = "User does not exist.";
            break;
          case 'wrong-password':
            errorMessage = "Wrong password for this user.";
            break;
          case 'invalid-email':
            errorMessage = "The email address is not valid.";
            break;
          case 'user-disabled':
            errorMessage = "This user account has been disabled.";
            break;
          default:
            errorMessage = "An error occurred. Please try again.";
        }
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(errorMessage, style: const TextStyle(fontSize: 20.0)),
          ),
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              "An unexpected error occurred. Please try again.",
              style: TextStyle(fontSize: 20.0),
            ),
          ),
        );
        print("Unexpected error during login: $e");
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Stack(
          children: [
            Container(
              padding: const EdgeInsets.only(top: 50.0, left: 20.0),
              height: MediaQuery.of(context).size.height / 2,
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
                "Welcome Back\nLog In",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 30.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.only(
                top: 30.0,
                left: 20.0,
                right: 20.0,
                bottom: 20.0,
              ),
              margin: EdgeInsets.only(
                top: MediaQuery.of(context).size.height / 5,
              ),
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(50.0),
                  topRight: Radius.circular(50.0),
                ),
              ),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Email",
                      style: TextStyle(
                        color: Color.fromARGB(255, 144, 125, 168),
                        fontSize: 20.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    TextFormField(
                      controller: _emailController,
                      decoration: InputDecoration(
                        hintText: "Enter your email",
                        prefixIcon: const Icon(Icons.email, color: Colors.grey),
                        hintStyle: const TextStyle(color: Colors.grey),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20.0),
                          borderSide: const BorderSide(
                            color: Color.fromARGB(255, 197, 196, 196),
                          ),
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your email';
                        }
                        if (!RegExp(
                          r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$',
                        ).hasMatch(value)) {
                          return 'Please enter a valid email';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 20.0),
                    const Text(
                      "Password",
                      style: TextStyle(
                        color: Color.fromARGB(255, 144, 125, 168),
                        fontSize: 20.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    TextFormField(
                      controller: _passwordController,
                      decoration: InputDecoration(
                        hintText: "Enter your Password",
                        prefixIcon: const Icon(Icons.key, color: Colors.grey),
                        suffixIcon: IconButton(
                          icon: Icon(
                            _isPasswordVisible
                                ? Icons.visibility
                                : Icons.visibility_off,
                            color: const Color.fromARGB(255, 238, 165, 228),
                          ),
                          onPressed: () {
                            setState(() {
                              _isPasswordVisible = !_isPasswordVisible;
                            });
                          },
                        ),
                        hintStyle: const TextStyle(color: Colors.grey),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20.0),
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
                        return null;
                      },
                    ),
                    const SizedBox(height: 30.0),
                    GestureDetector(
                      onTap: () async {
                        await loginUser();
                      },
                      child: Container(
                        width: MediaQuery.of(context).size.width,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 15.0,
                          vertical: 15.0,
                        ),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                               Color.fromARGB(255, 89, 57, 127),
                        Color.fromARGB(255, 29, 95, 128),
                        Color.fromARGB(255, 89, 57, 127),
                            ],
                          ),
                          borderRadius: BorderRadius.circular(50),
                        ),
                        child: const Center(
                          child: Text(
                            "Log In",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 25.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20.0),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          "Don't have an account?",
                          style: TextStyle(
                            color: Color.fromARGB(255, 58, 95, 114),
                            fontSize: 20.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(width: 10.0),
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const SignUp(),
                              ),
                            );
                          },
                          child: const Text(
                            "Sign Up",
                            style: TextStyle(
                              color: Color.fromARGB(255, 101, 61, 109),
                              fontSize: 25.0,
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
    );
  }
}








// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:tnaye_app/pages/home.dart';
// import 'package:tnaye_app/pages/signup.dart';

// class LogIn extends StatefulWidget {
//   const LogIn({super.key});

//   @override
//   State<LogIn> createState() => _LogInState();
// }

// class _LogInState extends State<LogIn> {
//   String? email, password;

//   TextEditingController _emailController = new TextEditingController();
//   TextEditingController _passwordController = new TextEditingController();

//   final _formKey = GlobalKey<FormState>();

//   userLogin() async {
//     try {
//       await FirebaseAuth.instance.signInWithEmailAndPassword(
//         email: email!,
//         password: password!,
//       );
//       Navigator.of(
//         context,
//       ).pushReplacement(MaterialPageRoute(builder: (context) => Home()));
//     } on FirebaseAuthException catch (e) {
//       if (e.code == 'user-not-found') {
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(
//             content: Text(
//               "No user found with this email",
//               style: TextStyle(fontSize: 18, color: Colors.white),
//             ),
//             duration: Duration(seconds: 2),
//           ),
//         );
//       } else if (e.code == 'wrong-password') {
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(
//             content: Text(
//               "Wrong password provided for that user",
//               style: TextStyle(fontSize: 18, color: Colors.white),
//             ),
//             duration: Duration(seconds: 2),
//           ),
//         );
//       } else {}
//     }
//   }
//     @override
//     Widget build(BuildContext context) {
//       return Scaffold(
//         body: Container(
//           child: Stack(
//             children: [
//               Container(
//                 padding: EdgeInsets.only(top: 50.0, left: 20.0),
//                 height: MediaQuery.of(context).size.height / 2,
//                 width: MediaQuery.of(context).size.width,
//                 decoration: BoxDecoration(
//                   gradient: LinearGradient(
//                     colors: [
//                       const Color.fromARGB(255, 159, 208, 233),
//                       const Color.fromARGB(255, 144, 125, 168),
//                       const Color.fromARGB(255, 161, 130, 167),
//                     ],
//                   ),
//                 ),
//                 child: Text(
//                   "Hello \nSign in",
//                   style: TextStyle(
//                     color: Colors.white,
//                     fontSize: 30.0,
//                     fontWeight: FontWeight.bold,
//                   ),
//                 ),
//               ),
//               Container(
//                 padding: EdgeInsets.only(
//                   top: 60.0,
//                   left: 20.0,
//                   right: 20.0,
//                   bottom: 20.0,
//                 ),
//                 margin: EdgeInsets.only(
//                   top: MediaQuery.of(context).size.height / 4,
//                 ),
//                 height: MediaQuery.of(context).size.height,
//                 width: MediaQuery.of(context).size.width,
//                 decoration: BoxDecoration(
//                   color: Colors.white,
//                   borderRadius: BorderRadius.only(
//                     topLeft: Radius.circular(50.0),
//                     topRight: Radius.circular(50.0),
//                   ),
//                 ),
//                 child: Form(
//                   key: _formKey,
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Text(
//                         "Email",
//                         style: TextStyle(
//                           color: Color.fromARGB(255, 87, 113, 126),
//                           fontSize: 25.0,
//                           fontWeight: FontWeight.bold,
//                         ),
//                       ),
//                       TextFormField(
//                         validator: (value) {
//                           if (value == null || value.isEmpty) {
//                             return 'Please enter your Email';
//                           }
//                           return null;
//                         },
//                         controller: _emailController,
//                         decoration: InputDecoration(
//                           hintText: "Enter your email",
//                           prefixIcon: Icon(Icons.email, color: Colors.grey),
//                           hintStyle: TextStyle(color: Colors.grey),
//                           border: OutlineInputBorder(
//                             borderRadius: BorderRadius.circular(20.0),
//                             borderSide: BorderSide(
//                               color: const Color.fromARGB(255, 197, 196, 196),
//                             ),
//                           ),
//                         ),
//                       ),
//                       SizedBox(height: 20.0),

//                       Text(
//                         "Password",
//                         style: TextStyle(
//                           color: const Color.fromARGB(255, 144, 125, 168),
//                           fontSize: 25.0,
//                           fontWeight: FontWeight.bold,
//                         ),
//                       ),
//                       TextFormField(
//                         validator: (value) {
//                           if (value == null || value.isEmpty) {
//                             return 'Please enter your password';
//                           }
//                           return null;
//                         },
//                         controller: _passwordController,
//                         decoration: InputDecoration(
//                           hintText: "Enter your Password",
//                           prefixIcon: Icon(Icons.key, color: Colors.grey),
//                           hintStyle: TextStyle(color: Colors.grey),
//                           border: OutlineInputBorder(
//                             borderRadius: BorderRadius.circular(20.0),
//                             borderSide: BorderSide(
//                               color: const Color.fromARGB(255, 197, 196, 196),
//                             ),
//                           ),
//                         ),
//                         obscureText: true,
//                       ),

//                       SizedBox(height: 10.0),
//                       Row(
//                         mainAxisAlignment: MainAxisAlignment.end,
//                         children: [
//                           Text(
//                             " Forgot password ?",
//                             style: TextStyle(
//                               color: const Color.fromARGB(255, 161, 130, 167),
//                               fontSize: 20.0,
//                               fontWeight: FontWeight.bold,
//                             ),
//                           ),
//                         ],
//                       ),
//                       SizedBox(height: 20.0),
//                       GestureDetector(
//                         onTap: () {
//                           if (_formKey.currentState!.validate()) {
//                             setState(() {
//                               email = _emailController.text.trim();
//                               password = _passwordController.text.trim();
//                             });
//                             userLogin();
//                           }
//                         },
                        
//                         child: Container(
//                           width: MediaQuery.of(context).size.width,
//                           padding: EdgeInsets.symmetric(
//                             horizontal: 15.0,
//                             vertical: 15.0,
//                           ),
                        
//                           decoration: BoxDecoration(
//                             gradient: LinearGradient(
//                               colors: [
//                                 const Color.fromARGB(255, 159, 208, 233),
//                                 const Color.fromARGB(255, 144, 125, 168),
//                                 const Color.fromARGB(255, 161, 130, 167),
//                               ],
//                             ),
//                             borderRadius: BorderRadius.circular(50),
//                           ),
//                           child: Center(
//                             child: Text(
//                               "Sign in",
//                               style: TextStyle(
//                                 color: Colors.white,
//                                 fontSize: 25.0,
//                                 fontWeight: FontWeight.bold,
//                               ),
//                             ),
//                           ),
//                         ),
//                       ),
//                       SizedBox(height: 20.0),
//                       Spacer(),
//                       Row(
//                         children: [
//                           Text(
//                             "Dont have an account?",
//                             style: TextStyle(
//                               color: Color.fromARGB(255, 58, 95, 114),
//                               fontSize: 20.0,
//                               fontWeight: FontWeight.bold,
//                             ),
//                           ),
//                           SizedBox(
//                             width: MediaQuery.of(context).size.width / 3.5,
//                           ),
//                           GestureDetector(
//                             onTap: () {
//                               Navigator.push(
//                                 context,
//                                 MaterialPageRoute(
//                                   builder: (context) => SignUp(),
//                                 ),
//                               );
//                             },
//                             child: Text(
//                               "Sign up",
//                               style: TextStyle(
//                                 color: Color.fromARGB(255, 101, 61, 109),
//                                 fontSize: 25.0,
//                                 fontWeight: FontWeight.bold,
//                               ),
//                             ),
//                           ),
//                         ],
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       );
//     }
//   }


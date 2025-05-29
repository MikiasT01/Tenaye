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
        await SharedPreferencesHelper().saveUserImage(""); // Default empty image

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
              style: TextStyle(fontSize: 20.0),
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
              style: const TextStyle(fontSize: 20.0),
            ),
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
        print("Unexpected error during registration: $e");
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
                    Color.fromARGB(255, 159, 208, 233),
                    Color.fromARGB(255, 144, 125, 168),
                    Color.fromARGB(255, 161, 130, 167),
                  ],
                ),
              ),
              child: const Text(
                "Hello \nCreate an account",
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
                      "Full Name",
                      style: TextStyle(
                        color: Color.fromARGB(255, 87, 113, 126),
                        fontSize: 20.0,
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
                        ),
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
                          return 'Please enter your name';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 20.0),
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
                        if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$')
                            .hasMatch(value)) {
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
                        suffixIcon: IconButton(icon: Icon(
                          _isPasswordVisible ? Icons.visibility : Icons.visibility_off,
                          color: const Color.fromARGB(255, 238, 165, 228),
                        ),
                        
                        onPressed: () {
                          setState(() {
                            _isPasswordVisible = !_isPasswordVisible;
                          });
                        },),
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
                        if (value.length < 6) {
                          return 'Password must be at least 6 characters';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 20.0),
                    const Text(
                      "Confirm Password",
                      style: TextStyle(
                        color: Color.fromARGB(255, 144, 125, 168),
                        fontSize: 20.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    TextFormField(
                      controller: _confirmPasswordController,
                      decoration: InputDecoration(
                        hintText: "Confirm your Password",
                        prefixIcon: const Icon(Icons.key, color: Colors.grey),
                        suffixIcon: IconButton(
                          icon: Icon(
                            _isConfirmPasswordVisible
                                ? Icons.visibility
                                : Icons.visibility_off,
                            color: Colors.grey,
                          ),
                          onPressed: () {
                            setState(() {
                              _isConfirmPasswordVisible = !_isConfirmPasswordVisible;
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
                      obscureText: _isConfirmPasswordVisible,
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
                    const SizedBox(height: 30.0),
                    GestureDetector(
                      onTap: () async {
                        if (_formKey.currentState!.validate()) {
                          await registration();
                        }
                      },
                      child: Container(
                        width: MediaQuery.of(context).size.width,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 15.0,
                          vertical: 15.0,
                        ),
                        decoration:  BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              Color.fromARGB(255, 159, 208, 233),
                              Color.fromARGB(255, 144, 125, 168),
                              Color.fromARGB(255, 161, 130, 167),
                            ],
                          ),
                          borderRadius: BorderRadius.circular(50),
                        ),
                        child: const Center(
                          child: Text(
                            "Sign up",
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
                          "Already have an account?",
                          style: TextStyle(
                            color: Color.fromARGB(255, 58, 95, 114),
                            fontSize: 15.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(width: 10.0),
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
// import 'package:tnaye_app/pages/login.dart';
// import 'package:random_string/random_string.dart';
// import 'package:tnaye_app/services/database.dart';
// import 'package:tnaye_app/services/shared_pref.dart';

// class SignUp extends StatefulWidget {
//   const SignUp({super.key});

//   @override
//   State<SignUp> createState() => _SignUpState();
// }

// class _SignUpState extends State<SignUp> {
//   String? name, email, password;

//   TextEditingController _nameFieldController = new TextEditingController();
//   TextEditingController _emailController = new TextEditingController();
//   TextEditingController _passwordController = new TextEditingController();
//   TextEditingController _confirmPasswordController = new TextEditingController();

//   final _formKey = GlobalKey<FormState>();

//   registration() async {
//     //print('Registration started');
//     //print('Name: $name, Email: $email, Password: $password');
//     if (password != null && email != null && name != null) {
//       try {
//         //print('attemptiong to create user with email : $email');
//         UserCredential userCredential = await FirebaseAuth.instance
//             .createUserWithEmailAndPassword(email: email!, password: password!);

//         String id = randomAlphaNumeric(10);
//         await SharedpreferenceHelper().saveUserName(_nameFieldController.text);
//         await SharedpreferenceHelper().saveUserEmail(_emailController.text);
//         await SharedpreferenceHelper().saveUserImage("");
//         await SharedpreferenceHelper().saveUserId(id);
//         Map<String, dynamic> userInfoMap = {
//           "Name": _nameFieldController.text,
//           "Email": _emailController.text,
//           "Id": id,
//           "Image": "",
//         };
//         await DatabaseMethods().addUserDetails(userInfoMap, id);

//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(
//             content: Text(
//               "Registration successful",
//               style: TextStyle(fontSize: 20.0),
//             ),
//           ),
//         );
//         Navigator.push(
//           context,
//           MaterialPageRoute(builder: (context) => LogIn()),
//         );
//       } on FirebaseAuthException catch (e) {
//         print('FirebaseAuthException: ${e.code} - ${e.message}');
//         if (e.code == 'weak-password') {
//           ScaffoldMessenger.of(context).showSnackBar(
//             SnackBar(
//               content: Text(
//                 "The password provided is too weak.",
//                 style: TextStyle(fontSize: 20.0),
//               ),
//             ),
//           );
//         } else if (e.code == 'email-already-in-use') {
//           ScaffoldMessenger.of(context).showSnackBar(
//             SnackBar(
//               content: Text(
//                 "The account already exists for that email.",
//                 style: TextStyle(fontSize: 20.0),
//               ),
//             ),
//           );
//         }
//       } catch (e) {
//         //print('un expected error $e');
//       }
//     } else
//       print('Validation failed: name, email, or password is null');
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Container(
//         child: Stack(
//           children: [
//             Container(
//               padding: EdgeInsets.only(top: 50.0, left: 20.0),
//               height: MediaQuery.of(context).size.height / 2,
//               width: MediaQuery.of(context).size.width,
//               decoration: BoxDecoration(
//                 gradient: LinearGradient(
//                   colors: [
//                     const Color.fromARGB(255, 159, 208, 233),
//                     const Color.fromARGB(255, 144, 125, 168),
//                     const Color.fromARGB(255, 161, 130, 167),
//                   ],
//                 ),
//               ),
//               child: Text(
//                 "Hello \nCreate an account",
//                 style: TextStyle(
//                   color: Colors.white,
//                   fontSize: 30.0,
//                   fontWeight: FontWeight.bold,
//                 ),
//               ),
//             ),
//             Container(
//               padding: EdgeInsets.only(
//                 top: 30.0,
//                 left: 20.0,
//                 right: 20.0,
//                 bottom: 20.0,
//               ),
//               margin: EdgeInsets.only(
//                 top: MediaQuery.of(context).size.height / 5,
//               ),
//               height: MediaQuery.of(context).size.height,
//               width: MediaQuery.of(context).size.width,
//               decoration: BoxDecoration(
//                 color: Colors.white,
//                 borderRadius: BorderRadius.only(
//                   topLeft: Radius.circular(50.0),
//                   topRight: Radius.circular(50.0),
//                 ),
//               ),
//               child: Form(
//                 key: _formKey,
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Text(
//                       "Full Name",
//                       style: TextStyle(
//                         color: Color.fromARGB(255, 87, 113, 126),
//                         fontSize: 20.0,
//                         fontWeight: FontWeight.bold,
//                       ),
//                     ),
//                     TextFormField(
//                       validator: (value) {
//                         if (value == null || value.isEmpty) {
//                           return 'Please enter your name';
//                         }
//                         return null;
//                       },
//                       controller: _nameFieldController,
//                       decoration: InputDecoration(
//                         hintText: "Enter your Name",
//                         prefixIcon: Icon(
//                           Icons.person_2_sharp,
//                           color: Colors.grey,
//                         ),
//                         hintStyle: TextStyle(color: Colors.grey),
//                         border: OutlineInputBorder(
//                           borderRadius: BorderRadius.circular(20.0),
//                           borderSide: BorderSide(
//                             color: const Color.fromARGB(255, 197, 196, 196),
//                           ),
//                         ),
//                       ),
//                     ),
//                     SizedBox(height: 20.0),
//                     Text(
//                       "Email",
//                       style: TextStyle(
//                         color: Color.fromARGB(255, 144, 125, 168),
//                         fontSize: 20.0,
//                         fontWeight: FontWeight.bold,
//                       ),
//                     ),
//                     TextFormField(
//                       validator: (value) {
//                         if (value == null || value.isEmpty) {
//                           return 'Please enter your email';
//                         }
//                         return null;
//                       },
//                       controller: _emailController,
//                       decoration: InputDecoration(
//                         hintText: "Enter your email",
//                         prefixIcon: Icon(Icons.email, color: Colors.grey),
//                         hintStyle: TextStyle(color: Colors.grey),
//                         border: OutlineInputBorder(
//                           borderRadius: BorderRadius.circular(20.0),
//                           borderSide: BorderSide(
//                             color: const Color.fromARGB(255, 197, 196, 196),
//                           ),
//                         ),
//                       ),
//                     ),
//                     SizedBox(height: 20.0),

//                     Text(
//                       "Password",
//                       style: TextStyle(
//                         color: Color.fromARGB(255, 144, 125, 168),
//                         fontSize: 20.0,
//                         fontWeight: FontWeight.bold,
//                       ),
//                     ),
//                     TextFormField(
//                       validator: (value) {
//                         if (value == null || value.isEmpty) {
//                           return 'Please enter your password';
//                         }
//                         return null;
//                       },

//                       controller: _passwordController,
//                       decoration: InputDecoration(
//                         hintText: "Enter your Password",
//                         prefixIcon: Icon(Icons.key, color: Colors.grey),
//                         hintStyle: TextStyle(color: Colors.grey),
//                         border: OutlineInputBorder(
//                           borderRadius: BorderRadius.circular(20.0),
//                           borderSide: BorderSide(
//                             color: const Color.fromARGB(255, 197, 196, 196),
//                           ),
//                         ),
//                       ),
//                       obscureText: true,
//                     ),
//                     SizedBox(height: 20.0),

//                     Text(
//                       "Confirm Password",
//                       style: TextStyle(
//                         color: const Color.fromARGB(255, 144, 125, 168),
//                         fontSize: 20.0,
//                         fontWeight: FontWeight.bold,
//                       ),
//                     ),
//                     TextFormField(
//                       validator: (value) {
//                         if (value == null || value.isEmpty) {
//                           return 'Please confirm passcode';
//                         }
//                         return null;
//                       },
//                       controller: _confirmPasswordController,
//                       decoration: InputDecoration(
//                         hintText: "Enter your Password",
//                         prefixIcon: Icon(Icons.key, color: Colors.grey),
//                         hintStyle: TextStyle(color: Colors.grey),
//                         border: OutlineInputBorder(
//                           borderRadius: BorderRadius.circular(20.0),
//                           borderSide: BorderSide(
//                             color: const Color.fromARGB(255, 197, 196, 196),
//                           ),
//                         ),
//                       ),
//                       obscureText: true,
//                     ),

//                     SizedBox(height: 30.0),
//                     GestureDetector(
//                       onTap: () async {
//                         if (_formKey.currentState!.validate()) {
//                           setState(() {
//                             name = _nameFieldController.text;
//                             email = _emailController.text;
//                             password = _passwordController.text;
//                           });
//                           await registration();
//                         }
//                       },
//                       child: Container(
//                         width: MediaQuery.of(context).size.width,
//                         padding: EdgeInsets.symmetric(
//                           horizontal: 15.0,
//                           vertical: 15.0,
//                         ),

//                         decoration: BoxDecoration(
//                           gradient: LinearGradient(
//                             colors: [
//                               const Color.fromARGB(255, 159, 208, 233),
//                               const Color.fromARGB(255, 144, 125, 168),
//                               const Color.fromARGB(255, 161, 130, 167),
//                             ],
//                           ),
//                           borderRadius: BorderRadius.circular(50),
//                         ),
//                         child: Center(
//                           child: Text(
//                             "Sign up",
//                             style: TextStyle(
//                               color: Colors.white,
//                               fontSize: 25.0,
//                               fontWeight: FontWeight.bold,
//                             ),
//                           ),
//                         ),
//                       ),
//                     ),

//                     SizedBox(height: 20.0),

//                     Row(
//                       children: [
//                         Text(
//                           "Already have \nan account?",
//                           style: TextStyle(
//                             color: Color.fromARGB(255, 58, 95, 114),
//                             fontSize: 15.0,
//                             fontWeight: FontWeight.bold,
//                           ),
//                         ),
//                         SizedBox(
//                           width: MediaQuery.of(context).size.width / 3.5,
//                         ),
//                         GestureDetector(
//                           onTap: () {
//                             Navigator.push(
//                               context,
//                               MaterialPageRoute(builder: (context) => LogIn()),
//                             );
//                           },
//                           child: Text(
//                             "Log in",
//                             style: TextStyle(
//                               color: Color.fromARGB(255, 101, 61, 109),
//                               fontSize: 25.0,
//                               fontWeight: FontWeight.bold,
//                             ),
//                           ),
//                         ),
//                       ],
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

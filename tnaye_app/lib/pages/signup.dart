import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:tnaye_app/pages/home.dart';
import 'package:tnaye_app/pages/login.dart';
import 'package:random_string/random_string.dart';
import 'package:tnaye_app/services/database.dart';

class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  String? name, email, password;

  TextEditingController _nameFieldController = new TextEditingController();
  TextEditingController _emailController = new TextEditingController();
  TextEditingController _passwordController = new TextEditingController();
  TextEditingController _confirmPasswordController = new TextEditingController();

  final _formKey = GlobalKey<FormState>();

  registration() async {
    print('Registration started');
    print('Name: $name, Email: $email, Password: $password');
    if (password != null && email != null && name != null) {
      try {
        //print('attemptiong to create user with email : $email');
        UserCredential userCredential = await FirebaseAuth.instance
            .createUserWithEmailAndPassword(email: email!, password: password!);

        String id = randomAlphaNumeric(10);
        Map<String, dynamic> userInfoMap = {
          "Name": _nameFieldController.text,
          "Email": _emailController.text,
          "Id": id,
          "Image": "",
        };
        await DatabaseMethods().addUserDetails(userInfoMap, id);

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              "Registration successful",
              style: TextStyle(fontSize: 20.0),
            ),
          ),
        );
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => LogIn()),
        );
      } on FirebaseAuthException catch (e) {
        print('FirebaseAuthException: ${e.code} - ${e.message}');
        if (e.code == 'weak-password') {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                "The password provided is too weak.",
                style: TextStyle(fontSize: 20.0),
              ),
            ),
          );
        } else if (e.code == 'email-already-in-use') {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                "The account already exists for that email.",
                style: TextStyle(fontSize: 20.0),
              ),
            ),
          );
        }
      } catch (e) {
        //print('un expected error $e');
      }
    } else
      print('Validation failed: name, email, or password is null');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Stack(
          children: [
            Container(
              padding: EdgeInsets.only(top: 50.0, left: 20.0),
              height: MediaQuery.of(context).size.height / 2,
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    const Color.fromARGB(255, 159, 208, 233),
                    const Color.fromARGB(255, 144, 125, 168),
                    const Color.fromARGB(255, 161, 130, 167),
                  ],
                ),
              ),
              child: Text(
                "Hello \nCreate an account",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 30.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Container(
              padding: EdgeInsets.only(
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
              decoration: BoxDecoration(
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
                    Text(
                      "Full Name",
                      style: TextStyle(
                        color: Color.fromARGB(255, 87, 113, 126),
                        fontSize: 20.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    TextFormField(
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your name';
                        }
                        return null;
                      },
                      controller: _nameFieldController,
                      decoration: InputDecoration(
                        hintText: "Enter your Name",
                        prefixIcon: Icon(
                          Icons.person_2_sharp,
                          color: Colors.grey,
                        ),
                        hintStyle: TextStyle(color: Colors.grey),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20.0),
                          borderSide: BorderSide(
                            color: const Color.fromARGB(255, 197, 196, 196),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 20.0),
                    Text(
                      "Email",
                      style: TextStyle(
                        color: Color.fromARGB(255, 144, 125, 168),
                        fontSize: 20.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    TextFormField(
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your email';
                        }
                        return null;
                      },
                      controller: _emailController,
                      decoration: InputDecoration(
                        hintText: "Enter your email",
                        prefixIcon: Icon(Icons.email, color: Colors.grey),
                        hintStyle: TextStyle(color: Colors.grey),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20.0),
                          borderSide: BorderSide(
                            color: const Color.fromARGB(255, 197, 196, 196),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 20.0),

                    Text(
                      "Password",
                      style: TextStyle(
                        color: Color.fromARGB(255, 144, 125, 168),
                        fontSize: 20.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    TextFormField(
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your password';
                        }
                        return null;
                      },

                      controller: _passwordController,
                      decoration: InputDecoration(
                        hintText: "Enter your Password",
                        prefixIcon: Icon(Icons.key, color: Colors.grey),
                        hintStyle: TextStyle(color: Colors.grey),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20.0),
                          borderSide: BorderSide(
                            color: const Color.fromARGB(255, 197, 196, 196),
                          ),
                        ),
                      ),
                      obscureText: true,
                    ),
                    SizedBox(height: 20.0),

                    Text(
                      "Confirm Password",
                      style: TextStyle(
                        color: const Color.fromARGB(255, 144, 125, 168),
                        fontSize: 20.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    TextFormField(
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please confirm passcode';
                        }
                        return null;
                      },
                      controller: _confirmPasswordController,
                      decoration: InputDecoration(
                        hintText: "Enter your Password",
                        prefixIcon: Icon(Icons.key, color: Colors.grey),
                        hintStyle: TextStyle(color: Colors.grey),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20.0),
                          borderSide: BorderSide(
                            color: const Color.fromARGB(255, 197, 196, 196),
                          ),
                        ),
                      ),
                      obscureText: true,
                    ),

                    SizedBox(height: 30.0),
                    GestureDetector(
                      onTap: () async {
                        if (_formKey.currentState!.validate()) {
                          setState(() {
                            name = _nameFieldController.text;
                            email = _emailController.text;
                            password = _passwordController.text;
                          });
                          await registration();
                        }
                      },
                      child: Container(
                        width: MediaQuery.of(context).size.width,
                        padding: EdgeInsets.symmetric(
                          horizontal: 15.0,
                          vertical: 15.0,
                        ),

                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              const Color.fromARGB(255, 159, 208, 233),
                              const Color.fromARGB(255, 144, 125, 168),
                              const Color.fromARGB(255, 161, 130, 167),
                            ],
                          ),
                          borderRadius: BorderRadius.circular(50),
                        ),
                        child: Center(
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

                    SizedBox(height: 20.0),

                    Row(
                      children: [
                        Text(
                          "Already have \nan account?",
                          style: TextStyle(
                            color: Color.fromARGB(255, 58, 95, 114),
                            fontSize: 15.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(
                          width: MediaQuery.of(context).size.width / 3.5,
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => LogIn()),
                            );
                          },
                          child: Text(
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

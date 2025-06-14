import 'package:flutter/material.dart';
import 'package:tnaye_app/pages/Noticifications.dart';
import 'package:tnaye_app/pages/Profile.dart';
import 'package:tnaye_app/pages/home.dart';
import 'package:tnaye_app/pages/login.dart';
import 'package:tnaye_app/services/shared_pref.dart';

class BaseScaffold extends StatefulWidget {
  final Widget body;
  final int currentIndex;

  const BaseScaffold({super.key, required this.body, this.currentIndex = 0});

  @override
  State<BaseScaffold> createState() => _BaseScaffoldState();
}

class _BaseScaffoldState extends State<BaseScaffold> {
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.currentIndex;
  }

  // Helper method for logout confirmation
  Future<void> _confirmLogout(BuildContext context) async {
    bool confirm =
        await showDialog(
          context: context,
          builder:
              (context) => AlertDialog(
                title: const Text(
                  'Confirm Logout',
                  style: TextStyle(
                    color: Color.fromARGB(255, 89, 57, 127),
                    fontSize: 16.0,
                  ),
                ),
                content: const Text(
                  'Are you sure you want to log out?',
                  style: TextStyle(
                    color: Color.fromARGB(255, 89, 57, 127),
                    fontSize: 14.0,
                  ),
                ),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(context, false),
                    child: const Text(
                      'Cancel',
                      style: TextStyle(
                        color: Color.fromARGB(255, 89, 57, 127),
                        fontSize: 14.0,
                      ),
                    ),
                  ),
                  TextButton(
                    onPressed: () => Navigator.pop(context, true),
                    child: const Text(
                      'Logout',
                      style: TextStyle(
                        color: Color.fromARGB(255, 89, 57, 127),
                        fontSize: 14.0,
                      ),
                    ),
                  ),
                ],
              ),
        ) ??
        false;

    if (confirm) {
      await SharedPreferencesHelper().clearUserData();
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => LogIn()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Container(
              width: MediaQuery.of(context).size.width,
              child: Column(
                children: [
                  // User Greeting with Dropdown
                  Container(
                    margin: const EdgeInsets.symmetric(
                      horizontal: 15.0,
                      vertical: 15.0,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              "Hello, ",
                              style: TextStyle(
                                color: Color.fromARGB(255, 89, 57, 127),
                                fontSize: 18.0,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            FutureBuilder<String?>(
                              future: SharedPreferencesHelper().getUserName(),
                              builder: (context, snapshot) {
                                if (snapshot.connectionState ==
                                    ConnectionState.waiting) {
                                  return const Text(
                                    "Loading...",
                                    style: TextStyle(
                                      color: Color.fromARGB(255, 89, 57, 127),
                                      fontSize: 18.0,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  );
                                }
                                if (snapshot.hasError ||
                                    snapshot.data == null) {
                                  return const Text(
                                    "Unknown User",
                                    style: TextStyle(
                                      color: Color.fromARGB(255, 89, 57, 127),
                                      fontSize: 18.0,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  );
                                }
                                return Text(
                                  snapshot.data!,
                                  style: const TextStyle(
                                    color: Color.fromARGB(255, 89, 57, 127),
                                    fontSize: 18.0,
                                    fontWeight: FontWeight.bold,
                                  ),
                                );
                              },
                            ),
                          ],
                        ),
                        PopupMenuButton<String>(
                          icon: ClipRRect(
                            borderRadius: BorderRadius.circular(35.0),
                            child: Image.asset(
                              "images/user_image.png",
                              width: 40.0,
                              height: 40.0,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) {
                                return const Icon(
                                  Icons.person,
                                  size: 40.0,
                                  color: Color.fromARGB(255, 89, 57, 127),
                                );
                              },
                            ),
                          ),
                          onSelected: (String value) {
                            if (value == 'profile') {
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => ProfilePage(),
                                ),
                              );
                            } else if (value == 'home') {
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(builder: (context) => Home()),
                              );
                            } else if (value == 'logout') {
                              _confirmLogout(context);
                            }
                          },
                          itemBuilder:
                              (
                                BuildContext context,
                              ) => <PopupMenuEntry<String>>[
                                const PopupMenuItem<String>(
                                  value: 'profile',
                                  child: ListTile(
                                    leading: Icon(
                                      Icons.person,
                                      color: Color.fromARGB(255, 89, 57, 127),
                                      size: 18.0,
                                    ),
                                    title: Text(
                                      'Profile',
                                      style: TextStyle(
                                        color: Color.fromARGB(255, 89, 57, 127),
                                        fontSize: 14.0,
                                      ),
                                    ),
                                  ),
                                ),
                                const PopupMenuItem<String>(
                                  value: 'home',
                                  child: ListTile(
                                    leading: Icon(
                                      Icons.home,
                                      color: Color.fromARGB(255, 89, 57, 127),
                                      size: 18.0,
                                    ),
                                    title: Text(
                                      'Home',
                                      style: TextStyle(
                                        color: Color.fromARGB(255, 89, 57, 127),
                                        fontSize: 14.0,
                                      ),
                                    ),
                                  ),
                                ),
                                const PopupMenuItem<String>(
                                  value: 'logout',
                                  child: ListTile(
                                    leading: Icon(
                                      Icons.logout,
                                      color: Color.fromARGB(255, 89, 57, 127),
                                      size: 18.0,
                                    ),
                                    title: Text(
                                      'Logout',
                                      style: TextStyle(
                                        color: Color.fromARGB(255, 89, 57, 127),
                                        fontSize: 14.0,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                        ),
                      ],
                    ),
                  ),

                  // Divider
                  const Divider(color: Color.fromARGB(255, 89, 57, 127)),

                  // Page-specific content
                  widget.body,
                ],
              ),
            ),
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.white,
        selectedItemColor: const Color.fromARGB(255, 89, 57, 127),
        unselectedItemColor: const Color.fromARGB(
          255,
          89,
          57,
          127,
        ).withOpacity(0.6),
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
          switch (index) {
            case 0:
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => Home()),
              );
              break;
            case 1:
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => NotificationPage()),
              );
              break;
            case 2:
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => ProfilePage()),
              );
              break;
          }
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home, size: 20.0),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.notifications, size: 20.0),
            label: 'Notifications',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person, size: 20.0),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}

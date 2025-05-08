import 'package:flutter/material.dart';
import 'package:tnaye_app/pages/booking.dart';
import 'package:tnaye_app/services/shared_pref.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  String? name, image;

  getthedatafromsharedpref() async {
    name = await SharedpreferenceHelper().getUserName();
    image = await SharedpreferenceHelper().getUserImage();
    setState(() {
    });
  }

  getontheload() async {
    await getthedatafromsharedpref();
    setState(() {});
  }

  @override
  void initState() {
    getontheload();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.lightBlue,
      body: Container(
        margin: EdgeInsets.only(top: 50.0, left: 20.0, right: 20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,

          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Hello, ",
                      style: TextStyle(
                        color: const Color.fromARGB(255, 183, 171, 206),
                        fontSize: 24.0,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Text(
                      name!,
                      style: TextStyle(
                        color: const Color.fromARGB(255, 241, 240, 244),
                        fontSize: 24.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
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
            SizedBox(height: 20.0),
            Divider(color: Colors.white70),
            SizedBox(height: 20.0),
            Text(
              "Services",
              style: TextStyle(
                color: const Color.fromARGB(255, 241, 240, 244),
                fontSize: 24.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 20.0),
            Row(
              children: [
                Flexible(
                  fit: FlexFit.tight,
                  child: GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder:
                              (context) => Booking(service: "psychologist"),
                        ),
                      );
                    },
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 10.0),
                      height: 170.0,
                      width: 150.0,
                      decoration: BoxDecoration(
                        color: Color.fromARGB(255, 68, 141, 178),
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset(
                            "images/general_practitioner_icon.jpg",
                            height: 120,
                            width: 140,
                            fit: BoxFit.cover,
                          ),
                          SizedBox(height: 10.0),
                          Text(
                            "General practitioner",
                            style: TextStyle(
                              color: const Color.fromARGB(255, 241, 240, 244),
                              fontSize: 20.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 20.0),

                Flexible(
                  fit: FlexFit.tight,
                  child: GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder:
                              (context) => Booking(service: "General medic"),
                        ),
                      );
                    },
                    child: Container(
                      height: 170.0,
                      width: 150.0,
                      decoration: BoxDecoration(
                        color: Color.fromARGB(255, 68, 141, 178),
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset(
                            "images/psychologizt_pic.jpg",
                            height: 120,
                            width: 120,
                            fit: BoxFit.cover,
                          ),
                          SizedBox(height: 10.0),
                          Text(
                            "Psychologist",
                            style: TextStyle(
                              color: const Color.fromARGB(255, 241, 240, 244),
                              fontSize: 17.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),

            SizedBox(height: 20.0),

            Row(
              children: [
                Flexible(
                  fit: FlexFit.tight,
                  child: GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder:
                              (context) => Booking(service: "chiropractor"),
                        ),
                      );
                    },
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 10.0),
                      height: 170.0,
                      width: 150.0,
                      decoration: BoxDecoration(
                        color: Color.fromARGB(255, 68, 141, 178),
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset(
                            "images/chiropractor_pic.jpg",
                            height: 120,
                            width: 140,
                            fit: BoxFit.cover,
                          ),
                          SizedBox(height: 10.0),
                          Text(
                            "chiropractor",
                            style: TextStyle(
                              color: const Color.fromARGB(255, 241, 240, 244),
                              fontSize: 20.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 20.0),

                Flexible(
                  fit: FlexFit.tight,
                  child: GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => Booking(service: "Dentist"),
                        ),
                      );
                    },
                    child: Container(
                      height: 170.0,
                      width: 150.0,
                      decoration: BoxDecoration(
                        color: Color.fromARGB(255, 68, 141, 178),
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset(
                            "images/dentist_pic.jpg",
                            height: 120,
                            width: 120,
                            fit: BoxFit.cover,
                          ),
                          SizedBox(height: 10.0),
                          Text(
                            "Dentist",
                            style: TextStyle(
                              color: const Color.fromARGB(255, 241, 240, 244),
                              fontSize: 17.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
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

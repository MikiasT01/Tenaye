import 'package:flutter/material.dart';
class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.lightBlue,
      body: Container(child: Column(children: [
        Row(children: [
          Text("Hello",style: TextStyle(color: Colors.deepPurple,fontSize:20.0, fontWeight: FontWeight.bold))
        ],)
      ],),)
    );
  }
}
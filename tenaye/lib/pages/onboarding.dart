import 'package:flutter/material.dart';
class Onboarding extends StatefulWidget {
  const Onboarding({super.key});

  @override
  State<Onboarding> createState() => _MyWidgetState();
}

class _MyWidgetState extends State<Onboarding> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.lightBlue,
      body: Container(
        margin: EdgeInsets.only(top: 120.0),
        child: Column(children: [
        Image.asset("images/doc1.png"),
        SizedBox(height: 50.0,),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 20.0),
          decoration:BoxDecoration(
            color: Colors.deepPurple,
            borderRadius: BorderRadius.circular(10)
          ) ,
          child: Text("Consult our Health experts",
          style: TextStyle(color:Colors.white, fontSize: 20.0, fontWeight: FontWeight.bold),),
        )
      ],),),
    );
  }
}
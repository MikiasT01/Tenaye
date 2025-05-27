import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class GetData extends StatelessWidget {
  final String documentId;

  GetData({required this.documentId});

  @override
  Widget build(BuildContext context) {
    CollectionReference Health_proffesionals = FirebaseFirestore.instance
        .collection('Health_professionals');
    return FutureBuilder<DocumentSnapshot>(
      future: Health_proffesionals.doc(documentId).get(),
      builder: ((context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          Map<String, dynamic> data =
              snapshot.data!.data() as Map<String, dynamic>;
          return Text(
            "Name: ${data['Name']},Speciality: ${data['Speciality']}",
          );
        }

        return Text("Something went wrong");
      }),
    );
  }
}

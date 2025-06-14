// // migration_service.dart
// import 'package:cloud_firestore/cloud_firestore.dart';

// Future<void> migrateDoctors() async {
//   final specialties = [
//     'Dentist',
//     'General Practitioner',
//     'Psychologist',
//     'Chiropractor',
//     'Pharmacist',
//     'Nurse',
//   ];
//   for (var specialty in specialties) {
//     final collection = 'Health_professional_$specialty';
//     final snapshot = await FirebaseFirestore.instance.collection(collection).get();
//     for (var doc in snapshot.docs) {
//       await doc.reference.update({
//         'averageRating': 0.0,
//         'ratingCount': 0,
//       });
//     }
//   }
// }


import 'package:cloud_firestore/cloud_firestore.dart';

Future<void> migrateDoctors() async {
  final specialties = [
    'Dentist',
    'General Practitioner',
    'Psychologist',
    'Chiropractor',
    'Pharmacist',
    'Nurse',
  ];
  for (var specialty in specialties) {
    final collection = 'Health_professional_$specialty';
    final snapshot = await FirebaseFirestore.instance.collection(collection).get();
    for (var doc in snapshot.docs) {
      await doc.reference.update({
        'averageRating': 0.0,
        'ratingCount': 0,
        'imageurl': 'https://buoukoimjnuahbxugrtd.supabase.co/storage/v1/object/public/doctorimages//demo_doc.jpg',
      });
    }
  }
}
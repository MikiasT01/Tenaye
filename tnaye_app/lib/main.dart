import 'package:flutter/material.dart';
import 'package:tnaye_app/pages/Alldoctorespage.dart';
import 'package:tnaye_app/pages/Health_prof_detail.dart';
import 'package:tnaye_app/pages/booking.dart';
import 'package:tnaye_app/pages/home.dart';
import 'package:tnaye_app/pages/login.dart';
import 'package:tnaye_app/pages/onboarding.dart';
import 'package:tnaye_app/pages/signup.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:tnaye_app/services/migration_services.dart';

import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    if (Firebase.apps.isEmpty) {
      await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      );
      //print('Firebase initialized successfully');
    } else {
      //print('Firebase already initialized');
    }
  } catch (e) {
   // print('Firebase initialization failed: $e');
  }
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key}); 

  // This widget is the root of your application.
  @override

  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Tenaye',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      //home: AllDoctorspage(),
      //home:MigrationScreen()
    home: Onboarding(),
  //home: Home(),
   // home: Booking( service: "dr user", bio: "hdsfbsdbdjsbcskdasfdbdskvb skcbjdskc ksbjc dskc shb dfsvkcb bdkh vf vadkab vkc kc dk vv ca vd cvb sv n kc vv dfkjvnzdjcjka dc vjskhsh b kx ckjdXbvhcbfkjds hdsvdskv  vsda sdhjcasdbfc ddsbc ashdjbc dasj;fcnadshckjdbshds dsbchsd cds cdsahkabcksdc  sc sxcdbsaocdcnn snc jchdsbhdbcadsncsx kdschdsbvdsb vnkx cjbs ckjasbcvdsbvdbvbc h  ", age: 33, speciality: 'general practitioner', imageUrl: 'https://example.com/image.jpg'),
      //home: LogIn(),
    //home: SignUp(),
     //home: HealthProfDetail(service: "general practitioner"),
      //home: HealthProfDetail(service: "Psychologist"),
      //home: HealthProfDetail(service: "Dentist"),
      //home: HealthProfDetail(service: "Physiotherapist"),
    );
  }
}





// for updating the dataase fields in firebase

// class MigrationScreen extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text('Migration')),
//       body: Center(
//         child: ElevatedButton(
//           onPressed: () async {
//             try {
//               await migrateDoctors();
//               ScaffoldMessenger.of(context).showSnackBar(
//                 SnackBar(content: Text('Migration completed!')),
//               );
//             } catch (e) {
//               ScaffoldMessenger.of(context).showSnackBar(
//                 SnackBar(content: Text('Error during migration: $e')),
//               );
//             }
//           },
//           child: Text('Run Migration'),
//         ),
//       ),
//     );
//   }
// }

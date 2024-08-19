import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:fluttertest/Screens/login.dart';
import 'package:fluttertest/Screens/registration_one.dart';
import 'package:fluttertest/Screens/welcomescreen.dart';
import 'package:fluttertest/Screens/who_are_you.dart';
import 'package:fluttertest/Screens/collegeslist.dart';
import 'package:fluttertest/Screens/addbook.dart';
import 'package:fluttertest/Screens/categorieslist.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  Future<Widget> _getInitialScreen() async {
    User? user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .get();

      if (userDoc.exists) {
        String role = userDoc.get('role');
        String selectedCollege = userDoc.get('selected_college');

        if (role == 'admin') {
          return CategoriesList(selectedCollege: selectedCollege);
        } else if (role == 'user') {
          return CollegesList();
        }
      }
    }

    return const WHoAreYou(); // Default to the welcome screen if no user is logged in
  }

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      routes: {
        "login": (context) => const Login(),
        "Registration": (context) => const Registration(),
      },
      theme: ThemeData(scaffoldBackgroundColor: Colors.white),
      home: FutureBuilder<Widget>(
        future: _getInitialScreen(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Scaffold(
              body: Center(child: CircularProgressIndicator()),
            );
          } else if (snapshot.hasData) {
            return snapshot.data!;
          } else {
            return const WHoAreYou(); // Default to the welcome screen if there's an error
          }
        },
      ),
    );
  }
}

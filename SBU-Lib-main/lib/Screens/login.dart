import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertest/Screens/categorieslist.dart';
import 'package:fluttertest/Screens/collegeslist.dart';
import 'package:fluttertest/Screens/who_are_you.dart';
import 'package:fluttertest/component/textfield.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  TextEditingController email = TextEditingController();
  TextEditingController pass = TextEditingController();
  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  void initState() {
    FirebaseAuth.instance.authStateChanges().listen((User? user) {
      if (user == null) {
        print('User is currently signed out!');
      } else {
        print('User is signed in!');
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Form(
          key: formKey,
          child: Column(
            children: [
              const Stack(
                children: [
                  CurvedContainer(),
                  MyImage(
                    photo: 'assets/images/Animation - LoginGirl.json',
                  ),
                ],
              ),
              const SizedBox(height: 20),
              MyTextField(
                icon: Icons.email,
                text: 'Email',
                obscure: false,
                val: 'enter your e-mail',
                mycontroller: email,
                validator: (val) {
                  if (val == "") {
                    return "Required field ";
                  }
                },
              ),
              const SizedBox(height: 20),
              MyTextField(
                obscure: true,
                icon: Icons.lock,
                text: 'password',
                val: 'enter your password',
                mycontroller: pass,
                validator: (val) {
                  if (val == "") {
                    return "Required field ";
                  }
                },
                suffixIcon: Icons.remove_red_eye_rounded,
              ),
              const SizedBox(height: 20),
              TextButton(
                onPressed: () async {
                  try {
                    // Sign in with email and password
                    final credential =
                        await FirebaseAuth.instance.signInWithEmailAndPassword(
                      email: email.text,
                      password: pass.text,
                    );

                    // Get the user's role from Firestore
                    User? user = credential.user;
                    if (user != null) {
                      DocumentSnapshot userDoc = await FirebaseFirestore
                          .instance
                          .collection('users')
                          .doc(user.uid)
                          .get();

                      if (userDoc.exists) {
                        String role = userDoc.get('role');
                        String selectedCollege =
                            userDoc.get('selected_college');

                        // Navigate based on role
                        if (role == 'admin') {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => CategoriesList(
                                  selectedCollege: selectedCollege),
                            ),
                          );
                        } else if (role == 'user') {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => CollegesList(),
                            ),
                          );
                        } else {
                          AwesomeDialog(
                            context: context,
                            dialogType: DialogType.error,
                            animType: AnimType.rightSlide,
                            title: 'Error',
                            desc:
                                'Invalid role detected. Please contact support.',
                          ).show();
                        }
                      } else {
                        AwesomeDialog(
                          context: context,
                          dialogType: DialogType.error,
                          animType: AnimType.rightSlide,
                          title: 'Error',
                          desc: 'User data not found. Please contact support.',
                        ).show();
                      }
                    }
                  } on FirebaseAuthException catch (e) {
                    if (e.code == 'user-not-found') {
                      print('No user found for this email.');
                      AwesomeDialog(
                        context: context,
                        dialogType: DialogType.error,
                        animType: AnimType.rightSlide,
                        title: 'Error',
                        desc: 'No account found for this email.',
                      ).show();
                    } else if (e.code == 'wrong-password') {
                      print('Wrong password provided for this user.');
                      AwesomeDialog(
                        context: context,
                        dialogType: DialogType.error,
                        animType: AnimType.rightSlide,
                        title: 'Error',
                        desc: 'The password provided is incorrect.',
                      ).show();
                    }
                  } catch (e) {
                    print(e);
                    AwesomeDialog(
                      context: context,
                      dialogType: DialogType.error,
                      animType: AnimType.rightSlide,
                      title: 'Error',
                      desc: 'An unexpected error occurred: $e',
                    ).show();
                  }
                },
                child: Container(
                  margin: const EdgeInsets.all(25),
                  width: double.infinity,
                  height: 70,
                  decoration: BoxDecoration(
                    border: Border.all(
                      width: 1,
                      color: const Color(0xff2c53b7),
                    ),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        textAlign: TextAlign.center,
                        'Login now',
                        style: TextStyle(
                            fontSize: 28,
                            color: Color(0xff2c53b7),
                            fontWeight: FontWeight.bold),
                      ),
                      Icon(
                        Icons.arrow_forward_ios_outlined,
                        color: Color(0xff2c53b7),
                      ),
                    ],
                  ),
                ),
              ),
              TextButton(
                onPressed: () {},
                child: const Text(
                  "Forget Password?",
                  style: TextStyle(fontSize: 20, color: Color(0xff2c53b7)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:fluttertest/component/MyDropdownList.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fluttertest/component/login_button.dart';
import 'package:fluttertest/component/textfield.dart';
import 'package:fluttertest/component/utils.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lottie/lottie.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart'; // Import Firestore
import 'package:firebase_storage/firebase_storage.dart'; // Import Firebase Storage

class Registration extends StatefulWidget {
  const Registration({super.key});

  @override
  State<Registration> createState() => _RegistrationState();
}

class _RegistrationState extends State<Registration> {
  Uint8List? _image;
  TextEditingController firstname = TextEditingController();
  TextEditingController lastname = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController pass = TextEditingController();
  TextEditingController confirmpass = TextEditingController();
  TextEditingController phone = TextEditingController();
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  String? selectedValue; // Declare a variable to hold the dropdown value
  bool _obscureTextPass = true; // Manage visibility of the password
  bool _obscureTextConfirmPass =
      true; // Manage visibility of the confirm password

  Future<void> selectImage() async {
    try {
      Uint8List? img = await pickImage(ImageSource.gallery);
      setState(() {
        _image = img;
      });
    } catch (e) {
      print("Error picking image: $e");
    }
  }

  Future<void> registerUser() async {
    if (formKey.currentState != null && formKey.currentState!.validate()) {
      if (pass.text != confirmpass.text) {
        AwesomeDialog(
          context: context,
          dialogType: DialogType.error,
          animType: AnimType.rightSlide,
          title: 'Error',
          desc: 'Passwords do not match.',
        ).show();
        return;
      }

      try {
        // Create user with Firebase Authentication
        UserCredential credential =
            await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: email.text.trim(),
          password: pass.text.trim(),
        );

        // Send email verification
        User? user = credential.user;
        if (user != null && !user.emailVerified) {
          await user.sendEmailVerification();
        }

        // Handle image upload
        String? imageUrl;
        if (_image != null) {
          final storageRef = FirebaseStorage.instance
              .ref()
              .child('profile_images')
              .child('${user!.uid}.jpg');
          final uploadTask = storageRef.putData(_image!);
          final snapshot = await uploadTask;
          imageUrl = await snapshot.ref.getDownloadURL();
        }

        // Store user information in Firestore
        try {
          await FirebaseFirestore.instance
              .collection('users')
              .doc(user!.uid)
              .set({
            'firstname': firstname.text.trim(),
            'lastname': lastname.text.trim(),
            'email': email.text.trim(),
            'phone': phone.text.trim(),
            'profile_image': imageUrl,
            'selected_college': selectedValue,
            'role': "user",
          });
        } catch (firestoreError) {
          print("Firestore error: $firestoreError");
          AwesomeDialog(
            context: context,
            dialogType: DialogType.error,
            animType: AnimType.rightSlide,
            title: 'Error',
            desc: 'Failed to save user data. Please try again.',
          ).show();
        }

        // Navigate to login screen after showing the dialog
        AwesomeDialog(
          context: context,
          dialogType: DialogType.success,
          animType: AnimType.rightSlide,
          title: 'Welcome to SBU-Lib',
          desc:
              'Registration complete. Please verify your email before logging in.',
        ).show().then((_) {
          Navigator.of(context).pushReplacementNamed('login');
        });
      } on FirebaseAuthException catch (e) {
        if (e.code == 'weak-password') {
          AwesomeDialog(
            context: context,
            dialogType: DialogType.error,
            animType: AnimType.rightSlide,
            title: 'Error',
            desc: 'The password provided is too weak.',
          ).show();
        } else if (e.code == 'email-already-in-use') {
          AwesomeDialog(
            context: context,
            dialogType: DialogType.error,
            animType: AnimType.rightSlide,
            title: 'Error',
            desc: 'An account already exists for that email.',
          ).show();
        }
      } catch (e) {
        print("Unexpected error: $e");
        AwesomeDialog(
          context: context,
          dialogType: DialogType.error,
          animType: AnimType.rightSlide,
          title: 'Error',
          desc: 'An unexpected error occurred. Please try again.',
        ).show();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Form(
          key: formKey,
          child: Column(
            children: [
              const SizedBox(height: 10),
              const SizedBox(height: 24),
              const Text(
                'Registration',
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 30,
                    fontWeight: FontWeight.bold),
              ),
              Lottie.asset(
                'assets/images/Animation - 1710302184526 (1).json',
              ),
              Stack(
                children: [
                  _image != null
                      ? CircleAvatar(
                          radius: 50,
                          backgroundImage: MemoryImage(_image!),
                        )
                      : const CircleAvatar(
                          radius: 50,
                          backgroundImage: AssetImage(
                              'assets/images/default-user-icon-23.jpg'),
                        ),
                  Positioned(
                      bottom: -10,
                      left: 65,
                      child: IconButton(
                          onPressed: selectImage,
                          icon: const Icon(
                            Icons.add_a_photo,
                            color: Color(0xff2c53b7),
                          ))),
                ],
              ),
              const SizedBox(height: 7),
              MyTextField(
                icon: Icons.person,
                obscure: false,
                text: 'First Name',
                val: 'enter your first name',
                mycontroller: firstname,
                validator: (val) => val == "" ? "Required field" : null,
              ),
              const SizedBox(height: 20),
              MyTextField(
                icon: Icons.person,
                obscure: false,
                text: 'Last Name',
                val: 'enter your last name',
                mycontroller: lastname,
                validator: (val) => val == "" ? "Required field" : null,
              ),
              const SizedBox(height: 20),
              MyTextField(
                icon: Icons.email,
                obscure: false,
                text: 'Email',
                val: 'enter your e-mail',
                mycontroller: email,
                validator: (val) => val == "" ? "Required field" : null,
              ),
              const SizedBox(height: 20),
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 20),
                child: TextFormField(
                  controller: pass,
                  obscureText: _obscureTextPass,
                  decoration: InputDecoration(
                    hintText: 'enter a password',
                    labelText: 'Password',
                    prefixIcon: Icon(Icons.lock),
                    suffixIcon: IconButton(
                      icon: Icon(
                        _obscureTextPass
                            ? Icons.visibility_off
                            : Icons.remove_red_eye_rounded,
                        color: Colors.grey,
                      ),
                      onPressed: () {
                        setState(() {
                          _obscureTextPass = !_obscureTextPass;
                        });
                      },
                    ),
                    filled: true,
                    fillColor: Colors.blueGrey[50],
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: BorderSide(
                          color: Colors.blueGrey, width: 1), // Border styling
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: BorderSide(
                          color: Colors.blueGrey, width: 1), // Border styling
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: BorderSide(
                          color: Colors.blueGrey, width: 1), // Border styling
                    ),
                  ),
                  validator: (val) => val == "" ? "Required field" : null,
                ),
              ),
              const SizedBox(height: 20),
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 20),
                child: TextFormField(
                  controller: confirmpass,
                  obscureText: _obscureTextConfirmPass,
                  decoration: InputDecoration(
                    hintText: 'enter the same password',
                    labelText: 'Confirm Password',
                    prefixIcon: Icon(Icons.lock),
                    suffixIcon: IconButton(
                      icon: Icon(
                        _obscureTextConfirmPass
                            ? Icons.visibility_off
                            : Icons.remove_red_eye_rounded,
                        color: Colors.grey,
                      ),
                      onPressed: () {
                        setState(() {
                          _obscureTextConfirmPass = !_obscureTextConfirmPass;
                        });
                      },
                    ),
                    filled: true,
                    fillColor: Colors.blueGrey[50],
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: BorderSide(
                          color: Colors.blueGrey, width: 1), // Border styling
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: BorderSide(
                          color: Colors.blueGrey, width: 1), // Border styling
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: BorderSide(
                          color: Colors.blueGrey, width: 1), // Border styling
                    ),
                  ),
                  validator: (val) => val == "" ? "Required field" : null,
                ),
              ),
              const SizedBox(height: 20),
              MyTextField(
                icon: Icons.phone,
                obscure: false,
                text: 'Phone Number',
                val: 'enter your phone number',
                mycontroller: phone,
                validator: (val) => val == "" ? "Required field" : null,
              ),
              const SizedBox(height: 20),
              MyDropdownList(
                onChanged: (String? newValue) {
                  setState(() {
                    selectedValue = newValue;
                  });
                  print('Selected item: $newValue');
                },
              ),
              TextButton(
                onPressed: registerUser,
                child: Container(
                  margin: const EdgeInsets.all(25),
                  width: double.infinity,
                  height: 70,
                  decoration: BoxDecoration(
                    color: const Color(0xff2c53b7),
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
                        'Register Now',
                        style: TextStyle(
                            fontSize: 28,
                            color: Colors.white,
                            fontWeight: FontWeight.bold),
                      ),
                      Icon(
                        Icons.arrow_circle_right_sharp,
                        color: Colors.white,
                        size: 32,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

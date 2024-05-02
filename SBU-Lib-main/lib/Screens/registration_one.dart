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

  void selectImage() async {
    Uint8List img = await pickImage(ImageSource.gallery);
    setState(() {
      _image = img;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          key: formKey,
          children: [
            // Icon(
            //   Icons.arrow_circle_left_rounded,
            //   color: Color(0xff2c53b7),
            //   size: 50,
            // ),
            const SizedBox(
              height: 10,
            ),
            const SizedBox(
              height: 24,
            ),
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
                        radius: 50, backgroundImage: MemoryImage(_image!))
                    : const CircleAvatar(
                        radius: 50,
                        backgroundImage: AssetImage(
                            'assets/images/default-user-icon-23.jpg'),
                      ),
                Positioned(
                    bottom: -10,
                    left: 65,
                    child: IconButton(
                        onPressed: () => selectImage(),
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
                validator: (val) {
                  if (val == "") {
                    return "Required field ";
                  }
                }),
            const SizedBox(height: 20),
            MyTextField(
                icon: Icons.person,
                obscure: false,
                text: 'Last Name',
                val: 'enter your last name',
                mycontroller: lastname,
                validator: (val) {
                  if (val == "") {
                    return "Required field ";
                  }
                }),
            const SizedBox(height: 20),
            MyTextField(
                icon: Icons.email,
                obscure: false,
                text: 'Email',
                val: 'enter your e-mail',
                mycontroller: email,
                validator: (val) {
                  if (val == "") {
                    return "Required field ";
                  }
                }),
            const SizedBox(height: 20),
            MyTextField(
                icon: Icons.lock,
                obscure: true,
                text: 'password',
                val: 'enter a password',
                suffixIcon: Icons.remove_red_eye_rounded,
                mycontroller: pass,
                validator: (val) {
                  if (val == "") {
                    return "Required field ";
                  }
                }),
            const SizedBox(height: 20),
            MyTextField(
                suffixIcon: Icons.remove_red_eye_rounded,
                icon: Icons.lock,
                obscure: true,
                text: 'Confirm password',
                val: 'enter the same password',
                mycontroller: confirmpass,
                validator: (val) {
                  if (val == "") {
                    return "Required field ";
                  }
                }),
            const SizedBox(height: 20),
            MyTextField(
                icon: Icons.phone,
                obscure: false,
                text: 'Phone Number',
                val: 'enter your phone number',
                mycontroller: phone,
                validator: (val) {
                  if (val == "") {
                    return "Required field ";
                  }
                }),
            const SizedBox(height: 20),
            MyDropdownList(
              onChanged: (String? newValue) {
                // ignore: avoid_print
                print('Selected item: $newValue');
              },
            ),

            TextButton(
              onPressed: () async {
                try {
                  final credential = await FirebaseAuth.instance
                      .createUserWithEmailAndPassword(
                    email: email.text,
                    password: pass.text,
                  );

                  AwesomeDialog(
                    context: context,
                    dialogType: DialogType.success,
                    animType: AnimType.rightSlide,
                    title: 'Welcome to SBU-Lib',
                    desc: 'Registration compleat.',
                  ).show();
                  Navigator.of(context).pushReplacementNamed('login');
                } on FirebaseAuthException catch (e) {
                  if (e.code == 'weak-password') {
                    print('The password provided is too weak.');
                    AwesomeDialog(
                      context: context,
                      dialogType: DialogType.error,
                      animType: AnimType.rightSlide,
                      title: 'Error',
                      desc: 'The password provided is too weak.',
                    ).show();
                  } else if (e.code == 'email-already-in-use') {
                    print('The account already exists for that email.');
                    AwesomeDialog(
                            context: context,
                            dialogType: DialogType.error,
                            animType: AnimType.rightSlide,
                            title: 'Error',
                            desc: ' account already exists for that email.')
                        .show();
                  }
                } catch (e) {
                  print(e);
                }
              },
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
                      'Rigster Now            ',
                      style: TextStyle(
                          fontSize: 28,
                          color: Colors.white,
                          fontWeight: FontWeight.bold),
                    ),
                    Icon(
                      Icons.arrow_circle_right_sharp,
                      color: Colors.white,
                    ),
                  ],
                ),
              ),
            ),

            const LoginButton(),
          ],
        ),
      ),
    );
  }
}

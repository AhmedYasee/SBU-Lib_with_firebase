import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:fluttertest/Screens/who_are_you.dart';
import 'package:fluttertest/component/textfield.dart';
import 'package:lottie/lottie.dart';
import '../component/custom_button.dart'; // Ensure this path is correct

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  _ForgotPasswordScreenState createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final TextEditingController _emailController = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  void _sendPasswordResetEmail() async {
    if (_formKey.currentState!.validate()) {
      try {
        await _auth.sendPasswordResetEmail(email: _emailController.text.trim());
        AwesomeDialog(
          context: context,
          dialogType: DialogType.success,
          animType: AnimType.rightSlide,
          title: 'Success',
          desc: 'Password reset link has been sent to your email.',
          btnOkOnPress: () {},
        ).show();
      } catch (e) {
        AwesomeDialog(
          context: context,
          dialogType: DialogType.error,
          animType: AnimType.rightSlide,
          title: 'Error',
          desc: 'Failed to send password reset email. Please try again.',
          btnOkOnPress: () {},
        ).show();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:
               SingleChildScrollView(
             child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Stack(
                          children: [
                            CurvedContainer(height: 2.5),
                            Center(
                              child: SizedBox(

                                height: 300,
                                child: Lottie.network(
                                  'https://lottie.host/5d1fe4b4-36d3-4637-8800-cc8eea493756/C7b06j3lA8.json',
                                  fit: BoxFit.contain, // Adjust this to fit the animation as needed
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),
                        const Text(
                          "Enter your email address below and we'll send you a link to reset your password.",
                          style: TextStyle(fontSize: 16),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 20),
                        Form(
                          key: _formKey,
                          child: MyTextField(
                            text: 'Email',
                            icon: Icons.email,
                            val: 'Please enter your email',
                            mycontroller: _emailController,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter your email';
                              } else if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
                                return 'Please enter a valid email';
                              }
                              return null;
                            },
                            obscure: false, // No need to obscure text in this case
                          ),
                        ),
                        const SizedBox(height: 20),
                        SizedBox(
                         // Button width responsive
                          child: CustomButton(
                            text: 'Send link',
                            onTap: () {
                              _sendPasswordResetEmail();
                            },
                          ),
                        ),
                        const SizedBox(height: 20),
                        TextButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: const Text(
                            "Back to Login",
                            style: TextStyle(fontSize: 18, color: Color(0xff2c53b7)),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
             ),
           )
    )
    ;
}}

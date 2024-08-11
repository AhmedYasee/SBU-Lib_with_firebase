import 'package:flutter/material.dart';

// ignore: must_be_immutable
class MyTextField extends StatelessWidget {
  MyTextField(
      {super.key,
      required this.text,
      this.icon,
      this.suffixIcon,
      required this.obscure,
      required this.val,
      required this.mycontroller,
      required this.validator});
  final String text;
  final bool obscure;
  final IconData? icon;
  final IconData? suffixIcon;
  final String val;
  final TextEditingController mycontroller;
  final String? Function(String?) validator;

  GlobalKey<FormState> formstate = GlobalKey();
  @override
  Widget build(BuildContext context) {
    return Container(
        color: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Container(
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.5),
                  spreadRadius: 2,
                  blurRadius: 7,
                  offset: const Offset(0, 3),
                )
              ]),
          child: Form(
            key: formstate,
            child: TextFormField(
              controller: mycontroller,
              validator: validator,
              // obscureText: obscure,
              decoration: InputDecoration(
                hintText: text,
                prefixIcon: icon != null
                    ? Icon(
                        icon,
                        color: const Color(0xff2c53b7),
                      )
                    : null,
                suffixIcon: Icon(
                  suffixIcon,
                ),
                labelText: text,
                filled: true,
                border: OutlineInputBorder(
                  borderSide: const BorderSide(color: Colors.transparent),
                  borderRadius: BorderRadius.circular(16),
                ),
                fillColor: Colors.white24,
              ),
            ),
          ),
        ));
  }
}

import 'package:flutter/material.dart';

class MyTextField2 extends StatelessWidget {
  final TextEditingController? controller;
  final String text;
  final bool obscure;
  final IconData? icon;
  final IconData? suffixIcon;
  final String val;

  MyTextField2({
    super.key,
    required this.text,
    this.icon,
    this.suffixIcon,
    required this.obscure,
    required this.val,
    this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
          hintText: text,
          prefixIcon: icon != null ? Icon(icon, color: Colors.blue) : null,
          suffixIcon: suffixIcon != null ? Icon(suffixIcon, color: Colors.blue) : null,
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
        ),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return val;
          }
          return null;
        },
        obscureText: obscure,
      ),
    );
  }
}

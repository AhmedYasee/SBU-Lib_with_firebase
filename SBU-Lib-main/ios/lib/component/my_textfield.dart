import 'package:flutter/material.dart';

class MyTextField extends StatelessWidget {
  final String text; // Label text for the input field
  final IconData? icon; // Optional icon on the left
  final IconData? suffixIcon; // Optional icon on the right
  final String val; // Hint text displayed inside the input field
  final TextEditingController mycontroller; // Controller for the text input
  final String? Function(String?) validator; // Validator function for input
  final bool obscure; // Whether to obscure the text (e.g., for passwords)

  const MyTextField({
    super.key,
    required this.text,
    this.icon,
    this.suffixIcon,
    required this.val,
    required this.mycontroller,
    required this.validator,
    this.obscure = false, // Default to false if not provided
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: mycontroller,
      validator: validator,
      obscureText: obscure,
      decoration: InputDecoration(
        hintText: val, // Displayed when the field is empty
        labelText: text, // Displayed as the label
        prefixIcon: icon != null ? Icon(icon) : null, // Optional icon on the left
        suffixIcon: suffixIcon != null ? Icon(suffixIcon) : null, // Optional icon on the right
        filled: true,
        fillColor: Colors.white24, // Background color of the text field
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16), // Rounded corners
          borderSide: BorderSide.none, // Removes border lines
        ),
      ),
    );
  }
}

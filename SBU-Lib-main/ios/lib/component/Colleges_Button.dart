import 'package:flutter/material.dart';
import 'package:fluttertest/constants/college_logos.dart'; // Import the file with the logo mapping

class Colleges_Button extends StatelessWidget {
  const Colleges_Button({
    super.key,
    this.onTap,
    this.text,
  });
  final void Function()? onTap;
  final String? text;

  @override
  Widget build(BuildContext context) {
    // Get the logo filename from the mapping
    String logoFilename = collegeLogos[text] ??
        'default_logo.png'; // Use a default logo if not found

    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.all(8),
        width: double.infinity,
        height: 85,
        decoration: BoxDecoration(
          border: Border.all(
            width: 1,
            color: const Color(0xff2c53b7),
          ),
          borderRadius: BorderRadius.circular(15),
        ),
        child: Row(
          children: [
            // Display the college logo
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 8),
              width: 50,
              height: 50,
              child: Image.asset(
                'assets/college_logos/$logoFilename',
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Icon(Icons.school,
                      color: Colors.grey); // Fallback icon if image not found
                },
              ),
            ),
            Expanded(
              child: Text(
                '$text',
                textAlign: TextAlign.left,
                style: const TextStyle(
                    fontSize: 16, // Smaller font size
                    color: Color(0xff2c53b7),
                    fontWeight: FontWeight.bold),
              ),
            ),
            const Icon(
              Icons.arrow_forward_ios_outlined,
              color: Color(0xff2c53b7),
            ),
          ],
        ),
      ),
    );
  }
}

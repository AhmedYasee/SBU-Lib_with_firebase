import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  const CustomButton({
    super.key,
    this.onTap,
    this.text,
  });
  final void Function()? onTap;
  final String? text;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.all(20),
        width: double.infinity,
        height: 70,
        decoration: BoxDecoration(
          border: Border.all(
            width: 1,
            color: const Color(0xff2c53b7),
          ),
          borderRadius: BorderRadius.circular(15),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              '$text',
              textAlign: TextAlign.center,
              style: const TextStyle(
                  fontSize: 28,
                  color: Color(0xff2c53b7),
                  fontWeight: FontWeight.bold),
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

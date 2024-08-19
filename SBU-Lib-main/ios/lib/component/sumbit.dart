import 'package:flutter/material.dart';

class SubmitButton extends StatelessWidget {
  const SubmitButton({super.key, this.onTap});
  final void Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.all(25),
        width: 370,
        height: 70,
        decoration: BoxDecoration(
          color: const Color(0xff2c53b7),
          border: Border.all(
            width: 1,
            color: const Color(0xff2c53b7),
          ),
          borderRadius: BorderRadius.circular(16),
        ),
        child: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              textAlign: TextAlign.center,
              'Submit            ',
              style: TextStyle(
                  fontSize: 28,
                  color: Colors.white,
                  fontWeight: FontWeight.bold),
            ),
            Icon(
              Icons.arrow_forward_ios_outlined,
              color: Colors.white,
            ),
          ],
        ),
      ),
    );
  }
}

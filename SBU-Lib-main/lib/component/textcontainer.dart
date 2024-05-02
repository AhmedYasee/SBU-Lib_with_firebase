import 'package:flutter/material.dart';

class TextContainer extends StatelessWidget {
  const TextContainer({
    super.key,
    required this.text,
    this.icon,
  });

  //final bool obscure;
  final String text;
  final IconData? icon;
  //final IconData? suffixIcon;

  @override
  Widget build(BuildContext context) {
    return (Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
      Container(
        height: 35,
        width: 100,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: const Color(0xff2c53b7),
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 2,
              blurRadius: 7,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Text(
          text,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 15,
          ),
        ),
      ),
    ]));
  }
}

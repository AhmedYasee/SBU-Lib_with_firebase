import 'package:flutter/material.dart'
    show
        BorderRadius,
        BoxDecoration,
        BoxFit,
        BuildContext,
        Color,
        Column,
        Container,
        FontWeight,
        MediaQuery,
        Positioned,
        Radius,
        Scaffold,
        SizedBox,
        Stack,
        StatelessWidget,
        Text,
        TextStyle,
        Widget;
import 'package:fluttertest/Screens/login.dart';
import 'package:fluttertest/Screens/registration_one.dart';
import 'package:fluttertest/component/custom_button.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';

class WHoAreYou extends StatelessWidget {
  const WHoAreYou({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          const Stack(
            children: [
              CurvedContainer(),
              MyImage(
                photo: 'assets/images/Animation - Registration.json',
              ),
            ],
          ),
          const SizedBox(
            height: 15,
          ),
          const Text(
            'Are You ?',
            style: TextStyle(
                color: Color(0xff2c53b7),
                fontSize: 26,
                fontWeight: FontWeight.w500),
          ),
          CustomButton(
            text: 'Admin         ',
            onTap: () {
              Get.to(const login());
            },
          ),
          CustomButton(
            text: 'User            ',
            onTap: () {
              Get.to(const Registration());
            },
          ),
        ],
      ),
    );
  }
}

class CurvedContainer extends StatelessWidget {
  const CurvedContainer({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
        height: MediaQuery.of(context).size.height / 1.9,
        width: double.infinity,
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(180),
              bottomRight: Radius.circular(180)),
          color: Color.fromARGB(255, 248, 246, 246),
        ));
  }
}

class MyImage extends StatelessWidget {
  const MyImage({
    super.key,
    required this.photo,
  });
  final String photo;
  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: 20,
      right: 30,
      left: 30,
      child: Lottie.asset(
        photo,
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height / 2,
        fit: BoxFit.contain,
      ),
    );
  }
}

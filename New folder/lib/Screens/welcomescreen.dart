import 'package:flutter/material.dart';
import 'package:fluttertest/Screens/who_are_you.dart';
import 'package:get/get.dart';

// ignore: camel_case_types
class welcomescreen extends StatelessWidget {
  const welcomescreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          const Stack(
            children: [
              CurvedContainer(),
              MyImage(
                photo: 'assets/images/Animation - AnimationBooks.json',
              ),
            ],
          ),
          SizedBox(
            height: 100,
            width: 350,
            child: Image.asset(
              'assets/images/Book.jpg',
              fit: BoxFit.fill,
              width: 350,
              height: 50,
            ),
          ),
          const SizedBox(
            height: 50,
          ),
          GestureDetector(
            onTap: () {
              Get.to(const WHoAreYou(),
                  transition: Transition.fadeIn,
                  duration: const Duration(milliseconds: 200));
            },
            child: Container(
              margin: const EdgeInsets.all(25),
              width: double.infinity,
              height: 70,
              decoration: BoxDecoration(
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
                    'Let\'s Go         ',
                    style: TextStyle(
                        fontSize: 28,
                        color: Color(0xff2c53b7),
                        fontWeight: FontWeight.bold),
                  ),
                  Positioned(
                    right: 5,
                    child: Icon(
                      Icons.arrow_forward_ios_outlined,
                      color: Color(0xff2c53b7),
                    ),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}

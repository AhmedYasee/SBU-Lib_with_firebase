import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:fluttertest/component/sumbit.dart';
import 'package:fluttertest/component/my_textfield.dart';
import 'package:fluttertest/component/my_textfield2.dart';
class FeedBack extends StatelessWidget {
  const FeedBack({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: const Text(
            "FeedBack",
            style: TextStyle(
              fontWeight: FontWeight.w700,
              color: Color.fromRGBO(53, 37, 85, 1),
            ),
          ),
          backgroundColor: Colors.white,
          centerTitle: true,
        ),
        body: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                const Text(
                  'Thank you!',
                  style: TextStyle(
                    fontSize: 20,
                    color: Color(0xFF2C53B7),
                    fontWeight: FontWeight.w700,
                    fontStyle: FontStyle.normal,
                  ),
                ),
                const Text(
                  'Rate the App',
                  style: TextStyle(
                    fontSize: 26,
                    color: Color.fromRGBO(53, 37, 85, 1),
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 10),
                RatingBar.builder(
                  initialRating: 3,
                  minRating: 1,
                  direction: Axis.horizontal,
                  allowHalfRating: true,
                  itemCount: 5,
                  itemPadding: const EdgeInsets.symmetric(horizontal: 5.0),
                  itemBuilder: (context, _) => const Icon(
                    Icons.star,
                    color: Colors.amber,
                  ),
                  onRatingUpdate: (rating) {
                    // ignore: avoid_print
                    print(rating);
                  },
                ),
                const SizedBox(
                    height: 30), // Add spacing between text and animation
                Lottie.asset(
                  'assets/images/Animation - PirsonRate.json', // Replace with your actual asset path
                  width: 350, // Adjust size as needed
                  height: 355,
                ),
                const SizedBox(height: 20),

                 MyTextField2( text: 'type here...', obscure: false,val:'required'
                ),
                const SubmitButton(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:fluttertest/component/details.dart';
import 'bookslist.dart';

class BooksDetails extends StatelessWidget {
  const BooksDetails({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: const Text(
            "Book Details",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          backgroundColor: Colors.white,
          centerTitle: true,
        ),
        body: Column(children: [
          TextButton(
              onPressed: (
              ) {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const BooksList()),
                );
              },
              child: const Row(children: [
                Icon(
                  Icons.arrow_back_ios_new_outlined,
                  size: 24,
                  color: Colors.black,
                ),
                Text(
                  "   Previous",
                  style: TextStyle(fontSize: 20, color: Colors.black),
                ),
              ])),
          const Padding(padding: EdgeInsets.all(10)),
          Details(
              name:
                  'How to Fail \n at Almost \n Everything and still \n Win Big',
              image: "assets/images/images.jpeg",
              desc:
                  "Kind of the Story of My Life is a 2013 non-fiction book by Scott Adams, creator of Dilbert. Adams shares many of the techniques and theories from his life which he believes can increase a person's likelihood of success.",
              maxLines: 9)
        ]),
      ),
    );
  }
}

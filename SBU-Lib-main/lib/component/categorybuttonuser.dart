import 'package:flutter/material.dart';
import 'package:fluttertest/Screens/bookslist.dart';
import 'package:fluttertest/component/textcontainer.dart';

class Category_Button_User extends StatelessWidget {
  const Category_Button_User({
    super.key,
    required this.text,
    required this.adminId,
    required this.categoryId,
  });

  final String text;
  final String adminId;
  final String categoryId;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => BooksList(
              adminId: adminId,
              categoryId: categoryId,
            ),
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.all(8),
        width: double.infinity,
        height: 150,
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              offset: const Offset(0, 1),
              blurRadius: 5,
              color: Colors.black.withOpacity(0.3),
            ),
          ],
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Text(
                  text,
                  style: const TextStyle(
                    color: Colors.black,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Icon(
                  Icons.announcement_outlined,
                  size: 24,
                )
              ],
            ),
            const Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                TextContainer(
                  text: "REF",
                  icon: Icons.adjust,
                ),
                TextContainer(
                  text: "PAPERS",
                  icon: Icons.mode_night,
                ),
                TextContainer(
                  text: "BOOKS",
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

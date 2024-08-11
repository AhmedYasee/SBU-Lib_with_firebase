import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fluttertest/component/bookcard.dart';
import 'package:fluttertest/component/my_textfield2.dart';

class BooksList extends StatelessWidget {
  const BooksList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          "Books List",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        backgroundColor: Colors.white,
        centerTitle: true,
      ),
      body: Column(
        children: [
          MyTextField2(
            text: "Search your book",
            icon: Icons.search,
            obscure: false,
            val: 'not valid!',
          ),
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance.collection("books").snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else if (snapshot.hasData) {
                  final bookDocs = snapshot.data!.docs;
                  return ListView.builder(
                    itemCount: bookDocs.length,
                    itemBuilder: (context, index) {
                      final bookData = bookDocs[index].data() as Map<String, dynamic>;
                      final bookName = bookData['title'] as String;
                      return BookCard(name: bookName);
                    },
                  );
                } else {
                  return const SizedBox(); // Return an empty container when there's no data
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}

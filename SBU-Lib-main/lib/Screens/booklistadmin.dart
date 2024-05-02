import 'package:flutter/material.dart';
import 'package:fluttertest/Screens/AddBook.dart';
import 'package:fluttertest/Screens/NavBar.dart';
import 'package:fluttertest/Screens/who_are_you.dart';
import 'package:fluttertest/component/add_button.dart';
import 'package:fluttertest/component/editedbookcard.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../component/my_textfield.dart';
import 'package:fluttertest/component/my_textfield2.dart';

class BooksListAdmin extends StatefulWidget {
  const BooksListAdmin({Key? key}) : super(key: key);

  @override
  _BooksListAdminState createState() => _BooksListAdminState();
}

class _BooksListAdminState extends State<BooksListAdmin> {
  // Stream of QuerySnapshot from Firestore
  Stream<QuerySnapshot> streamData() {
    return FirebaseFirestore.instance.collection("books").snapshots();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          "Books List For Admin",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        backgroundColor: Colors.white,
        centerTitle: true,
      ),
      drawer: const NavBar() ,
      body: Column(
        children: [
          MyTextField2(
            text: "Search your book",
            icon: Icons.search,
            obscure: false,
            val: 'not valid!',
          ),
          Expanded(
            child: StreamBuilder(
              stream: streamData(),
              builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else if (snapshot.hasData && snapshot.data!.docs.isNotEmpty) {
                  return ListView.builder(
                    itemCount: snapshot.data!.docs.length,
                    itemBuilder: (context, index) {
                      var doc = snapshot.data!.docs[index];
                      return EditedBookCard(
                        name: doc['title'], // Assuming 'title' is the field in the document
                      );
                    },
                  );
                } else {
                  return const SizedBox(); // Return an empty container when there's no data
                }
              },
            ),
          ),
          AddButton(
            text: "Add new book",
            onTap: () {
              Get.to(const AddBook());
            },
          ),
        ],
      ),
    );
  }
}

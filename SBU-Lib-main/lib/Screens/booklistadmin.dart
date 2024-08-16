import 'package:flutter/material.dart';
import 'package:fluttertest/Screens/AddBook.dart';
import 'package:fluttertest/Screens/NavBar.dart';
import 'package:fluttertest/Screens/editbook.dart';
import 'package:fluttertest/component/add_button.dart';
import 'package:fluttertest/component/editedbookcard.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../component/my_textfield2.dart';

class BooksListAdmin extends StatefulWidget {
  final String adminId;
  final String categoryId;

  const BooksListAdmin({
    Key? key,
    required this.adminId,
    required this.categoryId,
  }) : super(key: key);

  @override
  _BooksListAdminState createState() => _BooksListAdminState();
}

class _BooksListAdminState extends State<BooksListAdmin> {
  // Stream of QuerySnapshot from Firestore
  Stream<QuerySnapshot> streamData() {
    return FirebaseFirestore.instance
        .collection('colleges')
        .doc(widget.adminId)
        .collection('categories')
        .doc(widget.categoryId)
        .collection('books')
        .snapshots();
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
      drawer: const NavBar(),
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
                        name: doc['title'],
                        adminId: widget.adminId,
                        categoryId: widget.categoryId,
                        docId: doc.id, // Get the document ID
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => EditBook(
                                docid: doc.id,
                                adminId: widget.adminId,
                                categoryId: widget.categoryId,
                              ),
                            ),
                          );
                        },
                      );
                    },
                  );
                } else {
                  return const Center(
                    child: Text("No books available."),
                  );
                }
              },
            ),
          ),
          AddButton(
            text: "Add new book",
            onTap: () {
              Get.to(
                AddBook(
                  adminId: widget.adminId,
                  categoryId: widget.categoryId,
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

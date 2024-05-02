import 'package:flutter/material.dart';
import 'package:fluttertest/Screens/NavBar.dart';
import 'package:fluttertest/Screens/addnewcategory.dart' show AddNewCategory;
import 'package:fluttertest/component/add_button.dart';
import 'package:fluttertest/component/categorybutton.dart';
import 'package:get/route_manager.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class CategoriesList extends StatefulWidget {
  const CategoriesList({Key? key}) : super(key: key);

  @override
  _CategoriesListState createState() => _CategoriesListState();
}

class _CategoriesListState extends State<CategoriesList> {
  // Stream of QuerySnapshot from Firestore
  Stream<QuerySnapshot> streamData() {
    return FirebaseFirestore.instance.collection("categories").snapshots();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          "Categories List",
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
                      return Category_Button(
                        text: doc['name'], // Assuming 'name' is the field in the document
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
            text: 'Add New Category',
            onTap: () {
              Get.to(const AddNewCategory());
            },
          ),
        ],
      ),
    );
  }
}

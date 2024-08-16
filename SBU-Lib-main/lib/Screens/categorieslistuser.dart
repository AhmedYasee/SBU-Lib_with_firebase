import 'package:flutter/material.dart';
import 'package:fluttertest/Screens/NavBar.dart';
import 'package:fluttertest/Screens/addnewcategory.dart';
import 'package:fluttertest/component/add_button.dart';
import 'package:fluttertest/component/categorybutton.dart';
import 'package:fluttertest/component/my_textfield2.dart';
import 'package:get/route_manager.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class CategoriesListUser extends StatefulWidget {
  final String selectedCollege;

  const CategoriesListUser({Key? key, required this.selectedCollege})
      : super(key: key);

  @override
  _CategoriesListUserState createState() => _CategoriesListUserState();
}

class _CategoriesListUserState extends State<CategoriesListUser> {
  TextEditingController _searchController = TextEditingController();
  List<DocumentSnapshot> _allCategories = [];
  List<DocumentSnapshot> _filteredCategories = [];

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_filterCategories);
    _listenToCategories(); // Listen for real-time updates
  }

  void _listenToCategories() {
    FirebaseFirestore.instance
        .collection('colleges')
        .doc(widget.selectedCollege)
        .collection('categories')
        .snapshots()
        .listen((snapshot) {
      setState(() {
        _allCategories = snapshot.docs;
        _filteredCategories = _allCategories;
      });
    });
  }

  void _filterCategories() {
    String query = _searchController.text.toLowerCase();
    setState(() {
      _filteredCategories = _allCategories.where((category) {
        final categoryData = category.data() as Map<String, dynamic>;
        final categoryName = categoryData['name'] as String;
        return categoryName.toLowerCase().startsWith(query);
      }).toList();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
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
          MyTextField2(
            text: "Search your category",
            icon: Icons.search,
            obscure: false,
            val: 'not valid!',
            controller: _searchController,
          ),
          Expanded(
            child: _filteredCategories.isEmpty
                ? Center(
                    child: Text(
                      "No categories found. Please add one.",
                      style: TextStyle(fontSize: 18),
                    ),
                  )
                : ListView.builder(
                    itemCount: _filteredCategories.length,
                    itemBuilder: (context, index) {
                      var doc = _filteredCategories[index];
                      return Category_Button(
                        text: doc[
                            'name'], // Assuming 'name' is the field in the document
                        adminId: widget.selectedCollege,
                        categoryId: doc.id,
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}

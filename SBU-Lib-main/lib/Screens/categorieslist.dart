import 'package:flutter/material.dart';
import 'package:fluttertest/Screens/NavBar.dart';
import 'package:fluttertest/Screens/addnewcategory.dart' show AddNewCategory;
import 'package:fluttertest/component/add_button.dart';
import 'package:fluttertest/component/categorybutton.dart';
import 'package:fluttertest/component/my_textfield2.dart';
import 'package:get/route_manager.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class CategoriesList extends StatefulWidget {
  final String selectedCollege;

  const CategoriesList({Key? key, required this.selectedCollege})
      : super(key: key);

  @override
  _CategoriesListState createState() => _CategoriesListState();
}

class _CategoriesListState extends State<CategoriesList> {
  TextEditingController _searchController = TextEditingController();
  ValueNotifier<List<DocumentSnapshot>> _filteredCategoriesNotifier =
      ValueNotifier([]);
  List<DocumentSnapshot> _allCategories = [];

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_filterCategories);
    _listenToCategories();
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
        _filterCategories(); // Apply filtering after data is fetched
      });
    });
  }

  void _filterCategories() {
    String query = _searchController.text.toLowerCase();
    _filteredCategoriesNotifier.value = _allCategories.where((category) {
      final categoryData = category.data() as Map<String, dynamic>;
      final categoryName = categoryData['name'] as String;
      return categoryName.toLowerCase().startsWith(query);
    }).toList();
    _filteredCategoriesNotifier.value.sort((a, b) {
      final aName = (a.data() as Map<String, dynamic>)['name'] as String;
      final bName = (b.data() as Map<String, dynamic>)['name'] as String;
      return aName.toLowerCase().startsWith(query)
          ? -1
          : bName.toLowerCase().startsWith(query)
              ? 1
              : 0;
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    _filteredCategoriesNotifier.dispose();
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
            child: ValueListenableBuilder<List<DocumentSnapshot>>(
              valueListenable: _filteredCategoriesNotifier,
              builder: (context, filteredCategories, child) {
                return ListView.builder(
                  itemCount: filteredCategories.length,
                  itemBuilder: (context, index) {
                    var doc = filteredCategories[index];
                    return Category_Button(
                      text: doc['name'],
                      adminId: widget.selectedCollege,
                      categoryId: doc.id,
                    );
                  },
                );
              },
            ),
          ),
          AddButton(
            text: 'Add New Category',
            onTap: () {
              Get.to(AddNewCategory(selectedCollege: widget.selectedCollege));
            },
          ),
        ],
      ),
    );
  }
}

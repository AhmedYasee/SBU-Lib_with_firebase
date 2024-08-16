import 'package:flutter/material.dart';
import 'package:fluttertest/Screens/NavBar.dart';
import 'package:fluttertest/Screens/categorieslistuser.dart';
import 'package:fluttertest/component/my_textfield2.dart';
import 'package:fluttertest/component/Colleges_Button.dart';
import 'package:get/route_manager.dart';

class CollegesList extends StatefulWidget {
  const CollegesList({super.key});

  @override
  _CollegesListState createState() => _CollegesListState();
}

class _CollegesListState extends State<CollegesList> {
  final TextEditingController _searchController = TextEditingController();
  final ValueNotifier<List<String>> _filteredCollegesNotifier =
      ValueNotifier([]);
  final List<String> _allColleges = [
    'Faculty of Engineering at Shoubra',
    'Faculty of Engineering at Benha',
    'Faculty of Medicine',
    'Faculty of Commerce and Business Administration',
    'Faculty of Law',
    'Faculty of Pharmacy',
    'Faculty of Agriculture',
    'Faculty of Education',
    'Faculty of Arts',
    'Faculty of Computers and Information',
    'Faculty of Science',
    'Faculty of Applied Arts',
    'Faculty of Special Education',
    'Faculty of Physical Education',
    'Faculty of Veterinary Medicine',
    'Faculty of Nursing',
    'Faculty of Physiotherapy'
  ];

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_filterColleges);
    _filteredCollegesNotifier.value = _allColleges;
  }

  void _filterColleges() {
    String query = _searchController.text.toLowerCase();
    _filteredCollegesNotifier.value = _allColleges.where((college) {
      return college.toLowerCase().startsWith(query);
    }).toList();
  }

  @override
  void dispose() {
    _searchController.dispose();
    _filteredCollegesNotifier.dispose();
    super.dispose();
  }

  void _navigateToCategoriesList(String collegeName) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => CategoriesListUser(
          selectedCollege: collegeName,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Colleges List",
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
            text: 'Search your college',
            icon: Icons.search,
            obscure: false,
            val: 'not valid!',
            controller: _searchController,
          ),
          Expanded(
            child: ValueListenableBuilder<List<String>>(
              valueListenable: _filteredCollegesNotifier,
              builder: (context, filteredColleges, child) {
                return ListView.builder(
                  itemCount: filteredColleges.length,
                  itemBuilder: (context, index) {
                    return Colleges_Button(
                      text: filteredColleges[index],
                      onTap: () =>
                          _navigateToCategoriesList(filteredColleges[index]),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

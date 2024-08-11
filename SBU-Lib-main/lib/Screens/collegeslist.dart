import 'package:flutter/material.dart';
import 'package:fluttertest/Screens/NavBar.dart';
import 'package:fluttertest/component/my_textfield2.dart';
import 'package:fluttertest/component/Colleges_Button.dart';

class CollegesList extends StatefulWidget {
  const CollegesList({super.key});

  @override
  _CollegesListState createState() => _CollegesListState();
}

class _CollegesListState extends State<CollegesList> {
  TextEditingController _searchController = TextEditingController();
  ValueNotifier<List<String>> _filteredCollegesNotifier = ValueNotifier([]);
  List<String> _allColleges = [
    'Faculty of Engineering \nShoubra Branch',
    'Faculty of medicine',
    'Faculty of Commerce and \nBusiness Administration',
    'Faculty of Law',
    'Faculty of Pharmacy',
    'Faculty of Agriculture',
    'Faculty of Education',
    'Faculty of Arts',
    'Faculty of Computers \nand Information',
    'Faculty of Science',
    'Faculty of Applied \nArts',
    'Faculty of Special \nEducation',
    'Faculty of Physical \nEducation',
    'Faculty of Veterinary \nMedicine',
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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

// ignore_for_file: file_names

import 'package:flutter/material.dart';

class MyDropdownList extends StatefulWidget {
  final ValueChanged<String?> onChanged;

  const MyDropdownList({
    super.key,
    required this.onChanged,
  });

  @override
  // ignore: library_private_types_in_public_api
  _MyDropdownListState createState() => _MyDropdownListState();
}

class _MyDropdownListState extends State<MyDropdownList> {
  String? _selectedItem;
  final Map<String, IconData> collegeIcons = {
    'Faculty of Engineering': Icons.engineering,
    'Faculty of Commerce and Business Administration': Icons.business,
    'Faculty of Law': Icons.gavel,
    'Faculty of Medicine': Icons.local_hospital,
    'Faculty of Pharmacy': Icons.local_pharmacy,
    'Faculty of Agriculture': Icons.agriculture,
    'Faculty of Education': Icons.school,
    'Faculty of Arts': Icons.palette,
    'Faculty of Engineering at Shoubra': Icons.engineering,
    'Faculty of Computers and Information': Icons.computer,
    'Faculty of Science': Icons.science,
    'Faculty of Applied Arts': Icons.color_lens,
    'Faculty of Special Education': Icons.school,
    'Faculty of Physical Education': Icons.directions_run,
    'Faculty of Veterinary Medicine': Icons.pets,
    'Faculty of Nursing': Icons.local_hospital,
    'Faculty of Physiotherapy': Icons.accessibility,
    // Add more colleges as needed
  };

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: PopupMenuButton<String>(
        onSelected: (String value) {
          setState(() {
            _selectedItem = value;
          });
          widget.onChanged(value);
        },
        itemBuilder: (BuildContext context) {
          return collegeIcons.keys.map((String college) {
            return PopupMenuItem<String>(
              value: college,
              height: 50, // Adjust the height of the menu item
              child: Row(
                children: [
                  IconTheme(
                    data: const IconThemeData(
                        size: 24), // Adjust the size of the icon
                    child: Icon(collegeIcons[college]),
                  ),
                  const SizedBox(width: 8),
                  Flexible(
                    child: Text(
                      college,
                      overflow: TextOverflow.ellipsis,
                      style:
                          const TextStyle(fontSize: 16), // Adjust the font size
                    ),
                  ),
                ],
              ),
            );
          }).toList();
        },
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
          height: 64, // Adjust the height of the container
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.black),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Icon(
                Icons.school,
                color: Color(0xff2c53b7),
              ), // Prefix icon
              const SizedBox(width: 5), // Spacer
              Expanded(
                child: Text(
                  style: const TextStyle(
                      fontSize: 17, color: Color.fromARGB(255, 67, 67, 67)),
                  _selectedItem ?? ' Select College',
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const Icon(Icons.arrow_drop_up),
            ],
          ),
        ),
      ),
    );
  }
}

class MyDropdownListContainer extends StatelessWidget {
  final ValueChanged<String?> onChanged;

  const MyDropdownListContainer({
    super.key,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return PopupMenuTheme(
      data: const PopupMenuThemeData(
          color: Colors.blue), // Set background color to white
      child: MyDropdownList(onChanged: onChanged),
    );
  }
}

import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertest/Screens/NavBar.dart';
import 'package:get/route_manager.dart';
import 'package:image_picker/image_picker.dart';
import 'package:fluttertest/Screens/NavBar.dart';

class AddBook extends StatefulWidget {
  const AddBook({super.key});

  @override
  State<AddBook> createState() => _AddBookState();
}

class _AddBookState extends State<AddBook> {
  bool st1 = false;
  bool st2 = false;
  bool st3 = false;
  String? type;
  final ImagePicker _picker = ImagePicker();
  File? _imageFile;

  TextEditingController title = TextEditingController();
  TextEditingController discription = TextEditingController();
  CollectionReference books = FirebaseFirestore.instance.collection('books');

      Future<void> addUser() {
      // Call the user's CollectionReference to add a new user
      return books
          .add({
              'title' : title.text ,
              'discription': discription.text
          })
          .then((value) => print("books Added"))
          .catchError((error) => print("Failed to add books: $error"));
    }

  Future<void> pickImage() async {
    final XFile? pickedImage =
        await _picker.pickImage(source: ImageSource.gallery);
    if (pickedImage != null) {
      setState(() {
        _imageFile = File(pickedImage.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: const Text(
            "Add/Edit book in list",
            style: TextStyle(
              fontWeight: FontWeight.w700,
              color: Color.fromARGB(255, 0, 0, 0),
            ),
            
          ),
          backgroundColor: Colors.white,
          centerTitle: true,
        ),
        drawer: const NavBar(),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            child: Column(
              children: [
                const SizedBox(height: 0.5),

                const Text(
                  "Artificial Intelligence",
                  style: TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                    color: Color.fromARGB(255, 0, 0, 0),
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.all(10),
                ),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(
                        color: const Color.fromARGB(255, 168, 165, 165)),
                    borderRadius: BorderRadius.circular(8.0),
                    boxShadow: const [
                      BoxShadow(
                        color: Color.fromARGB(255, 154, 154, 154),
                        spreadRadius: 1,
                        blurRadius: 7,
                      ),
                    ],
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: [
                        const Text(
                          'Title',
                          style: TextStyle(
                            fontSize: 20.0,
                            color: Color(0xff2c53b7),
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        TextField(
                          controller : title,
                          decoration: InputDecoration(
                            fillColor: Colors.grey[200],
                            filled: true,
                          ),
                          
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 20.0), //one

                const Padding(
                  padding: EdgeInsets.all(10),
                ),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(
                        color: const Color.fromARGB(255, 168, 165, 165)),
                    borderRadius: BorderRadius.circular(8.0),
                    boxShadow: const [
                      BoxShadow(
                        color: Color.fromARGB(255, 154, 154, 154),
                        spreadRadius: 1,
                        blurRadius: 7,
                      ),
                    ],
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: [
                        const Text(
                          'Description',
                          style: TextStyle(
                            fontSize: 20.0,
                            color: Color(0xff2c53b7),
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        TextField(
                           controller : discription,
                          decoration: InputDecoration(
                            fillColor: Colors.grey[200],
                            filled: true,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 20.0), //twoo
                const Padding(
                  padding: EdgeInsets.all(10),
                ),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(
                        color: const Color.fromARGB(255, 168, 165, 165)),
                    borderRadius: BorderRadius.circular(8.0),
                    boxShadow: const [
                      BoxShadow(
                        color: Color.fromARGB(255, 154, 154, 154),
                        spreadRadius: 1,
                        blurRadius: 7,
                      ),
                    ],
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: [
                        const Text(
                          'Choose the type please',
                          style: TextStyle(
                            fontSize: 20.0,
                            color: Color(0xff2c53b7),
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        RadioListTile(
                            activeColor: const Color.fromARGB(255, 16, 42, 108),
                            title: const Text("Book"),
                            value: "Book",
                            groupValue: type,
                            onChanged: (val) {
                              setState(() {
                                type = val!;
                              });
                            }),
                        RadioListTile(
                            activeColor: const Color.fromARGB(255, 16, 42, 108),
                            title: const Text("Paper"),
                            groupValue: type,
                            value: "Paper",
                            onChanged: (val) {
                              setState(() {
                                type = val!;
                              });
                            }),
                        RadioListTile(
                            activeColor: const Color.fromARGB(255, 16, 42, 108),
                            title: const Text("Reference"),
                            groupValue: type,
                            value: "Reference",
                            onChanged: (val) {
                              setState(() {
                                type = val!;
                              });
                            })
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 20.0),
                const Padding(
                  padding: EdgeInsets.all(10),
                ),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(
                        color: const Color.fromARGB(255, 168, 165, 165)),
                    borderRadius: BorderRadius.circular(8.0),
                    boxShadow: const [
                      BoxShadow(
                        color: Color.fromARGB(255, 154, 154, 154),
                        spreadRadius: 1,
                        blurRadius: 7,
                      ),
                    ],
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: [
                        const Text(
                          'Upload the poster',
                          style: TextStyle(
                            fontSize: 20.0,
                            color: Color(0xff2c53b7),
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        _imageFile == null
                            ? const Text('No image selected')
                            : Image.file(_imageFile!),
                        IconButton(
                          icon: const Icon(
                            Icons.photo_size_select_actual_rounded,
                            color: Color.fromARGB(255, 16, 42, 108),
                          ), // Use your desired icon
                          onPressed: pickImage,
                        ),
                      ],
                    ),
                  ),
                ),
                //twoo
                const Padding(
                  padding: EdgeInsets.all(10),
                ),
                TextButton(
                    onPressed: () {
                      addUser();
                      Get.back();
                    },
                    child: const Row(
                        mainAxisSize:
                            MainAxisSize.min, // Size the row to fit content
                        children: [
                          Text(
                            'Add',
                            style: TextStyle(
                                fontSize: 30.0, color: Color(0xff2c53b7)),
                          ),
                          SizedBox(
                              width:
                                  7), // Add some spacing between icon and text
                          Icon(Icons.add_link_rounded,
                              color: Color(0xff2c53b7)),
                        ]),
                    style: OutlinedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(
                            15.0), // Set border radius for circle
                      ),
                      side: const BorderSide(
                        color: Color(0xff2c53b7), // Customize border color
                        width: 2.0,
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 40.0),

                      // Customize border width
                    ))
              ],
            ),
          ),
        ),
      ),
    );
  }
}

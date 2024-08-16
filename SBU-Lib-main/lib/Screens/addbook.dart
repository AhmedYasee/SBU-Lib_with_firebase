import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:fluttertest/Screens/NavBar.dart';
import 'package:get/route_manager.dart';
import 'package:image_picker/image_picker.dart';

class AddBook extends StatefulWidget {
  final String adminId;
  final String categoryId;

  const AddBook({
    Key? key,
    required this.adminId,
    required this.categoryId,
  }) : super(key: key);

  @override
  _AddBookState createState() => _AddBookState();
}

class _AddBookState extends State<AddBook> {
  bool st1 = false;
  bool st2 = false;
  bool st3 = false;
  String? type;
  final ImagePicker _picker = ImagePicker();
  File? _imageFile;
  String? imageUrl; // To store the image URL

  TextEditingController title = TextEditingController();
  TextEditingController description = TextEditingController();

  Future<void> pickImage() async {
    final XFile? pickedImage =
        await _picker.pickImage(source: ImageSource.gallery);
    if (pickedImage != null) {
      setState(() {
        _imageFile = File(pickedImage.path);
      });
    }
  }

  Future<void> addBook() async {
    CollectionReference books = FirebaseFirestore.instance
        .collection('colleges')
        .doc(widget.adminId)
        .collection('categories')
        .doc(widget.categoryId)
        .collection('books');

    if (_imageFile != null) {
      // Upload the image to Firebase Storage
      final Reference storageReference = FirebaseStorage.instance
          .ref()
          .child('book_images/${DateTime.now().millisecondsSinceEpoch}.jpeg');
      final metadata = SettableMetadata(
        contentType: 'image/jpeg',
        customMetadata: {'uploaded_by': 'your_app_name'},
      );
      UploadTask uploadTask = storageReference.putFile(_imageFile!, metadata);
      await uploadTask.whenComplete(() async {
        // Get the download URL
        imageUrl = await storageReference.getDownloadURL();
        // Add the book data to Firestore
        await books
            .add({
              'title': title.text,
              'description': description.text,
              'type': type,
              'imageUrl': imageUrl, // Add image URL to the data
            })
            .then((value) => print("Book Added"))
            .catchError((error) => print("Failed to add book: $error"));
      });
    } else {
      // Add the book data to Firestore without image
      await books
          .add({
            'title': title.text,
            'description': description.text,
            'type': type,
          })
          .then((value) => print("Book Added"))
          .catchError((error) => print("Failed to add book: $error"));
    }
    Get.back();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: const Text(
            "Add Book to List",
            style: TextStyle(
              fontWeight: FontWeight.w700,
              color: Color.fromARGB(255, 0, 0, 0),
            ),
          ),
          backgroundColor: Colors.white,
          centerTitle: true,
        ),
        drawer: const NavBar(), // Replace with your actual NavBar widget
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            child: Column(
              children: [
                const SizedBox(height: 0.5),
                const Text(
                  "New Addition",
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
                          controller: title,
                          decoration: InputDecoration(
                            fillColor: Colors.grey[200],
                            filled: true,
                          ),
                        ),
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
                          'Description',
                          style: TextStyle(
                            fontSize: 20.0,
                            color: Color(0xff2c53b7),
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        TextField(
                          controller: description,
                          decoration: InputDecoration(
                            fillColor: Colors.grey[200],
                            filled: true,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 20.0),
                Container(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Checkbox(
                            value: st1,
                            onChanged: (bool? value) {
                              setState(() {
                                type = 'reference';
                                st1 = value!;
                                st2 = false;
                                st3 = false;
                              });
                            },
                          ),
                          const Text(
                            'Reference',
                            style: TextStyle(
                              fontSize: 18.0,
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Checkbox(
                            value: st2,
                            onChanged: (bool? value) {
                              setState(() {
                                type = 'paper';
                                st2 = value!;
                                st1 = false;
                                st3 = false;
                              });
                            },
                          ),
                          const Text(
                            'Paper',
                            style: TextStyle(
                              fontSize: 18.0,
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Checkbox(
                            value: st3,
                            onChanged: (bool? value) {
                              setState(() {
                                type = 'book';
                                st3 = value!;
                                st1 = false;
                                st2 = false;
                              });
                            },
                          ),
                          const Text(
                            'Book',
                            style: TextStyle(
                              fontSize: 18.0,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20.0),
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
                            ? Center(
                                child: IconButton(
                                  icon: Icon(Icons.add_a_photo),
                                  onPressed: pickImage,
                                ),
                              )
                            : Image.file(
                                _imageFile!,
                                fit: BoxFit.cover,
                              ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 20.0),
                ElevatedButton(
                  onPressed: addBook,
                  style: OutlinedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15.0),
                    ),
                    side: const BorderSide(
                      color: Color(0xff2c53b7),
                      width: 2.0,
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 40.0),
                  ),
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'Add Book',
                        style:
                            TextStyle(fontSize: 30.0, color: Color(0xff2c53b7)),
                      ),
                      SizedBox(width: 7),
                      Icon(Icons.add, color: Color(0xff2c53b7)),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

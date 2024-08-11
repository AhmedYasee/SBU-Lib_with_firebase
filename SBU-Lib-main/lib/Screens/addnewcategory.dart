import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertest/Screens/categorieslist.dart';
import 'package:fluttertest/Screens/who_are_you.dart';
import 'package:fluttertest/component/my_textfield.dart';
import 'package:fluttertest/component/sumbit.dart';
import 'package:get/get.dart';

class AddNewCategory extends StatelessWidget {
  final String selectedCollege;

  const AddNewCategory({super.key, required this.selectedCollege});

  @override
  Widget build(BuildContext context) {
    TextEditingController name = TextEditingController();
    CollectionReference categories = FirebaseFirestore.instance
        .collection('colleges')
        .doc(selectedCollege)
        .collection('categories');

    Future<void> addCategory() {
      return categories
          .add({'name': name.text})
          .then((value) => print("Category Added"))
          .catchError((error) => print("Failed to add category: $error"));
    }

    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: const Text(
            "Add new Category",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          backgroundColor: Colors.white,
          centerTitle: true,
        ),
        body: SingleChildScrollView(
            child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
              const MyImage(
                photo: 'assets/images/Person writing credentials.json',
              ),
              Container(
                  margin: const EdgeInsets.all(8),
                  width: 400,
                  height: 170,
                  decoration: BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                        offset: const Offset(0, 1),
                        blurRadius: 5,
                        color: Colors.black.withOpacity(0.3),
                      ),
                    ],
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        const Text(
                          'Title',
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 26,
                              fontWeight: FontWeight.w500),
                        ),
                        MyTextField(
                          icon: Icons.category,
                          text: 'Add Category',
                          val: 'Add New Category',
                          mycontroller: name,
                          validator: (val) {
                            if (val == "") {
                              return "Required field ";
                            }
                          },
                        ),
                      ])),
              SubmitButton(
                onTap: () {
                  addCategory();
                  Get.back();
                },
              ),
            ])));
  }
}

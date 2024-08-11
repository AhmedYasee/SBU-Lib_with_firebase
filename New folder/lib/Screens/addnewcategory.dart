import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertest/Screens/NavBar.dart';
import 'package:fluttertest/Screens/categorieslist.dart';
import 'package:fluttertest/Screens/who_are_you.dart';
import 'package:fluttertest/component/my_textfield.dart';
import 'package:fluttertest/component/sumbit.dart';
import 'package:get/get.dart';
import 'package:fluttertest/component/my_textfield2.dart';
import 'package:fluttertest/Screens/NavBar.dart';


class AddNewCategory extends StatelessWidget {
  const AddNewCategory({super.key});

  @override
  Widget build(BuildContext context) {
    //var text = Text as String;
    
    TextEditingController name = TextEditingController();
     CollectionReference categories = FirebaseFirestore.instance.collection('categories');

      Future<void> addUser() {
      // Call the user's CollectionReference to add a new user
      return categories
          .add({
              'name' : name.text 
          })
          .then((value) => print("category Added"))
          .catchError((error) => print("Failed to add category: $error"));
    }
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
         // leading: IconButton(
          //    onPressed: () {
          //      Navigator.push(context,
          //          MaterialPageRoute(builder: (context) => const WHoAreYou()));
          //    },
           //   icon: const Icon(Icons.list)),
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
        drawer: const NavBar(),
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
                        Text(
                          'Tiltle',
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
                   addUser();
                  // Navigate back to the previous page
                   Get.back();
                },
              ),
            ])));
  }
}

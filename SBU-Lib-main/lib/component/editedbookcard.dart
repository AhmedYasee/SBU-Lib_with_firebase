import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertest/Screens/EditBook.dart';
import 'package:get/get.dart';
import 'package:firebase_storage/firebase_storage.dart';

class EditedBookCard extends StatelessWidget {
  final String name;
  final String docId;
  final String adminId;
  final String categoryId;
  final VoidCallback onTap;

  const EditedBookCard({
    Key? key,
    required this.name,
    required this.docId,
    required this.adminId,
    required this.categoryId,
    required this.onTap,
  }) : super(key: key);

  Future<void> _deleteBook(BuildContext context) async {
    try {
      // Reference to the Firestore document
      final docRef = FirebaseFirestore.instance
          .collection('colleges')
          .doc(adminId)
          .collection('categories')
          .doc(categoryId)
          .collection('books')
          .doc(docId);

      // Fetch the document
      DocumentSnapshot doc = await docRef.get();

      // Check if the document exists
      if (!doc.exists) {
        Get.snackbar(
          'Book not found',
          'The book you are trying to delete does not exist.',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
        return;
      }

      // Get the document data and handle null values
      final data = doc.data() as Map<String, dynamic>?;

      // Get the image URL from the document data
      String? imageUrl = data?['imageUrl'] as String?;

      // Delete the book document from Firestore
      await docRef.delete();

      // Delete the image from Firebase Storage if it exists
      if (imageUrl != null && imageUrl.isNotEmpty) {
        try {
          await FirebaseStorage.instance.refFromURL(imageUrl).delete();
        } catch (e) {
          // Handle errors related to image deletion
          print("Failed to delete image: $e");
          Get.snackbar(
            'Image deletion failed',
            'The book was deleted, but there was an issue deleting the image.',
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.orange,
            colorText: Colors.white,
          );
        }
      }

      Get.snackbar(
        'Book deleted successfully',
        '',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: const Color(0xff2c53b7), // Blue
        colorText: Colors.white,
      );
    } catch (e) {
      print("Failed to delete book: $e");
      Get.snackbar(
        'Failed to delete book',
        'An error occurred while deleting the book.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  void _showDeleteDialog(BuildContext context) {
    AwesomeDialog(
      context: context,
      dialogType: DialogType.question,
      animType: AnimType.rightSlide,
      title: 'Delete Book',
      desc: 'Are you sure you want to delete this book?',
      btnCancel: ElevatedButton(
        onPressed: () {
          Navigator.of(context).pop(); // Close the dialog
        },
        child: Text('Cancel'),
      ),
      btnOk: ElevatedButton(
        onPressed: () async {
          Navigator.of(context).pop(); // Close the dialog
          await _deleteBook(context);
        },
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all(
            const Color.fromARGB(240, 240, 5, 5),
          ),
        ),
        child: const Padding(
          padding: EdgeInsets.all(4),
          child: Row(
            children: [
              Text(
                'Delete',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 15,
                ),
              )
            ],
          ),
        ),
      ),
    ).show();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      shadowColor: Colors.black,
      color: Colors.white,
      child: SizedBox(
        width: 400,
        height: 170,
        child: Padding(
          padding: const EdgeInsets.all(30),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    name,
                    style: const TextStyle(
                      color: Colors.black,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Icon(
                    Icons.announcement_outlined,
                    size: 24,
                  )
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => EditBook(
                            docid: docId,
                            adminId: adminId,
                            categoryId: categoryId,
                          ),
                        ),
                      );
                    },
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(
                        const Color(0xff2c53b7),
                      ),
                    ),
                    child: const Padding(
                      padding: EdgeInsets.all(2),
                      child: Row(
                        children: [
                          Text(
                            'Edit',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 15,
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      _showDeleteDialog(context);
                    },
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(
                        const Color.fromARGB(240, 240, 5, 5),
                      ),
                    ),
                    child: const Padding(
                      padding: EdgeInsets.all(4),
                      child: Row(
                        children: [
                          Text(
                            'Delete',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 15,
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}

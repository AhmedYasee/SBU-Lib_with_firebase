import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertest/Screens/EditBook.dart';
import 'package:get/get.dart';
import 'package:firebase_storage/firebase_storage.dart';

class EditedBookCard extends StatelessWidget {
  final String name;
  final String docId;
  final VoidCallback onTap;

  const EditedBookCard({
    Key? key,
    required this.name,
    required this.docId,
    required this.onTap,
  }) : super(key: key);

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
                            docid:
                                docId, // Pass the docId to the EditBook screen
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
                      AwesomeDialog(
                        context: context,
                        dialogType: DialogType.question,
                        animType: AnimType.rightSlide,
                        title: 'Delete Book',
                        desc: 'Are you sure you want to delete this book?',
                        btnCancel: ElevatedButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: Text('Cancel'),
                        ),
                        btnOk: ElevatedButton(
                          onPressed: () async {
                            // Get the image URL from Firestore (assuming it's stored in a field called 'imageUrl')
                            DocumentSnapshot doc = await FirebaseFirestore
                                .instance
                                .collection("books")
                                .doc(docId)
                                .get();
                            String? imageUrl = doc.get('imageUrl');

                            // Delete the book document from Firestore
                            await FirebaseFirestore.instance
                                .collection("books")
                                .doc(docId)
                                .delete();

                            // Delete the image from Firebase Storage
                            if (imageUrl != null) {
                              await FirebaseStorage.instance
                                  .refFromURL(imageUrl)
                                  .delete();
                            }

                            Navigator.pop(context); // Close the AwesomeDialog

                            // Show a snackbar using Get
                            Get.snackbar(
                              'Book deleted successfully',
                              '',
                              snackPosition: SnackPosition.BOTTOM,
                              backgroundColor: const Color(
                                  0xff2c53b7), // Change the color to blue
                              colorText: Colors
                                  .white, // Change the text color to white
                            );
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

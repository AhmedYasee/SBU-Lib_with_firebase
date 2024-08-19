import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertest/Screens/booklistadmin.dart';
import 'package:fluttertest/component/textcontainer.dart';
import 'package:awesome_dialog/awesome_dialog.dart';

class Category_Button extends StatelessWidget {
  const Category_Button({
    super.key,
    required this.text,
    required this.adminId,
    required this.categoryId,
  });

  final String text;
  final String adminId;
  final String categoryId;

  // Fetch the count of documents in a specific Firestore collection
  Future<int> _getCollectionCount(String collectionPath) async {
    final firestore = FirebaseFirestore.instance;
    final querySnapshot = await firestore.collection(collectionPath).get();

    // Debugging: Print document IDs to ensure correct counting
    for (var doc in querySnapshot.docs) {
      print('Document ID: ${doc.id}');
    }

    return querySnapshot.docs.length;
  }

  // Fetch counts for books, refs, and papers collections
  Future<Map<String, int>> _fetchCounts() async {
    final booksCount = await _getCollectionCount('books');
    final refsCount = await _getCollectionCount('refs');
    final papersCount = await _getCollectionCount('papers');

    return {
      'books': booksCount,
      'refs': refsCount,
      'papers': papersCount,
    };
  }

  // Function to delete the category and its subcategories
  Future<void> _deleteCategory(BuildContext context) async {
    try {
      final firestore = FirebaseFirestore.instance;

      // Delete all subcollections under the category
      var collections = ['books', 'refs', 'papers'];
      for (var collection in collections) {
        var collectionRef = firestore
            .collection('colleges')
            .doc(adminId)
            .collection('categories')
            .doc(categoryId)
            .collection(collection);

        var snapshots = await collectionRef.get();
        for (var doc in snapshots.docs) {
          await doc.reference.delete();
        }
      }

      // Delete the category itself
      await firestore
          .collection('colleges')
          .doc(adminId)
          .collection('categories')
          .doc(categoryId)
          .delete();

      Navigator.of(context).pop(); // Close the dialog
    } catch (e) {
      print('Error deleting category: $e');
    }
  }

  void _showDeleteDialog(BuildContext context) {
    AwesomeDialog(
      context: context,
      dialogType: DialogType.question,
      animType: AnimType.rightSlide,
      title: 'Delete Category',
      desc:
          'Are you sure you want to delete this category and all its subcategories?',
      btnCancel: ElevatedButton(
        onPressed: () {
          Navigator.of(context).pop(); // Close the dialog
        },
        child: const Text('Cancel'),
      ),
      btnOk: ElevatedButton(
        onPressed: () async {
          await _deleteCategory(context);
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
    return FutureBuilder<Map<String, int>>(
      future: _fetchCounts(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }

        final counts = snapshot.data ?? {};

        return GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => BooksListAdmin(
                  categoryId: categoryId,
                  adminId: adminId,
                ),
              ),
            );
          },
          child: Container(
            margin: const EdgeInsets.all(8),
            width: double.infinity,
            height: 150,
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
            child: Stack(
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Text(
                          text,
                          style: const TextStyle(
                            color: Colors.black,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const Icon(
                          Icons.announcement_outlined,
                          size: 24,
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        TextContainer(
                          text: "REF (${counts['refs'] ?? 0})",
                          icon: Icons.adjust,
                        ),
                        TextContainer(
                          text: "PAPERS (${counts['papers'] ?? 0})",
                          icon: Icons.mode_night,
                        ),
                        TextContainer(
                          text: "BOOKS (${counts['books'] ?? 0})",
                        ),
                      ],
                    ),
                  ],
                ),
                Positioned(
                  top: 10,
                  right: 10,
                  child: IconButton(
                    icon: const Icon(Icons.delete, color: Colors.red),
                    onPressed: () {
                      _showDeleteDialog(context);
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

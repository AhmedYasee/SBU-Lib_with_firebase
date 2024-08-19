import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertest/Screens/booklistadmin.dart';
import 'package:fluttertest/component/textcontainer.dart';

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
            child: Column(
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
          ),
        );
      },
    );
  }
}

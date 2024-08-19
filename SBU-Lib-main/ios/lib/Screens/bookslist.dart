import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fluttertest/component/bookcard.dart';
import 'package:fluttertest/component/my_textfield2.dart';

class BooksList extends StatefulWidget {
  final String adminId; // College name
  final String categoryId; // Category ID

  const BooksList({
    Key? key,
    required this.adminId,
    required this.categoryId,
  }) : super(key: key);

  @override
  _BooksListState createState() => _BooksListState();
}

class _BooksListState extends State<BooksList> {
  TextEditingController _searchController = TextEditingController();
  ValueNotifier<List<DocumentSnapshot>> _filteredBooksNotifier =
  ValueNotifier([]);
  List<DocumentSnapshot> _allBooks = [];

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_filterBooks);
    _fetchBooks();
  }

  void _fetchBooks() {
    FirebaseFirestore.instance
        .collection('colleges')
        .doc(widget.adminId)
        .collection('categories')
        .doc(widget.categoryId)
        .collection('books')
        .get()
        .then((snapshot) {
      _allBooks = snapshot.docs;
      _filterBooks(); // Apply filtering after data is fetched
    });
  }

  void _filterBooks() {
    String query = _searchController.text.toLowerCase();
    _filteredBooksNotifier.value = _allBooks.where((book) {
      final bookData = book.data() as Map<String, dynamic>;
      final bookName = bookData['title'] as String;
      return bookName.toLowerCase().contains(query);
    }).toList();
  }

  @override
  void dispose() {
    _searchController.dispose();
    _filteredBooksNotifier.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100], // Background color for a lighter feel
      appBar: AppBar(

        title: const Text(
          "Books List",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0, // Flat look for the AppBar
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            MyTextField2(
              text: "Search your book",
              icon: Icons.search,
              obscure: false,
              val: 'not valid!',
              controller: _searchController,
            ),
            const SizedBox(height: 20), // Space between search field and list
            Expanded(
              child: ValueListenableBuilder<List<DocumentSnapshot>>(
                valueListenable: _filteredBooksNotifier,
                builder: (context, filteredBooks, child) {
                  if (filteredBooks.isEmpty) {
                    return Center(
                      child: Text(
                        "No books found.",
                        style: TextStyle(fontSize: 18, color: Colors.grey[600]),
                      ),
                    );
                  }
                  return ListView.separated(
                    separatorBuilder: (context, index) => Divider(
                      color: Colors.grey[300],
                      thickness: 1,
                    ),
                    itemCount: filteredBooks.length,
                    itemBuilder: (context, index) {
                      var doc = filteredBooks[index];
                      return BookCard(
                        bookId: doc.id,
                        adminId: widget.adminId,
                        categoryId: widget.categoryId,
                        name: doc['title'], // Assuming 'title' is the field in the document
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

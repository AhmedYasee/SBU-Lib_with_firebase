import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class BooksDetails extends StatefulWidget {
  final String bookId;
  final String adminId;
  final String categoryId;

  const BooksDetails({
    Key? key,
    required this.bookId,
    required this.adminId,
    required this.categoryId,
  }) : super(key: key);

  @override
  _BooksDetailsState createState() => _BooksDetailsState();
}

class _BooksDetailsState extends State<BooksDetails> {
  Map<String, dynamic>? bookData;

  @override
  void initState() {
    super.initState();
    _fetchBookDetails();
  }

  void _fetchBookDetails() async {
    DocumentSnapshot doc = await FirebaseFirestore.instance
        .collection('colleges')
        .doc(widget.adminId)
        .collection('categories')
        .doc(widget.categoryId)
        .collection('books')
        .doc(widget.bookId)
        .get();

    setState(() {
      bookData = doc.data() as Map<String, dynamic>?;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          "Book Details",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        backgroundColor: Colors.blueAccent,
        centerTitle: true,
        elevation: 0,
      ),
      body: bookData == null
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: const Row(
                      children: [
                        Icon(
                          Icons.arrow_back_ios_new_outlined,
                          size: 24,
                          color: Colors.blueAccent,
                        ),
                        Text(
                          "   Back",
                          style:
                              TextStyle(fontSize: 20, color: Colors.blueAccent),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Book Cover
                      Container(
                        width: 150,
                        height: 200,
                        margin: const EdgeInsets.only(right: 16.0),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.5),
                              spreadRadius: 2,
                              blurRadius: 7,
                              offset: const Offset(0, 3),
                            ),
                          ],
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Image.network(
                            bookData!['imageUrl'] ??
                                'https://via.placeholder.com/150',
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) =>
                                Image.asset('assets/placeholder.png'),
                          ),
                        ),
                      ),
                      // Book Details
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              bookData!['title'] ?? 'No Title',
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 24,
                                color: Colors.black87,
                              ),
                            ),
                            const SizedBox(height: 8),
                            // Placeholder for Rating Stars
                            Row(
                              children: List.generate(5, (index) {
                                return Icon(
                                  Icons.star,
                                  color: index < (bookData?['rating'] ?? 0)
                                      ? Colors.yellow
                                      : Colors.grey,
                                  size: 20,
                                );
                              }),
                            ),
                            const SizedBox(height: 16),
                            Text(
                              'Description',
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                                color: Colors.black87,
                              ),
                            ),
                            const Divider(thickness: 2),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 8.0),
                              child: Text(
                                bookData!['description'] ??
                                    'No Description Available',
                                style: const TextStyle(fontSize: 16),
                                maxLines: 5,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const Spacer(),
                  // Borrow This Book Button
                  Center(
                    child: ElevatedButton.icon(
                      onPressed: () {
                        // Button action here
                      },
                      icon: const Icon(Icons.bookmark_add_outlined),
                      label: const Text('Borrow This Book'),
                      style: ElevatedButton.styleFrom(
                        foregroundColor: Colors.white,
                        backgroundColor: Colors.blueAccent,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 24.0,
                          vertical: 12.0,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        elevation: 5,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                ],
              ),
            ),
    );
  }
}

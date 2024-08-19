import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:fluttertest/Screens/booksdetails.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class BookCard extends StatefulWidget {
  final String bookId;
  final String adminId;
  final String categoryId;
  final String name;

  const BookCard({
    required this.bookId,
    required this.adminId,
    required this.categoryId,
    required this.name,
    super.key,
  });

  @override
  _BookCardState createState() => _BookCardState();
}

class _BookCardState extends State<BookCard> {
  String? imageUrl;

  @override
  void initState() {
    super.initState();
    _fetchBookImage();
  }

  void _fetchBookImage() async {
    DocumentSnapshot doc = await FirebaseFirestore.instance
        .collection('colleges')
        .doc(widget.adminId)
        .collection('categories')
        .doc(widget.categoryId)
        .collection('books')
        .doc(widget.bookId)
        .get();

    setState(() {
      imageUrl = (doc.data() as Map<String, dynamic>)['imageUrl'];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      shadowColor: Colors.black,
      color: Colors.white,
      child: SizedBox(
        width: 400,
        height: 150,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              // Book Image
              Container(
                width: 70,
                height: 100,
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
                  child: imageUrl != null
                      ? Image.network(
                    imageUrl!,
                    fit: BoxFit.cover,
                  )
                      : Image.asset('assets/placeholder.png'),
                ),
              ),
              // Book Name and Rating
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      widget.name,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: Color(0xff2c53b7),
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    RatingBar.builder(
                      initialRating: 3,
                      minRating: 1,
                      direction: Axis.horizontal,
                      allowHalfRating: true,
                      itemCount: 4,
                      itemSize: 20,
                      itemBuilder: (context, _) => const Icon(
                        Icons.star,
                        color: Colors.amber,
                      ),
                      onRatingUpdate: (rating) {
                        print(rating);
                      },
                    ),
                  ],
                ),
              ),
              // Details Button
              TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => BookDetails(
                        bookId: widget.bookId,
                        adminId: widget.adminId,
                        categoryId: widget.categoryId,
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
                  padding: EdgeInsets.all(4),
                  child: Text(
                    'Details',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 15,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

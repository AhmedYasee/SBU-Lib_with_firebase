import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:awesome_dialog/awesome_dialog.dart';

class BookDetails extends StatefulWidget {
  final String bookId;
  final String adminId;
  final String categoryId;

  const BookDetails({
    Key? key,
    required this.bookId,
    required this.adminId,
    required this.categoryId,
  }) : super(key: key);

  @override
  _BookDetailsState createState() => _BookDetailsState();
}

class _BookDetailsState extends State<BookDetails> {
  Future<DocumentSnapshot>? _bookDetails;

  @override
  void initState() {
    super.initState();
    _bookDetails = FirebaseFirestore.instance
        .collection('colleges')
        .doc(widget.adminId)
        .collection('categories')
        .doc(widget.categoryId)
        .collection('books')
        .doc(widget.bookId)
        .get();
  }

  void _requestBorrow() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      _showErrorDialog('User not logged in.');
      return;
    }

    try {
      final userDoc = await FirebaseFirestore.instance.collection('users').doc(user.uid).get();
      final userName = userDoc.data()?['firstname'] ?? 'Unknown User';
      final userCollege = userDoc.data()?['college'] ?? 'Unknown College';
      final userPhone = userDoc.data()?['phone_number'] ?? 'Unknown Phone Number';
      final requestDate = DateTime.now().toLocal().toString(); // Local date-time format

      final bookDoc = await FirebaseFirestore.instance
          .collection('colleges')
          .doc(widget.adminId)
          .collection('categories')
          .doc(widget.categoryId)
          .collection('books')
          .doc(widget.bookId)
          .get();
      final bookTitle = bookDoc.data()?['title'] ?? 'Unknown Title';
      final bookImage = bookDoc.data()?['imageUrl'] ?? 'https://via.placeholder.com/150';

      await FirebaseFirestore.instance
          .collection('colleges')
          .doc(widget.adminId)
          .collection('bookRequests')
          .add({
        'bookId': widget.bookId,
        'categoryId': widget.categoryId,
        'requesterId': user.uid,
        'requesterName': userName,
        'requesterCollege': userCollege,
        'requesterPhone': userPhone,
        'bookTitle': bookTitle,
        'bookImage': bookImage,
        'date': requestDate,
        'status': 'Pending',
      });

      _showSuccessDialog();
    } catch (e) {
      print('Error sending borrow request: $e');
      _showErrorDialog('Failed to send borrow request. Please try again.');
    }
  }

  void _showSuccessDialog() {
    AwesomeDialog(
      context: context,
      dialogType: DialogType.success,
      animType: AnimType.rightSlide,
      title: 'Success',
      desc: 'Borrow request sent to admin.',
      btnOkOnPress: () {},
    ).show();
  }

  void _showErrorDialog(String message) {
    AwesomeDialog(
      context: context,
      dialogType: DialogType.error,
      animType: AnimType.rightSlide,
      title: 'Error',
      desc: message,
      btnOkOnPress: () {},
    ).show();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Book Details'),
      ),
      body: FutureBuilder<DocumentSnapshot>(
        future: _bookDetails,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          if (!snapshot.hasData || !snapshot.data!.exists) {
            return const Center(child: Text('No details available.'));
          }

          final data = snapshot.data!.data() as Map<String, dynamic>;

          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 120,
                      height: 180,
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
                          data['imageUrl'] ?? 'https://via.placeholder.com/150',
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) =>
                              Image.asset('assets/placeholder.png'),
                        ),
                      ),
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            data['title'] ?? 'No Title',
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 30,
                              color: Color(0xff2c53b7),
                            ),
                          ),
                          const SizedBox(height: 8),
                          Row(
                            children: List.generate(5, (index) {
                              return Icon(
                                Icons.star,
                                color: index < (data['rating'] ?? 0)
                                    ? Colors.yellow
                                    : Colors.grey,
                                size: 20,
                              );
                            }),
                          ),
                          const SizedBox(height: 16),
                          Align(
                            alignment: Alignment.centerRight,
                            child: ElevatedButton.icon(
                              onPressed: _requestBorrow,
                              icon: const Icon(Icons.bookmark_add_outlined),
                              label: const Text('Borrow This Book'),
                              style: ElevatedButton.styleFrom(
                                foregroundColor: Colors.white,
                                backgroundColor: const Color(0xff2c53b7),
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
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16.0),
                  decoration: BoxDecoration(
                    color: Colors.blueAccent,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Description',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        data['description'] ?? 'No Description Available',
                        style: const TextStyle(fontSize: 16),
                        textAlign: TextAlign.left,
                        maxLines: null,
                        overflow: TextOverflow.visible,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

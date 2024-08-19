import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // Import the intl package

class BookRequestScreen extends StatefulWidget {
  final String adminId;

  const BookRequestScreen({Key? key, required this.adminId}) : super(key: key);

  @override
  _BookRequestScreenState createState() => _BookRequestScreenState();
}

class _BookRequestScreenState extends State<BookRequestScreen> {
  late Stream<QuerySnapshot> _bookRequestsStream;

  @override
  void initState() {
    super.initState();
    _bookRequestsStream = FirebaseFirestore.instance
        .collection('colleges')
        .doc(widget.adminId)
        .collection('bookRequests')
        .snapshots();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Book Requests'),
      ),
      body: Container(
        color: Colors.grey[200], // Greyish background color
        child: StreamBuilder<QuerySnapshot>(
          stream: _bookRequestsStream,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            }

            if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
              return const Center(child: Text('No book requests found.'));
            }

            final bookRequests = snapshot.data!.docs;

            return ListView.builder(
              itemCount: bookRequests.length,
              itemBuilder: (context, index) {
                final requestData =
                    bookRequests[index].data() as Map<String, dynamic>;
                final bookTitle = requestData['bookTitle'] ?? 'Unknown Title';
                final bookImage = requestData['bookImage'] ??
                    'https://via.placeholder.com/150';
                final requesterName =
                    requestData['requesterName'] ?? 'Unknown Name';
                final requesterPhone =
                    requestData['requesterPhone'] ?? 'Unknown Phone';
                final requesterCollege =
                    requestData['requesterCollege'] ?? 'Unknown College';
                final requestDate = requestData['date'];
                String formattedDate;

                if (requestDate is Timestamp) {
                  formattedDate =
                      DateFormat('yyyy-MM-dd').format(requestDate.toDate());
                } else if (requestDate is DateTime) {
                  formattedDate = DateFormat('yyyy-MM-dd').format(requestDate);
                } else if (requestDate is String) {
                  formattedDate =
                      requestDate; // Assume already in correct format
                } else {
                  formattedDate = 'Unknown Date';
                }

                return Card(
                  shadowColor: Colors.black,
                  color: Colors.white,
                  margin:
                      const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                  child: SizedBox(
                    height: 280, // Increased height to fit content
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Book Image
                          Container(
                            width: 110,
                            height: 150,
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
                                bookImage,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) =>
                                    Image.asset('assets/placeholder.png'),
                              ),
                            ),
                          ),
                          // Request Details
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  bookTitle,
                                  style: const TextStyle(
                                    color: Color(0xff2c53b7),
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  'Name: $requesterName',
                                  style: const TextStyle(
                                    fontSize: 16,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  'Phone: $requesterPhone',
                                  style: const TextStyle(
                                    fontSize: 16,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  'College: $requesterCollege',
                                  style: const TextStyle(
                                    fontSize: 16,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  'Date: $formattedDate',
                                  style: const TextStyle(
                                    fontSize: 16,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                // Dropdown List
                                DropdownButton<String>(
                                  value: requestData['status'],
                                  onChanged: (newValue) {
                                    if (newValue != null) {
                                      FirebaseFirestore.instance
                                          .collection('colleges')
                                          .doc(widget.adminId)
                                          .collection('bookRequests')
                                          .doc(bookRequests[index].id)
                                          .update({'status': newValue});
                                    }
                                  },
                                  items: <String>[
                                    'Pending',
                                    'Approved',
                                    'Rejected'
                                  ].map<DropdownMenuItem<String>>(
                                      (String value) {
                                    Color textColor;
                                    switch (value) {
                                      case 'Approved':
                                        textColor = Colors.green;
                                        break;
                                      case 'Rejected':
                                        textColor = Colors.red;
                                        break;
                                      default:
                                        textColor = Colors.yellow;
                                    }
                                    return DropdownMenuItem<String>(
                                      value: value,
                                      child: Text(
                                        value,
                                        style: TextStyle(
                                          color: textColor,
                                          fontSize: 16,
                                        ),
                                      ),
                                    );
                                  }).toList(),
                                  style: const TextStyle(
                                    fontSize: 16,
                                  ),
                                  isExpanded: true,
                                  underline: Container(
                                    height: 2,
                                    color: Colors.grey[300],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}

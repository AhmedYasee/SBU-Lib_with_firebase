import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class BookRequestScreen extends StatefulWidget {
  const BookRequestScreen({Key? key}) : super(key: key);

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
        .doc('YOUR_ADMIN_ID') // Replace with your admin ID or fetch it dynamically
        .collection('bookRequests')
        .snapshots();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Book Requests'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: _bookRequestsStream,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            print('Error: ${snapshot.error}');
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text('No book requests found.'));
          }

          final requests = snapshot.data!.docs;

          if (requests.isEmpty) {
            return const Center(child: Text('No requests available.'));
          }

          return ListView.builder(
            itemCount: requests.length,
            itemBuilder: (context, index) {
              final request = requests[index];
              final requestData = request.data() as Map<String, dynamic>;

              // Debugging output
              print('Request Data: $requestData');

              return Card(
                margin: const EdgeInsets.all(8.0),
                elevation: 5,
                child: ListTile(
                  contentPadding: const EdgeInsets.all(8.0),
                  leading: requestData['bookImage'] != null
                      ? Image.network(
                    requestData['bookImage'],
                    fit: BoxFit.cover,
                    width: 50,
                    height: 50,
                    errorBuilder: (context, error, stackTrace) =>
                    const Icon(Icons.image),
                  )
                      : const Icon(Icons.image),
                  title: Text(requestData['bookTitle'] ?? 'Unknown Title'),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Requester: ${requestData['requesterName'] ?? 'Unknown'}'),
                      Text('College: ${requestData['requesterCollege'] ?? 'Unknown'}'),
                      Text('Date: ${_formatDate(requestData['date'] ?? '')}'),
                      Text('Phone: ${requestData['phoneNumber'] ?? 'Unknown'}'),
                    ],
                  ),
                  trailing: DropdownButton<String>(
                    value: requestData['status'] ?? 'Pending',
                    onChanged: (newStatus) {
                      _updateRequestStatus(request.id, newStatus);
                    },
                    items: <String>['Pending', 'Borrowed', 'Returned']
                        .map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

  void _updateRequestStatus(String requestId, String? status) {
    FirebaseFirestore.instance
        .collection('colleges')
        .doc('YOUR_ADMIN_ID') // Replace with your admin ID or fetch it dynamically
        .collection('bookRequests')
        .doc(requestId)
        .update({'status': status})
        .catchError((error) {
      print('Error updating request status: $error');
    });
  }

  String _formatDate(String date) {
    // Assuming the date is in ISO 8601 format. Adjust as needed.
    try {
      final dateTime = DateTime.parse(date);
      final formattedDate = '${dateTime.year}-${dateTime.month.toString().padLeft(2, '0')}-${dateTime.day.toString().padLeft(2, '0')} ${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}';
      return formattedDate;
    } catch (e) {
      print('Error formatting date: $e');
      return 'Invalid Date';
    }
  }
}

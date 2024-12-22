import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class NotificationPage extends StatelessWidget {
  const NotificationPage({super.key});

  @override
  Widget build(BuildContext context) {
    final FirebaseFirestore firestore = FirebaseFirestore.instance;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'ការជូនដំណឹង', // Khmer title
          style: TextStyle(
            fontFamily: 'Koulen', // Khmer font
            fontSize: 26,
            color: Color(0xFF2E7D32), // Dark green
          ),
        ),
        centerTitle: true,
        backgroundColor: Color(0xFFE8F5E9), // Light green background
        elevation: 2,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(20),
          ),
        ),
      ),
      backgroundColor: Color(0xFFF1F8E9), // Very light green background
      body: StreamBuilder<QuerySnapshot>(
        stream: firestore
            .collection('messages')
            .orderBy('createdAt', descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.error_outline, size: 60, color: Colors.red[300]),
                  const SizedBox(height: 16),
                  const Text('មានបញ្ហាក្នុងការទាញយកព័ត៌មាន',
                    style: TextStyle(fontFamily: 'Koulen'),
                  ),
                ],
              ),
            );
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF43A047)),
              ),
            );
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.notifications_off_outlined, size: 60, color: Colors.grey[400]),
                  const SizedBox(height: 16),
                  const Text('មិនមានការជូនដំណឹងថ្មីទេ',
                    style: TextStyle(
                      fontFamily: 'Koulen',
                      fontSize: 16,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            );
          }

          final messages = snapshot.data!.docs;
          final groupedMessages = _groupMessagesByDate(messages);

          return ListView.builder(
            physics: const BouncingScrollPhysics(),
            itemCount: groupedMessages.length,
            itemBuilder: (context, index) {
              final group = groupedMessages[index];
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    margin: const EdgeInsets.fromLTRB(16, 24, 16, 8),
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                      color: const Color(0xFF66BB6A), // Green
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.green.withOpacity(0.2),
                          blurRadius: 4,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Text(
                      _getKhmerDate(group['date']),
                      style: const TextStyle(
                        fontFamily: 'Koulen',
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  ...group['messages'].map<Widget>((message) {
                    return AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.green.withOpacity(0.1),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                        ],
                        border: Border.all(
                          color: const Color(0xFFA5D6A7),
                          width: 1,
                        ),
                      ),
                      child: ListTile(
                        contentPadding: const EdgeInsets.all(16),
                        leading: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: const Color(0xFFE8F5E9),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Icon(
                            Icons.notifications,
                            color: Color(0xFF43A047),
                            size: 28,
                          ),
                        ),
                        title: Text(
                          message['title'] ?? 'គ្មានចំណងជើង',
                          style: const TextStyle(
                            fontFamily: 'Koulen',
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            color: Color(0xFF2E7D32),
                          ),
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 8),
                            Text(
                              message['description'] ?? 'គ្មានការពិពណ៌នា',
                              style: const TextStyle(
                                fontFamily: 'Koulen',
                                fontSize: 14,
                                color: Colors.black87,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              _formatTimestampKhmer(message['createdAt'] as Timestamp),
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.green[700],
                                fontStyle: FontStyle.italic,
                              ),
                            ),
                          ],
                        ),
                        onTap: () {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                backgroundColor: const Color(0xFFF1F8E9),
                                title: Text(
                                  message['title'] ?? 'គ្មានចំណងជើង',
                                  style: const TextStyle(
                                    fontFamily: 'Koulen',
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFF2E7D32),
                                  ),
                                ),
                                content: SingleChildScrollView(
                                  child: Text(
                                    message['description'] ?? 'គ្មានការពិពណ៌នា',
                                    style: const TextStyle(
                                      fontFamily: 'Koulen',
                                      fontSize: 16,
                                    ),
                                  ),
                                ),
                                actions: <Widget>[
                                  TextButton(
                                    style: TextButton.styleFrom(
                                      foregroundColor: const Color(0xFF43A047),
                                    ),
                                    child: const Text(
                                      'បិទ',
                                      style: TextStyle(
                                        fontFamily: 'Koulen',
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                  ),
                                ],
                              );
                            },
                          );
                        },
                      ),
                    );
                  }).toList(),
                ],
              );
            },
          );
        },
      ),
    );
  }

  String _getKhmerDate(String date) {
    switch (date) {
      case 'Today':
        return 'ថ្ងៃនេះ';
      case 'Yesterday':
        return 'ម្សិលមិញ';
      case 'Older':
        return 'មុនៗ';
      default:
        return date;
    }
  }

  List<Map<String, dynamic>> _groupMessagesByDate(List<QueryDocumentSnapshot> messages) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = today.subtract(const Duration(days: 1));

    final groupedMessages = <Map<String, dynamic>>[];

    final todayMessages = messages.where((message) {
      final createdAt = (message['createdAt'] as Timestamp).toDate();
      return createdAt.isAfter(today);
    }).toList();

    if (todayMessages.isNotEmpty) {
      groupedMessages.add({'date': 'Today', 'messages': todayMessages});
    }

    final yesterdayMessages = messages.where((message) {
      final createdAt = (message['createdAt'] as Timestamp).toDate();
      return createdAt.isAfter(yesterday) && createdAt.isBefore(today);
    }).toList();

    if (yesterdayMessages.isNotEmpty) {
      groupedMessages.add({'date': 'Yesterday', 'messages': yesterdayMessages});
    }

    final olderMessages = messages.where((message) {
      final createdAt = (message['createdAt'] as Timestamp).toDate();
      return createdAt.isBefore(yesterday);
    }).toList();

    if (olderMessages.isNotEmpty) {
      groupedMessages.add({'date': 'Older', 'messages': olderMessages});
    }

    return groupedMessages;
  }

  String _formatTimestampKhmer(Timestamp timestamp) {
    final now = DateTime.now();
    final date = timestamp.toDate();
    final difference = now.difference(date);

    if (difference.inDays > 0) {
      return '${difference.inDays} ថ្ងៃមុន';
    } else if (difference.inHours > 0) {
      return '${difference.inHours} ម៉ោងមុន';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes} នាទីមុន';
    } else {
      return 'ទើបតែឥឡូវនេះ';
    }
  }
}

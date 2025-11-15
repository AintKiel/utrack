import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:utrack/features/app_pages/home/elements/recentAct/recentActItems.dart';
import 'package:utrack/utils/formatters/iconsNoPad.dart';
import '../../../../../utils/constants/colors.dart';
import '../../../../../utils/helpers/helper_functions.dart';

class RecentActivity extends StatefulWidget {
  const RecentActivity({super.key});

  // ... rest of the code remains the same ...
  State<RecentActivity> createState() => _RecentActivityState();
}

class _RecentActivityState extends State<RecentActivity> {
  String _getTimeAgo(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.inSeconds < 60) {
      return 'Just now';
    } else if (difference.inMinutes < 60) {
      return '${difference.inMinutes}m ago';
    } else if (difference.inHours < 24) {
      return '${difference.inHours}h ago';
    } else if (difference.inDays < 7) {
      return '${difference.inDays}d ago';
    } else {
      return 'A week ago';
    }
  }

  String _getInitials(String name) {
    List<String> nameParts = name.split(' ');
    String initials = '';
    for (var part in nameParts) {
      if (part.isNotEmpty) {
        initials += part[0].toUpperCase();
      }
    }
    return initials.length > 2 ? initials.substring(0, 2) : initials;
  }

  @override
  Widget build(BuildContext context) {
    final currentUser = FirebaseAuth.instance.currentUser;

    if (currentUser == null) {
      return Container(
        padding: const EdgeInsets.all(16),
        child: Center(
          child: Text('Not logged in', style: TextStyle(color: Colors.grey[600])),
        ),
      );
    }

    final lentStream = FirebaseFirestore.instance
        .collection('Users')
        .doc(currentUser.uid)
        .collection('LentTransactions')
        .orderBy('createdAt', descending: true)
        .snapshots();

    final owedStream = FirebaseFirestore.instance
        .collection('Users')
        .doc(currentUser.uid)
        .collection('OwedTransactions')
        .orderBy('createdAt', descending: true)
        .snapshots();

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).brightness == Brightness.dark
            ? Colors.transparent
            : Colors.transparent,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// --- Header ---
          Row(
            children: [
              Icon(Icons.access_time, color: Colors.green, size: 22),
              SizedBox(width: 8),
              Text(
                "Recent Activity",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: Theme.of(context).brightness == Brightness.dark
                      ? UColors.white
                      : UColors.black,
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),

          /// --- Activity List ---
          StreamBuilder<QuerySnapshot>(
            stream: lentStream,
            builder: (context, lentSnapshot) {
              return StreamBuilder<QuerySnapshot>(
                stream: owedStream,
                builder: (context, owedSnapshot) {
                  if (lentSnapshot.connectionState == ConnectionState.waiting ||
                      owedSnapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  // Combine both lists
                  List<Map<String, dynamic>> allTransactions = [];

                  if (lentSnapshot.hasData) {
                    for (var doc in lentSnapshot.data!.docs) {
                      final data = doc.data() as Map<String, dynamic>;
                      allTransactions.add({...data, 'isLent': true});
                    }
                  }

                  if (owedSnapshot.hasData) {
                    for (var doc in owedSnapshot.data!.docs) {
                      final data = doc.data() as Map<String, dynamic>;
                      allTransactions.add({...data, 'isLent': false});
                    }
                  }

                  // Sort by date
                  allTransactions.sort((a, b) {
                    final dateA = (a['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now();
                    final dateB = (b['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now();
                    return dateB.compareTo(dateA);
                  });

                  final recentTransactions = allTransactions.take(5).toList();

                  if (recentTransactions.isEmpty) {
                    return Center(
                      child: Text(
                        'No recent activity',
                        style: TextStyle(color: Colors.grey[600], fontSize: 14),
                      ),
                    );
                  }

                  return ListView.separated(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: recentTransactions.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 10),
                    itemBuilder: (context, index) {
                      final transaction = recentTransactions[index];
                      final isLent = transaction['isLent'] as bool;

                      // Show recipient if you lent, sender if you owe
                      final name = isLent
                          ? (transaction['recipientName'] ?? 'Unknown')
                          : (transaction['senderName'] ?? 'Unknown');

                      final amount = transaction['amount'] ?? 0.0;
                      final createdAt = transaction['createdAt'] != null
                          ? (transaction['createdAt'] as Timestamp).toDate()
                          : DateTime.now();

                      return RecentActItems(
                        initials: _getInitials(name),
                        name: name,
                        time: _getTimeAgo(createdAt),
                        amount: Row(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              isLent ? '+' : '-',
                              style: TextStyle(
                                color: isLent ? Colors.green : Colors.red,
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                              ),
                            ),
                            UIconsNoPad.pesoSign(
                              size: 14, 
                              color: isLent ? Colors.green : Colors.red,
                            ),
                            Text(
                              amount.toString(),
                              style: TextStyle(
                                color: isLent ? Colors.green : Colors.red,
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                        amountColor: isLent ? Colors.green : Colors.red,
                        icon: isLent
                            ? UIconsNoPad.paid(color: Colors.green, size: 14)
                            : UIconsNoPad.borrowIcon(color: Colors.orange, size: 14),
                        iconColor: isLent ? Colors.green : Colors.orange,
                      );
                    },
                  );
                },
              );
            },
          ),
        ],
      ),
    );
  }
}
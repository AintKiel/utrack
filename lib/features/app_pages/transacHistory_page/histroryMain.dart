import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:utrack/features/app_pages/transacHistory_page/searchBar.dart';
import '../../../common/widgets/custom_shapes/containers/tertiary_header_container.dart';
import '../../../services/transaction_history_service.dart';

import 'transacContainer.dart';

class TransactionModel {
  final String name;
  final String type; // Money Lent, Borrowed Money, Payment Sent, Received Payment
  final String? paymentType; // Partial Payment, Full Payment (only for payment transactions)
  final double amount;
  final DateTime dateTime; // combined date+time for sorting

  TransactionModel({
    required this.name,
    required this.type,
    this.paymentType,
    required this.amount,
    required this.dateTime,
  });
}

class HistoryMain extends StatefulWidget {
  const HistoryMain({super.key});

  @override
  State<HistoryMain> createState() => _HistoryMainState();
}

class _HistoryMainState extends State<HistoryMain> {
  String _searchText = '';
  String _sort = 'Recent';
  String _type = 'All Types';

  void _onFilterChanged(String sort, String type) {
    setState(() {
      _sort = sort;
      _type = type;
    });
  }

  void _onSearchChanged(String value) {
    setState(() {
      _searchText = value;
    });
  }

  List<TransactionModel> _applyFilters(List<Map<String, dynamic>> rawTransactions) {
    // Convert raw data to TransactionModel
    List<TransactionModel> list = rawTransactions.map((data) {
      return TransactionModel(
        name: data['name'] as String,
        type: data['type'] as String,
        paymentType: data['paymentType'] as String?,
        amount: data['amount'] as double,
        dateTime: data['dateTime'] as DateTime,
      );
    }).toList();

    // search
    if (_searchText.trim().isNotEmpty) {
      final q = _searchText.toLowerCase();
      list = list.where((t) => t.name.toLowerCase().contains(q)).toList();
    }

    // type filter
    if (_type != 'All Types') {
      list = list.where((t) => t.type.toLowerCase() == _type.toLowerCase()).toList();
    }

    // sort
    switch (_sort) {
      case 'Recent':
        list.sort((a, b) => b.dateTime.compareTo(a.dateTime));
        break;
      case 'Amount':
        list.sort((a, b) => b.amount.compareTo(a.amount));
        break;
      case 'Name':
        list.sort((a, b) => a.name.toLowerCase().compareTo(b.name.toLowerCase()));
        break;
      default:
        list.sort((a, b) => b.dateTime.compareTo(a.dateTime));
    }

    return list;
  }

  @override
  Widget build(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor:
      isDark ? Colors.grey.shade900 : Colors.grey.shade100,
      body: SafeArea(
        top: false,
        child: Column(
          children: [
            UTertiaryHeaderContainer(
              height: 290,   // Increased height prevents overflow
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 65),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "History",
                      style: Theme.of(context).textTheme.headlineSmall!.copyWith(
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        fontSize: 25,
                      ),
                    ),

                    const SizedBox(height: 20),

                    HistorySearchBar(
                      onFilterChanged: _onFilterChanged,
                      onSearchChanged: _onSearchChanged,
                    ),
                  ],
                ),
              ),
            ),
            /// -----------------------------------------
            /// TRANSACTION LIST
            /// -----------------------------------------
            Expanded(
              child: StreamBuilder<List<Map<String, dynamic>>>(
                stream: TransactionHistoryService.getAllTransactionsStream(),
                builder: (context, snapshot) {
                  // Loading state
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }

                  // Error state
                  if (snapshot.hasError) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.error_outline,
                            size: 60,
                            color: Colors.red.shade300,
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'Error loading transactions',
                            style: TextStyle(
                              fontSize: 16,
                              color: isDark ? Colors.white70 : Colors.black54,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            snapshot.error.toString(),
                            style: TextStyle(
                              fontSize: 12,
                              color: isDark ? Colors.white54 : Colors.black38,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    );
                  }

                  // No data or empty state
                  if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.history,
                            size: 80,
                            color: isDark ? Colors.grey.shade700 : Colors.grey.shade300,
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'No transactions yet',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w500,
                              color: isDark ? Colors.white70 : Colors.black54,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Your transaction history will appear here',
                            style: TextStyle(
                              fontSize: 14,
                              color: isDark ? Colors.white54 : Colors.black38,
                            ),
                          ),
                        ],
                      ),
                    );
                  }

                  // Apply filters to the data
                  final filtered = _applyFilters(snapshot.data!);

                  // Filtered results empty
                  if (filtered.isEmpty) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.search_off,
                            size: 80,
                            color: isDark ? Colors.grey.shade700 : Colors.grey.shade300,
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'No matching transactions',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w500,
                              color: isDark ? Colors.white70 : Colors.black54,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Try adjusting your filters or search',
                            style: TextStyle(
                              fontSize: 14,
                              color: isDark ? Colors.white54 : Colors.black38,
                            ),
                          ),
                        ],
                      ),
                    );
                  }

                  // Display transaction list
                  return ListView.builder(
                    padding: EdgeInsets.zero,
                    itemCount: filtered.length,
                    itemBuilder: (context, index) {
                      final t = filtered[index];

                      final date = DateFormat('MM/dd/yyyy').format(t.dateTime);
                      final time = DateFormat('hh:mm a').format(t.dateTime);

                      return Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        child: TransacContainer(
                          name: t.name,
                          type: t.type,
                          paymentType: t.paymentType,
                          amount: t.amount,
                          date: date,
                          time: time,
                        ),
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
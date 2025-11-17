import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../common/widgets/custom_shapes/containers/tertiary_header_container.dart';
import 'searchBar.dart';
import 'transacContainer.dart';

class TransactionModel {
  final String name;
  final String type; // Lent, Borrowed, Received, Paid
  final String status; // Completed, Pending, Failed
  final double amount;
  final DateTime dateTime; // combined date+time for sorting

  TransactionModel({
    required this.name,
    required this.type,
    required this.status,
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
  // sample data
  final List<TransactionModel> _allTransactions = [
    TransactionModel(
      name: 'Ana Garcia',
      type: 'Received',
      status: 'Completed',
      amount: 2000,
      dateTime: DateFormat('MM/dd/yyyy hh:mm a').parse('12/15/2024 06:30 PM'),
    ),
    TransactionModel(
      name: 'Pedro Reyes',
      type: 'Lent',
      status: 'Completed',
      amount: 500,
      dateTime: DateFormat('MM/dd/yyyy hh:mm a').parse('12/14/2024 11:20 AM'),
    ),
    TransactionModel(
      name: 'Rosa Martinez',
      type: 'Borrowed',
      status: 'Completed',
      amount: 1500,
      dateTime: DateFormat('MM/dd/yyyy hh:mm a').parse('12/13/2024 05:15 PM'),
    ),
    TransactionModel(
      name: 'Juan Dela Cruz',
      type: 'Paid',
      status: 'Pending',
      amount: 750,
      dateTime: DateFormat('MM/dd/yyyy hh:mm a').parse('12/18/2024 02:00 PM'),
    ),
    TransactionModel(
      name: 'Maria Lopez',
      type: 'Received',
      status: 'Failed',
      amount: 300,
      dateTime: DateFormat('MM/dd/yyyy hh:mm a').parse('12/16/2024 09:10 AM'),
    ),
  ];

  List<TransactionModel> _filtered = [];
  String _searchText = '';
  String _sort = 'Recent';
  String _type = 'All Types';
  String _status = 'All Status';

  @override
  void initState() {
    super.initState();
    _filtered = List.from(_allTransactions);
    _applyFilters();
  }

  void _onFilterChanged(String sort, String type, String status) {
    setState(() {
      _sort = sort;
      _type = type;
      _status = status;
      _applyFilters();
    });
  }

  void _onSearchChanged(String value) {
    setState(() {
      _searchText = value;
      _applyFilters();
    });
  }

  void _applyFilters() {
    // start from all
    List<TransactionModel> list = List.from(_allTransactions);

    // search
    if (_searchText.trim().isNotEmpty) {
      final q = _searchText.toLowerCase();
      list = list.where((t) => t.name.toLowerCase().contains(q)).toList();
    }

    // type filter
    if (_type != 'All Types') {
      list = list.where((t) => t.type.toLowerCase() == _type.toLowerCase()).toList();
    }

    // status filter
    if (_status != 'All Status') {
      list = list.where((t) => t.status.toLowerCase() == _status.toLowerCase()).toList();
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

    _filtered = list;
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
              child: ListView.builder(
                padding: EdgeInsets.zero,
                itemCount: _filtered.length,
                itemBuilder: (context, index) {
                  final t = _filtered[index];

                  final date = DateFormat('MM/dd/yyyy').format(t.dateTime);
                  final time = DateFormat('hh:mm a').format(t.dateTime);

                  return Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,  // 🔥 Smaller than 16
                      vertical: 6,
                    ),
                    child: TransacContainer(
                      name: t.name,
                      type: t.type,
                      status: t.status,
                      amount: t.amount,
                      date: date,
                      time: time,
                    ),
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

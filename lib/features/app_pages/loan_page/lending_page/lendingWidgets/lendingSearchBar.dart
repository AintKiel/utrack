import 'package:flutter/material.dart';
import '../../../../../utils/constants/colors.dart';

class DebtorSearchSortSection extends StatelessWidget {
  final bool dark;
  final String selectedSort;
  final ValueChanged<String?> onSortChanged;

  const DebtorSearchSortSection({
    super.key,
    required this.dark,
    required this.selectedSort,
    required this.onSortChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: dark
            ? Colors.black.withOpacity(0.15)
            : Colors.white.withOpacity(0.15),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ==== HEADER ====
          Text(
            'Debtor List',
            style: TextStyle(
              color: dark ? Colors.black : Colors.white,
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 3),
          Text(
            'Manage your lending accounts',
            style: TextStyle(
              color: dark ? Colors.black54 : Colors.white70,
              fontSize: 12,
            ),
          ),
          const SizedBox(height: 10),

          // ==== SEARCH BAR ====
          Container(
            decoration: BoxDecoration(
              color: dark ? Colors.black87 : Colors.white,
              borderRadius: BorderRadius.circular(25),
            ),
            child: TextField(
              style: TextStyle(
                color: dark ? Colors.white : Colors.black,
              ),
              decoration: InputDecoration(
                hintText: 'Search',
                hintStyle: TextStyle(
                  color: dark ? Colors.white70 : Colors.grey,
                ),
                prefixIcon: Icon(
                  Icons.search,
                  color: dark ? Colors.white70 : Colors.grey,
                  size: 18,
                ),
                border: InputBorder.none,
                contentPadding: const EdgeInsets.symmetric(vertical: 12),
              ),
            ),
          ),
          const SizedBox(height: 10),

          // ==== SORT DROPDOWN ====
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Sort by:',
                style: TextStyle(
                  color: dark ? Colors.black : Colors.white,
                  fontSize: 13,
                ),
              ),
              Container(
                height: 30,
                padding: const EdgeInsets.symmetric(horizontal: 10),
                decoration: BoxDecoration(
                  color: dark ? Colors.black87 : Colors.white,
                  borderRadius: BorderRadius.circular(25),
                  border: Border.all(
                    color: dark ? Colors.white24 : Colors.black12,
                  ),
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    dropdownColor:
                    dark ? UColors.darkGrey : Colors.white,
                    iconEnabledColor:
                    dark ? Colors.white : Colors.black,
                    value: selectedSort,
                    items: const [
                      DropdownMenuItem(
                          value: 'Recent', child: Text('Recent')),
                      DropdownMenuItem(value: 'A-Z', child: Text('A-Z')),
                      DropdownMenuItem(
                          value: 'Due Date', child: Text('Due Date')),
                    ],
                    onChanged: onSortChanged,
                    style: TextStyle(
                      color: dark ? Colors.white : Colors.black,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

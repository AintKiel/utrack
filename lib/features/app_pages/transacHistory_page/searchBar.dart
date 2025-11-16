import 'package:flutter/material.dart';

class HistorySearchBar extends StatefulWidget {
  final Function(String sort, String type, String status) onFilterChanged;
  final Function(String text) onSearchChanged;

  const HistorySearchBar({
    super.key,
    required this.onFilterChanged,
    required this.onSearchChanged,
  });

  @override
  State<HistorySearchBar> createState() => _HistorySearchBarState();
}

class _HistorySearchBarState extends State<HistorySearchBar> {
  String selectedSort = "Recent";
  String selectedType = "All Types";
  String selectedStatus = "All Status";

  final List<String> sortOptions = ["Recent", "Amount", "Name"];
  final List<String> typeOptions = ["All Types", "Lent", "Borrowed", "Received", "Paid"];
  final List<String> statusOptions = ["All Status", "Completed", "Pending", "Failed"];

  final TextEditingController _searchController = TextEditingController();

  void _updateFilters() {
    widget.onFilterChanged(selectedSort, selectedType, selectedStatus);
  }

  @override
  void initState() {
    super.initState();
    _searchController.addListener(() {
      widget.onSearchChanged(_searchController.text);
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Widget _buildDropdown(
      String value,
      List<String> items,
      ValueChanged<String?> onChanged,
      ) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E1E1E) : Colors.white,
        borderRadius: BorderRadius.circular(10),
      ),
      child: DropdownButton<String>(
        value: value,
        underline: const SizedBox(),
        items: items.map((e) => DropdownMenuItem(value: e, child: Text(e, style: const TextStyle(fontSize: 13)))).toList(),
        onChanged: onChanged,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    return Column(
      children: [
        // Search field
        TextField(
          controller: _searchController,
          decoration: InputDecoration(
            hintText: "Search transactions...",
            prefixIcon: const Icon(Icons.search),
            filled: true,
            fillColor: isDark ? const Color(0xFF1E1E1E) : Colors.white,
            contentPadding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: BorderSide.none,
            ),
          ),
        ),
        const SizedBox(height: 10),

        // filter row
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: _buildDropdown(selectedSort, sortOptions, (v) {
                if (v == null) return;
                setState(() => selectedSort = v);
                _updateFilters();
              }),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: _buildDropdown(selectedType, typeOptions, (v) {
                if (v == null) return;
                setState(() => selectedType = v);
                _updateFilters();
              }),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: _buildDropdown(selectedStatus, statusOptions, (v) {
                if (v == null) return;
                setState(() => selectedStatus = v);
                _updateFilters();
              }),
            ),
          ],
        ),
      ],
    );
  }
}

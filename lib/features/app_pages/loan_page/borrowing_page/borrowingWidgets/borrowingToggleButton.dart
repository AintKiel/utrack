import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../../navigation_menu.dart';

class BorrowingToggleButtons extends StatelessWidget {
  final bool isBorrowingSelected;
  final bool dark;

  const BorrowingToggleButtons({
    super.key,
    required this.isBorrowingSelected,
    required this.dark,
  });

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<NavigationController>();

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Row(
        children: [
          // ==== LENDING BUTTON ====
          Expanded(
            child: ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: !isBorrowingSelected
                    ? (dark ? Colors.black : Colors.white)
                    : (dark ? Colors.black12 : Colors.white24),
                foregroundColor: !isBorrowingSelected
                    ? (dark ? Colors.white : Colors.black)
                    : (dark ? Colors.black54 : Colors.white70),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                padding: const EdgeInsets.symmetric(vertical: 10),
              ),
              onPressed: () {
                // ✅ Switch to LendingPage via GetX
                controller.loanPageIndex.value = 0;
              },
              icon: Icon(
                Icons.trending_up_rounded,
                size: 16,
                color: !isBorrowingSelected
                    ? (dark ? Colors.white : Colors.black)
                    : (dark ? Colors.black54 : Colors.white70),
              ),
              label: Text(
                'Lending',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: !isBorrowingSelected
                      ? (dark ? Colors.white : Colors.black)
                      : (dark ? Colors.black54 : Colors.white70),
                ),
              ),
            ),
          ),

          const SizedBox(width: 10),

          // ==== BORROWING BUTTON ====
          Expanded(
            child: ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: isBorrowingSelected
                    ? (dark ? Colors.black : Colors.white)
                    : (dark ? Colors.black12 : Colors.white24),
                foregroundColor: isBorrowingSelected
                    ? (dark ? Colors.white : Colors.black)
                    : (dark ? Colors.black54 : Colors.white70),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                padding: const EdgeInsets.symmetric(vertical: 10),
              ),
              onPressed: () {},
              icon: Icon(
                Icons.trending_down_rounded,
                size: 16,
                color: isBorrowingSelected
                    ? (dark ? Colors.white : Colors.black)
                    : (dark ? Colors.white70 : Colors.black54),
              ),
              label: Text(
                'Borrowing',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: isBorrowingSelected
                      ? (dark ? Colors.white : Colors.black)
                      : (dark ? Colors.white70 : Colors.black54),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
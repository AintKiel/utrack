import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../../navigation_menu.dart';

class LendingToggleButtons extends StatelessWidget {
  final bool isLendingSelected;
  final bool dark;
  final ValueChanged<bool> onToggle;

  const LendingToggleButtons({
    super.key,
    required this.isLendingSelected,
    required this.dark,
    required this.onToggle,
  });

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<NavigationController>(); // ✅ GetX controller

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Row(
        children: [
          // ==== LENDING BUTTON ====
          Expanded(
            child: ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: isLendingSelected
                    ? (dark ? Colors.black : Colors.white)
                    : (dark ? Colors.black12 : Colors.white24),
                foregroundColor: isLendingSelected
                    ? (dark ? Colors.white : Colors.black)
                    : (dark ? Colors.black54 : Colors.white70),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                padding: const EdgeInsets.symmetric(vertical: 10),
              ),
              onPressed: () => onToggle(true),
              icon: Icon(
                Icons.trending_up_rounded,
                size: 16,
                color: isLendingSelected
                    ? (dark ? Colors.white : Colors.black)
                    : (dark ? Colors.black54 : Colors.white70),
              ),
              label: Text(
                'Lending',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: isLendingSelected
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
                backgroundColor: !isLendingSelected
                    ? (dark ? Colors.black : Colors.white)
                    : (dark ? Colors.black12 : Colors.white24),
                foregroundColor: !isLendingSelected
                    ? (dark ? Colors.white : Colors.black)
                    : (dark ? Colors.black54 : Colors.white70),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                padding: const EdgeInsets.symmetric(vertical: 10),
              ),
              onPressed: () {
                // ✅ Switch page using GetX, not Navigator
                controller.loanPageIndex.value = 1; // BorrowingPage
              },
              icon: Icon(
                Icons.trending_down_rounded,
                size: 16,
                color: !isLendingSelected
                    ? (dark ? Colors.white : Colors.black)
                    : (dark ? Colors.white70 : Colors.black54),
              ),
              label: Text(
                'Borrowing',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: !isLendingSelected
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
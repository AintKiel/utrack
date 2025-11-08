import 'package:flutter/material.dart';
import '../../borrowing_page/borrowing_page.dart';

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
                onToggle(false); // update toggle state

                // 👇 navigate to BorrowingPage
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const BorrowingPage(),
                  ),
                );
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

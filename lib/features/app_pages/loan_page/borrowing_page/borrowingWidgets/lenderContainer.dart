import 'package:flutter/material.dart';
import 'package:utrack/utils/constants/text_strings.dart';
import '../../../../../utils/constants/colors.dart';
import '../../../../../utils/formatters/iconsNoPad.dart';
import '../../../../../utils/helpers/helper_functions.dart';
import 'borrowingViewDetails/borrowingMoreInfos.dart';

class LenderList extends StatelessWidget {
  final List<Map<String, dynamic>> lenders;

  const LenderList({super.key, required this.lenders});

  @override
  Widget build(BuildContext context) {
    final dark = UHelperFunctions.isDarkMode(context);

    if (lenders.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 40),
          child: Text(
            UTexts.noDebtors, // You can also create UTexts.noLenders if needed
            textAlign: TextAlign.center,
            style: TextStyle(
              color: dark ? Colors.white70 : Colors.black54,
              fontSize: 14,
              fontWeight: FontWeight.w400,
            ),
          ),
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Column(
        children: lenders
            .map((lender) => _buildLenderCard(
          context,
          lender: lender,
        ))
            .toList(),
      ),
    );
  }

  // 🔹 Lender card widget
  Widget _buildLenderCard(
      BuildContext context, {
        required Map<String, dynamic> lender,
      }) {
    final dark = UHelperFunctions.isDarkMode(context);

    final name = lender['name'];
    final date = lender['date'];
    final amount = lender['amount'];
    final status = lender['status'];
    final color = lender['color'] as Color;
    final initials = lender['initials'];

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: dark ? UColors.black : UColors.white,
        border: Border.all(
          color: dark ? Colors.white24 : UColors.darkGrey.withOpacity(0.3),
          width: 1,
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: dark ? Colors.black45 : Colors.black12,
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              // Avatar
              CircleAvatar(
                backgroundColor:
                dark ? Colors.white.withOpacity(0.1) : Colors.blue.shade100,
                child: Text(
                  initials,
                  style: TextStyle(
                    color: dark ? Colors.white : Colors.black87,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(width: 10),

              // Name + Date
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name,
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                        color: dark ? Colors.white : Colors.black,
                      ),
                    ),
                    Text(
                      date,
                      style: TextStyle(
                        color: dark ? Colors.white60 : Colors.black54,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),

              // Amount + Status
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      UIconsNoPad.pesoSign(
                        size: 11,
                        color: dark ? Colors.white : Colors.black87,
                      ),
                      const SizedBox(width: 2),
                      Text(
                        '$amount',
                        style: TextStyle(
                          color: dark ? Colors.white : Colors.black87,
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  Container(
                    margin: const EdgeInsets.only(top: 4),
                    padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: color.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      status,
                      style: TextStyle(
                        color: color,
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 10),

          // 🔹 View Details Button (opens popup)
          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              onPressed: () {
                Navigator.of(context).push(
                  PageRouteBuilder(
                    opaque: false,
                    barrierDismissible: true,
                    pageBuilder: (_, __, ___) =>
                        BorrowingMoreInfos(lender: lender),
                  ),
                );
              },
              icon: Icon(
                Icons.remove_red_eye_rounded,
                size: 16,
                color: dark ? Colors.white : Colors.black,
              ),
              label: Text(
                'View Details',
                style: TextStyle(
                  fontSize: 13,
                  color: dark ? Colors.white : Colors.black,
                ),
              ),
              style: OutlinedButton.styleFrom(
                side: BorderSide(
                  color: dark ? Colors.white54 : Colors.black45,
                ),
                padding:
                const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
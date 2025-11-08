import 'package:flutter/material.dart';

import '../../../../../utils/constants/colors.dart';
import '../../../../../utils/formatters/iconsNoPad.dart';
import '../../../../../utils/helpers/helper_functions.dart';

class UTotalLentCard extends StatelessWidget {
  const UTotalLentCard({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final dark = UHelperFunctions.isDarkMode(context);
    return Container(
      decoration: BoxDecoration(
        color: dark
            ? Colors.black.withOpacity(0.15)
            : Colors.white.withOpacity(0.15),
        borderRadius: BorderRadius.circular(14),
      ),
      padding: const EdgeInsets.all(14),
      margin: const EdgeInsets.symmetric(horizontal: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Total Lent',
                style: TextStyle(
                  color: UColors.warning,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 5),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  UIconsNoPad.pesoSign(size: 22, color: dark ? Colors.black : Colors.white,),
                  const SizedBox(width: 4),
                  Text(
                    '15,500',    /// total amount
                    style: TextStyle(
                      color: dark ? Colors.black : Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),

              Text(
                '4 active borrowers',
                style: TextStyle(
                  color: dark ? Colors.black54 : Colors.white70,
                  fontSize: 12,
                ),
              ),
            ],
          ),
          Icon(
            Icons.trending_up_rounded,
            size: 38,
              color: dark ? Colors.black : Colors.white,
          ),
        ],
      ),
    );
  }
}

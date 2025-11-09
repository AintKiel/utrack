import 'package:flutter/material.dart';
import '../../../../../utils/constants/colors.dart';
import 'lenderContainer.dart';

class LenderListContainer extends StatelessWidget {
  final bool dark;
  final List<Map<String, dynamic>> lenders;

  const LenderListContainer({
    super.key,
    required this.dark,
    required this.lenders,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
      decoration: BoxDecoration(
        color: dark ? UColors.black : UColors.white,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(24),
          topRight: Radius.circular(24),
        ),
      ),
      child: LenderList(lenders: lenders),
    );
  }
}
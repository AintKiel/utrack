import 'package:flutter/material.dart';
import '../../../../../services/borrowing_service.dart';
import '../../../../../services/recalculate_stats_service.dart';
import '../../../../../utils/constants/colors.dart';
import '../../../../../utils/formatters/iconsNoPad.dart';
import '../../../../../utils/helpers/helper_functions.dart';

class UTotalOwedCard extends StatefulWidget {
  const UTotalOwedCard({
    super.key,
  });

  @override
  State<UTotalOwedCard> createState() => _UTotalOwedCardState();
}

class _UTotalOwedCardState extends State<UTotalOwedCard> {
  double totalOwed = 0.0;
  int lenderCount = 0;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    final owed = await BorrowingService.getTotalOwed();
    final count = await BorrowingService.getLenderCount();
    setState(() {
      totalOwed = owed;
      lenderCount = count;
      isLoading = false;
    });
  }

  Future<void> _recalculateStats() async {
    setState(() => isLoading = true);
    
    // Print detailed breakdown
    await RecalculateStatsService.printTransactionBreakdown();
    
    // Recalculate and update stats
    final result = await RecalculateStatsService.recalculatePaymentStats();
    
    if (result['success'] == true) {
      // Show success message
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('✅ Stats recalculated! Total Owed: ₱${result['totalOwed']}'),
            backgroundColor: Colors.green,
          ),
        );
      }
      // Reload data
      await _loadData();
    } else {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('❌ Error: ${result['error']}'),
            backgroundColor: Colors.red,
          ),
        );
      }
      setState(() => isLoading = false);
    }
  }

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
                'Total Owed',
                style: TextStyle(
                  color: Colors.lightGreen,
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
                  isLoading
                      ? SizedBox(
                          width: 60,
                          height: 22,
                          child: LinearProgressIndicator(
                            backgroundColor: Colors.white24,
                            valueColor: AlwaysStoppedAnimation<Color>(
                              dark ? Colors.black : Colors.white,
                            ),
                          ),
                        )
                      : Text(
                          totalOwed.toStringAsFixed(2).replaceAll(RegExp(r'\.00$'), ''),
                          style: TextStyle(
                            color: dark ? Colors.black : Colors.white,
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                ],
              ),

              Text(
                '$lenderCount lender${lenderCount != 1 ? "s" : ""}',
                style: TextStyle(
                  color: dark ? Colors.black54 : Colors.white70,
                  fontSize: 12,
                ),
              ),
            ],
          ),
          Column(
            children: [
              Icon(
                Icons.trending_down_rounded,
                size: 38,
                color: dark ? Colors.black : Colors.white,
              ),
              const SizedBox(height: 4),
              GestureDetector(
                onTap: _recalculateStats,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color: Colors.white24,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.refresh,
                        size: 12,
                        color: dark ? Colors.black : Colors.white,
                      ),
                      const SizedBox(width: 2),
                      Text(
                        'Fix',
                        style: TextStyle(
                          fontSize: 10,
                          color: dark ? Colors.black : Colors.white,
                        ),
                      ),
                    ],
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
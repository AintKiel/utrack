import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../common/widgets/custom_shapes/containers/secondary_header_container.dart';
import '../../../../navigation_menu.dart';
import '../../../../services/borrowing_service.dart';
import '../../../../utils/constants/colors.dart';
import '../../../../utils/formatters/iconsNoPad.dart';
import '../../../../utils/helpers/helper_functions.dart';
import 'borrowingWidgets/borrowingSearchBar.dart';
import 'borrowingWidgets/borrowingToggleButton.dart';
import 'borrowingWidgets/lenderList.dart';
import 'borrowingWidgets/totalOwedCard.dart';

class BorrowingPage extends StatefulWidget {
  const BorrowingPage({super.key});

  @override
  State<BorrowingPage> createState() => _BorrowingPageState();
}

class _BorrowingPageState extends State<BorrowingPage> {
  bool isLendingSelected = true;
  String selectedSort = 'Recent';

  @override
  Widget build(BuildContext context) {
    final dark = UHelperFunctions.isDarkMode(context);

    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: dark ? UColors.black : UColors.white,

      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          children: [
            // ==== HEADER SECTION ====
            USecondaryHeaderContainer(
              height: 486,
              child: Padding(
                padding: const EdgeInsets.only(bottom: 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 40),

                    /// ==== BACK ARROW ====
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 1.0),
                      child: IconButton(
                        icon: UIconsNoPad.back(
                          color: dark ? Colors.black : Colors.white,
                          size: 25,
                        ),
                        onPressed: () {
                          final controller = Get.find<NavigationController>();
                          controller.loanPageIndex.value = 0;
                          controller.selectedIndex.value = 0;
                        },
                      ),
                    ),

                    const SizedBox(height: 5),

                    /// ==== TOTAL LENT CARD ====
                    const UTotalOwedCard(),

                    const SizedBox(height: 14),

                    /// ==== TOGGLE BUTTONS ====
                    BorrowingToggleButtons(
                      isBorrowingSelected: true,
                      dark: dark,
                    ),

                    const SizedBox(height: 18),

                    /// ==== SEARCH + SORT ====
                    LenderSearchSortSection(
                      dark: dark,
                      selectedSort: selectedSort,
                      onSortChanged: (value) => setState(() => selectedSort = value!),
                    ),
                  ],
                ),
              ),
            ),

            /// ==== LENDER LIST ====
            StreamBuilder<List<Map<String, dynamic>>>(
              stream: BorrowingService.getLendersStream(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: Padding(
                      padding: EdgeInsets.all(32.0),
                      child: CircularProgressIndicator(),
                    ),
                  );
                }

                final lenders = snapshot.data ?? [];
                return LenderListContainer(
                  dark: dark,
                  lenders: lenders,
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
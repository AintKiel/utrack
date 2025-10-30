import 'package:flutter/material.dart';
import 'package:utrack/common/widgets/custom_shapes/containers/primary_header_container.dart';
import 'package:utrack/common/widgets/appbar/homeAppBar.dart';
import 'package:utrack/features/app_pages/home/elements/financialHealth/financialHealth.dart';
import 'package:utrack/features/app_pages/home/elements/totalUTracks/totalUtangsBox.dart';
import '../../../common/widgets/profile/profile_card.dart';
import 'elements/alertelements/overdueAlert.dart';
import 'elements/recentAct/recentActivity.dart';

class HomePageScreen extends StatelessWidget {
  const HomePageScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      /// 👇 No background extension, appbar scrolls away naturally
      extendBodyBehindAppBar: true,

      /// Transparent AppBar that disappears when scrolling
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(kToolbarHeight),
        child: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          automaticallyImplyLeading: false,
          flexibleSpace: const SafeArea(
            child: UHomeAppBar(),
          ),
        ),
      ),

      /// --- Body content (scrollable)
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            /// --- Scrollable Content ---
            Column(
              children: [
                /// --- Blue Header Background ---
                const UPrimaryHeaderContainer(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 80), // 👈 reduced height (was 80)

                      /// Profile Card with Overlapping Alert
                      Stack(
                        clipBehavior: Clip.none,
                        children: [
                          ProfileCard(),

                          /// Payment Alert (e.g. OverdueAlert() / WarningAlert() / GoodCondition())
                          OverdueAlert(),
                          SizedBox(height: 100),
                        ],
                      ),
                    ],
                  ),
                ),

                /// --- Financial health Section ---
                Container(
                  width: double.infinity,
                  height: MediaQuery.of(context).size.height * 0.55,
                  decoration: const BoxDecoration(
                    color: Colors.transparent,
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),

                  child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    child: const Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: 20),
                        FinancialHealth(),
                        SizedBox(height: 20),
                        RecentActivity(),
                        SizedBox(height: 50),
                      ],
                    ),
                  ),
                ),
              ],
            ),

            /// --- Utang Summary Boxes (Overlapping Section) ---
            const Positioned(
              top: 80, // 👈 keep your preferred alignment
              left: 17,
              right: 17,
              child: UtangSummarySection(),
            ),
          ],
        ),
      ),
    );
  }
}

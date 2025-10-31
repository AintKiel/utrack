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

      extendBodyBehindAppBar: true,

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

        body: Stack(
          clipBehavior: Clip.none,
          children: [
            /// --- White scrollable section (FinancialHealth + RecentActivity only)
            Align(
              alignment: Alignment.bottomCenter,
              child: SizedBox(
                height: MediaQuery.of(context).size.height * 0.44, // 👈 adjust as needed
                child: Container(
                  width: double.infinity,
                  color: Colors.transparent,
                  padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
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
              ),
            ),


            /// --- Blue header + fixed items above ---
            const UPrimaryHeaderContainer(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 80),
                  Stack(
                    clipBehavior: Clip.none,
                    children: [
                      ProfileCard(),
                      OverdueAlert(),
                      SizedBox(height: 100),
                    ],
                  ),
                ],
              ),
            ),

            /// --- Utang summary section (floating overlap) ---
            const Positioned(
              top: 80,
              left: 17,
              right: 17,
              child: UtangSummarySection(),
            ),
          ],
        )
    );
  }
}

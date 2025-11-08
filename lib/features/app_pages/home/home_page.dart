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
    final size = MediaQuery.of(context).size;
    final isSmallScreen = size.width < 360; // e.g., small phones
    final isTablet = size.width > 600; // tablets

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

      body: LayoutBuilder(
        builder: (context, constraints) {
          final height = constraints.maxHeight;

          return Stack(
            clipBehavior: Clip.none,
            children: [
              /// --- Scrollable main content ---
              Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                  width: double.infinity,
                  height: 400,
                  padding: EdgeInsets.symmetric(
                    vertical: isSmallScreen ? 4 : 8,
                    horizontal: isSmallScreen ? 8 : 16,
                  ),
                  child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    child: const Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: 1),
                        FinancialHealth(),
                        SizedBox(height: 20),
                        RecentActivity(),
                        SizedBox(height: 50),
                      ],
                    ),
                  ),
                ),
              ),

              /// --- Blue header section ---
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

              /// --- Floating summary section ---
              Positioned(
                top: isSmallScreen ? 70 : 80,
                left: isSmallScreen ? 12 : 17,
                right: isSmallScreen ? 12 : 17,
                child: const UtangSummarySection(),
              ),
            ],
          );
        },
      ),
    );
  }
}

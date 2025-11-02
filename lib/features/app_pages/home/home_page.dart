import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:utrack/common/widgets/custom_shapes/containers/primary_header_container.dart';
import 'package:utrack/common/widgets/appbar/homeAppBar.dart';
import 'package:utrack/features/app_pages/home/elements/financialHealth/financialHealth.dart';
import 'package:utrack/features/app_pages/home/elements/totalUTracks/totalUtangsBox.dart';
import '../../../common/widgets/profile/profile_card.dart';
import 'elements/alertelements/overdueAlert.dart';
import 'elements/recentAct/recentActivity.dart';

class HomePageScreen extends StatefulWidget {
  const HomePageScreen({super.key});

  @override
  State<HomePageScreen> createState() => _HomePageScreenState();
}

class _HomePageScreenState extends State<HomePageScreen> {
  String userFirstName = 'User';
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchUserData();
  }

  Future<void> _fetchUserData() async {
    try {
      // Get current user from Firebase
      final user = FirebaseAuth.instance.currentUser;

      if (user != null) {
        // Get first name from displayName
        String firstName = user.displayName ?? 'User';

        // If displayName contains full name, extract first name
        if (firstName.contains(' ')) {
          firstName = firstName.split(' ')[0];
        }

        // Optionally: fetch additional user data from Firestore
        // final userDoc = await FirebaseFirestore.instance
        //     .collection('users')
        //     .doc(user.uid)
        //     .get();
        // final firstName = userDoc['firstName'] ?? 'User';

        setState(() {
          userFirstName = firstName;
          isLoading = false;
        });
      } else {
        setState(() {
          userFirstName = 'User';
          isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        userFirstName = 'User';
        isLoading = false;
      });
      print('Error fetching user data: $e');
    }
  }

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
              height: MediaQuery.of(context).size.height * 0.44,
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
          UPrimaryHeaderContainer(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 80),
                Stack(
                  clipBehavior: Clip.none,
                  children: [
                    // Pass the actual user first name here
                    ProfileCard(userFirstName: userFirstName),
                    const OverdueAlert(),
                    const SizedBox(height: 100),
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
      ),
    );
  }
}
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../features/app_pages/home/notif_screen.dart';
import '../../../utils/constants/colors.dart';
import '../../../utils/constants/text_strings.dart';
import '../notification/notif_widget.dart';
import 'appbar.dart';

class UHomeAppBar extends StatelessWidget implements PreferredSizeWidget {
  const UHomeAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return UAppBar(
      showLogo: true,
      backgroundColor: Colors.transparent,
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            UTexts.utrack,
            style: Theme.of(context)
                .textTheme
                .headlineSmall!
                .apply(color: UColors.white),
          ),
          Text(
            UTexts.utrackSubTitle,
            style: Theme.of(context)
                .textTheme
                .labelMedium!
                .apply(color: UColors.buttonDisabled),
          ),
        ],
      ),
      actions: [
        Notification_Widget(
          onPressed: () => Get.to(() => const UNotificationScreen()),
          iconColor: UColors.white,
        ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:utrack/utils/formatters/icons.dart';
import 'package:utrack/utils/themes/custom_themes/device_utility.dart';
import '../../../utils/constants/colors.dart';
import '../../../utils/constants/image_strings.dart';
import '../../../utils/formatters/images.dart';
import '../../../utils/helpers/helper_functions.dart';

class UAppBar extends StatelessWidget implements PreferredSizeWidget {
  const UAppBar({
    super.key,
    this.title,
    this.actions,
    this.leadingIcon,
    this.leadingOnPressed,
    this.showLogo = true,
    this.backgroundColor = UColors.primary,
    this.showBackArrow = false,
  });

  final Widget? title;
  final bool showBackArrow;
  final bool showLogo;
  final IconData? leadingIcon;
  final List<Widget>? actions;
  final Color backgroundColor;
  final VoidCallback? leadingOnPressed;

  @override
  Widget build(BuildContext context) {
    final dark = UHelperFunctions.isDarkMode(context);

    /// 👇 Wrap the AppBar inside a container with full background extension
    return Container(
      color: backgroundColor, // 👈 This color now extends behind the status bar
      child: SafeArea(
        top: false, // 👈 Allow the background to go behind the status bar
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 0),
          child: AppBar(
            backgroundColor: Colors.transparent, // 👈 Transparent so container color shows
            elevation: 0,
            automaticallyImplyLeading: false,
            leadingWidth: showLogo ? 10 : null,

            /// --- Leading Icon / Back Button ---
            leading: showBackArrow
                ? IconButton(
              onPressed: () => Get.back(),
              icon: UIcons.back(),
            )
                : leadingIcon != null
                ? IconButton(
              onPressed: leadingOnPressed,
              icon: UIcons.forward(),
            )
                : null,

            /// --- Title Section ---
            title: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                if (showLogo) ...[
                  Padding(
                    padding: const EdgeInsets.only(left: 0),
                    child: Image.asset(
                      UImages.lightAppLogo,
                      height: ULogoSizes.appLogoSmall,
                    ),
                  ),
                  const SizedBox(width: 2),
                ],
                if (title != null) title!,
              ],
            ),

            /// --- Action Buttons ---
            actions: actions,
          ),
        ),
      ),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(UDeviceUtility.getAppBarHeight());
}

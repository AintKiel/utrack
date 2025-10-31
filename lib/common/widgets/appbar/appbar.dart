import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:utrack/utils/formatters/icons.dart';
import 'package:utrack/utils/themes/custom_themes/device_utility.dart';
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
    this.backgroundColor = Colors.transparent,
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

    return AppBar(
      backgroundColor: backgroundColor,
      elevation: 0,
      surfaceTintColor: Colors.transparent,
      scrolledUnderElevation: 0,
      automaticallyImplyLeading: false,
      toolbarHeight: UDeviceUtility.getAppBarHeight(),
      leadingWidth: showLogo ? 10 : null,

      leading: showBackArrow
          ? IconButton(onPressed: () => Get.back(), icon: UIcons.back())
          : leadingIcon != null
          ? IconButton(onPressed: leadingOnPressed, icon: UIcons.forward())
          : null,

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
            const SizedBox(width: 4),
          ],
          if (title != null) title!,
        ],
      ),

      actions: actions,
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(UDeviceUtility.getAppBarHeight());
}

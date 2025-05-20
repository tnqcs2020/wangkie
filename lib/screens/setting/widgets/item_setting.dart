import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:iconsax/iconsax.dart';
import 'package:wangkie_app/common/app_images.dart';
import 'package:wangkie_app/common/app_sizes.dart';

class ItemSetting extends StatelessWidget {
  const ItemSetting({
    super.key,
    required this.title,
    required this.icon,
    this.actionWidget,
    this.onActionTap,
    required this.isDark,
    this.isDivider = true,
  });
  final String title;
  final IconData icon;
  final Widget? actionWidget;
  final VoidCallback? onActionTap;
  final bool isDark;
  final bool isDivider;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onActionTap,
      child: Container(
        constraints: BoxConstraints(minHeight: 50.h),
        width: double.infinity,
        color: Colors.transparent,
        padding: EdgeInsets.only(
          top: AppSizes.md,
          bottom: isDivider ? 0 : AppSizes.md,
        ),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: <Widget>[
                    icon == Icons.person
                        ? SvgPicture.asset(
                          AppImages.user,
                          width: AppSizes.iconLg,
                          colorFilter:
                              isDark
                                  ? ColorFilter.mode(
                                    Colors.white70,
                                    BlendMode.srcIn,
                                  )
                                  : ColorFilter.mode(
                                    Colors.black,
                                    BlendMode.srcIn,
                                  ),
                        )
                        : Icon(
                          icon,
                          size: AppSizes.iconLg,
                          color: isDark ? Colors.white70 : Colors.black,
                        ),
                    SizedBox(width: AppSizes.spaceBtwItems),
                    Text(
                      title,
                      style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                        color: isDark ? Colors.white70 : Colors.black,
                      ),
                    ),
                  ],
                ),
                if (icon == Iconsax.logout5)
                  SizedBox.shrink()
                else if (actionWidget != null)
                  actionWidget!
                else if (onActionTap != null)
                  GestureDetector(
                    onTap: onActionTap!,
                    child: Icon(
                      Iconsax.arrow_right_3,
                      size: AppSizes.iconSm,
                      color: isDark ? Colors.white70 : Colors.black,
                    ),
                  ),
              ],
            ),
            if (isDivider)
              Padding(
                padding: EdgeInsets.only(top: AppSizes.md),
                child: Divider(
                  color:
                      isDark
                          ? Colors.white.withValues(alpha: 0.15)
                          : Colors.black.withValues(alpha: 0.15),
                  indent: AppSizes.iconLg + AppSizes.spaceBtwItems,
                  height: (0.1).h,
                ),
              ),
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:wangkie_app/common/app_images.dart';
import 'package:wangkie_app/common/app_sizes.dart';
import 'package:wangkie_app/l10n/app_localizations.dart';

class LoginHeader extends StatelessWidget {
  const LoginHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Image(
          height: 100.h,
          image: AssetImage(AppImages.appLogo),
          fit: BoxFit.contain,
        ),
        SizedBox(height: AppSizes.spaceBtwItems),
        Text(
          AppLocalizations.of(context)!.loginTitle,
          style: Theme.of(
            context,
          ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
        ),
        Text(
          AppLocalizations.of(context)!.loginSubTitle,
          style: Theme.of(context).textTheme.bodyLarge,
        ),
      ],
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:wangkie_app/common/app_images.dart';
import 'package:wangkie_app/common/app_sizes.dart';
import 'package:wangkie_app/l10n/app_localizations.dart';
import 'package:wangkie_app/screens/register/widgets/register_form.dart';

class RegisterScreen extends StatelessWidget {
  const RegisterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        body: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              physics: BouncingScrollPhysics(),
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: constraints.maxHeight),
                child: Container(
                  padding: EdgeInsets.all(AppSizes.xl),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Image(
                        height: 85.h,
                        image: AssetImage(AppImages.appLogo),
                        fit: BoxFit.contain,
                      ),
                      SizedBox(height: AppSizes.smallSpace),
                      Text(
                        AppLocalizations.of(context)!.signupTitle,
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: AppSizes.smallSpace),
                      RegisterForm(),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

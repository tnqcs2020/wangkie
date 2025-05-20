import 'package:flutter/material.dart';
import 'package:wangkie_app/common/app_sizes.dart';
import 'package:wangkie_app/common/widgets/custom_divider.dart';
import 'package:wangkie_app/l10n/app_localizations.dart';
import 'package:wangkie_app/screens/login/widgets/login_form.dart';
import 'package:wangkie_app/screens/login/widgets/method_login.dart';
import 'package:wangkie_app/screens/login/widgets/login_header.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
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
                  // color: Colors.black12,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      LoginHeader(),
                      SizedBox(height: AppSizes.spaceBtwSections),
                      LoginForm(),
                      SizedBox(height: AppSizes.spaceBtwSections),
                      CustomDivider(text: AppLocalizations.of(context)!.orSignInWith),
                      SizedBox(height: AppSizes.spaceBtwSections),
                      MethodLogin(),
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

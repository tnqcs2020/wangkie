import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:iconsax/iconsax.dart';
import 'package:wangkie_app/common/app_colors.dart';
import 'package:wangkie_app/common/app_sizes.dart';
import 'package:wangkie_app/common/cubits/auth_cubit.dart';
import 'package:wangkie_app/common/widgets/custom_textformfield.dart';
import 'package:wangkie_app/models/data_response_model.dart';
import 'package:wangkie_app/l10n/app_localizations.dart';

class LoginForm extends StatefulWidget {
  const LoginForm({super.key});

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final _emailCtrl = TextEditingController();
  final _passCtrl = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          CustomTextFormField(
            controller: _emailCtrl,
            labelText: AppLocalizations.of(context)!.email,
            prefixIcon: Iconsax.direct_right,
            validator: (value) {
              if (value!.length < 8) {
                return AppLocalizations.of(context)!.passShort;
              }
              return null;
            },
          ),
          // SizedBox(height: AppSizes.spaceBtwInputFields),
          CustomTextFormField(
            controller: _passCtrl,
            labelText: AppLocalizations.of(context)!.password,
            prefixIcon: Iconsax.password_check,
            isPass: true,
            validator: (value) {
              if (value!.length < 8) {
                return AppLocalizations.of(context)!.passShort;
              }
              return null;
            },
          ),
          // SizedBox(height: AppSizes.spaceBtwInputFields),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              GestureDetector(
                onTap: () {},
                child: Text(
                  AppLocalizations.of(context)!.forgetPassword,
                  style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                    color: AppColors.primary,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: AppSizes.spaceBtwSections),
          SizedBox(
            width: double.infinity,
            height: AppSizes.buttonHeight,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                elevation: AppSizes.buttonElevation,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppSizes.borderRadiusMd),
                ),
              ),
              onPressed: () async {
                if (_emailCtrl.text.isNotEmpty || _passCtrl.text.isNotEmpty) {
                  if (_formKey.currentState!.validate()) {
                    final DataResponseModel resData = await context
                        .read<AuthCubit>()
                        .login(_emailCtrl.text, _passCtrl.text);
                    if (context.read<AuthCubit>().state.isAuthenticated) {
                      context.go('/home');
                    } else {
                      Flushbar(
                        margin: EdgeInsets.all(8.w),
                        borderRadius: BorderRadius.circular(8.r),
                        message: resData.message,
                        icon: Icon(
                          resData.success
                              ? Iconsax.tick_circle
                              : Icons.info_outline,
                          size: AppSizes.iconLg,
                          color: resData.success ? Colors.green : Colors.red,
                        ),
                        duration: Duration(seconds: 3),
                      ).show(context);
                    }
                  }
                } else {
                  Flushbar(
                    margin: EdgeInsets.all(8.w),
                    borderRadius: BorderRadius.circular(8.r),
                    message: AppLocalizations.of(context)!.errorLoginEmpty,
                    icon: Icon(
                      Icons.info_outline,
                      size: AppSizes.iconLg,
                      color: Colors.red,
                    ),
                    duration: Duration(seconds: 3),
                  ).show(context);
                }
              },
              child: Text(
                AppLocalizations.of(context)!.signIn,
                style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ),
          SizedBox(height: AppSizes.spaceBtwItems),
          SizedBox(
            width: double.infinity,
            height: AppSizes.buttonHeight,
            child: OutlinedButton(
              style: OutlinedButton.styleFrom(
                foregroundColor: Colors.black87,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppSizes.borderRadiusMd),
                ),
                side: BorderSide(color: Colors.grey.shade400, width: 1),
              ),
              onPressed: () => context.go('/register'),
              child: Text(
                AppLocalizations.of(context)!.createAccount,
                style: Theme.of(
                  context,
                ).textTheme.bodyLarge!.copyWith(fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

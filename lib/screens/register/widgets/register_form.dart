import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:iconsax/iconsax.dart';
import 'package:wangkie_app/common/app_colors.dart';
import 'package:wangkie_app/common/app_sizes.dart';
import 'package:wangkie_app/common/cubits/auth_cubit.dart';
import 'package:wangkie_app/common/widgets/custom_divider.dart';
import 'package:wangkie_app/common/widgets/custom_textformfield.dart';
import 'package:wangkie_app/l10n/app_localizations.dart';
import 'package:wangkie_app/models/data_response_model.dart';
import 'package:wangkie_app/models/user_model.dart';

class RegisterForm extends StatefulWidget {
  const RegisterForm({super.key});

  @override
  State<RegisterForm> createState() => _RegisterFormState();
}

class _RegisterFormState extends State<RegisterForm> {
  final _emailCtrl = TextEditingController();
  final _passCtrl = TextEditingController();
  final _repassCtrl = TextEditingController();
  final _nameCtrl = TextEditingController();
  final _phoneCtrl = TextEditingController();
  final _dobCtrl = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          CustomDivider(text: AppLocalizations.of(context)!.required),
          SizedBox(height: AppSizes.smallSpace),
          CustomTextFormField(
            controller: _nameCtrl,
            labelText: AppLocalizations.of(context)!.fullName,
            prefixIcon: Iconsax.user,
            validator: (value) {
              if (value!.length < 8) {
                return AppLocalizations.of(context)!.passShort;
              }
              return null;
            },
          ),
          SizedBox(height: AppSizes.spaceBtwInputFields),
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
          SizedBox(height: AppSizes.spaceBtwInputFields),
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
          SizedBox(height: AppSizes.spaceBtwInputFields),
          CustomTextFormField(
            controller: _repassCtrl,
            labelText: AppLocalizations.of(context)!.rePassword,
            prefixIcon: Iconsax.password_check,
            isPass: true,
            validator: (value) {
              if (value!.length < 8) {
                return AppLocalizations.of(context)!.passShort;
              } else if (value != _passCtrl.text) {
                return AppLocalizations.of(context)!.passNoMatch;
              }
              return null;
            },
          ),
          SizedBox(height: AppSizes.spaceBtwInputFields),
          CustomDivider(text: AppLocalizations.of(context)!.optional),
          SizedBox(height: AppSizes.smallSpace),
          CustomTextFormField(
            controller: _phoneCtrl,
            labelText: AppLocalizations.of(context)!.phoneNo,
            prefixIcon: Iconsax.call,
            validator: (value) {
              // if (value!.length < 10) {
              //   return AppLocalizations.of(context)!.passShort;
              // } else if (value != _passCtrl.text) {
              //   return AppLocalizations.of(context)!.passNoMatch;
              // }
              return null;
            },
          ),
          SizedBox(height: AppSizes.spaceBtwInputFields),
          CustomTextFormField(
            controller: _dobCtrl,
            labelText: AppLocalizations.of(context)!.dateOfBirth,
            prefixIcon: Iconsax.calendar,
            validator: (value) {
              return null;
            },
          ),
          SizedBox(height: AppSizes.spaceBtwSections * 1.5),
          SizedBox(
            width: double.infinity,
            height: AppSizes.buttonHeight,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                // foregroundColor: Colors.white,
                elevation: AppSizes.buttonElevation,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppSizes.borderRadiusMd),
                ),
              ),
              onPressed: () async {
                if (_emailCtrl.text.isNotEmpty ||
                    _nameCtrl.text.isNotEmpty ||
                    _passCtrl.text.isNotEmpty ||
                    _repassCtrl.text.isNotEmpty) {
                  if (_formKey.currentState!.validate()) {
                    final user = UserModel(
                      email: _emailCtrl.text,
                      fullName: _nameCtrl.text,
                      phoneNumber: _phoneCtrl.text,
                      dateOfBirth: _dobCtrl.text,
                      avatarUrl: "",
                    );
                    final DataResponseModel resData = await context
                        .read<AuthCubit>()
                        .register(user, _passCtrl.text);
                    if (context.read<AuthCubit>().state.isAuthenticated) {
                      context.go('/home');
                    } else {
                      Flushbar(
                        margin: EdgeInsets.all(8.w),
                        borderRadius: BorderRadius.circular(8.r),
                        message: resData.message,
                        icon: Icon(
                          Icons.info_outline,
                          size: AppSizes.iconLg,
                          color: Colors.red,
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
                AppLocalizations.of(context)!.register,
                style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ),
          SizedBox(height: AppSizes.spaceBtwSections),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                AppLocalizations.of(context)!.haveAccount,
                style: Theme.of(context).textTheme.bodyLarge,
              ),
              GestureDetector(
                onTap: () => context.go('/login'),
                child: Text(
                  AppLocalizations.of(context)!.signIn,
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: AppColors.primary,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

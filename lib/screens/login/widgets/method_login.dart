import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:wangkie_app/common/app_images.dart';
import 'package:wangkie_app/common/app_sizes.dart';
import 'package:wangkie_app/common/cubits/auth_cubit.dart';
import 'package:wangkie_app/models/data_response_model.dart';

class MethodLogin extends StatelessWidget {
  const MethodLogin({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey.shade300),
            borderRadius: BorderRadius.circular(100.r),
          ),
          child: IconButton(
            onPressed: () async {
              final DataResponseModel resData =
                  await context.read<AuthCubit>().loginGoogle();
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
                    color: resData.success ? Colors.green : Colors.red,
                  ),
                  duration: Duration(seconds: 3),
                ).show(context);
              }
            },
            icon: Image(
              width: AppSizes.iconLg,
              height: AppSizes.iconLg,
              image: AssetImage(AppImages.googleLogo),
            ),
          ),
        ),
        SizedBox(width: AppSizes.spaceBtwItems),
        Container(
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey.shade300),
            borderRadius: BorderRadius.circular(100.r),
          ),
          child: IconButton(
            onPressed: () {},
            icon: Image(
              width: AppSizes.iconLg,
              height: AppSizes.iconLg,
              image: AssetImage(
                Theme.of(context).brightness == Brightness.dark
                    ? AppImages.appleDark
                    : AppImages.appleLight,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

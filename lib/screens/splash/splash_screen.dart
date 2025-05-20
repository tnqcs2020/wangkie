import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:wangkie_app/common/app_sizes.dart';
import 'package:wangkie_app/common/cubits/auth_cubit.dart';
import 'package:wangkie_app/utils/user_save.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _checkLogin();
  }

  Future<void> _checkLogin() async {
    Map<String, dynamic>? userInfo = await loadAuthState();
    if (userInfo != null) {
      final res = await context.read<AuthCubit>().loginToken(
        userInfo['email'],
        userInfo['token'],
      );
      final expired = res['expired'];

      if (expired) {
        context.go('/login');
        Flushbar(
          margin: EdgeInsets.all(8.w),
          borderRadius: BorderRadius.circular(8.r),
          message: 'Phiên đăng nhập đã hết hạn. Vui lòng đăng nhập lại.',
          icon: Icon(
            Icons.info_outline,
            size: AppSizes.iconLg,
            color: Colors.red,
          ),
          duration: Duration(seconds: 3),
        ).show(context);
      } else {
        final resData = res['resData'];
        if (resData.success) {
          context.go('/home');
        } else {
          Flushbar(
            margin: EdgeInsets.all(8),
            borderRadius: BorderRadius.circular(8),
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
      context.go('/login');
    }
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(body: Center(child: CircularProgressIndicator()));
  }
}

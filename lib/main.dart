import 'package:device_preview/device_preview.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:wangkie_app/common/app_colors.dart';
import 'package:wangkie_app/common/app_navigation.dart';
import 'package:wangkie_app/common/app_sizes.dart';
import 'package:wangkie_app/common/cubits/language_cubit.dart';
import 'package:wangkie_app/firebase_options.dart';
import 'package:wangkie_app/l10n/app_localizations.dart';
import 'common/cubits/theme_cubit.dart';
import 'common/cubits/auth_cubit.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(statusBarColor: Colors.blueAccent),
  );
  runApp(
    DevicePreview(
      enabled: !kReleaseMode,
      // enabled: false,
      builder:
          (context) => ScreenUtilInit(
            designSize: Size(428, 926),
            minTextAdapt: true,
            splitScreenMode: true,
            builder:
                (context, child) => MultiBlocProvider(
                  providers: [
                    BlocProvider(create: (_) => ThemeCubit()),
                    BlocProvider(create: (_) => AuthCubit()),
                    BlocProvider(create: (_) => LanguageCubit()),
                  ],
                  child: const MyApp(),
                ),
          ),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LanguageCubit, Locale>(
      builder: (context, locale) {
        return BlocBuilder<ThemeCubit, ThemeMode>(
          builder: (context, themeMode) {
            return MaterialApp.router(
              routerConfig: AppNavigation.router,
              theme: ThemeData(
                colorScheme: ColorScheme.light(primary: AppColors.primary),
                textTheme: AppSizes.scaledTextTheme(
                  ThemeData.light().textTheme,
                ),
                useMaterial3: true,
              ),
              darkTheme: ThemeData(
                colorScheme: ColorScheme.dark(
                  primary: AppColors.secondary,
                  secondary: AppColors.secondary,
                ),
                textTheme: AppSizes.scaledTextTheme(ThemeData.dark().textTheme),
                scaffoldBackgroundColor: Colors.black,
                useMaterial3: true,
              ),
              themeMode: themeMode,
              debugShowCheckedModeBanner: false,
              locale: locale,
              localizationsDelegates: AppLocalizations.localizationsDelegates,
              supportedLocales: AppLocalizations.supportedLocales,
            );
          },
        );
      },
    );
  }
}

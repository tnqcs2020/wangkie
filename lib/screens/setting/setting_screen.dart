import 'package:animated_toggle_switch/animated_toggle_switch.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:iconsax/iconsax.dart';
import 'package:wangkie_app/common/app_colors.dart';
import 'package:wangkie_app/common/app_sizes.dart';
import 'package:wangkie_app/common/cubits/auth_cubit.dart';
import 'package:wangkie_app/common/cubits/language_cubit.dart';
import 'package:wangkie_app/common/cubits/theme_cubit.dart';
import 'package:wangkie_app/common/widgets/custom_show_alert_dialog.dart';
import 'package:wangkie_app/l10n/app_localizations.dart';
import 'package:wangkie_app/models/user_model.dart';
import 'package:wangkie_app/screens/setting/widgets/item_setting.dart';

class SettingScreen extends StatefulWidget {
  const SettingScreen({super.key});

  @override
  State<SettingScreen> createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {
  bool isDark() {
    return Theme.of(context).brightness == Brightness.dark;
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        constraints: BoxConstraints(
          minHeight: double.infinity,
          minWidth: double.infinity,
        ),
        child: SingleChildScrollView(
          padding: EdgeInsets.fromLTRB(
            AppSizes.xl,
            AppSizes.md,
            AppSizes.xl,
            AppSizes.xl,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              BlocBuilder<AuthCubit, AuthState>(
                builder: (context, userState) {
                  if (userState.isAuthenticated && userState.user != null) {
                    final UserModel user = userState.user!;
                    return Center(
                      child: Column(
                        children: [
                          CircleAvatar(
                            radius: 50,
                            backgroundColor: Colors.blueGrey.shade300,
                            child:
                                user.avatarUrl! != ""
                                    ? ClipRRect(
                                      borderRadius: BorderRadius.circular(50),
                                      child: Image.network(
                                        user.avatarUrl!,
                                        fit: BoxFit.none,
                                        scale: 0.8,
                                      ),
                                    )
                                    : Icon(
                                      Iconsax.gallery_slash5,
                                      size: AppSizes.iconLg,
                                      color:
                                          isDark()
                                              ? Colors.white70
                                              : Colors.black,
                                    ),
                          ),
                          SizedBox(height: AppSizes.smallSpace),
                          Text(
                            user.fullName,
                            style: Theme.of(
                              context,
                            ).textTheme.headlineSmall!.copyWith(
                              color: isDark() ? Colors.white70 : Colors.black,
                            ),
                          ),
                        ],
                      ),
                    );
                  }
                  return SizedBox.shrink();
                },
              ),
              SizedBox(height: AppSizes.spaceBtwSections),
              Container(
                padding: EdgeInsets.fromLTRB(AppSizes.md, 0, AppSizes.md, 0),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(AppSizes.cardRadiusMd),
                  color:
                      isDark()
                          ? Colors.blueGrey.withValues(alpha: 0.3)
                          : Colors.grey.withValues(alpha: 0.3),
                ),
                child: Column(
                  children: [
                    ItemSetting(
                      title: AppLocalizations.of(context)!.profile,
                      icon: Icons.person,
                      onActionTap: () {
                        context.push('/profile');
                      },
                      isDark: isDark(),
                    ),
                    ItemSetting(
                      title: AppLocalizations.of(context)!.darkMode,
                      icon: Icons.brightness_4,
                      onActionTap:
                          () => context.read<ThemeCubit>().toggleTheme(),
                      actionWidget: SizedBox(
                        width: 50.w,
                        child: AnimatedToggleSwitch<bool>.dual(
                          current:
                              context.read<ThemeCubit>().state ==
                              ThemeMode.dark,
                          first: false,
                          second: true,
                          spacing: 0.w,
                          style: ToggleStyle(
                            backgroundColor:
                                isDark() ? Colors.green : Colors.grey.shade400,
                            borderColor:
                                isDark() ? Colors.green : Colors.grey.shade400,
                            indicatorColor: Colors.transparent,
                            borderRadius: BorderRadius.circular(100.0),
                          ),
                          height: 26.w,
                          iconBuilder:
                              (value) => CircleAvatar(
                                backgroundColor:
                                    isDark()
                                        ? Colors.grey.shade300
                                        : Colors.white,
                                radius: 35.r,
                              ),
                          onChanged:
                              (value) =>
                                  context.read<ThemeCubit>().toggleTheme(),
                        ),
                      ),
                      isDark: isDark(),
                    ),
                    ItemSetting(
                      title: AppLocalizations.of(context)!.language,
                      icon: Iconsax.translate5,
                      onActionTap:
                          () => context.read<LanguageCubit>().changeLanguage(),
                      actionWidget: SizedBox(
                        width: 80.w,
                        child: AnimatedToggleSwitch<bool>.dual(
                          current:
                              context.read<LanguageCubit>().state ==
                              Locale('en'),
                          first: true,
                          second: false,
                          spacing: 0.w,
                          style: ToggleStyle(
                            backgroundColor: Colors.grey.shade400,
                            borderColor: Colors.grey.shade400,
                            indicatorColor:
                                isDark() ? Colors.green : AppColors.primary,
                            borderRadius: BorderRadius.circular(100.0),
                          ),
                          height: 31.w,
                          iconBuilder:
                              (value) => Text(
                                value
                                    ? AppLocalizations.of(context)!.englishShort
                                    : AppLocalizations.of(
                                      context,
                                    )!.vietnameseShort,
                                style: Theme.of(
                                  context,
                                ).textTheme.bodySmall!.copyWith(
                                  color: Colors.white.withValues(alpha: 0.9),
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                          textBuilder:
                              (value) => Text(
                                !value
                                    ? AppLocalizations.of(context)!.englishShort
                                    : AppLocalizations.of(
                                      context,
                                    )!.vietnameseShort,
                                style: Theme.of(
                                  context,
                                ).textTheme.bodySmall!.copyWith(
                                  color: Colors.black.withValues(alpha: 0.7),
                                ),
                              ),
                          onChanged:
                              (value) =>
                                  context
                                      .read<LanguageCubit>()
                                      .changeLanguage(),
                        ),
                      ),
                      isDark: isDark(),
                    ),
                    ItemSetting(
                      title: AppLocalizations.of(context)!.logout,
                      icon: Iconsax.logout5,
                      onActionTap: () {
                        customShowDialog(
                          context: context,
                          title: AppLocalizations.of(context)!.confirmLogout,
                          content:
                              AppLocalizations.of(context)!.areYouSureLogout,
                          actionText: AppLocalizations.of(context)!.logout,
                          onAction: () {
                            context.read<AuthCubit>().logout();
                            context.go('/login');
                          },
                        );
                      },
                      isDark: isDark(),
                      isDivider: false,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

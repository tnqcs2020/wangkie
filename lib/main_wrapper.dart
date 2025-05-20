import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:iconsax/iconsax.dart';
import 'package:wangkie_app/common/app_sizes.dart';
import 'package:wangkie_app/l10n/app_localizations.dart';

class MainWrapper extends StatefulWidget {
  const MainWrapper({super.key, required this.navigationShell});
  final StatefulNavigationShell navigationShell;
  @override
  State<MainWrapper> createState() => _MainWrapperState();
}

class _MainWrapperState extends State<MainWrapper> {
  int _currentIndex = 0;
  void _goToBranch(int index) {
    widget.navigationShell.goBranch(
      index,
      initialLocation: index == widget.navigationShell.currentIndex,
    );
  }

  bool isDark() {
    return Theme.of(context).brightness == Brightness.dark;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      body: SizedBox(
        height: double.infinity - 80.h,
        width: double.infinity,
        child: widget.navigationShell,
      ),
      bottomNavigationBar: MediaQuery.removePadding(
        context: context,
        removeBottom: true,
        child: Container(
          height: 80.h,
          decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                color: Colors.black38,
                blurRadius: 5,
                offset: Offset(0, 3),
              ),
            ],
          ),
          child: BottomNavigationBar(
            currentIndex: _currentIndex,
            onTap: (index) {
              setState(() => _currentIndex = index);
              _goToBranch(_currentIndex);
            },
            iconSize: AppSizes.iconLg,
            backgroundColor:
                isDark() ? Colors.grey.shade900 : Colors.grey.shade100,
            unselectedFontSize:
                Theme.of(context).textTheme.bodySmall!.fontSize!,
            selectedFontSize: Theme.of(context).textTheme.titleSmall!.fontSize!,
            type: BottomNavigationBarType.fixed,
            items: [
              BottomNavigationBarItem(
                icon: Icon(
                  _currentIndex == 0
                      ? Iconsax.home_trend_up5
                      : Iconsax.home_trend_up,
                ),
                label: AppLocalizations.of(context)!.home,
              ),
              BottomNavigationBarItem(
                icon: Icon(
                  _currentIndex == 1 ? Iconsax.category5 : Iconsax.category4,
                ),
                label: AppLocalizations.of(context)!.more,
              ),
              BottomNavigationBarItem(
                icon: Padding(
                  padding: EdgeInsets.only(
                    right: _currentIndex == 2 ? 30.w : 0.w,
                  ),
                  child: Icon(
                    _currentIndex == 2 ? Iconsax.setting_25 : Iconsax.setting_2,
                  ),
                ),
                label: AppLocalizations.of(context)!.settings,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

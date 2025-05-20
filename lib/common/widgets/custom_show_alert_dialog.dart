import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show defaultTargetPlatform;
import 'package:go_router/go_router.dart';
import 'package:wangkie_app/common/app_colors.dart';
import 'package:wangkie_app/l10n/app_localizations.dart';

void customShowDialog({
  required BuildContext context,
  required String title,
  required String content,
  required String actionText,
  required VoidCallback onAction,
}) {
  bool isDark() {
    return Theme.of(context).brightness == Brightness.dark;
  }

  showAdaptiveDialog(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) {
      if (defaultTargetPlatform == TargetPlatform.android) {
        return AlertDialog(
          backgroundColor: isDark() ? Colors.blueGrey.shade900 : Colors.white,
          title: Text(title, style: Theme.of(context).textTheme.headlineSmall),
          content: Text(content, style: Theme.of(context).textTheme.bodyLarge),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                context.pop();
              },
              child: Text(
                AppLocalizations.of(context)!.cancel,
                style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                  color: isDark() ? Colors.green.shade300 : AppColors.primary,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            TextButton(
              onPressed: onAction,
              child: Text(
                actionText,
                style: Theme.of(
                  context,
                ).textTheme.bodyLarge!.copyWith(color: Colors.red.shade300),
              ),
            ),
          ],
        );
      } else {
        return CupertinoAlertDialog(
          title: Text(title),
          content: Text(content),
          actions: <Widget>[
            CupertinoDialogAction(
              onPressed: () {
                context.pop();
              },
              child: Text(
                AppLocalizations.of(context)!.cancel,
                style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                  color: isDark() ? Colors.green.shade300 : AppColors.primary,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            CupertinoDialogAction(
              onPressed: onAction,
              child: Text(
                actionText,
                style: Theme.of(
                  context,
                ).textTheme.bodyLarge!.copyWith(color: Colors.red.shade300),
              ),
            ),
          ],
        );
      }
    },
  );
}

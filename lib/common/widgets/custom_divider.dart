import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomDivider extends StatelessWidget {
  final String text;
  const CustomDivider({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Flexible(
          child: Divider(
            color: Colors.grey,
            thickness: 0.5.h,
            indent: 40.h,
            endIndent: 10.h,
          ),
        ),
        Text(text, style: Theme.of(context).textTheme.bodyMedium),
        Flexible(
          child: Divider(
            color: Colors.grey,
            thickness: 0.5.h,
            indent: 10.h,
            endIndent: 40.h,
          ),
        ),
      ],
    );
  }
}

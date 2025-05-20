import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:wangkie_app/common/app_colors.dart';
import 'package:wangkie_app/common/app_sizes.dart';

class CustomTextFormField extends StatefulWidget {
  const CustomTextFormField({
    super.key,
    this.controller,
    required this.labelText,
    this.isPass = false,
    this.validator,
    this.prefixIcon,
    this.initialValue,
  });
  final TextEditingController? controller;
  final String labelText;
  final bool? isPass;
  final String? Function(String?)? validator;
  final IconData? prefixIcon;
  final String? initialValue;

  @override
  State<CustomTextFormField> createState() => _CustomTextFormFieldState();
}

class _CustomTextFormFieldState extends State<CustomTextFormField> {
  bool isObscured = true;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return SizedBox(
      height: AppSizes.fieldHeight,
      child: TextFormField(
        controller: widget.controller,
        readOnly: widget.controller == null,
        initialValue: widget.controller == null ? widget.initialValue : null,
        enabled: widget.controller != null,
        decoration:
            widget.controller != null
                ? InputDecoration(
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey.shade400),
                    borderRadius: BorderRadius.circular(
                      AppSizes.borderRadiusMd,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: isDark ? AppColors.secondary : AppColors.primary,
                    ),
                    borderRadius: BorderRadius.circular(
                      AppSizes.borderRadiusMd,
                    ),
                  ),
                  errorBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.red.shade900),
                    borderRadius: BorderRadius.circular(
                      AppSizes.borderRadiusMd,
                    ),
                  ),
                  focusedErrorBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.red.shade900),
                    borderRadius: BorderRadius.circular(
                      AppSizes.borderRadiusMd,
                    ),
                  ),
                  prefixIcon:
                      widget.prefixIcon != null
                          ? Icon(
                            widget.prefixIcon,
                            size: AppSizes.iconSm,
                            color: isDark ? Colors.white70 : Colors.black,
                          )
                          : null,
                  labelText: widget.labelText,
                  labelStyle: TextStyle(
                    color: isDark ? Colors.white70 : Colors.black,
                  ),
                  floatingLabelStyle:
                      widget.validator != null &&
                              widget.validator!(widget.controller!.text) != null
                          ? TextStyle(color: Colors.red.shade900)
                          : TextStyle(
                            color: isDark ? Colors.white70 : Colors.black,
                          ),
                  suffixIcon:
                      widget.isPass!
                          ? IconButton(
                            icon: Icon(
                              isObscured ? Iconsax.eye_slash : Iconsax.eye,
                              size: AppSizes.iconSm,
                              color: isDark ? Colors.white70 : Colors.black,
                            ),
                            onPressed: () {
                              setState(() {
                                isObscured = !isObscured;
                              });
                            },
                          )
                          : null,
                  helperText: ' ',
                )
                : InputDecoration(
                  labelText: widget.labelText,
                  labelStyle: TextStyle(
                    color: isDark ? Colors.white70 : Colors.black,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(
                      AppSizes.borderRadiusMd,
                    ),
                  ),
                  filled: true,
                  fillColor: isDark ? Colors.white24 : Colors.grey[300],
                  prefixIcon:
                      widget.prefixIcon != null
                          ? Icon(widget.prefixIcon, size: AppSizes.iconSm)
                          : null,
                ),
        style: TextStyle(color: isDark ? Colors.white70 : Colors.black),
        obscureText: widget.isPass! && isObscured,
        validator: widget.validator,
        autovalidateMode: AutovalidateMode.onUserInteraction,
      ),
    );
  }
}

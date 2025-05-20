import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:iconsax/iconsax.dart';
import 'package:image_picker/image_picker.dart';
import 'package:wangkie_app/common/app_colors.dart';
import 'package:wangkie_app/common/app_sizes.dart';
import 'package:wangkie_app/common/cubits/auth_cubit.dart';
import 'package:wangkie_app/common/widgets/custom_textformfield.dart';
import 'package:wangkie_app/l10n/app_localizations.dart';
import 'package:wangkie_app/models/data_response_model.dart';
import 'package:wangkie_app/models/user_model.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  TextEditingController? _fullNameCtrl;
  TextEditingController? _phoneNumberCtrl;
  TextEditingController? _dateOfBirthCtrl;
  TextEditingController? _avatarUrlCtrl;
  late UserModel user;
  // bool _showBackButton = false;

  @override
  void initState() {
    super.initState();
    final authState = context.read<AuthCubit>().state;
    if (authState.isAuthenticated && authState.user != null) {
      user = authState.user!;
      _fullNameCtrl = TextEditingController(text: user.fullName);
      _phoneNumberCtrl = TextEditingController(text: user.phoneNumber);
      _dateOfBirthCtrl = TextEditingController(text: user.dateOfBirth);
      _avatarUrlCtrl = TextEditingController(text: user.avatarUrl);
    }
  }

  @override
  void dispose() {
    _fullNameCtrl!.dispose();
    _phoneNumberCtrl!.dispose();
    _dateOfBirthCtrl!.dispose();
    _avatarUrlCtrl!.dispose();
    super.dispose();
  }

  Future<void> _pickAvatar(ImageSource source) async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: source, imageQuality: 80);
    if (pickedFile != null) {
      setState(() {
        // _avatarUrl = File(pickedFile.path);
      });
    }
  }

  void _showPopupMenu(BuildContext context, Offset offset) async {
    final RenderBox overlay =
        Overlay.of(context).context.findRenderObject() as RenderBox;
    await showMenu(
      context: context,
      position: RelativeRect.fromRect(
        Rect.fromPoints(offset, offset),
        Offset.zero & overlay.size,
      ),
      items: [
        PopupMenuItem(value: 'gallery', child: Text('Chọn từ thư viện')),
        PopupMenuItem(value: 'camera', child: Text('Chụp ảnh')),
      ],
      elevation: 8.0,
    ).then((value) {
      if (value == 'gallery') {
        _pickAvatar(ImageSource.gallery);
      } else if (value == 'camera') {
        _pickAvatar(ImageSource.camera);
      }
    });
  }

  // void _saveProfile() {
  //   String? avatarUrl = context.read<AuthCubit>().state.user?.avatarUrl;
  // if (_avatarUrl != null) {
  //   final uploadedUrl = await _uploadAvatar(_selectedImage!);
  //   if (uploadedUrl != null) {
  //     avatarUrl = uploadedUrl;
  //   }
  // }

  // final updatedUser = UserModel(
  //   email: context.read<AuthCubit>().state.user!.email,
  //   fullName: _fullNameController.text,
  //   phoneNumber: _phoneNumberController.text,
  //   dateOfBirth: _dateOfBirthController.text,
  //   avatarUrl: avatarUrl,
  // );

  // context.read<AuthCubit>().updateProfile(updatedUser);
  // }

  @override
  Widget build(BuildContext context) {
    bool isDark = Theme.of(context).brightness == Brightness.dark;
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        body: SafeArea(
          child: SingleChildScrollView(
            padding: EdgeInsets.fromLTRB(
              AppSizes.xl,
              0,
              AppSizes.xl,
              AppSizes.xl,
            ),
            child: BlocBuilder<AuthCubit, AuthState>(
              builder: (context, userState) {
                if (userState.isAuthenticated && userState.user != null) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          GestureDetector(
                            onTap: () => context.pop(),
                            child: Icon(
                              Iconsax.arrow_left_2,
                              size: AppSizes.iconLg,
                              color:
                                  isDark
                                      ? AppColors.secondary
                                      : AppColors.primary,
                              weight: 10,
                              grade: 10,
                            ),
                          ),
                          GestureDetector(
                            onTap: () async {
                              setState(() {
                                user.fullName = _fullNameCtrl!.text;
                                user.phoneNumber = _phoneNumberCtrl!.text;
                                user.dateOfBirth = _dateOfBirthCtrl!.text;
                                user.avatarUrl = "";
                              });
                              final DataResponseModel resData = await context
                                  .read<AuthCubit>()
                                  .updateProfile(user);
                              Flushbar(
                                margin: EdgeInsets.all(8.w),
                                borderRadius: BorderRadius.circular(8.r),
                                message: resData.message,
                                icon: Icon(
                                  resData.success
                                      ? Iconsax.tick_circle
                                      : Icons.info_outline,
                                  size: AppSizes.iconLg,
                                  color:
                                      resData.success
                                          ? Colors.green
                                          : Colors.red,
                                ),
                                duration: Duration(seconds: 3),
                              ).show(context);
                            },
                            child: Text(
                              AppLocalizations.of(context)!.save,
                              style: Theme.of(
                                context,
                              ).textTheme.titleLarge!.copyWith(
                                fontWeight: FontWeight.bold,
                                color:
                                    isDark
                                        ? AppColors.secondary
                                        : AppColors.primary,
                              ),
                            ),
                          ),
                        ],
                      ),
                      Center(
                        child: GestureDetector(
                          onTapDown: (TapDownDetails details) {
                            _showPopupMenu(context, details.globalPosition);
                          },
                          child: CircleAvatar(
                            radius: 60.r,
                            child: Stack(
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(60.r),
                                  child:
                                      user.avatarUrl! != ""
                                          ? Image.network(
                                            user.avatarUrl!,
                                            fit: BoxFit.fill,
                                            scale: 0.95,
                                          )
                                          : SizedBox(
                                            width: 110.w,
                                            height: 110.h,
                                            child: Icon(
                                              Icons.person,
                                              size: 70.w,
                                            ),
                                          ),
                                ),
                                Positioned(
                                  bottom: 0,
                                  right: 0,
                                  child: CircleAvatar(
                                    backgroundColor: Colors.grey,
                                    radius: 15.r,
                                    child: Icon(
                                      Icons.camera_alt_outlined,
                                      size: AppSizes.iconMd,
                                      color: Colors.black54,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: AppSizes.spaceBtwSections),
                      CustomTextFormField(
                        initialValue: userState.user!.email,
                        labelText: AppLocalizations.of(context)!.email,
                        prefixIcon: Iconsax.direct_right,
                      ),
                      CustomTextFormField(
                        controller: _fullNameCtrl!,
                        labelText: AppLocalizations.of(context)!.fullName,
                        prefixIcon: Iconsax.user,
                        validator: (value) {
                          if (value!.length < 8) {
                            return AppLocalizations.of(context)!.passShort;
                          }
                          return null;
                        },
                      ),
                      CustomTextFormField(
                        controller: _phoneNumberCtrl!,
                        labelText: AppLocalizations.of(context)!.phoneNo,
                        prefixIcon: Iconsax.call,
                      ),
                      CustomTextFormField(
                        controller: _dateOfBirthCtrl!,
                        labelText: AppLocalizations.of(context)!.dateOfBirth,
                        prefixIcon: Iconsax.calendar,
                      ),
                    ],
                  );
                } else {
                  return SizedBox.shrink();
                }
              },
            ),
          ),
        ),
      ),
    );
  }
}

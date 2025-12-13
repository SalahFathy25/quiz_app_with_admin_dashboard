import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SuccessDialog extends StatelessWidget {
  final String title;
  final VoidCallback onPressed;

  const SuccessDialog({
    super.key,
    required this.title,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.r)),
      title: Text(
        title,
        textAlign: TextAlign.center,
        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20.sp),
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.check_circle_outline, color: Colors.green, size: 60.r),
          SizedBox(height: 20.h),
          Text(
            'you_can_now_login'.tr(),
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 16.sp),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: onPressed,
          child: Text('ok'.tr(), style: TextStyle(fontSize: 18.sp)),
        ),
      ],
    );
  }
}

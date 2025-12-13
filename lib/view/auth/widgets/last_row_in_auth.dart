import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../core/routes/app_routes.dart';
import '../../../core/routes/routes.dart';

Widget lastRowInAuth(BuildContext context, {bool isLogin = true}) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      Text(
        isLogin ? 'dont_have_account'.tr() : 'already_have_account'.tr(),
        style: TextStyle(fontSize: 14.sp),
      ),
      TextButton(
        onPressed: () => isLogin
            ? Navigator.pushNamed(context, registerScreen)
            : Navigator.of(context).pop(),
        child: Text(
          isLogin ? 'register'.tr() : 'login'.tr(),
          style: TextStyle(fontSize: 14.sp),
        ),
      ),
    ],
  );
}

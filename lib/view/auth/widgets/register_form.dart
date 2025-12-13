import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:quiz_app/view/auth/widgets/last_row_in_auth.dart';
import 'package:quiz_app/core/widgets/custom_dropdown_button.dart';
import 'package:quiz_app/core/widgets/custom_text_field.dart';

import '../../../core/widgets/custom_button.dart';

class RegisterForm extends StatelessWidget {
  final GlobalKey<FormState> formKey;
  final TextEditingController usernameController;
  final TextEditingController emailController;
  final TextEditingController passwordController;
  final String selectedRole;
  final bool isLoading;
  final void Function(String?) onRoleChanged;
  final void Function() onRegister;

  const RegisterForm({
    super.key,
    required this.formKey,
    required this.usernameController,
    required this.emailController,
    required this.passwordController,
    required this.selectedRole,
    required this.isLoading,
    required this.onRoleChanged,
    required this.onRegister,
  });

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: Column(
        children: [
          SizedBox(height: 20.h),
          CustomTextField(
            controller: usernameController,
            labelText: 'username'.tr(),
            validator: (value) =>
                value!.isEmpty ? 'please_enter_username'.tr() : null,
          ),
          SizedBox(height: 16.h),
          CustomTextField(
            controller: emailController,
            labelText: 'email'.tr(),
            validator: (value) =>
                value!.isEmpty ? 'please_enter_email'.tr() : null,
          ),
          SizedBox(height: 16.h),
          CustomTextField(
            controller: passwordController,
            labelText: 'password'.tr(),
            isPassword: true,
            validator: (value) =>
                value!.isEmpty ? 'please_enter_password'.tr() : null,
          ),
          SizedBox(height: 16.h),
          CustomDropdownButton<String>(
            value: selectedRole,
            labelText: 'role'.tr(),
            items: [
              DropdownMenuItem(value: 'user', child: Text('user'.tr())),
              DropdownMenuItem(value: 'admin', child: Text('admin'.tr())),
            ],
            onChanged: onRoleChanged,
          ),
          SizedBox(height: 32.h),
          CustomButton(
            text: 'register'.tr(),
            onPressed: onRegister,
            isLoading: isLoading,
          ),
          SizedBox(height: 16.h),
          lastRowInAuth(context, isLogin: false),
        ],
      ),
    );
  }
}

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:quiz_app/core/routes/routes.dart';
import 'package:quiz_app/logic/auth/auth_cubit.dart';
import 'package:quiz_app/logic/auth/auth_state.dart';

class LoginForm extends StatelessWidget {
  final GlobalKey<FormState> formKey;
  final TextEditingController emailController;
  final TextEditingController passwordController;
  final bool rememberMe;
  final ValueChanged<bool?> onRememberMeChanged;
  final VoidCallback onLogin;

  const LoginForm({
    super.key,
    required this.formKey,
    required this.emailController,
    required this.passwordController,
    required this.rememberMe,
    required this.onRememberMeChanged,
    required this.onLogin,
  });

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: Column(
        children: [
          SizedBox(height: 20.h),
          TextFormField(
            controller: emailController,
            decoration: InputDecoration(labelText: 'email'.tr()),
            validator: (value) =>
                value!.isEmpty ? 'please_enter_email'.tr() : null,
          ),
          SizedBox(height: 16.h),
          TextFormField(
            controller: passwordController,
            decoration: InputDecoration(
              labelText: 'password'.tr(),
            ),
            obscureText: true,
            validator: (value) =>
                value!.isEmpty ? 'please_enter_password'.tr() : null,
          ),
          SizedBox(height: 16.h),
          Row(
            children: [
              Checkbox(
                value: rememberMe,
                onChanged: onRememberMeChanged,
              ),
              const Text('Remember Me'),
            ],
          ),
          SizedBox(height: 32.h),
          BlocBuilder<AuthCubit, AuthState>(
            builder: (context, state) {
              return ElevatedButton(
                onPressed: state is AuthLoading ? null : onLogin,
                child: state is AuthLoading
                    ? const CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation(
                          Colors.white,
                        ),
                      )
                    : Text('login'.tr()),
              );
            },
          ),
          SizedBox(height: 16.h),
          TextButton(
            onPressed: () =>
                Navigator.pushNamed(context, AppRoutes.register),
            child: Text('dont_have_account'.tr()),
          ),
        ],
      ),
    );
  }
}

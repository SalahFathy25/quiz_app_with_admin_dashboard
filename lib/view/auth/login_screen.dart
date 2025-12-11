import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:quiz_app/logic/auth/auth_cubit.dart';
import 'package:quiz_app/logic/auth/auth_state.dart';
import 'package:quiz_app/core/routes/routes.dart';
import 'package:quiz_app/logic/settings/settings_cubit.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _rememberMe = false;

  @override
  void initState() {
    super.initState();
    _loadUserCredentials();
  }

  void _loadUserCredentials() async {
    final prefs = await SharedPreferences.getInstance();
    final email = prefs.getString('email');
    final password = prefs.getString('password');
    if (email != null && password != null) {
      setState(() {
        _emailController.text = email;
        _passwordController.text = password;
        _rememberMe = true;
      });
    }
  }

  void _handleLogin() async {
    if (_formKey.currentState!.validate()) {
      final prefs = await SharedPreferences.getInstance();
      if (_rememberMe) {
        await prefs.setString('email', _emailController.text);
        await prefs.setString('password', _passwordController.text);
      } else {
        await prefs.remove('email');
        await prefs.remove('password');
      }
      context.read<AuthCubit>().signIn(
        _emailController.text,
        _passwordController.text,
      );
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocConsumer<AuthCubit, AuthState>(
        listener: (context, state) {
          if (state is AuthError) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text(state.message)));
          }
        },
        builder: (context, state) {
          return CustomScrollView(
            slivers: [
              SliverAppBar(
                expandedHeight: 200.h,
                pinned: true,
                flexibleSpace: FlexibleSpaceBar(
                  title: Text(
                    'login'.tr(),
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  background: Container(color: Theme.of(context).primaryColor),
                ),
                actions: [
                  IconButton(
                    onPressed: () =>
                        Navigator.pushNamed(context, AppRoutes.settingsScreen),
                    icon: const Icon(Icons.settings),
                    tooltip: 'settings'.tr(),
                  ),
                ],
              ),
              SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsets.all(24.w),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        SizedBox(height: 20.h),
                        TextFormField(
                          controller: _emailController,
                          decoration: InputDecoration(labelText: 'email'.tr()),
                          validator: (value) =>
                              value!.isEmpty ? 'please_enter_email'.tr() : null,
                        ),
                        SizedBox(height: 16.h),
                        TextFormField(
                          controller: _passwordController,
                          decoration: InputDecoration(
                            labelText: 'password'.tr(),
                          ),
                          obscureText: true,
                          validator: (value) => value!.isEmpty
                              ? 'please_enter_password'.tr()
                              : null,
                        ),
                        SizedBox(height: 16.h),
                        Row(
                          children: [
                            Checkbox(
                              value: _rememberMe,
                              onChanged: (value) {
                                setState(() {
                                  _rememberMe = value!;
                                });
                              },
                            ),
                            const Text('Remember Me'),
                          ],
                        ),
                        SizedBox(height: 32.h),
                        ElevatedButton(
                          onPressed: state is AuthInitial ? null : _handleLogin,
                          child: state is AuthInitial
                              ? const CircularProgressIndicator(
                                  valueColor: AlwaysStoppedAnimation(
                                    Colors.white,
                                  ),
                                )
                              : Text('login'.tr()),
                        ),
                        SizedBox(height: 16.h),
                        TextButton(
                          onPressed: () =>
                              Navigator.pushNamed(context, AppRoutes.register),
                          child: Text('dont_have_account'.tr()),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

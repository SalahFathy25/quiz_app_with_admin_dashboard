import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:quiz_app/logic/auth/auth_cubit.dart';
import 'package:quiz_app/logic/auth/auth_state.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  String _selectedRole = 'user';

  @override
  void dispose() {
    _emailController.dispose();
    _usernameController.dispose();
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
          } else if (state is Authenticated) {
            showDialog(
              context: context,
              barrierDismissible: false,
              builder: (context) => AlertDialog(
                title: Text('registration_successful'.tr()),
                content: Icon(
                  Icons.check_circle_outline,
                  color: Colors.green,
                  size: 60.r,
                ),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop(); // Close dialog
                      Navigator.of(context).pop(); // Go back to login screen
                    },
                    child: Text('ok'.tr()),
                  ),
                ],
              ),
            );
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
                    'register'.tr(),
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  background: Container(color: Theme.of(context).primaryColor),
                ),
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
                          controller: _usernameController,
                          decoration: InputDecoration(labelText: 'username'.tr()),
                          validator: (value) => value!.isEmpty
                              ? 'please_enter_username'.tr()
                              : null,
                        ),
                        SizedBox(height: 16.h),
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
                        DropdownButtonFormField<String>(
                          value: _selectedRole,
                          decoration: InputDecoration(labelText: 'role'.tr()),
                          items: [
                            DropdownMenuItem(
                              value: 'user',
                              child: Text('user'.tr()),
                            ),
                            DropdownMenuItem(
                              value: 'admin',
                              child: Text('admin'.tr()),
                            ),
                          ],
                          onChanged: (value) {
                            setState(() {
                              _selectedRole = value!;
                            });
                          },
                        ),
                        SizedBox(height: 32.h),
                        ElevatedButton(
                          onPressed: state is AuthLoading
                              ? null
                              : () {
                                  if (_formKey.currentState!.validate()) {
                                    context.read<AuthCubit>().signUp(
                                      _emailController.text,
                                      _passwordController.text,
                                      _selectedRole,
                                      _usernameController.text,
                                    );
                                  }
                                },
                          child: state is AuthLoading
                              ? const CircularProgressIndicator(
                                  valueColor: AlwaysStoppedAnimation(
                                    Colors.white,
                                  ),
                                )
                              : Text('register'.tr()),
                        ),
                        SizedBox(height: 16.h),
                        TextButton(
                          onPressed: () => Navigator.of(context).pop(),
                          child: Text('already_have_account'.tr()),
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

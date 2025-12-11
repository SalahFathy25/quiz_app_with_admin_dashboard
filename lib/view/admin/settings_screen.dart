import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../logic/settings/settings_cubit.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'settings'.tr(),
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            _buildSettingTile(
              context,
              title: 'theme'.tr(),
              icon: Icons.brightness_6_rounded,
              trailing: DropdownButton<ThemeMode>(
                value: context.watch<SettingsCubit>().state.themeMode,
                underline: const SizedBox(),
                items: [
                  DropdownMenuItem(
                    value: ThemeMode.system,
                    child: Text('system'.tr()),
                  ),
                  DropdownMenuItem(
                    value: ThemeMode.light,
                    child: Text('light'.tr()),
                  ),
                  DropdownMenuItem(
                    value: ThemeMode.dark,
                    child: Text('dark'.tr()),
                  ),
                ],
                onChanged: (themeMode) {
                  if (themeMode != null) {
                    context.read<SettingsCubit>().changeTheme(themeMode);
                  }
                },
              ),
            ),
            SizedBox(height: 16.h),
            _buildSettingTile(
              context,
              title: 'language'.tr(),
              icon: Icons.language_rounded,
              trailing: DropdownButton<Locale>(
                value: context.watch<SettingsCubit>().state.locale,
                underline: const SizedBox(),
                items: [
                  DropdownMenuItem(
                    value: const Locale('en'),
                    child: Text('english'.tr()),
                  ),
                  DropdownMenuItem(
                    value: const Locale('ar'),
                    child: Text('arabic'.tr()),
                  ),
                ],
                onChanged: (locale) {
                  if (locale != null) {
                    context.read<SettingsCubit>().changeLocale(locale);
                    context.setLocale(locale);
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSettingTile(
    BuildContext context, {
    required String title,
    required IconData icon,
    required Widget trailing,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(12.0),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8.0),
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8.0),
            ),
            child: Icon(icon, color: Theme.of(context).primaryColor),
          ),
          const SizedBox(width: 16.0),
          Expanded(
            child: Text(
              title,
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
            ),
          ),
          trailing,
        ],
      ),
    );
  }
}

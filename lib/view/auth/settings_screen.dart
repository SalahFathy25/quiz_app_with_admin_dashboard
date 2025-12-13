import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../logic/settings/settings_cubit.dart';
import 'widgets/build_setting_tile.dart';

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
            buildSettingTile(
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
            buildSettingTile(
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
}

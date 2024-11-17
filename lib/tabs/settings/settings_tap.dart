import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo/app_theme.dart';
import 'package:todo/auth/login_screen.dart';
import 'package:todo/auth/user_provider.dart';
import 'package:todo/firebase_functions.dart';
import 'package:todo/tabs/settings/language.dart';
import 'package:todo/tabs/tasks/task_provider.dart';

import 'setting_provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class SettingsTap extends StatefulWidget {
  const SettingsTap({super.key});

  @override
  State<SettingsTap> createState() => _SettingsTapState();
}

List<Language> language = [
  Language(name: 'English', code: 'en'),
  Language(name: 'العربية', code: 'ar'),
];

class _SettingsTapState extends State<SettingsTap> {
  @override
  Widget build(BuildContext context) {
    TextTheme textTheme = Theme.of(context).textTheme;
    SettingProvider settingProvider = Provider.of<SettingProvider>(context);

    return Column(
      children: [
        Container(
          padding: const EdgeInsetsDirectional.only(top: 45, start: 25),
          height: MediaQuery.sizeOf(context).height * 0.18,
          width: double.infinity,
          color: AppTheme.primary,
          child: Text(AppLocalizations.of(context)!.setting,
              style: Theme.of(context).textTheme.titleMedium),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 18.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(
                height: 35,
              ),
              Text(
                AppLocalizations.of(context)!.language,
                style: textTheme.titleMedium?.copyWith(
                    fontSize: 14,
                    color: settingProvider.isDark
                        ? AppTheme.white
                        : AppTheme.black),
              ),
              Padding(
                padding: const EdgeInsets.all(32.0),
                child: Container(
                  decoration: BoxDecoration(
                      border: Border.all(color: AppTheme.primary),
                      color: settingProvider.isDark
                          ? AppTheme.black
                          : AppTheme.white,
                      borderRadius: BorderRadius.circular(5)),
                  height: MediaQuery.sizeOf(context).height * 0.07,
                  width: MediaQuery.sizeOf(context).height * 0.7,
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton(
                      padding: const EdgeInsetsDirectional.only(start: 12),
                      iconEnabledColor: AppTheme.primary,
                      isExpanded: true,
                      value: settingProvider.langCode,
                      borderRadius: BorderRadius.circular(15),
                      items: [
                        DropdownMenuItem(
                          value: 'en',
                          child: Text(
                            'English',
                            style: textTheme.titleSmall?.copyWith(
                                color: settingProvider.isDark
                                    ? AppTheme.white
                                    : AppTheme.black),
                          ),
                        ),
                        DropdownMenuItem(
                          value: 'ar',
                          child: Text('العربية',
                              style: textTheme.titleSmall?.copyWith(
                                  color: settingProvider.isDark
                                      ? AppTheme.white
                                      : AppTheme.black)),
                        ),
                      ],
                      onChanged: (value) {
                        settingProvider.changeLang(value ?? 'English');
                      },
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 25,
              ),
              Text(
                AppLocalizations.of(context)!.mode,
                style: textTheme.titleMedium?.copyWith(
                    fontSize: 14,
                    color: settingProvider.isDark
                        ? AppTheme.white
                        : AppTheme.black),
              ),
              Padding(
                padding: const EdgeInsets.all(32.0),
                child: Container(
                  decoration: BoxDecoration(
                      border: Border.all(color: AppTheme.primary),
                      color: settingProvider.isDark
                          ? AppTheme.black
                          : AppTheme.white,
                      borderRadius: BorderRadius.circular(5)),
                  height: MediaQuery.sizeOf(context).height * 0.07,
                  width: MediaQuery.sizeOf(context).height * 0.7,
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                      iconEnabledColor: AppTheme.primary,
                      padding: const EdgeInsetsDirectional.only(start: 12),
                      isExpanded: true,
                      value: settingProvider.isDark ? 'Dark' : 'Light',
                      borderRadius: BorderRadius.circular(15),
                      onChanged: (String? newValue) {
                        if (newValue != null) {
                          settingProvider.changeTheme();
                        }
                      },
                      items: [
                        DropdownMenuItem(
                            value: 'Light',
                            child: Text(
                              AppLocalizations.of(context)!.light,
                              style: textTheme.titleSmall?.copyWith(
                                  color: settingProvider.isDark
                                      ? AppTheme.white
                                      : AppTheme.black),
                            )),
                        DropdownMenuItem(
                            value: 'Dark',
                            child: Text(
                              AppLocalizations.of(context)!.dark,
                              style: textTheme.titleSmall?.copyWith(
                                  color: settingProvider.isDark
                                      ? AppTheme.white
                                      : AppTheme.black),
                            )),
                      ],
                    ),
                  ),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    AppLocalizations.of(context)!.logOut,
                    style: textTheme.titleMedium?.copyWith(
                        fontSize: 14,
                        color: settingProvider.isDark
                            ? AppTheme.white
                            : AppTheme.black),
                  ),
                  IconButton(
                    onPressed: () {
                      FirebaseFunction.logOut();
                      Navigator.of(context)
                          .pushReplacementNamed(LoginScreen.routeName);
                      Provider.of<TaskProvider>(context, listen: false)
                          .resetData();
                      Provider.of<UserProvider>(context, listen: false)
                          .updateUser(null);
                    },
                    icon: Icon(
                      Icons.login_outlined,
                      size: 24,
                      color: settingProvider.isDark
                          ? AppTheme.white
                          : AppTheme.black,
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ],
    );
  }
}

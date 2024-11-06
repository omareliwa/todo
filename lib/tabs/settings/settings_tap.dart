import 'package:flutter/material.dart';
import 'package:todo/app_theme.dart';
import 'package:todo/tabs/settings/language.dart';

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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsetsDirectional.only(top: 45, start: 25),
          height: MediaQuery.sizeOf(context).height * 0.18,
          width: double.infinity,
          color: AppTheme.primary,
          child: Text(
            'Settings',
            style: Theme.of(context)
                .textTheme
                .titleMedium
                ?.copyWith(color: AppTheme.white),
          ),
        ),
        const SizedBox(
          height: 35,
        ),
        Padding(
          padding: const EdgeInsetsDirectional.only(start: 18.0),
          child: Text(
            'Language',
            style: textTheme.titleMedium?.copyWith(fontSize: 14),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(32.0),
          child: Container(
            decoration: BoxDecoration(
                border: Border.all(color: AppTheme.primary),
                color: AppTheme.white,
                borderRadius: BorderRadius.circular(5)),
            height: MediaQuery.sizeOf(context).height * 0.07,
            width: MediaQuery.sizeOf(context).height * 0.7,
            child: DropdownButtonHideUnderline(
              child: DropdownButton(
                padding: const EdgeInsetsDirectional.only(start: 12),
                iconEnabledColor: AppTheme.primary,
                isExpanded: true,
                value: 'en',
                borderRadius: BorderRadius.circular(15),
                items: [
                  DropdownMenuItem(
                    value: 'en',
                    child: Text('English', style: textTheme.titleSmall),
                  ),
                  DropdownMenuItem(
                    value: 'ar',
                    child: Text('العربية', style: textTheme.titleSmall),
                  ),
                ],
                onChanged: (value) {},
              ),
            ),
          ),
        ),
        const SizedBox(
          height: 25,
        ),
        Padding(
          padding: const EdgeInsetsDirectional.only(start: 18.0),
          child: Text(
            'Mode',
            style: textTheme.titleMedium?.copyWith(fontSize: 14),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(32.0),
          child: Container(
            decoration: BoxDecoration(
                border: Border.all(color: AppTheme.primary),
                color: AppTheme.white,
                borderRadius: BorderRadius.circular(5)),
            height: MediaQuery.sizeOf(context).height * 0.07,
            width: MediaQuery.sizeOf(context).height * 0.7,
            child: DropdownButtonHideUnderline(
              child: DropdownButton(
                iconEnabledColor: AppTheme.primary,
                padding: const EdgeInsetsDirectional.only(start: 12),
                isExpanded: true,
                value: 'dark',
                borderRadius: BorderRadius.circular(15),
                items: [
                  DropdownMenuItem(
                    value: 'dark',
                    child: Text('Dark Mode', style: textTheme.titleSmall),
                  ),
                  DropdownMenuItem(
                    value: 'light',
                    child: Text('Light Mode', style: textTheme.titleSmall),
                  ),
                ],
                onChanged: (value) {},
              ),
            ),
          ),
        ),
      ],
    );
  }
}

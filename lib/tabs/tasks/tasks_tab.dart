import 'package:easy_date_timeline/easy_date_timeline.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo/app_theme.dart';
import 'package:todo/auth/user_provider.dart';
import 'package:todo/tabs/settings/setting_provider.dart';
import 'package:todo/tabs/tasks/task_item.dart';
import 'package:todo/tabs/tasks/task_provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class TasksTap extends StatefulWidget {
  const TasksTap({super.key});

  @override
  State<TasksTap> createState() => _TasksTapState();
}

class _TasksTapState extends State<TasksTap> {
  bool shouldGetTask = true;

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.sizeOf(context).height;
    TaskProvider taskProvider = Provider.of<TaskProvider>(context);
    SettingProvider settingProvider = Provider.of<SettingProvider>(context);
    String userId =
        Provider.of<UserProvider>(context, listen: false).currentUser!.id;
    if (shouldGetTask) {
      taskProvider.getTasks(userId);
      shouldGetTask = false;
    }
    return Column(
      children: [
        Stack(
          children: [
            Container(
              height: screenHeight * 0.18,
              width: double.infinity,
              color: AppTheme.primary,
            ),
            PositionedDirectional(
              top: 20,
              start: 25,
              child: SafeArea(
                child: Text(AppLocalizations.of(context)!.todoList,
                    style: Theme.of(context).textTheme.titleMedium
                    // ?.copyWith(color: AppTheme.white),
                    ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: screenHeight * 0.12),
              child: EasyInfiniteDateTimeLine(
                locale: settingProvider.langCode,
                firstDate: DateTime.now().subtract(
                  const Duration(days: 365),
                ),
                focusDate: taskProvider.selectedDate,
                lastDate: DateTime.now().add(
                  const Duration(days: 365),
                ),
                onDateChange: (selectedDate) =>
                    taskProvider.getSelectedDateTasks(selectedDate, userId),
                showTimelineHeader: false,
                dayProps: EasyDayProps(
                  height: 79,
                  width: 58,
                  dayStructure: DayStructure.dayStrDayNum,
                  activeDayStyle: DayStyle(
                    decoration: BoxDecoration(
                      color: settingProvider.isDark
                          ? AppTheme.black
                          : AppTheme.white,
                      borderRadius: const BorderRadius.all(
                        Radius.circular(5),
                      ),
                    ),
                    dayNumStyle: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: AppTheme.primary,
                    ),
                    dayStrStyle: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: AppTheme.primary,
                    ),
                  ),
                  inactiveDayStyle: DayStyle(
                    decoration: BoxDecoration(
                      color: settingProvider.isDark
                          ? AppTheme.black
                          : AppTheme.white,
                      borderRadius: const BorderRadius.all(
                        Radius.circular(5),
                      ),
                    ),
                    dayNumStyle: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: settingProvider.isDark
                          ? AppTheme.white
                          : AppTheme.black,
                    ),
                    dayStrStyle: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: settingProvider.isDark
                          ? AppTheme.white
                          : AppTheme.black,
                    ),
                  ),
                  todayStyle: DayStyle(
                    decoration: BoxDecoration(
                      color: settingProvider.isDark
                          ? AppTheme.black
                          : AppTheme.white,
                      borderRadius: const BorderRadius.all(
                        Radius.circular(5),
                      ),
                    ),
                    dayNumStyle: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: settingProvider.isDark
                          ? AppTheme.white
                          : AppTheme.black,
                    ),
                    dayStrStyle: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: settingProvider.isDark
                          ? AppTheme.white
                          : AppTheme.black,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.only(top: 20),
            itemBuilder: (_, index) => TaskItem(taskProvider.tasks[index]),
            itemCount: taskProvider.tasks.length,
          ),
        )
      ],
    );
  }
}

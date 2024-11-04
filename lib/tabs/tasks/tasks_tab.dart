import 'package:easy_date_timeline/easy_date_timeline.dart';
import 'package:flutter/material.dart';
import 'package:todo/app_theme.dart';
import 'package:todo/tabs/tasks/task_item.dart';

class TasksTap extends StatelessWidget {
  static const routeName = "/tasks";

  const TasksTap({super.key});

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.sizeOf(context).height;
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

                child: Text(
                  'To Do List',
                  style: Theme.of(context)
                      .textTheme
                      .titleMedium
                      ?.copyWith(color: AppTheme.white),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: screenHeight * 0.12),
              child: EasyInfiniteDateTimeLine(
                firstDate: DateTime.now().subtract(
                  const Duration(days: 365),
                ),
                focusDate: DateTime.now(),
                lastDate: DateTime.now().add(
                  const Duration(days: 365),
                ),
                showTimelineHeader: false,
                dayProps: const EasyDayProps(
                  height: 79,
                  width: 58,
                  dayStructure: DayStructure.dayStrDayNum,
                  activeDayStyle: DayStyle(
                    decoration: BoxDecoration(
                      color: AppTheme.white,
                      borderRadius: BorderRadius.all(
                        Radius.circular(5),
                      ),
                    ),
                    dayNumStyle: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: AppTheme.primary,
                    ),
                    dayStrStyle: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: AppTheme.primary,
                    ),
                  ),
                  inactiveDayStyle: DayStyle(
                    decoration: BoxDecoration(
                      color: AppTheme.white,
                      borderRadius: BorderRadius.all(
                        Radius.circular(5),
                      ),
                    ),
                    dayNumStyle: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: AppTheme.black,
                    ),
                    dayStrStyle: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: AppTheme.black,
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
            itemBuilder: (_, index) => const TaskItem(),
            itemCount: 10,
          ),
        )
      ],
    );
  }
}

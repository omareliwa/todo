import 'package:flutter/material.dart';
import 'package:todo/app_theme.dart';
import 'package:todo/models/task_model.dart';

class TaskItem extends StatelessWidget {
  TaskItem(this.task, {super.key});

  TaskModel task;

  @override
  Widget build(BuildContext context) {
    TextTheme textTheme = Theme.of(context).textTheme;
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 20),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppTheme.white,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Row(
        children: [
          Container(
            height: 62,
            width: 4,
            margin: const EdgeInsetsDirectional.only(end: 12),
            color: AppTheme.primary,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                task.title,
                style: textTheme.titleMedium?.copyWith(color: AppTheme.primary),
              ),
              const SizedBox(
                height: 5,
              ),
              Text(task.description, style: textTheme.titleSmall),
            ],
          ),
          const Spacer(),
          Container(
            height: 34,
            width: 69,
            decoration: BoxDecoration(
              color: AppTheme.primary,
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(
              Icons.check,
              color: AppTheme.white,
              size: 32,
            ),
          ),
        ],
      ),
    );
  }
}

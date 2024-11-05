import 'package:flutter/material.dart';
import 'package:todo/app_theme.dart';

class TaskItem extends StatelessWidget {
  const TaskItem({super.key});

  @override
  Widget build(BuildContext context) {
    TextTheme textTheme = Theme.of(context).textTheme;
    return Container(
      margin:  EdgeInsets.symmetric(vertical: 8, horizontal: 20),
      padding:  EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppTheme.white,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Row(
        children: [
          Container(
            height: 62,
            width: 4,
            margin:  EdgeInsetsDirectional.only(end: 12),
            color: AppTheme.primary,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'play',
                style: textTheme.titleMedium?.copyWith(color: AppTheme.primary),
              ),
               SizedBox(
                height: 5,
              ),
              Text('tasks descripion', style: textTheme.titleSmall),
            ],
          ),
           Spacer(),
          Container(
            height: 34,
            width: 69,
            decoration: BoxDecoration(
              color: AppTheme.primary,
              borderRadius: BorderRadius.circular(10),
            ),
            child:  Icon(
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

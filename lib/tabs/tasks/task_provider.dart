import 'package:flutter/cupertino.dart';
import 'package:todo/firebase_functions.dart';
import 'package:todo/models/task_model.dart';

class TaskProvider with ChangeNotifier {
  List<TaskModel> tasks = [];
  DateTime selectedDate = DateTime.now();

  Future<void> getTasks() async {
    List<TaskModel> allTasks = await FirebaseFunction.getAllTaskFromFirestore();
    tasks = allTasks
        .where(
          (task) =>
              task.date.year == selectedDate.year &&
              task.date.month == selectedDate.month &&
              task.date.day == selectedDate.day,
        )
        .toList();
    notifyListeners();
  }

  void getSelectedDateTasks(DateTime date) {
    selectedDate = date;
    getTasks();
  }
}

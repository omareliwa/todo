class TaskModel {
  TaskModel({
    required this.title,
    required this.description,
    required this.date,
    this.isDone = false,
    this.id = '',
  });

  String id;
  bool isDone;
  String title;
  String description;
  DateTime date;
}

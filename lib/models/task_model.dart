import 'package:cloud_firestore/cloud_firestore.dart';

class TaskModel {
  String id;
  bool isDone;
  String title;
  String description;
  DateTime date;

  TaskModel({
    required this.title,
    required this.description,
    required this.date,
    this.isDone = false,
    this.id = '',
  });

  TaskModel.fromJson(Map<String, dynamic> json)
      : this(
          id: json['id'],
          title: json['title'],
          isDone: json['isDone'],
          description: json['description'],
          date: (json['date'] as Timestamp).toDate(),
        );

  Map<String, dynamic> toJson() => {
        'id': id,
        'isDone': isDone,
        'title': title,
        'description': description,
        'date': Timestamp.fromDate(date),
      };
}

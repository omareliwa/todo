import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:todo/app_theme.dart';
import 'package:todo/auth/user_provider.dart';
import 'package:todo/firebase_functions.dart';
import 'package:todo/models/task_model.dart';
import 'package:todo/tabs/settings/setting_provider.dart';
import 'package:todo/tabs/tasks/task_provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:todo/widgets/default_elevated_button.dart';
import 'package:todo/widgets/default_text_form_field.dart';

class TaskItem extends StatefulWidget {
  const TaskItem(this.task, {super.key});

  final TaskModel task;

  @override
  State<TaskItem> createState() => _TaskItemState();
}

class _TaskItemState extends State<TaskItem> {
  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  DateFormat dateFormat = DateFormat('dd/MM/yyyy');

  // DateTime selectedDate = DateTime.now();
  var formKey = GlobalKey<FormState>();
  bool isDone = false;

  @override
  Widget build(BuildContext context) {
    TextTheme textTheme = Theme.of(context).textTheme;
    SettingProvider settingProvider = Provider.of(context);
    return Container(
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(50)),
        margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 20),
        child: Slidable(
          startActionPane: ActionPane(
            motion: const ScrollMotion(),
            dismissible: DismissiblePane(onDismissed: () {}),
            children: [
              SlidableAction(
                flex: 1,
                borderRadius: BorderRadius.circular(15),
                onPressed: (_) {
                  String userId =
                      Provider.of<UserProvider>(context, listen: false)
                          .currentUser!
                          .id;
                  FirebaseFunction.deleteTaskFromFirestore(
                          widget.task.id, userId)
                      .then((value) {
                    Provider.of<TaskProvider>(context, listen: false)
                        .getTasks(userId);
                  }).catchError((_) {
                    Fluttertoast.showToast(
                      msg: "Some Thing Went Wrong",
                      toastLength: Toast.LENGTH_LONG,
                      gravity: ToastGravity.CENTER,
                      timeInSecForIosWeb: 5,
                      backgroundColor: AppTheme.red,
                      textColor: AppTheme.white,
                      fontSize: 16.0,
                    );
                  });
                },
                backgroundColor: AppTheme.red,
                foregroundColor: AppTheme.white,
                icon: Icons.delete,
                label: AppLocalizations.of(context)!.delete,
              ),
              SlidableAction(
                flex: 1,
                borderRadius: BorderRadius.circular(15),
                onPressed: (_) {
                  // setState(() {});
                  String userId =
                      Provider.of<UserProvider>(context, listen: false)
                          .currentUser!
                          .id;
                  showEditTaskDialog(context, userId, widget.task.id)
                      .then((value) {
                    Provider.of<TaskProvider>(context, listen: false)
                        .getTasks(userId);
                  }).catchError((_) {
                    Fluttertoast.showToast(
                      msg: "Some Thing Went Wrong",
                      toastLength: Toast.LENGTH_LONG,
                      gravity: ToastGravity.CENTER,
                      timeInSecForIosWeb: 5,
                      backgroundColor: AppTheme.red,
                      textColor: AppTheme.white,
                      fontSize: 16.0,
                    );
                  });
                },
                backgroundColor: AppTheme.primary,
                foregroundColor: AppTheme.white,
                icon: Icons.edit_outlined,
                label: AppLocalizations.of(context)!.edit,
              ),
            ],
          ),
          child: Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: settingProvider.isDark ? AppTheme.black : AppTheme.white,
              //AppTheme.white ,
              borderRadius: BorderRadius.circular(15),
            ),
            child: Row(children: [
              Container(
                height: 62,
                width: 4,
                margin: const EdgeInsetsDirectional.only(end: 12),
                color: isDone ? AppTheme.green : AppTheme.primary,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.task.title,
                    style: textTheme.titleMedium?.copyWith(
                        color: isDone ? AppTheme.green : AppTheme.primary),
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  Text(widget.task.description,
                      style: textTheme.titleSmall?.copyWith(
                          color: settingProvider.isDark
                              ? AppTheme.white
                              : AppTheme.black)),
                ],
              ),
              const Spacer(),
              GestureDetector(
                onTap: () {
                  setState(() {
                    isDone = !isDone;
                  });

                  // Update Firestore if needed
                  String userId =
                      Provider.of<UserProvider>(context, listen: false)
                          .currentUser!
                          .id;
                  FirebaseFunction.editTaskInFirestore(
                    userId: userId,
                    taskId: widget.task.id,
                    updatedFields: {'isDone': true},
                  ).catchError((error) {
                    Fluttertoast.showToast(
                      msg: "Failed to mark as done",
                      toastLength: Toast.LENGTH_SHORT,
                      gravity: ToastGravity.BOTTOM,
                    );
                  });
                },
                child: isDone
                    ? Text(
                        "Done",
                        style: textTheme.titleLarge?.copyWith(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: AppTheme.green),
                      )
                    : Container(
                        height: 40,
                        width: 69,
                        decoration: BoxDecoration(
                          color: AppTheme.primary,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Center(
                          child: Icon(
                            Icons.check,
                            color: AppTheme.white,
                            size: 32,
                          ),
                        ),
                      ),
              ),
            ]),
          ),
        ));
  }

  showEditTaskDialog(BuildContext context, String userId, String taskId) async {
    final DocumentSnapshot<TaskModel> taskSnapshot =
        await FirebaseFunction.getTasksCollection(userId).doc(taskId).get();

    final TaskModel task = taskSnapshot.data()!;
    final TextEditingController titleController =
        TextEditingController(text: task.title);
    final TextEditingController descriptionController =
        TextEditingController(text: task.description);
    DateTime selectedDate = task.date;

    showDialog(
        context: context,
        builder: (context) => AlertDialog(
              title: Center(
                child: Text(
                  AppLocalizations.of(context)!.addNewTask,
                ),
              ),
              content: Form(
                key: formKey,
                child: Column(
                  children: [
                    DefaultTextFormField(
                      controller: titleController,
                      hintText: AppLocalizations.of(context)!.enterTaskTitle,
                      validator: (value) {
                        //لحذف المسافات
                        // value?.trim();
                        if (value == null || value.trim().isEmpty) {
                          return 'Title can not be empty';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    DefaultTextFormField(
                      controller: descriptionController,
                      hintText: AppLocalizations.of(context)!.enterDesc,
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Description can not be empty';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 10),
                    InkWell(
                      onTap: () async {
                        DateTime? dateTime = await showDatePicker(
                          initialEntryMode: DatePickerEntryMode.calendarOnly,
                          initialDate: selectedDate,
                          context: context,
                          firstDate: DateTime.now(),
                          lastDate: DateTime.now().add(
                            const Duration(days: 365),
                          ),
                        );
                        if (dateTime != null && dateTime != selectedDate) {
                          selectedDate = dateTime;
                          setState(() {});
                        }
                      },
                      child: Text(
                        dateFormat.format(selectedDate),
                      ),
                    ),
                  ],
                ),
              ),
              actions: [
                DefaultElevatedButton(
                  label: 'Save Edite',
                  onPressed: () async {
                    Navigator.pop(context);
                    if (formKey.currentState!.validate()) {}

                    await FirebaseFunction.editTaskInFirestore(
                      userId: userId,
                      taskId: taskId,
                      updatedFields: {
                        'title': titleController.text.trim(),
                        'description': descriptionController.text.trim(),
                        'updatedAt': FieldValue.serverTimestamp(),
                        'isDone': isDone
                      },
                    );
                  },
                ),
              ],
            ));
  }
}

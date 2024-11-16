import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:todo/app_theme.dart';
import 'package:todo/auth/user_provider.dart';
import 'package:todo/firebase_functions.dart';
import 'package:todo/models/task_model.dart';
import 'package:todo/tabs/tasks/task_provider.dart';
import 'package:todo/widgets/default_elevated_button.dart';
import 'package:todo/widgets/default_text_form_field.dart';

class AddTaskBottomSheet extends StatefulWidget {
  const AddTaskBottomSheet({super.key});

  @override
  State<AddTaskBottomSheet> createState() => _AddTaskBottomSheetState();
}

class _AddTaskBottomSheetState extends State<AddTaskBottomSheet> {
  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  DateFormat dateFormat = DateFormat('dd/MM/yyyy');
  DateTime selectedDate = DateTime.now();
  var formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    TextStyle? titleMediumStyle = Theme.of(context).textTheme.titleMedium;
    return Padding(
      padding:
          EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      child: Container(
        decoration: const BoxDecoration(
            borderRadius: BorderRadius.horizontal(
              left: Radius.circular(15),
              right: Radius.circular(15),
            ),
            color: AppTheme.white),
        height: MediaQuery.sizeOf(context).height * 0.6,
        padding: const EdgeInsets.all(20),
        child: Form(
          key: formKey,
          child: SingleChildScrollView(
            child: Column(
              children: [
                Text(
                  'Add new task',
                  style: titleMediumStyle,
                ),
                const SizedBox(
                  height: 16,
                ),
                DefaultTextFormField(
                  controller: titleController,
                  hintText: 'Enter task title',
                  validator: (value) {
                    //لحذف المسافات
                    // value?.trim();
                    if (value == null || value.trim().isEmpty) {
                      return 'Title can not be empty';
                    }
                    return null;
                  },
                ),
                const SizedBox(
                  height: 16,
                ),
                DefaultTextFormField(
                  controller: descriptionController,
                  hintText: 'Enter task description',
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Description can not be empty';
                    }
                    return null;
                  },
                ),
                const SizedBox(
                  height: 16,
                ),
                Text(
                  'Select date',
                  style:
                      titleMediumStyle?.copyWith(fontWeight: FontWeight.w400),
                ),
                const SizedBox(
                  height: 8,
                ),
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
                const SizedBox(
                  height: 32,
                ),
                DefaultElevatedButton(
                    label: 'Add',
                    onPressed: () {
                      if (formKey.currentState!.validate()) {
                        addTask();
                      }
                    })
              ],
            ),
          ),
        ),
      ),
    );
  }

  void addTask() {
    TaskModel task = TaskModel(
      title: titleController.text,
      description: descriptionController.text,
      date: selectedDate,
    );
    String userId =
        Provider.of<UserProvider>(context, listen: false).currentUser!.id;
    FirebaseFunction.addTaskToFirestore(task, userId).then(
      (value) {
        Navigator.of(context).pop();
        Provider.of<TaskProvider>(context, listen: false).getTasks(userId);
        Fluttertoast.showToast(
          msg: "Task Added Successfully",
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 5,
          backgroundColor: AppTheme.green,
          textColor: AppTheme.white,
          fontSize: 16.0,
        );
      },
    ).catchError(
      (_) {
        Fluttertoast.showToast(
          msg: "Some Thing Went Wrong",
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 5,
          backgroundColor: AppTheme.red,
          textColor: AppTheme.white,
          fontSize: 16.0,
        );
      },
    );
  }
}

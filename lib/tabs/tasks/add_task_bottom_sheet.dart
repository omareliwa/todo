import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:todo/app_theme.dart';
import 'package:todo/auth/user_provider.dart';
import 'package:todo/firebase_functions.dart';
import 'package:todo/models/task_model.dart';
import 'package:todo/tabs/settings/setting_provider.dart';
import 'package:todo/tabs/tasks/task_provider.dart';
import 'package:todo/widgets/default_elevated_button.dart';
import 'package:todo/widgets/default_text_form_field.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

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
    SettingProvider settingProvider = Provider.of(context);
    return Padding(
      padding:
          EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      child: Container(
        decoration: BoxDecoration(
            borderRadius: const BorderRadius.horizontal(
              left: Radius.circular(15),
              right: Radius.circular(15),
            ),
            color: settingProvider.isDark ? AppTheme.black : AppTheme.white),
        height: MediaQuery.sizeOf(context).height * 0.6,
        padding: const EdgeInsets.all(20),
        child: Form(
          key: formKey,
          child: SingleChildScrollView(
            child: Column(
              children: [
                Text(
                  AppLocalizations.of(context)!.addNewTask,
                  style: titleMediumStyle?.copyWith(
                      color: settingProvider.isDark
                          ? AppTheme.white
                          : AppTheme.black),
                ),
                const SizedBox(
                  height: 16,
                ),
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
                const SizedBox(
                  height: 16,
                ),
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
                const SizedBox(
                  height: 16,
                ),
                Text(
                  AppLocalizations.of(context)!.selectDate,
                  style: titleMediumStyle?.copyWith(
                      fontWeight: FontWeight.w400,
                      color: settingProvider.isDark
                          ? AppTheme.white
                          : AppTheme.black),
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
                    label: AppLocalizations.of(context)!.add,
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

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:todo/models/task_model.dart';
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
    return Container(
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
                style: titleMediumStyle?.copyWith(fontWeight: FontWeight.w400),
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
    );
  }

  void addTask() {
    TaskModel task = TaskModel(
      title: titleController.text,
      description: descriptionController.text,
      date: selectedDate,
    );
  }
}

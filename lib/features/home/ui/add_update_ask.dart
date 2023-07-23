import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_app/features/home/bloc/home_page_bloc.dart';
import 'package:todo_app/models/task.dart';
import 'package:intl/intl.dart';
import 'package:todo_app/sf/notification.dart';

class AddOrUpdateTask extends StatefulWidget {
  const AddOrUpdateTask({Key? key, required this.userId, this.task})
      : super(key: key);
  final Task? task;
  final String userId;
  @override
  _AddOrUpdateTaskState createState() => _AddOrUpdateTaskState();
}

class _AddOrUpdateTaskState extends State<AddOrUpdateTask> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  DateTime _selectedDate = DateTime.now();
  TimeOfDay _selectedTime = TimeOfDay.now();

  @override
  void initState() {
    if (widget.task != null) {
      _titleController.text = widget.task!.title;
      _descriptionController.text = widget.task!.description;
      _selectedDate = widget.task!.dueDate;
      _selectedTime = TimeOfDay.fromDateTime(widget.task!.dueDate);
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.task == null ? "Add task" : "Update task"),
      ),
      body: BlocConsumer<HomePageBloc, HomePageState>(
        bloc: BlocProvider.of<HomePageBloc>(context),
        listener: (context, state) {
          if (state is AddedTaskSuccessState) {
            Navigator.pop(context);
          } else if (state is UpdatedTaskSuccessState) {
            Navigator.pop(context);
          }
        },
        builder: (context, state) {
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _titleField(),
                  _desField(),
                  _selectDateButton(),
                  _selectTimeButton(),
                  _addOrUpdateTaskButton()
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _titleField() {
    return Container(
      margin: const EdgeInsets.fromLTRB(0, 0, 0, 20),
      child: TextFormField(
        autofocus: true,
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Please enter some text';
          }
          return null;
        },
        controller: _titleController,
        decoration: InputDecoration(
          labelText:
              widget.task == null ? "Title" : widget.task!.title.toString(),
          border: const OutlineInputBorder(),
        ),
      ),
    );
  }

  Widget _desField() {
    return Container(
      margin: const EdgeInsets.fromLTRB(0, 0, 0, 20),
      child: TextFormField(
        controller: _descriptionController,
        maxLines: 4,
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Please enter some text';
          }
          return null;
        },
        decoration: InputDecoration(
          labelText: widget.task == null
              ? "Descreption"
              : widget.task!.description.toString(),
          border: const OutlineInputBorder(),
        ),
      ),
    );
  }

  Widget _selectDateButton() {
    return Container(
      margin: const EdgeInsets.fromLTRB(0, 0, 0, 20),
      child: TextButton(
        onPressed: () => _selectDate(context),
        child: Text(
            'Select Date: ${DateFormat('dd/MM/yyyy').format(_selectedDate)}'),
      ),
    );
  }

  Widget _selectTimeButton() {
    return Container(
      margin: const EdgeInsets.fromLTRB(0, 0, 0, 20),
      child: TextButton(
        onPressed: () => _selectTime(context),
        child: Text('Select Time: ${_selectedTime.format(context)}'),
      ),
    );
  }

  Widget _addOrUpdateTaskButton() {
    return ElevatedButton(
      onPressed: () {
        _addOrUpdateTask();
      },
      child: Text(widget.task == null ? "Add task" : "Update task"),
    );
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2023),
      lastDate: DateTime(2030),
    );
    setState(() {
      _selectedDate = picked!;
      print("Check $_selectedDate");
    });
  }

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: _selectedTime,
    );
    setState(() {
      _selectedTime = picked!;
      print("Check $_selectedTime");
    });
  }

  void _addOrUpdateTask() {
    String title = _titleController.text.trim().toString();
    String description = _descriptionController.text.trim().toString();
    DateTime dueDate = DateTime(_selectedDate.year, _selectedDate.month,
        _selectedDate.day, _selectedTime.hour, _selectedTime.minute);
    Task task = Task(
        taskId: widget.task?.taskId ?? UniqueKey().toString(),
        title: title,
        description: description,
        dueDate: dueDate,
        isCompleted: 0,
        userId: widget.userId);
    if (_formKey.currentState!.validate()) {
      if (widget.task != null) {
        BlocProvider.of<HomePageBloc>(context).add(UpdateTaskEvent(task));
        // NotificationService.instance.scheduleSendNotifi(task);
      } else {
        BlocProvider.of<HomePageBloc>(context).add(AddTaskEvent(task));
        // NotificationService.instance.scheduleSendNotifi(task);
      }
    }
  }
}

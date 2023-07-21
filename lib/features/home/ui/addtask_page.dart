import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_app/features/home/bloc/home_page_bloc.dart';
import 'package:todo_app/models/task.dart';
import 'package:intl/intl.dart';

class AddTaskPage extends StatefulWidget {
  const AddTaskPage({Key? key, required this.userId}) : super(key: key);

  final String userId;
  @override
  _AddTaskPageState createState() => _AddTaskPageState();
}

class _AddTaskPageState extends State<AddTaskPage> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  DateTime _selectedDate = DateTime.now();
  TimeOfDay _selectedTime = TimeOfDay.now();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Task'),
      ),
      body: BlocConsumer<HomePageBloc, HomePageState>(
        bloc: BlocProvider.of<HomePageBloc>(context),
        listener: (context, state) {
          if (state is AddTaskSuccessState) {
            BlocProvider.of<HomePageBloc>(context).add(AddedTaskEvent());
            Navigator.pop(context);
          }
        },
        builder: (context, state) {
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  TextFormField(
                    controller: _titleController,
                    decoration: const InputDecoration(
                      labelText: 'Title',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _descriptionController,
                    maxLines: 4,
                    decoration: const InputDecoration(
                      labelText: 'Description',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextButton(
                    onPressed: () => _selectDate(context),
                    child: Text(
                        'Select Date: ${DateFormat('dd/MM/yyyy').format(_selectedDate)}'),
                  ),
                  const SizedBox(height: 16),
                  TextButton(
                    onPressed: () => _selectTime(context),
                    child:
                        Text('Select Time: ${_selectedTime.format(context)}'),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      _addTask();
                    },
                    child: const Text('Add Task'),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2021),
      lastDate: DateTime(2030),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
        print("Check $_selectedDate");
      });
    }
  }

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: _selectedTime,
    );
    if (picked != null && picked != _selectedTime) {
      setState(() {
        _selectedTime = picked;
      });
    }
  }

  void _addTask() {
    String title = _titleController.text.trim().toString();
    String description = _descriptionController.text.trim().toString();
    DateTime dueDate = DateTime(_selectedDate.year, _selectedDate.month,
        _selectedDate.day, _selectedTime.hour, _selectedTime.minute);
    Random random = Random();
    String taskId = random.nextInt(1000).toString();
    Task addTask = Task(
        taskId: taskId,
        title: title,
        description: description,
        dueDate: dueDate,
        isCompleted: 0,
        userId: widget.userId);
    print("due date + ${addTask.isCompleted.runtimeType}");
    BlocProvider.of<HomePageBloc>(context).add(AddTaskClickedEvent(addTask));
  }
}

import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:intl/intl.dart';
import 'package:meta/meta.dart';
import 'package:todo_app/helper/taskhelper.dart';
import 'package:todo_app/models/task.dart';
import 'package:todo_app/sf/preferences.dart';

part 'home_page_event.dart';
part 'home_page_state.dart';

class HomePageBloc extends Bloc<HomePageEvent, HomePageState> {
  HomePageBloc() : super(HomePageInitial()) {
    on<HomePageLoadData>(homePageLoadData);
    on<AddButtonClickedEvent>(addButtonClickedEvent);
    on<UpdateButtonClickEvent>(updateButtonClickEvent);
    on<AddTaskEvent>(addTaskEvent);
    on<CompleteTaskEvent>(completeTaskEvent);
    on<DeleteTaskEvent>(deleteTaskEvent);
    on<UpdateTaskEvent>(updateTaskEvent);
  }

  FutureOr<void> homePageLoadData(
      HomePageLoadData event, Emitter<HomePageState> emit) async {
    DateTime dateTime = DateTime.now();
    String date = DateFormat('yyyy-MM-dd').format(dateTime);
    String? userId = await Preferences.instance.getUser();
    List<Task> listTask =
        await TaskHelper.instance.getAllTasks(userId!, event.dayOfWeek);
    double percentDone =
        await TaskHelper.instance.getAllTasksByDay(userId, date);
    emit(HomePageLoadSuccess(listTask, percentDone));
  }

  FutureOr<void> addButtonClickedEvent(
      AddButtonClickedEvent event, Emitter<HomePageState> emit) {
    print("Check addbtn");
    emit(HomePageAddButtonClickedState());
  }

  FutureOr<void> updateButtonClickEvent(
      UpdateButtonClickEvent event, Emitter<HomePageState> emit) {
    print("Check bloc clicked");
    emit(HomePageUpdateButtonClickedState(event.task));
  }

  FutureOr<void> addTaskEvent(AddTaskEvent event, Emitter<HomePageState> emit) {
    TaskHelper.instance.insertTask(event.task);
    emit(AddedTaskSuccessState());
  }

  FutureOr<void> completeTaskEvent(
      CompleteTaskEvent event, Emitter<HomePageState> emit) {
    Task task = event.task.copyWith(isCompleted: 1);
    print("Before update ${task.isCompleted}");
    TaskHelper.instance.updateTask(task);
    emit(CompletedTaskSuccessState());
  }

  FutureOr<void> deleteTaskEvent(
      DeleteTaskEvent event, Emitter<HomePageState> emit) {
    TaskHelper.instance.deleteTask(event.task);
    emit(DeletedTaskSuccessState());
  }

  FutureOr<void> updateTaskEvent(
      UpdateTaskEvent event, Emitter<HomePageState> emit) {
    print("before ${event.task.description}");
    Task task = event.task.copyWith(
        title: event.task.title,
        description: event.task.description,
        dueDate: event.task.dueDate);
    TaskHelper.instance.updateTask(task);
    emit(UpdatedTaskSuccessState());
  }
}

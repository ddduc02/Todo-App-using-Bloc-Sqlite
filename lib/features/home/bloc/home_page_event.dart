part of 'home_page_bloc.dart';

@immutable
abstract class HomePageEvent {}

class HomePageLoadData extends HomePageEvent {
  int dayOfWeek;
  HomePageLoadData(this.dayOfWeek);
}

class HeaderLoadEvent extends HomePageEvent {
  final String date;
  HeaderLoadEvent(this.date);
}

//navigate
class AddButtonClickedEvent extends HomePageEvent {}

class UpdateButtonClickEvent extends HomePageEvent {
  final Task task;
  UpdateButtonClickEvent(this.task);
}

// CRUD
class AddTaskEvent extends HomePageEvent {
  final Task task;
  AddTaskEvent(this.task);
}

class AddedTaskEvent extends HomePageEvent {}

class CompleteTaskEvent extends HomePageEvent {
  final Task task;
  CompleteTaskEvent(this.task);
}

class DeleteTaskEvent extends HomePageEvent {
  final Task task;
  DeleteTaskEvent(this.task);
}

class UpdateTaskEvent extends HomePageEvent {
  final Task task;
  UpdateTaskEvent(this.task);
}

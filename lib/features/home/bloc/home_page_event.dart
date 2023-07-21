part of 'home_page_bloc.dart';

@immutable
abstract class HomePageEvent {}

class HomePageLoadData extends HomePageEvent {}

class AddButtonClickedEvent extends HomePageEvent {}

class AddTaskClickedEvent extends HomePageEvent {
  final Task task;
  AddTaskClickedEvent(this.task);
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

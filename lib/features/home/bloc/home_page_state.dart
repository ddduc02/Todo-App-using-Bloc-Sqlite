part of 'home_page_bloc.dart';

@immutable
abstract class HomePageState {}

abstract class HomePageNavigate extends HomePageState {}

abstract class HomePageMessage extends HomePageState {}

class HomePageInitial extends HomePageState {}

class HomePageLoadSuccess extends HomePageState {
  final List<Task> listTask;

  HomePageLoadSuccess(this.listTask);
}

class HomePageAddButtonClickedState extends HomePageNavigate {}

class AddTaskSuccessState extends HomePageMessage {}

class CompletedTaskState extends HomePageMessage {}

class DeletedTaskSuccessState extends HomePageMessage {}

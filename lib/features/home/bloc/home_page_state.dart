part of 'home_page_bloc.dart';

@immutable
abstract class HomePageState {}

abstract class HomePageNavigate extends HomePageState {}

abstract class HomePageMessage extends HomePageState {}

class HomePageInitial extends HomePageState {}

class HomePageLoadSuccess extends HomePageState {
  final List<Task> listTask;
  double percentDone;

  HomePageLoadSuccess(this.listTask, this.percentDone);
}

// class HeaderLoadSuccess extends HomePageState {
//   double percentDone;
//   HeaderLoadSuccess(this.percentDone);
// }

class HomePageAddButtonClickedState extends HomePageNavigate {}

class HomePageUpdateButtonClickedState extends HomePageNavigate {
  final Task task;
  HomePageUpdateButtonClickedState(this.task);
}

class AddedTaskSuccessState extends HomePageMessage {}

class CompletedTaskSuccessState extends HomePageMessage {}

class DeletedTaskSuccessState extends HomePageMessage {}

class UpdatedTaskSuccessState extends HomePageMessage {}

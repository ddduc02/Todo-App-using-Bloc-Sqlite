import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:todo_app/helper/taskhelper.dart';
import 'package:todo_app/models/task.dart';
import 'package:todo_app/sf/preferences.dart';

part 'home_page_event.dart';
part 'home_page_state.dart';

class HomePageBloc extends Bloc<HomePageEvent, HomePageState> {
  HomePageBloc() : super(HomePageInitial()) {
    List<Task> listTask;
    on<HomePageLoadData>(((event, emit) async {
      String? userId = await Preferences.instance.getUser();
      listTask = await TaskHelper.instance.getAllTasks(userId!);
      emit(HomePageLoadSuccess(listTask));
    }));
    on<AddButtonClickedEvent>((event, emit) {
      print("Check addbtn");
      emit(HomePageAddButtonClickedState());
    });
    on<AddTaskClickedEvent>((event, emit) async {
      TaskHelper.instance.insertTask(event.task);
      emit(AddTaskSuccessState());
    });
    on<AddedTaskEvent>((event, emit) async {
      String? userId = await Preferences.instance.getUser();
      listTask = await TaskHelper.instance.getAllTasks(userId!);
      print("check length ${listTask.length}");
      emit(HomePageLoadSuccess(listTask));
    });
    on<CompleteTaskEvent>((event, emit) async {
      Task task = event.task.copyWith(isCompleted: 1);
      print("Before update ${task.isCompleted}");
      TaskHelper.instance.updateTask(task);
      String? userId = await Preferences.instance.getUser();
      listTask = await TaskHelper.instance.getAllTasks(userId!);
      emit(HomePageLoadSuccess(listTask));
    });

    on<DeleteTaskEvent>((event, emit) async {
      TaskHelper.instance.deleteTask(event.task);
      String? userId = await Preferences.instance.getUser();
      listTask = await TaskHelper.instance.getAllTasks(userId!);
      emit(HomePageLoadSuccess(listTask));
      emit(DeletedTaskSuccessState());
    });
  }
}

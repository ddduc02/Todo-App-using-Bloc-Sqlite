import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:todo_app/features/login/bloc/login_event.dart';
import 'package:todo_app/features/login/bloc/loginsubmission_status.dart';
import 'package:todo_app/helper/databasehelper.dart';

part 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  LoginBloc() : super(LoginInitialState()) {
    on<LoginInitialEvent>((event, emit) {
      emit(LoginInitialState());
    });
    on<LoginSubmitClickedEvent>((event, emit) async {
      bool check = await DataBaseHelper.instance.getUsers(event.userName, event.password);
      if(check){
        emit(LoginSubmitSuccessState());
      } else {
        emit(LoginSubmitFailed());
      }
    });
  }
}

import 'package:bloc/bloc.dart';
import 'package:todo_app/features/login/bloc/login_event.dart';
import 'package:todo_app/helper/userhelper.dart';
import 'package:todo_app/models/user.dart';
import 'package:todo_app/sf/preferences.dart';

part 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  LoginBloc() : super(LoginInitialState()) {
    on<LoginInitialEvent>((event, emit) {
      emit(LoginInitialState());
    });
    on<LoginSubmitClickedEvent>((event, emit) async {
      User? user =
          await UserHelper.instance.getUsers(event.userName, event.password);
      if (user != null) {
        Preferences.instance.setIsLoggedIn();
        Preferences.instance.setUser(user.id!);
        emit(LoginSubmitSuccessState(user));
      } else {
        emit(LoginSubmitFailed());
      }
    });
  }
}

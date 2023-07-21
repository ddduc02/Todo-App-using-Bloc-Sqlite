import 'dart:math';
import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:todo_app/helper/userhelper.dart';
import 'package:todo_app/models/user.dart';

part 'signup_event.dart';
part 'signup_state.dart';

class SignUpBloc extends Bloc<SignUpEvent, SignUpState> {
  SignUpBloc() : super(SignUpInitial()) {
    on<SignUpInitialEvent>((event, emit) {
      emit(SignUpInitial());
    });
    on<SignUpBtnClickedEvent>((event, emit) async {
      print("check clicked event");
      emit(SignUpLoadingState());
      await Future.delayed(const Duration(seconds: 2));
      var idRandom = Random().nextInt(1000);
      User user = User(idRandom.toString(), 0,
          username: event.userName, password: event.password);
      UserHelper.instance.insertUser(user);
      emit(SignUpSuccessState());
    });
  }
}

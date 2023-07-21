part of 'login_bloc.dart';

abstract class LoginState {
}

abstract class LoginMessage extends LoginState {}

class LoginInitialState extends LoginState {}

class LoginLoadingState extends LoginState {}

class LoginSubmitSuccessState extends LoginState {
  final User user;
  LoginSubmitSuccessState(this.user);}

class LoginSubmitFailed extends LoginMessage {}
part of 'signup_bloc.dart';

@immutable
abstract class SignUpEvent {}

class SignUpInitialEvent extends SignUpEvent  {}

class SignUpBtnClickedEvent extends SignUpEvent {
  String userName;
  String password;
  SignUpBtnClickedEvent(this.userName, this.password);
}



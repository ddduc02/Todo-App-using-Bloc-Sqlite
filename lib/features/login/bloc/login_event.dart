
abstract class LoginEvent {}

class LoginInitialEvent extends LoginEvent {}

class LoginSubmitClickedEvent extends LoginEvent {
  final String userName;
  final String password;
  LoginSubmitClickedEvent(this.userName, this.password);
}

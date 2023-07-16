abstract class LoginSubmissionStatus {
  const LoginSubmissionStatus();
}

class LoginInitialStatus extends LoginSubmissionStatus {
  const LoginInitialStatus();
}

class LoginSubmitting extends LoginSubmissionStatus {}

class LoginSuccess extends LoginSubmissionStatus {}

class LoginFailded extends LoginSubmissionStatus {}


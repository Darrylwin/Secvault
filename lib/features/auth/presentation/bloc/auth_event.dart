sealed class AuthEvent {}

class InitEvent extends AuthEvent {}

class LoginRequested extends AuthEvent {
  final String email;
  final String password;

  LoginRequested({required this.email, required this.password});
}

class RegisterRequested extends AuthEvent {
  final String email;
  final String password;

  RegisterRequested({required this.email, required this.password});
}

class LogoutRequested extends AuthEvent {}

class CheckAuthRequested extends AuthEvent {} //for get_current_user usecase

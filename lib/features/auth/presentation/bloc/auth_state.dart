sealed class AuthState {}

final class AuthInitial extends AuthState {}

final class AuthFailure extends AuthState {
  AuthFailure(this.failureMessage);

  final String failureMessage;
}

final class AUthLoading extends AuthState {}

final class AuthSuccess extends AuthState {
  final String uid;

  AuthSuccess(this.uid);
}

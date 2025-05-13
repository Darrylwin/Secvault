import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/usecases/login.dart';
import 'auth_event.dart';
import 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final Login loginUsecase;

  AuthBloc({required this.loginUsecase}) : super(AuthInitial()) {
    on<LoginRequested>(_onLoginRequested);
  }

  Future<void> _onLoginRequested(
      LoginRequested event, Emitter<AuthState> emit) async {
    emit(AuthLoading());

    try {
      final result =
          await loginUsecase(email: event.email, password: event.password);

      result.fold((failure) => emit(AuthFailure(failure.message)),
          (success) => emit(AuthSuccess()));
    } catch (e) {
      emit(AuthFailure('$e'));
    }
  }
}

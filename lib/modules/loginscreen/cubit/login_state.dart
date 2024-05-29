part of 'login_cubit.dart';

@immutable
sealed class LoginState {}

final class LoginInitial extends LoginState {}

final class ChangePasswordVisibilityState extends LoginState {}

final class LoginLoadingState extends LoginState {}

final class LoginSuccessState extends LoginState {
  final String token;

  LoginSuccessState(this.token);
}

final class LoginErrorState extends LoginState {
}

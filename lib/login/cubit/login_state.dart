part of 'login_cubit.dart';

@immutable
sealed class LoginState {
  final supabase.User? user;

  const LoginState({this.user});
}

final class LoginInitial extends LoginState {}

final class LoginSuccess extends LoginState {
  @override
  final supabase.User user;

  const LoginSuccess(this.user);
}

final class LoginFailed extends LoginState {}

final class LoginLoading extends LoginState {}

part of 'auth_bloc.dart';

@immutable
sealed class AuthEvent {
  final supabase.AuthState? state;

  const AuthEvent({this.state});
}

class AuthUserChanged extends AuthEvent {
  const AuthUserChanged(this.state);

  @override
  final supabase.AuthState? state;
}

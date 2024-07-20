part of 'auth_bloc.dart';

enum AuthStatus { unknown, authenticated, unauthenticated }

class AuthState {
  const AuthState._({
    this.status = AuthStatus.unknown,
    this.user,
  });

  const AuthState.unknown() : this._();

  const AuthState.authenticated(supabase.User user)
      : this._(status: AuthStatus.authenticated, user: user);

  const AuthState.unauthenticated()
      : this._(status: AuthStatus.unauthenticated);

  final AuthStatus status;
  final supabase.User? user;

  AuthState copyWith({
    AuthStatus? status,
    supabase.User? user,
  }) {
    return AuthState._(
      status: status ?? this.status,
      user: user ?? this.user,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AuthState &&
          runtimeType == other.runtimeType &&
          status == other.status &&
          user == other.user;

  @override
  int get hashCode => status.hashCode ^ user.hashCode;
}

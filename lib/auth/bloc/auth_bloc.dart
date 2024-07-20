import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:budsy/app/router.dart';
import 'package:budsy/auth/repository/auth_repository.dart';
import 'package:supabase_flutter/supabase_flutter.dart' as supabase;

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepository _authRepository;
  StreamSubscription<supabase.AuthState>? _userSubscription;
  AuthBloc({required AuthRepository authRepository})
      : _authRepository = authRepository,
        super(const AuthState.unknown()) {
    _userSubscription = _authRepository.authStateChanges.listen((state) {
      add(AuthUserChanged(state));
    });
    on<AuthUserChanged>((event, emit) async {
      if (event.state!.event == supabase.AuthChangeEvent.signedIn ||
          supabase.Supabase.instance.client.auth.currentUser != null) {
        emit(AuthState.authenticated(
          event.state!.session!.user,
        ));
        goRouter.refresh();
      } else {
        emit(const AuthState.unauthenticated());
      }
    });
  }
  @override
  Future<void> close() {
    _userSubscription?.cancel();
    return super.close();
  }
}

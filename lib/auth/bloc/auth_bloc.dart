import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:canjo/app/router.dart';
import 'package:canjo/auth/repository/auth_repository.dart';
import 'package:sentry_flutter/sentry_flutter.dart';
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
        SentryUser user = SentryUser(
            id: event.state!.session!.user.id,
            email: event.state!.session!.user.email);
        await Sentry.configureScope((scope) async => await scope.setUser(user));
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

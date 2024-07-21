import 'package:bloc/bloc.dart';
import 'package:budsy/app/router.dart';
import 'package:budsy/auth/repository/auth_repository.dart';
import 'package:budsy/subscription/subscription_repository.dart';
import 'package:meta/meta.dart';
import 'package:supabase/supabase.dart' as supabase;
import 'package:supabase_flutter/supabase_flutter.dart';

part 'login_state.dart';

class LoginCubit extends Cubit<LoginState> {
  final AuthRepository _authRepository;
  final SubscriptionRepository _subscriptionRepository;
  LoginCubit(
      {required AuthRepository authRepository,
      required SubscriptionRepository subscriptionRepository})
      : _authRepository = authRepository,
        _subscriptionRepository = subscriptionRepository,
        super(LoginInitial());

  Future<void> signInWithGoogle() => _signInWithGoogle();
  Future<void> signInWithApple() => _signInWithApple();
  Future<void> signOut() => _onSignOut();

  Future<void> _signInWithGoogle() async {
    try {
      supabase.AuthResponse authResponse =
          await _authRepository.signInWithGoogle();

      if (authResponse.user == null) {
        emit(LoginFailed());
        return;
      }

      await _subscriptionRepository.login(authResponse.user!.id);

      emit(LoginSuccess(authResponse.user!));
    } catch (e) {
      emit(LoginFailed());
    }
  }

  Future<void> _signInWithApple() async {
    try {
      supabase.AuthResponse authResponse =
          await _authRepository.signInWithApple();

      if (authResponse.user == null) {
        emit(LoginFailed());
        return;
      }

      await _subscriptionRepository.login(authResponse.user!.id);

      emit(LoginSuccess(authResponse.user!));
    } catch (e) {
      emit(LoginFailed());
    }
  }

  Future<void> _onSignOut() async {
    try {
      await _authRepository.signOut();
      goRouter.go('/login');
      emit(LoginInitial());
    } catch (e) {
      emit(LoginFailed());
    }
  }
}

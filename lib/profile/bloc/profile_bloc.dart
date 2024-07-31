import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:canjo/app/snackbars.dart';
import 'package:canjo/auth/bloc/auth_bloc.dart';
import 'package:canjo/consts.dart';
import 'package:canjo/login/cubit/login_cubit.dart';
import 'package:canjo/profile/model/user.dart';
import 'package:canjo/profile/repository/profile_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:supabase_flutter/supabase_flutter.dart' as sb;

part 'profile_event.dart';
part 'profile_state.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  final AuthBloc _authBloc;
  final LoginCubit _loginCubit;
  StreamSubscription? _authBlocSubscription;
  StreamSubscription? _loginCubitSubscription;
  final ProfileRepository _profileRepository;
  ProfileBloc({
    required ProfileRepository profileRepository,
    required AuthBloc authBloc,
    required LoginCubit loginCubit,
  })  : _profileRepository = profileRepository,
        _authBloc = authBloc,
        _loginCubit = loginCubit,
        super(ProfileInitial()) {
    _authBlocSubscription = _authBloc.stream.listen((authState) {
      if (authState.status == AuthStatus.authenticated) {
        add(CreateProfile(
          user: User(
            id: authState.user!.id,
            email: authState.user!.email,
          ),
        ));
      }
    });

    _loginCubitSubscription = _loginCubit.stream.listen((loginState) {
      if (loginState is LoginSuccess) {
        add(LoadProfile());
      }
    });

    on<LoadProfile>(_onLoadProfile);
    on<CreateProfile>(_onCreateProfile);
    on<UpdateProfile>(_onUpdateProfile);
    on<DeleteProfile>(_onDeleteProfile);
  }

  void _onLoadProfile(LoadProfile event, Emitter<ProfileState> emit) async {
    emit(ProfileLoading());
    try {
      final user = await _profileRepository
          .getUser(sb.Supabase.instance.client.auth.currentUser!.id);
      if (user == null) {
        emit(const ProfileError(message: 'Failed to load user'));
        return;
      }
      emit(ProfileLoaded(user: user));
    } catch (e) {
      print(e);
      scaffoldKey.currentState
          ?.showSnackBar(getErrorSnackBar('Failed to load user: $e'));
      emit(ProfileError(message: e.toString()));
    }
  }

  void _onCreateProfile(CreateProfile event, Emitter<ProfileState> emit) async {
    emit(ProfileLoading());
    try {
      User? user = await _profileRepository.createUser(event.user);
      if (user == null) {
        emit(const ProfileError(message: 'Failed to create user'));
        return;
      }
      emit(ProfileLoaded(user: event.user));
    } catch (e) {
      scaffoldKey.currentState
          ?.showSnackBar(getErrorSnackBar('Failed to create user: $e'));
      emit(ProfileError(message: e.toString()));
    }
  }

  void _onUpdateProfile(UpdateProfile event, Emitter<ProfileState> emit) async {
    emit(ProfileLoading());
    try {
      await _profileRepository.updateUser(event.user);
      emit(ProfileLoaded(user: event.user));
    } catch (e) {
      scaffoldKey.currentState
          ?.showSnackBar(getErrorSnackBar('Failed to update user: $e'));
      emit(ProfileError(message: e.toString()));
    }
  }

  void _onDeleteProfile(DeleteProfile event, Emitter<ProfileState> emit) async {
    emit(ProfileLoading());
    try {
      await _profileRepository.deleteUser();
      emit(ProfileInitial());
    } catch (e) {
      scaffoldKey.currentState
          ?.showSnackBar(getErrorSnackBar('Failed to delete user: $e'));
      emit(ProfileError(message: e.toString()));
    }
  }

  @override
  Future<void> close() {
    _authBlocSubscription?.cancel();
    _loginCubitSubscription?.cancel();
    return super.close();
  }
}

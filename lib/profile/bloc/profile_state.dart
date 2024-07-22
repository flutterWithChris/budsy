part of 'profile_bloc.dart';

sealed class ProfileState extends Equatable {
  final User? user;
  const ProfileState({this.user});

  @override
  List<Object?> get props => [user];
}

final class ProfileInitial extends ProfileState {}

final class ProfileLoading extends ProfileState {}

final class ProfileLoaded extends ProfileState {
  @override
  final User user;
  const ProfileLoaded({required this.user});

  @override
  List<Object?> get props => [user];
}

final class ProfileError extends ProfileState {
  final String message;
  const ProfileError({required this.message});

  @override
  List<Object?> get props => [message];
}

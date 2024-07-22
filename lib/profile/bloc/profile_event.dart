part of 'profile_bloc.dart';

sealed class ProfileEvent extends Equatable {
  const ProfileEvent();

  @override
  List<Object> get props => [];
}

final class LoadProfile extends ProfileEvent {}

final class CreateProfile extends ProfileEvent {
  final User user;
  const CreateProfile({required this.user});

  @override
  List<Object> get props => [user];
}

final class UpdateProfile extends ProfileEvent {
  final User user;
  const UpdateProfile({required this.user});

  @override
  List<Object> get props => [user];
}

final class DeleteProfile extends ProfileEvent {}

part of 'feelings_cubit.dart';

sealed class FeelingsState extends Equatable {
  const FeelingsState();

  @override
  List<Object> get props => [];
}

final class FeelingsInitial extends FeelingsState {}

final class FeelingsLoading extends FeelingsState {}

final class FeelingsLoaded extends FeelingsState {
  final List<Feeling> feelings;

  const FeelingsLoaded(this.feelings);

  @override
  List<Object> get props => [feelings];
}

final class FeelingsError extends FeelingsState {
  final String message;

  const FeelingsError(this.message);

  @override
  List<Object> get props => [message];
}

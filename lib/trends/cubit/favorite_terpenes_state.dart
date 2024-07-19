part of 'favorite_terpenes_cubit.dart';

sealed class FavoriteTerpenesState extends Equatable {
  const FavoriteTerpenesState();

  @override
  List<Object> get props => [];
}

final class FavoriteTerpenesInitial extends FavoriteTerpenesState {}

final class FavoriteTerpenesLoading extends FavoriteTerpenesState {}

final class FavoriteTerpenesLoaded extends FavoriteTerpenesState {
  final List<Terpene> terpenes;

  const FavoriteTerpenesLoaded(this.terpenes);

  @override
  List<Object> get props => [terpenes];
}

final class FavoriteTerpenesError extends FavoriteTerpenesState {
  final String message;

  const FavoriteTerpenesError(this.message);

  @override
  List<Object> get props => [message];
}

part of 'stash_bloc.dart';

@immutable
sealed class StashState {}

final class StashInitial extends StashState {}

final class StashLoading extends StashState {}

final class StashLoaded extends StashState {
  final List<Product> products;

  StashLoaded(this.products);
}

final class StashError extends StashState {
  final String message;

  StashError(this.message);
}

final class ProductUpdated extends StashState {
  final Product product;

  ProductUpdated(this.product);
}

final class ProductAdded extends StashState {
  final Product product;

  ProductAdded(this.product);
}

final class ProductRemoved extends StashState {
  final Product product;

  ProductRemoved(this.product);
}

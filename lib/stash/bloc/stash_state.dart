part of 'stash_bloc.dart';

@immutable
sealed class StashState extends Equatable {
  final List<Product>? products;
  final Product? product;
  final String? message;

  const StashState({
    this.products,
    this.product,
    this.message,
  });

  @override
  List<Object?> get props => [
        products,
        product,
        message,
      ];
}

final class StashInitial extends StashState {}

final class StashLoading extends StashState {}

final class StashLoaded extends StashState {
  @override
  final List<Product> products;

  const StashLoaded(this.products);
}

final class StashError extends StashState {
  @override
  final String message;

  const StashError(this.message);
}

final class ProductUpdated extends StashState {
  @override
  final Product product;

  const ProductUpdated(this.product);
}

final class ProductAdded extends StashState {
  @override
  final Product product;

  const ProductAdded(this.product);
}

final class ProductRemoved extends StashState {
  @override
  final Product product;

  const ProductRemoved(this.product);
}

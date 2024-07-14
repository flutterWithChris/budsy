part of 'product_details_bloc.dart';

@immutable
sealed class ProductDetailsState extends Equatable {
  final Product? product;
  final List<String>? images;
  final List<Cannabinoid>? cannabinoids;
  final List<Terpene>? terpenes;

  const ProductDetailsState({
    this.product,
    this.images,
    this.cannabinoids,
    this.terpenes,
  });

  @override
  List<Object?> get props => [product, images, cannabinoids, terpenes];
}

final class ProductDetailsInitial extends ProductDetailsState {}

final class ProductDetailsLoading extends ProductDetailsState {}

final class ProductDetailsLoaded extends ProductDetailsState {
  @override
  final Product product;
  @override
  final List<String> images;
  @override
  final List<Cannabinoid> cannabinoids;
  @override
  final List<Terpene> terpenes;

  const ProductDetailsLoaded({
    required this.product,
    required this.images,
    required this.cannabinoids,
    required this.terpenes,
  });
}

final class ProductDetailsError extends ProductDetailsState {
  final String message;

  const ProductDetailsError(this.message);
}

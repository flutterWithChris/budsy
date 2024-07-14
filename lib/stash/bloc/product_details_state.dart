part of 'product_details_bloc.dart';

@immutable
sealed class ProductDetailsState {}

final class ProductDetailsInitial extends ProductDetailsState {}

final class ProductDetailsLoading extends ProductDetailsState {}

final class ProductDetailsLoaded extends ProductDetailsState {
  final Product product;
  final List<String> images;
  final List<Cannabinoid> cannabinoids;
  final List<Terpene> terpenes;

  ProductDetailsLoaded({
    required this.product,
    required this.images,
    required this.cannabinoids,
    required this.terpenes,
  });
}

final class ProductDetailsError extends ProductDetailsState {
  final String message;

  ProductDetailsError(this.message);
}

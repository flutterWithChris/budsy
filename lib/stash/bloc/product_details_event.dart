part of 'product_details_bloc.dart';

@immutable
class ProductDetailsEvent {}

class FetchProductDetails extends ProductDetailsEvent {
  final Product product;

  FetchProductDetails(this.product);
}

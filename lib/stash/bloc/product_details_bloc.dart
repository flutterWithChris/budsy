import 'package:bloc/bloc.dart';
import 'package:budsy/stash/model/cannabinoid.dart';
import 'package:budsy/stash/model/product.dart';
import 'package:budsy/stash/model/terpene.dart';
import 'package:budsy/stash/repository/product_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

part 'product_details_event.dart';
part 'product_details_state.dart';

class ProductDetailsBloc
    extends Bloc<ProductDetailsEvent, ProductDetailsState> {
  final ProductRepository _productRepository;
  ProductDetailsBloc({required ProductRepository productRepository})
      : _productRepository = productRepository,
        super(ProductDetailsLoading()) {
    on<FetchProductDetails>(_onFetchProductDetails);
  }

  void _onFetchProductDetails(
      FetchProductDetails event, Emitter<ProductDetailsState> emit) async {
    emit(ProductDetailsLoading());
    try {
      final product = event.product;
      List<Cannabinoid> cannabinoids =
          await _productRepository.fetchCannabinoids(event.product.id!) ?? [];
      List<Terpene> terpenes =
          await _productRepository.fetchTerpenes(event.product.id!) ?? [];
      List<String> images =
          await _productRepository.fetchProductImages(event.product.id!) ?? [];

      emit(ProductDetailsLoaded(
          product: product,
          images: images,
          cannabinoids: cannabinoids,
          terpenes: terpenes));
    } catch (e) {
      emit(ProductDetailsError(e.toString()));
    }
  }
}

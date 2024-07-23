import 'package:bloc/bloc.dart';
import 'package:canjo/stash/model/cannabinoid.dart';
import 'package:canjo/stash/model/product.dart';
import 'package:canjo/stash/model/terpene.dart';
import 'package:canjo/stash/repository/product_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:image_picker/image_picker.dart';
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
      final productId = event.product.id!;
      final product = await _productRepository.fetchProductById(productId);

      if (product == null) {
        emit(const ProductDetailsError('Error fetching product'));
        return;
      }

      List<Cannabinoid> cannabinoids =
          await _productRepository.fetchCannabinoids(productId) ?? [];
      List<Terpene> terpenes =
          await _productRepository.fetchTerpenes(productId) ?? [];
      List<String> images =
          await _productRepository.fetchProductImages(productId) ?? [];
      print('Images: $images');
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

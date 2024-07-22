import 'package:bloc/bloc.dart';
import 'package:canjo/stash/model/product.dart';
import 'package:equatable/equatable.dart';

part 'products_state.dart';

class ProductsCubit extends Cubit<ProductsState> {
  ProductsCubit() : super(ProductsInitial());
  void loadProducts() => _onLoadProducts();

  void _onLoadProducts() async {
    emit(ProductsLoading());
    try {
      // List<Product>? products = await _productsRepository.getProducts();
      // print(products);
      // if (products == null) {
      //   emit(const ProductsError('Failed to load products'));
      //   return;
      // }
      // emit(ProductsLoaded(products));
    } catch (e) {
      print(e);
      emit(const ProductsError('Failed to load products'));
    }
  }
}

import 'package:bloc/bloc.dart';
import 'package:budsy/stash/model/product.dart';
import 'package:budsy/stash/repository/product_repository.dart';
import 'package:meta/meta.dart';

part 'stash_event.dart';
part 'stash_state.dart';

class StashBloc extends Bloc<StashEvent, StashState> {
  final ProductRepository _productRepository;
  StashBloc({required ProductRepository productRepository})
      : _productRepository = productRepository,
        super(StashLoading()) {
    on<FetchStash>(_onFetchStash);
    on<AddToStash>(_onAddToStash);
    on<RemoveFromStash>(_onRemoveFromStash);
    on<UpdateProduct>(_onUpdateProduct);
  }

  void _onFetchStash(FetchStash event, Emitter<StashState> emit) async {
    emit(StashLoading());
    try {
      final products = await _productRepository.fetchProducts(event.userId);
      print('Products: $products');
      emit(StashLoaded(products ?? []));
    } catch (e) {
      emit(StashError(e.toString()));
    }
  }

  void _onAddToStash(AddToStash event, Emitter<StashState> emit) async {
    try {
      emit(StashLoading());
      await _productRepository.addProduct(event.product);
      emit(StashLoaded(
          await _productRepository.fetchProducts(event.userId) ?? []));
    } catch (e) {
      emit(StashError(e.toString()));
    }
  }

  void _onRemoveFromStash(
      RemoveFromStash event, Emitter<StashState> emit) async {
    try {
      emit(StashLoading());
      await _productRepository.deleteProduct(event.product.id!);
      emit(StashLoaded(
          await _productRepository.fetchProducts(event.userId) ?? []));
    } catch (e) {
      emit(StashError(e.toString()));
    }
  }

  void _onUpdateProduct(UpdateProduct event, Emitter<StashState> emit) async {
    try {
      emit(StashLoading());
      await _productRepository.updateProduct(event.product);
      emit(StashLoaded(
          await _productRepository.fetchProducts(event.userId) ?? []));
    } catch (e) {
      emit(StashError(e.toString()));
    }
  }
}

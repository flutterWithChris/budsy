import 'package:bloc/bloc.dart';
import 'package:budsy/auth/bloc/auth_bloc.dart';
import 'package:budsy/consts.dart';
import 'package:budsy/stash/model/cannabinoid.dart';
import 'package:budsy/stash/model/product.dart';
import 'package:budsy/stash/model/terpene.dart';
import 'package:budsy/stash/repository/product_repository.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:meta/meta.dart';

part 'stash_event.dart';
part 'stash_state.dart';

class StashBloc extends Bloc<StashEvent, StashState> {
  final ProductRepository _productRepository;
  final AuthBloc _authBloc;
  List<Cannabinoid>? allCannabinoids;
  List<Terpene>? allTerpenes;
  Product? productDraft;
  StashBloc(
      {required ProductRepository productRepository,
      required AuthBloc authBloc})
      : _productRepository = productRepository,
        _authBloc = authBloc,
        super(StashLoading()) {
    on<FetchStash>(_onFetchStash);
    on<AddToStash>(_onAddToStash);
    on<RemoveFromStash>(_onRemoveFromStash);
    on<UpdateProduct>(_onUpdateProduct);
  }

  void _onFetchStash(FetchStash event, Emitter<StashState> emit) async {
    emit(StashLoading());
    try {
      List<Product>? products;

      await Future.wait([
        _productRepository.fetchProducts(event.userId),
        _productRepository.fetchAllCannabinoids(),
        _productRepository.fetchAllTerpenes()
      ]).then((value) {
        products = value[0] as List<Product>?;
        allCannabinoids = value[1] as List<Cannabinoid>?;
        allTerpenes = value[2] as List<Terpene>?;
      });
      print('All Cannabinoids: $allCannabinoids');
      print('All Terpenes: ${allTerpenes?.length}');
      print('Products: $products');
      if (products == null) {
        emit(StashError('Error fetching stash'));
        return;
      }
      emit(StashLoaded(products!));
    } catch (e) {
      emit(StashError(e.toString()));
    }
  }

  void _onAddToStash(AddToStash event, Emitter<StashState> emit) async {
    try {
      emit(StashLoading());
      Product? product = await _productRepository.addProduct(event.product);
      if (product == null) {
        emit(StashError('Error adding product'));
        return;
      }
      if (event.product.cannabinoids != null) {
        await _productRepository.addProductCannabinoids(
            product.id!, event.product.cannabinoids!);
      }
      if (event.product.terpenes != null) {
        await _productRepository.addProductTerpenes(
            product.id!, event.product.terpenes!);
      }
      if (event.images.isNotEmpty) {
        await _productRepository.addProductImages(product.id!, event.images);
      }
      add(FetchStash(_authBloc.state.user!.id));
    } catch (e) {
      emit(StashError(e.toString()));
    }
  }

  void _onRemoveFromStash(
      RemoveFromStash event, Emitter<StashState> emit) async {
    try {
      emit(StashLoading());
      await _productRepository.deleteProduct(event.product.id!);
      add(FetchStash(_authBloc.state.user!.id));
    } catch (e) {
      emit(StashError(e.toString()));
    }
  }

  void _onUpdateProduct(UpdateProduct event, Emitter<StashState> emit) async {
    try {
      emit(StashLoading());
      Product product = await _productRepository.updateProduct(event.product);
      emit(StashUpdated(product));
      add(FetchStash(_authBloc.state.user!.id));
    } catch (e) {
      print(e);

      emit(StashError(e.toString()));
    }
  }
}

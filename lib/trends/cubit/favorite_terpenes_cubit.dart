import 'package:bloc/bloc.dart';
import 'package:canjo/app/snackbars.dart';
import 'package:canjo/consts.dart';
import 'package:canjo/stash/model/product.dart';
import 'package:canjo/stash/model/terpene.dart';
import 'package:canjo/stash/repository/product_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:sentry_flutter/sentry_flutter.dart';

part 'favorite_terpenes_state.dart';

class FavoriteTerpenesCubit extends Cubit<FavoriteTerpenesState> {
  final ProductRepository _productRepository;
  FavoriteTerpenesCubit({required ProductRepository productRepository})
      : _productRepository = productRepository,
        super(FavoriteTerpenesInitial());
  void loadFavoriteTerpenes(List<Product> products) => _onLoadFavoriteTerpenes(
        products,
      );

  void _onLoadFavoriteTerpenes(List<Product> favoriteProducts) async {
    emit(FavoriteTerpenesLoading());
    try {
      List<Product> productsWithTerpenes = [];
      Map<Terpene, int> favoriteTerpenes = {};
      for (var product in favoriteProducts) {
        List<Terpene> terpenes =
            await _productRepository.fetchTerpenes(product.id!) ?? [];
        if (terpenes.isNotEmpty) {
          for (var terpene in terpenes) {
            if (favoriteTerpenes.containsKey(terpene)) {
              favoriteTerpenes[terpene] = favoriteTerpenes[terpene]! + 1;
            } else {
              favoriteTerpenes[terpene] = 1;
            }
          }
        }
      }
      List<Terpene> sortedTerpenes = favoriteTerpenes.keys.toList()
        ..sort((a, b) => favoriteTerpenes[b]!.compareTo(favoriteTerpenes[a]!));

      emit(FavoriteTerpenesLoaded(sortedTerpenes.take(3).toList()));
    } catch (e, stackTrace) {
      scaffoldKey.currentState?.showSnackBar(
        getErrorSnackBar('Failed to load favorite terpenes. Please try again.'),
      );
      await Sentry.captureException(
        e,
        stackTrace: stackTrace,
      );
      return null;

      emit(FavoriteTerpenesError(e.toString()));
    }
  }
}

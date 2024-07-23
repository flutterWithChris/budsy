part of 'stash_bloc.dart';

@immutable
sealed class StashEvent {}

class FetchStash extends StashEvent {
  final String userId;

  FetchStash(this.userId);
}

class AddToStash extends StashEvent {
  final Product product;
  final List<XFile> images;

  AddToStash(this.product, this.images);
}

class RemoveFromStash extends StashEvent {
  final Product product;

  RemoveFromStash(this.product);
}

class UpdateProduct extends StashEvent {
  final Product product;
  final List<XFile>? images;

  UpdateProduct(this.product, {this.images});
}

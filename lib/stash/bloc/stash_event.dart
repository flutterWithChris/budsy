part of 'stash_bloc.dart';

@immutable
sealed class StashEvent {}

class FetchStash extends StashEvent {
  final String userId;

  FetchStash(this.userId);
}

class AddToStash extends StashEvent {
  final String userId;
  final Product product;

  AddToStash(this.userId, this.product);
}

class RemoveFromStash extends StashEvent {
  final String userId;
  final Product product;

  RemoveFromStash(this.userId, this.product);
}

class UpdateProduct extends StashEvent {
  final String userId;
  final Product product;

  UpdateProduct(this.userId, this.product);
}

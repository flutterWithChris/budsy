part of 'subscription_bloc.dart';

sealed class SubscriptionState extends Equatable {
  final CustomerInfo? customerInfo;
  final List<Package>? packages;
  const SubscriptionState({this.customerInfo, this.packages});

  @override
  List<Object?> get props => [packages];
}

final class SubscriptionInitial extends SubscriptionState {}

final class SubscriptionLoading extends SubscriptionState {}

final class SubscriptionLoaded extends SubscriptionState {
  @override
  final CustomerInfo? customerInfo;
  @override
  final List<Package>? packages;

  const SubscriptionLoaded({this.customerInfo, this.packages});

  @override
  List<Object?> get props => [customerInfo, packages];
}

final class SubscriptionError extends SubscriptionState {
  final String error;

  const SubscriptionError(this.error);

  @override
  List<Object> get props => [error];
}

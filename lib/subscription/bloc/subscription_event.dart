part of 'subscription_bloc.dart';

sealed class SubscriptionEvent extends Equatable {
  const SubscriptionEvent();

  @override
  List<Object?> get props => [];
}

class SubscriptionInit extends SubscriptionEvent {
  final String? userId;

  const SubscriptionInit(this.userId);

  @override
  List<Object?> get props => [userId];
}

class SubscriptionLogin extends SubscriptionEvent {
  final String userId;

  const SubscriptionLogin(this.userId);

  @override
  List<Object?> get props => [userId];
}

class SubscriptionLogout extends SubscriptionEvent {}

class SubscriptionGetCustomerInfo extends SubscriptionEvent {}

class SubscriptionCustomerInfoUpdate extends SubscriptionEvent {
  final CustomerInfo customerInfo;

  const SubscriptionCustomerInfoUpdate(this.customerInfo);

  @override
  List<Object> get props => [customerInfo];
}

class GetMonthlySubscription extends SubscriptionEvent {
  final Offerings offerings;

  const GetMonthlySubscription(this.offerings);

  @override
  List<Object> get props => [offerings];
}

class PurchaseSubscription extends SubscriptionEvent {
  final Package package;

  const PurchaseSubscription(this.package);

  @override
  List<Object> get props => [package];
}

class ShowPaywall extends SubscriptionEvent {}

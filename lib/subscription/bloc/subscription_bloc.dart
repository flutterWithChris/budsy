import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:canjo/app/snackbars.dart';
import 'package:canjo/auth/bloc/auth_bloc.dart';
import 'package:canjo/consts.dart';
import 'package:canjo/login/cubit/login_cubit.dart';
import 'package:canjo/subscription/subscription_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:purchases_flutter/models/customer_info_wrapper.dart';
import 'package:purchases_flutter/purchases_flutter.dart';
import 'package:purchases_ui_flutter/purchases_ui_flutter.dart';

part 'subscription_event.dart';
part 'subscription_state.dart';

class SubscriptionBloc extends Bloc<SubscriptionEvent, SubscriptionState> {
  final SubscriptionRepository _subscriptionRepository;
  final LoginCubit _loginCubit;
  final AuthBloc _authBloc;
  StreamSubscription? _loginStateStream;
  CustomerInfo? customerInfo;
  SubscriptionBloc(
      {required SubscriptionRepository subscriptionRepository,
      required LoginCubit loginCubit,
      required AuthBloc authBloc})
      : _subscriptionRepository = subscriptionRepository,
        _loginCubit = loginCubit,
        _authBloc = authBloc,
        super(SubscriptionLoading()) {
    on<SubscriptionInit>(_onSubscriptionInit);
    on<SubscriptionLogin>(_onSubscriptionLogin);
    on<SubscriptionLogout>(_onSubscriptionLogout);
    on<SubscriptionGetCustomerInfo>(_onSubscriptionGetCustomerInfo);
    on<PurchaseSubscription>(_onPurchaseSubscription);
    on<ShowPaywall>(_onShowPaywall);

    _loginStateStream = _authBloc.stream.listen((state) {
      if (state.status == AuthStatus.authenticated) {
        print('SubscriptionBloc: AuthStatus.authenticated');
        add(SubscriptionLogin(state.user!.id));
      }
    });

    // Listen to customer info update
    _subscriptionRepository.setListenCustomerInfoFunction((customerInfo) {
      add(SubscriptionCustomerInfoUpdate(customerInfo));
    });
  }

  // Init SDK
  void _onSubscriptionInit(
      SubscriptionInit event, Emitter<SubscriptionState> emit) async {
    try {
      emit(SubscriptionLoading());
      await _subscriptionRepository.initPlatformState(event.userId);

      emit(const SubscriptionLoaded());
    } catch (e) {
      print(e);
      emit(const SubscriptionError('Failed to init SDK'));
    }
  }

  // Login
  void _onSubscriptionLogin(
      SubscriptionLogin event, Emitter<SubscriptionState> emit) async {
    try {
      emit(SubscriptionLoading());
      await _subscriptionRepository.login(event.userId);
      CustomerInfo? customerInfo =
          await _subscriptionRepository.getCustomerInfo();
      if (customerInfo != null) {
        emit(SubscriptionLoaded(customerInfo: customerInfo));
      } else {
        emit(const SubscriptionError('Failed to get customer info'));
      }
    } catch (e) {
      print(e);
      emit(const SubscriptionError('Failed to login'));
    }
  }

  // Logout
  void _onSubscriptionLogout(
      SubscriptionLogout event, Emitter<SubscriptionState> emit) async {
    try {
      emit(SubscriptionLoading());
      await _subscriptionRepository.logout();
      emit(SubscriptionInitial());
    } catch (e) {
      print(e);
      emit(const SubscriptionError('Failed to logout'));
    }
  }

  // Get customer info
  void _onSubscriptionGetCustomerInfo(SubscriptionGetCustomerInfo event,
      Emitter<SubscriptionState> emit) async {
    try {
      emit(SubscriptionLoading());
      CustomerInfo? customerInfo =
          await _subscriptionRepository.getCustomerInfo();
      if (customerInfo != null) {
        emit(SubscriptionLoaded(customerInfo: customerInfo));
      } else {
        emit(const SubscriptionError('Failed to get customer info'));
      }
    } catch (e) {
      print(e);
      emit(const SubscriptionError('Failed to get customer info'));
    }
  }

  // Customer info update
  void _onSubscriptionCustomerInfoUpdate(SubscriptionCustomerInfoUpdate event,
      Emitter<SubscriptionState> emit) async {
    emit(SubscriptionLoaded(customerInfo: event.customerInfo));
  }

  // Purchase subscription
  void _onPurchaseSubscription(
      PurchaseSubscription event, Emitter<SubscriptionState> emit) async {
    try {
      emit(SubscriptionLoading());
      CustomerInfo? updatedInfo =
          await _subscriptionRepository.purchasePackage(event.package);
      if (updatedInfo == null) {
        emit(const SubscriptionError('Failed to purchase subscription'));
        return;
      }
      emit(SubscriptionLoaded(
        customerInfo: updatedInfo,
      ));
    } catch (e) {
      print(e);
      emit(const SubscriptionError('Failed to purchase subscription'));
    }
  }

  // Show paywall
  void _onShowPaywall(
      ShowPaywall event, Emitter<SubscriptionState> emit) async {
    try {
      SubscriptionState oldState = state;
      emit(SubscriptionLoading());
      final paywallResult =
          await RevenueCatUI.presentPaywall(displayCloseButton: true);
      if (paywallResult == PaywallResult.purchased ||
          paywallResult == PaywallResult.restored) {
        CustomerInfo? updatedInfo =
            await _subscriptionRepository.getCustomerInfo();
        if (updatedInfo == null) {
          scaffoldKey.currentState!.showSnackBar(
            getErrorSnackBar('Failed to get customer info'),
          );
          emit(const SubscriptionError('Failed to get customer info'));
          return;
        }
        scaffoldKey.currentState!.showSnackBar(
          getSuccessSnackBar('Subscription purchased!'),
        );
        emit(SubscriptionLoaded(
          customerInfo: updatedInfo,
        ));
      } else if (paywallResult == PaywallResult.cancelled) {
        emit(SubscriptionLoaded(customerInfo: oldState.customerInfo));
      } else {
        scaffoldKey.currentState!.showSnackBar(
          getErrorSnackBar('Failed to purchase subscription'),
        );
        emit(const SubscriptionError('Failed to purchase subscription'));
      }
    } catch (e) {
      print(e);
      emit(const SubscriptionError('Failed to show paywall'));
      emit(const SubscriptionError('Failed to get offerings'));
    }
  }

  @override
  Future<void> close() {
    // TODO: implement close
    _loginStateStream?.cancel();
    return super.close();
  }
}

import 'dart:io';

import 'package:canjo/app/snackbars.dart';
import 'package:canjo/consts.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:purchases_flutter/purchases_flutter.dart';
import 'package:sentry_flutter/sentry_flutter.dart';

class SubscriptionRepository {
  Future<void> initPlatformState(String? userId) async {
    await Purchases.setLogLevel(LogLevel.error);

    try {
      PurchasesConfiguration configuration;
      if (Platform.isAndroid) {
        configuration = PurchasesConfiguration(
          dotenv.env['REVCAT_ANDROID_API_KEY']!,
        );
      } else {
        configuration = PurchasesConfiguration(
          dotenv.env['REVCAT_IOS_API_KEY']!,
        );
      }
      userId != null
          ? await Purchases.configure(configuration..appUserID = userId)
          : await Purchases.configure(configuration);
    } catch (e, stackTrace) {
      scaffoldKey.currentState?.showSnackBar(
        getErrorSnackBar('Failed to configure Purchases. Please try again.'),
      );
      await Sentry.captureException(
        e,
        stackTrace: stackTrace,
      );
      print(e);
    }
  }

  Future<void> login(String userId) async {
    try {
      await Purchases.logIn(userId);
    } catch (e, stackTrace) {
      scaffoldKey.currentState?.showSnackBar(
        getErrorSnackBar('Failed to login. Please try again.'),
      );
      await Sentry.captureException(
        e,
        stackTrace: stackTrace,
      );
    }
  }

  // Simply do not logout the SDK. In the case of switching accounts, you can call login when the user logs in to the different account with their new App User ID.
  Future<void> logout() async {
    try {
      await Purchases.logOut();
    } catch (e, stackTrace) {
      scaffoldKey.currentState?.showSnackBar(
        getErrorSnackBar('Failed to logout. Please try again.'),
      );
      await Sentry.captureException(
        e,
        stackTrace: stackTrace,
      );
    }
  }

  Future<CustomerInfo?> getCustomerInfo() async {
    try {
      final customerInfo = await Purchases.getCustomerInfo();
      print(customerInfo);
      return customerInfo;
    } catch (e, stackTrace) {
      scaffoldKey.currentState?.showSnackBar(
        getErrorSnackBar('Failed to get customer info. Please try again.'),
      );
      await Sentry.captureException(
        e,
        stackTrace: stackTrace,
      );
      return null;
    }
  }

  // Custoemr info update stream
  void setListenCustomerInfoFunction(
      void Function(CustomerInfo) function) async {
    Purchases.addCustomerInfoUpdateListener(function);
  }

  // Get offerings
  Future<Offerings?> getOfferings() async {
    try {
      final offerings = await Purchases.getOfferings();
      print(offerings);
      if (offerings.current != null &&
          offerings.current!.availablePackages.isNotEmpty) {
        return offerings;
      } else {
        return null;
      }
    } catch (e, stackTrace) {
      scaffoldKey.currentState?.showSnackBar(
        getErrorSnackBar('Failed to get offerings. Please try again.'),
      );
      await Sentry.captureException(
        e,
        stackTrace: stackTrace,
      );
      return null;
    }
  }

  // Get Products from offerings
  Future<List<Package>?> getAvailablePackages(Offerings offerings) async {
    try {
      if (offerings.current != null) {
        return offerings.current!.availablePackages;
      } else {
        return [];
      }
    } catch (e, stackTrace) {
      await Sentry.captureException(
        e,
        stackTrace: stackTrace,
      );
      return null;
    }
  }

  // Access the monthly product
  Future<Package?> getMonthlyProduct(Offerings offerings) async {
    try {
      if (offerings.current != null && offerings.current!.monthly != null) {
        final monthly = offerings.current!.monthly;
        return monthly;
      } else {
        return null;
      }
    } catch (e, stackTrace) {
      await Sentry.captureException(
        e,
        stackTrace: stackTrace,
      );
      return null;
    }
  }

  // Purchase product
  Future<CustomerInfo?> purchasePackage(Package package) async {
    try {
      CustomerInfo purchaserInfo = await Purchases.purchasePackage(package);
      print(purchaserInfo);
      return purchaserInfo;
    } catch (e) {
      print(e);
      return null;
    }
  }

  // Check if customer has active entitlement
  Future<bool> hasActiveEntitlement(CustomerInfo customerInfo) async {
    try {
      if (customerInfo.entitlements.active.isNotEmpty) {
        return true;
      } else {
        return false;
      }
    } catch (e, stackTrace) {
      await Sentry.captureException(
        e,
        stackTrace: stackTrace,
      );
      return false;
    }
  }
}

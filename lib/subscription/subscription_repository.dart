import 'dart:io';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:purchases_flutter/purchases_flutter.dart';

class SubscriptionRepository {
  Future<void> initPlatformState(String userId) async {
    await Purchases.setLogLevel(LogLevel.debug);

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

      await Purchases.configure(configuration..appUserID = userId);
    } catch (e) {
      print(e);
    }
  }

  Future<void> login(String userId) async {
    try {
      await Purchases.logIn(userId);
    } catch (e) {
      print(e);
    }
  }

  // Simply do not logout the SDK. In the case of switching accounts, you can call login when the user logs in to the different account with their new App User ID.
  Future<void> logout() async {
    try {
      await Purchases.logOut();
    } catch (e) {
      print(e);
    }
  }

  Future<CustomerInfo?> getCustomerInfo() async {
    try {
      final customerInfo = await Purchases.getCustomerInfo();
      print(customerInfo);
      return customerInfo;
    } catch (e) {
      print(e);
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
        print('Offerings / Packages are empty');
        return null;
      }
    } catch (e) {
      print(e);
      return null;
    }
  }

  // Access the monthly product
  Package? getMonthlyProduct(Offerings offerings) {
    try {
      if (offerings.current != null && offerings.current!.monthly != null) {
        final monthly = offerings.current!.monthly;
        return monthly;
      } else {
        print('Monthly product is not available');
        return null;
      }
    } catch (e) {
      print(e);
    }
    return null;
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
  bool hasActiveEntitlement(CustomerInfo customerInfo) {
    try {
      if (customerInfo.entitlements.active.isNotEmpty) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      print(e);
      return false;
    }
  }
}

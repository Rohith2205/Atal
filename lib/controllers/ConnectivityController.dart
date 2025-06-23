import 'dart:async';
import 'dart:io';

import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';

class ConnectivityController extends GetxController {
  final RxBool isOnline = false.obs;
  final Connectivity _connectivity = Connectivity();
  late Stream<List<ConnectivityResult>> _connectivityStream;
  final Completer<void> _initialized = Completer<void>();
  bool get isOffline => !isOnline.value;

  Future<void> get onInitialized => _initialized.future;

  @override
  void onInit() {
    super.onInit();
    _initializeConnectivity();
  }

  Future<void> _initializeConnectivity() async {

     await _checkInitialConnectivity();
     _listenToConnectivityChanges();
     _initialized.complete();

  }

  Future<void> _checkInitialConnectivity() async {
    try {
      final result = await _connectivity.checkConnectivity();
      await _updateConnectionStatus(result);
    } catch (e) {
      if (kDebugMode) {
        print('Error checking initial connectivity: $e');
      }
      // Default to offline if we can't check
      isOnline.value = false;
    }
  }

  void _listenToConnectivityChanges() {
    _connectivityStream = _connectivity.onConnectivityChanged;
    _connectivityStream.listen(
      _updateConnectionStatus,
      onError: (error) {
        if (kDebugMode) {
          print('Connectivity stream error: $error');
        }
      },
    );
  }

  Future<void> _updateConnectionStatus(List<ConnectivityResult> result) async {
    isOnline.value = false;
    // isOnline.value = result != ConnectivityResult.none;
    // isOnline.value = result.first!= ConnectivityResult.none;
    if (result.first != ConnectivityResult.none) {
      final hasInternet = await _hasInternetAccess();
      safePrint("internet lookup result = $hasInternet");
      isOnline.value = hasInternet;
    }
  }

  Future<bool> _hasInternetAccess() async {
    try {
      final lookup = await InternetAddress.lookup('google.com');
      return lookup.isNotEmpty && lookup[0].rawAddress.isNotEmpty;
    } catch (e) {
      if (kDebugMode) {
        print('No internet access: $e');
      }
      return false;
    }
  }

  @override
  void onClose() {
    // Clean up if needed
    super.onClose();
  }
}
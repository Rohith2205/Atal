import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'ConnectivityController.dart';
import 'UserTableController.dart';

class AuthController extends GetxController {
  // Observable properties
  final RxBool isLoading = true.obs;
  final RxBool isAuthenticated = false.obs;
  final RxString authError = ''.obs;

  // Dependencies
  late UserController _userController;
  late ConnectivityController _connectivityController;

  @override
  Future onInit() async {
    super.onInit();
    await _initializeController();
  }

  Future _initializeController() async {
    try {
      // Initialize connectivity first
      _connectivityController = Get.put(ConnectivityController(), permanent: true);
      await _connectivityController.onInitialized;

      // Initialize user controller
      _userController = Get.put(UserController(), permanent: true);

      // Wait for user controller to be ready
      await _userController.onReady();

      // Check authentication status
      await _checkAuthenticationStatus();

    } catch (e) {
      authError.value = 'Failed to initialize authentication';
      safePrint('Auth initialization error: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> _checkAuthenticationStatus() async {
    try {
      final session = await Amplify.Auth.fetchAuthSession();
      isAuthenticated.value = session.isSignedIn;

      if (session.isSignedIn) {
        await _fetchCognitoUserAttributes();
        safePrint("User authenticated: ${_userController.userName.value} (${_userController.userId.value})");
      }
    } catch (e) {
      isAuthenticated.value = false;
      safePrint('Error checking auth status: $e');
    }
  }

  Future _fetchCognitoUserAttributes() async {
    try {
      final attributes = await Amplify.Auth.fetchUserAttributes();

      // Extract user information from Cognito attributes
      final email = _getAttributeValue(attributes, 'email');
      final phoneNumber = _getAttributeValue(attributes, 'phone_number');
      final name = _getAttributeValue(attributes, 'name');
      final userId = _getAttributeValue(attributes, 'sub');

      // Update user controller with basic info
      await _userController.setUserBasicInfo(
        name: name,
        emailAddress: email,
        phone: phoneNumber,
        id: userId,
      );

      safePrint('Cognito attributes loaded successfully');
    } catch (e) {
      authError.value = 'Failed to load user attributes';
      if (kDebugMode) {
        print('Error fetching user attributes: $e');
      }
    }
  }

  String _getAttributeValue(List<AuthUserAttribute> attributes, String key) {
    try {
      return attributes.firstWhere((attr) => attr.userAttributeKey.key == key).value;
    } catch (e) {
      if (kDebugMode) {
        print('Attribute $key not found');
      }
      return '';
    }
  }

  // Public methods
  Future<bool> signOut() async {
    try {
      isLoading.value = true;

      // Clear user data first
      await _userController.clearUserData();

      // Sign out from Amplify
      await Amplify.Auth.signOut();

      // Update authentication state
      isAuthenticated.value = false;
      authError.value = '';

      return true;
    } catch (e) {
      authError.value = 'Failed to sign out';
      if (kDebugMode) {
        print('Error signing out: $e');
      }
      Get.snackbar(
        'Error',
        'Failed to sign out. Please try again.',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.red.shade100,
        colorText: Colors.red.shade700,
      );
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> refreshAuthState() async {
    isLoading.value = true;
    await _checkAuthenticationStatus();
    isLoading.value = false;
  }

  // Getters for UI
  UserController get userController => _userController;
  ConnectivityController get connectivityController => _connectivityController;

  // Computed properties
  bool get hasError => authError.value.isNotEmpty;
  bool get isReady => !isLoading.value && !hasError;
}
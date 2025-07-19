import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'ConnectivityController.dart';
import 'UserTableController.dart';
import 'package:atl_membership/components/personaldetails.dart'; // Add this import

class AuthController extends GetxController {
  final RxBool isLoading = true.obs;
  final RxBool isAuthenticated = false.obs;
  final RxString authError = ''.obs;
  final RxBool shouldShowPersonalDetailsDialog = false.obs;

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
        safePrint("User authenticated: ${_userController.userName?.value} (${_userController.userId.value})");

        // Check if user needs to complete personal details
        await _checkPersonalDetailsCompletion();
      }
    } catch (e) {
      isAuthenticated.value = false;
      safePrint('Error checking auth status: $e');
    }
  }

  Future<void> _checkPersonalDetailsCompletion() async {
    try {
      // Check if user has completed personal details
      // This assumes you have a method to check if personal details are complete
      final hasCompletedPersonalDetails = await _userController.hasCompletedPersonalDetails();

      if (!hasCompletedPersonalDetails) {
        // Show personal details dialog after a short delay
        Future.delayed(const Duration(milliseconds: 500), () {
          _showPersonalDetailsDialog();
        });
      }
    } catch (e) {
      safePrint('Error checking personal details completion: $e');
    }
  }

  void _showPersonalDetailsDialog() {
    if (Get.isDialogOpen == true) return; // Prevent multiple dialogs

    Get.dialog(
      const PersonalDetailsDialog(),
      barrierDismissible: false, // User must complete the form
      barrierColor: Colors.black54,
    );
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
      shouldShowPersonalDetailsDialog.value = false;

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

  // Handle email verification completion
  Future<void> onEmailVerificationCompleted() async {
    try {
      // Refresh auth state
      await refreshAuthState();

      // Show personal details dialog
      _showPersonalDetailsDialog();

      safePrint('Email verification completed for user: ${_userController.userId.value}');
    } catch (e) {
      safePrint('Error handling email verification completion: $e');
      authError.value = 'Failed to process email verification';
      throw e;
    }
  }

  // Handle policy acceptance
  Future<void> onPolicyAccepted() async {
    try {
      safePrint('Policy accepted by user: ${_userController.userId.value}');
    } catch (e) {
      safePrint('Error handling policy acceptance: $e');
      authError.value = 'Failed to process policy acceptance';
      throw e;
    }
  }

  // Handle personal details completion
  Future<void> onPersonalDetailsCompleted() async {
    try {
      safePrint('Personal details completed for user: ${_userController.userId.value}');

      // Mark that personal details are complete
      shouldShowPersonalDetailsDialog.value = false;

      // You can add additional logic here like updating user preferences

    } catch (e) {
      safePrint('Error handling personal details completion: $e');
      authError.value = 'Failed to complete profile setup';
      throw e;
    }
  }

  Future<void> refreshUserData() async {
    try {
      if (isAuthenticated.value) {
        await _fetchCognitoUserAttributes();
      }
    } catch (e) {
      safePrint('Error refreshing user data: $e');
      authError.value = 'Failed to refresh user data';
    }
  }

  // Method to manually trigger personal details dialog (if needed)
  void showPersonalDetailsDialog() {
    _showPersonalDetailsDialog();
  }

  // Getters
  bool get isPolicyAccepted {
    return _userController.isPolicyAccepted.value;
  }

  UserController get userController => _userController;
  ConnectivityController get connectivityController => _connectivityController;
  String? get userId => _userController.userId.value;
  bool get hasError => authError.value.isNotEmpty;
  bool get isReady => !isLoading.value && !hasError;
  bool get needsPersonalDetails => shouldShowPersonalDetailsDialog.value;
}
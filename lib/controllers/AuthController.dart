import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../components/personaldetails.dart';
import 'ConnectivityController.dart';
import 'UserTableController.dart';
import '../utils/routes.dart';

class AuthController extends GetxController {
  // Observable properties
  final RxBool isLoading = true.obs;
  final RxBool isAuthenticated = false.obs;
  final RxString authError = ''.obs;
  final RxString _userId = ''.obs;
  final RxBool isNewUser = false.obs;

  // Add this flag to track if personal details flow has been completed in this session
  final RxBool _hasCompletedPersonalDetailsFlow = false.obs;

  // Add flag to prevent multiple dialog shows
  final RxBool _isDialogShowing = false.obs;

  // Dependencies
  late UserController _userController;
  late ConnectivityController _connectivityController;

  // Add this getter to expose the user ID
  String? get userId => _userId.value.isNotEmpty ? _userId.value : null;

  @override
  Future onInit() async {
    super.onInit();
    await _initializeController();
    _listenToAuthChanges();
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

  // Listen to Amplify Auth state changes
  void _listenToAuthChanges() {
    Amplify.Hub.listen(HubChannel.Auth, (hubEvent) {
      switch (hubEvent.eventName) {
        case 'SIGNED_IN':
          _handleSignIn();
          break;
        case 'SIGNED_OUT':
          _handleSignOut();
          break;
        case 'SESSION_EXPIRED':
          _handleSessionExpired();
          break;
        case 'USER_DELETED':
          _handleUserDeleted();
          break;
      }
    });
  }

  Future<void> _handleSignIn() async {
    safePrint('User signed in - checking user status');

    // Prevent multiple simultaneous sign-in handling
    if (isLoading.value) {
      safePrint('Already processing sign in, skipping...');
      return;
    }

    // Add a small delay to ensure any signup redirects complete first
    await Future.delayed(const Duration(milliseconds: 100));

    isLoading.value = true;

    try {
      await _fetchCognitoUserAttributes();

      // Check user status
      final userStatus = await _checkUserStatus();

      isAuthenticated.value = true;

      if (userStatus == UserStatus.needsPersonalDetails) {
        // New user - show personal details dialog
        isNewUser.value = true;
        _showPersonalDetailsDialog();
      } else {
        // User is complete or only needs policy - go to home
        isNewUser.value = false;

        // Only navigate if we're not already on the home screen
        if (Get.currentRoute != Routes.HOME) {
          Get.offAllNamed(Routes.HOME);
        }
      }
    } catch (e) {
      safePrint('Error handling sign in: $e');
      authError.value = 'Failed to process sign in';
    } finally {
      isLoading.value = false;
    }
  }

  // Enhanced user status checking
  Future<UserStatus> _checkUserStatus() async {
    try {
      // First ensure user controller has loaded data
      await _userController.loadFullUserData();

      // Wait a moment for data to be processed
      await Future.delayed(const Duration(milliseconds: 500));

      // Check if user is registered in database
      final isRegistered = await _userController.isUserRegistered();
      if (!isRegistered) {
        safePrint('User not registered in database - needs personal details');
        return UserStatus.needsPersonalDetails;
      }

      // Check if user has completed personal details
      final hasPersonalDetails = await _userController.hasCompletedPersonalDetails();
      if (!hasPersonalDetails) {
        safePrint('User registered but missing personal details');
        return UserStatus.needsPersonalDetails;
      }

      // Check if policy is accepted
      final isPolicyAccepted = await _userController.checkPolicyStatus();
      if (!isPolicyAccepted) {
        safePrint('User has personal details but policy not accepted');
        return UserStatus.needsPolicy;
      }

      safePrint('User is complete - personal details and policy both done');
      return UserStatus.complete;

    } catch (e) {
      safePrint('Error checking user status: $e');
      return UserStatus.needsPersonalDetails; // Default to requiring personal details
    }
  }

  void _showPersonalDetailsDialog() {
    // Prevent multiple dialogs from showing
    if (_isDialogShowing.value || _hasCompletedPersonalDetailsFlow.value) {
      safePrint('Dialog already showing or flow completed, skipping...');
      return;
    }

    // Check if there's already a dialog open
    if (Get.isDialogOpen == true) {
      safePrint('Another dialog is already open, skipping...');
      return;
    }

    _isDialogShowing.value = true;

    // Delay to ensure UI is ready
    Future.delayed(const Duration(milliseconds: 500), () {
      // Double-check before showing
      if (!_hasCompletedPersonalDetailsFlow.value && !Get.isDialogOpen!) {
        Get.dialog(
          const PersonalDetailsDialog(),
          barrierDismissible: false,
          barrierColor: Colors.black54,
        ).then((_) {
          // Dialog closed
          _isDialogShowing.value = false;
        });
      } else {
        _isDialogShowing.value = false;
      }
    });
  }

  Future<void> _handleSignOut() async {
    safePrint('User signed out');
    isAuthenticated.value = false;
    isNewUser.value = false;
    _userId.value = '';
    _hasCompletedPersonalDetailsFlow.value = false;
    _isDialogShowing.value = false;
    await _userController.clearUserData();
  }

  Future<void> _handleSessionExpired() async {
    safePrint('Session expired');
    isAuthenticated.value = false;
    isNewUser.value = false;
    _hasCompletedPersonalDetailsFlow.value = false;
    _isDialogShowing.value = false;

    // Close any open dialogs
    if (Get.isDialogOpen == true) {
      Get.back();
    }

    Get.snackbar(
      'Session Expired',
      'Please sign in again',
      snackPosition: SnackPosition.TOP,
      backgroundColor: Colors.orange.shade100,
      colorText: Colors.orange.shade700,
    );
  }

  Future<void> _handleUserDeleted() async {
    safePrint('User deleted');
    isAuthenticated.value = false;
    isNewUser.value = false;
    _hasCompletedPersonalDetailsFlow.value = false;
    _isDialogShowing.value = false;
    await _userController.clearUserData();
  }

  Future<void> _checkAuthenticationStatus() async {
    try {
      final session = await Amplify.Auth.fetchAuthSession();

      if (session.isSignedIn) {
        await _fetchCognitoUserAttributes();

        // Check user status - this now properly loads data first
        final userStatus = await _checkUserStatus();
        isAuthenticated.value = true;

        if (userStatus == UserStatus.needsPersonalDetails && !_hasCompletedPersonalDetailsFlow.value) {
          isNewUser.value = true;
          // Only show dialog if we're not in loading state
          if (!isLoading.value) {
            _showPersonalDetailsDialog();
          }
        } else {
          isNewUser.value = false;
          // User is complete or only needs policy - will be handled by UserController
        }

        safePrint("User authenticated: ${_userController.userName.value} (${_userController.userId.value})");
        safePrint("User status: $userStatus");
      } else {
        isAuthenticated.value = false;
        _hasCompletedPersonalDetailsFlow.value = false;
        _isDialogShowing.value = false;
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

      // Store the user ID
      _userId.value = userId;

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

  // Called when personal details are successfully submitted
  Future<void> onPersonalDetailsCompleted() async {
    try {
      safePrint('Personal details completed');

      // Mark personal details flow as completed
      _hasCompletedPersonalDetailsFlow.value = true;
      _isDialogShowing.value = false;

      isNewUser.value = false;
      isAuthenticated.value = true;

      // Close dialog if it's still open
      if (Get.isDialogOpen == true) {
        Get.back();
      }

      // Small delay before navigation to ensure dialog is closed
      await Future.delayed(const Duration(milliseconds: 200));

      // Navigate to home screen
      Get.offAllNamed(Routes.HOME);

      // Show success message
      Get.snackbar(
        'Profile Complete',
        'Welcome! Your profile has been set up successfully.',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.green.shade100,
        colorText: Colors.green.shade700,
        icon: const Icon(Icons.check_circle, color: Colors.green),
      );
    } catch (e) {
      safePrint('Error completing personal details: $e');
    }
  }

  // NEW METHOD: Called when policy is accepted
  Future<void> onPolicyAccepted() async {
    try {
      safePrint('Policy accepted - redirecting to home');

      // Close any open dialogs
      if (Get.isDialogOpen == true) {
        Get.back();
      }

      // Small delay before navigation to ensure dialog is closed
      await Future.delayed(const Duration(milliseconds: 200));

      // Navigate directly to home screen
      Get.offAllNamed(Routes.HOME);

      // Show success message
      Get.snackbar(
        'Welcome!',
        'You can now access all features of the app.',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.green.shade100,
        colorText: Colors.green.shade700,
        icon: const Icon(Icons.check_circle, color: Colors.green),
      );
    } catch (e) {
      safePrint('Error handling policy acceptance: $e');
    }
  }

  // SIGNUP IMPLEMENTATION
  Future<bool> signUp({
    required String email,
    required String password,
    required String name,
    String? phoneNumber,
  }) async {
    try {
      isLoading.value = true;
      authError.value = '';

      safePrint('Starting signup process for: $email');

      // Prepare user attributes
      Map<AuthUserAttributeKey, String> userAttributes = {
        AuthUserAttributeKey.email: email,
        AuthUserAttributeKey.name: name,
      };

      // Add phone number if provided
      if (phoneNumber != null && phoneNumber.isNotEmpty) {
        userAttributes[AuthUserAttributeKey.phoneNumber] = phoneNumber;
      }

      // Sign up with Amplify
      final result = await Amplify.Auth.signUp(
        username: email,
        password: password,
        options: SignUpOptions(
          userAttributes: userAttributes,
        ),
      );

      safePrint('Signup result: ${result.isSignUpComplete}');

      if (result.isSignUpComplete) {
        // User is immediately confirmed (rare case)
        safePrint('Signup completed immediately - redirecting to login');

        // Redirect to login page
        Get.offAllNamed(Routes.LOGIN);

        // Show success message
        Get.snackbar(
          'Account Created Successfully',
          'Your account has been created. Please sign in with your credentials.',
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.green.shade100,
          colorText: Colors.green.shade700,
          icon: const Icon(Icons.check_circle, color: Colors.green),
          duration: const Duration(seconds: 4),
        );

        return true;
      } else {
        // Most common case - email confirmation required
        safePrint('Signup requires email confirmation');

        // Check if you have a confirmation screen, otherwise go to login
        if (Routes.CONFIRM_EMAIL.isNotEmpty) {
          // Navigate to email confirmation screen
          Get.offNamed(Routes.CONFIRM_EMAIL, arguments: {
            'email': email,
            'fromSignup': true,
          });
        } else {
          // No confirmation screen - go to login
          Get.offAllNamed(Routes.LOGIN);
        }

        Get.snackbar(
          'Verification Required',
          'Please check your email and click the verification link, then sign in.',
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.blue.shade100,
          colorText: Colors.blue.shade700,
          icon: const Icon(Icons.email, color: Colors.blue),
          duration: const Duration(seconds: 5),
        );

        return true; // Return true as signup was successful, just needs confirmation
      }

    } on AuthException catch (e) {
      // Handle specific Amplify Auth errors
      String errorMessage = _getAuthErrorMessage(e);
      authError.value = errorMessage;
      safePrint('Signup Auth error: ${e.message}');

      Get.snackbar(
        'Signup Failed',
        errorMessage,
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.red.shade100,
        colorText: Colors.red.shade700,
        icon: const Icon(Icons.error, color: Colors.red),
        duration: const Duration(seconds: 4),
      );

      return false;

    } catch (e) {
      // Handle other errors
      authError.value = 'An unexpected error occurred during signup';
      safePrint('Signup general error: $e');

      Get.snackbar(
        'Signup Failed',
        'An unexpected error occurred. Please try again.',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.red.shade100,
        colorText: Colors.red.shade700,
        icon: const Icon(Icons.error, color: Colors.red),
      );

      return false;
    } finally {
      isLoading.value = false;
    }
  }

  // Helper method to get user-friendly error messages
  String _getAuthErrorMessage(AuthException e) {
    switch (e.message.toLowerCase()) {
      case 'user already exists':
      case 'an account with the given email already exists':
        return 'An account with this email already exists. Please sign in instead.';
      case 'password did not conform with policy':
        return 'Password is too weak. Please use a stronger password.';
      case 'invalid email address format':
        return 'Please enter a valid email address.';
      case 'username/client id combination not found':
        return 'Invalid email format. Please check and try again.';
      default:
        return e.message.isNotEmpty ? e.message : 'Failed to create account. Please try again.';
    }
  }

  // Email confirmation method
  Future<bool> confirmSignUp({
    required String email,
    required String confirmationCode,
  }) async {
    try {
      isLoading.value = true;
      authError.value = '';

      safePrint('Confirming signup for: $email');

      final result = await Amplify.Auth.confirmSignUp(
        username: email,
        confirmationCode: confirmationCode,
      );

      if (result.isSignUpComplete) {
        safePrint('Email confirmation successful');

        // Redirect to login page
        Get.offAllNamed(Routes.LOGIN);

        Get.snackbar(
          'Email Verified',
          'Your email has been verified. Please sign in with your credentials.',
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.green.shade100,
          colorText: Colors.green.shade700,
          icon: const Icon(Icons.check_circle, color: Colors.green),
          duration: const Duration(seconds: 4),
        );

        return true;
      } else {
        authError.value = 'Email confirmation failed';
        return false;
      }

    } on AuthException catch (e) {
      String errorMessage = _getConfirmationErrorMessage(e);
      authError.value = errorMessage;
      safePrint('Confirmation error: ${e.message}');

      Get.snackbar(
        'Verification Failed',
        errorMessage,
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.red.shade100,
        colorText: Colors.red.shade700,
        icon: const Icon(Icons.error, color: Colors.red),
      );

      return false;
    } catch (e) {
      authError.value = 'Failed to verify email';
      safePrint('Confirmation general error: $e');
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  // Helper method for confirmation error messages
  String _getConfirmationErrorMessage(AuthException e) {
    switch (e.message.toLowerCase()) {
      case 'invalid verification code provided':
        return 'Invalid verification code. Please check and try again.';
      case 'code mismatch':
        return 'Verification code is incorrect. Please try again.';
      case 'expired code':
        return 'Verification code has expired. Please request a new one.';
      default:
        return e.message.isNotEmpty ? e.message : 'Failed to verify email. Please try again.';
    }
  }

  // Resend confirmation code
  Future<bool> resendConfirmationCode(String email) async {
    try {
      isLoading.value = true;

      await Amplify.Auth.resendSignUpCode(username: email);

      Get.snackbar(
        'Code Sent',
        'A new verification code has been sent to your email.',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.blue.shade100,
        colorText: Colors.blue.shade700,
        icon: const Icon(Icons.email, color: Colors.blue),
      );

      return true;
    } catch (e) {
      safePrint('Resend code error: $e');

      Get.snackbar(
        'Failed to Resend',
        'Could not send verification code. Please try again.',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.red.shade100,
        colorText: Colors.red.shade700,
      );

      return false;
    } finally {
      isLoading.value = false;
    }
  }

  // SIGN IN METHOD
  Future<bool> signIn({
    required String email,
    required String password,
  }) async {
    try {
      isLoading.value = true;
      authError.value = '';

      safePrint('Starting sign in process for: $email');

      final result = await Amplify.Auth.signIn(
        username: email,
        password: password,
      );

      if (result.isSignedIn) {
        safePrint('Sign in successful');
        // The Hub listener will handle the rest
        return true;
      } else {
        // Handle additional steps if needed (MFA, etc.)
        safePrint('Sign in requires additional steps');
        authError.value = 'Additional authentication steps required';
        return false;
      }

    } on AuthException catch (e) {
      String errorMessage = _getSignInErrorMessage(e);
      authError.value = errorMessage;
      safePrint('Sign in Auth error: ${e.message}');

      Get.snackbar(
        'Sign In Failed',
        errorMessage,
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.red.shade100,
        colorText: Colors.red.shade700,
        icon: const Icon(Icons.error, color: Colors.red),
      );

      return false;

    } catch (e) {
      authError.value = 'An unexpected error occurred during sign in';
      safePrint('Sign in general error: $e');

      Get.snackbar(
        'Sign In Failed',
        'An unexpected error occurred. Please try again.',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.red.shade100,
        colorText: Colors.red.shade700,
        icon: const Icon(Icons.error, color: Colors.red),
      );

      return false;
    } finally {
      isLoading.value = false;
    }
  }

  // Helper method for sign in error messages
  String _getSignInErrorMessage(AuthException e) {
    switch (e.message.toLowerCase()) {
      case 'incorrect username or password':
      case 'user does not exist':
        return 'Invalid email or password. Please check your credentials.';
      case 'user is not confirmed':
        return 'Please verify your email address before signing in.';
      case 'password reset required':
        return 'Password reset is required. Please check your email.';
      case 'user is disabled':
        return 'Your account has been disabled. Please contact support.';
      case 'too many failed attempts':
        return 'Too many failed attempts. Please try again later.';
      default:
        return e.message.isNotEmpty ? e.message : 'Failed to sign in. Please try again.';
    }
  }

  // Public sign out method
  Future<bool> signOut() async {
    try {
      isLoading.value = true;

      // Close any open dialogs
      if (Get.isDialogOpen == true) {
        Get.back();
      }

      // Clear user data first
      await _userController.clearUserData();
      _userId.value = '';
      isNewUser.value = false;
      _hasCompletedPersonalDetailsFlow.value = false;
      _isDialogShowing.value = false;

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

  // Method to manually mark personal details as completed (for testing)
  void markPersonalDetailsCompleted() {
    _hasCompletedPersonalDetailsFlow.value = true;
    _isDialogShowing.value = false;
    isNewUser.value = false;
  }

  // Getters for UI
  UserController get userController => _userController;
  ConnectivityController get connectivityController => _connectivityController;

  // Computed properties
  bool get hasError => authError.value.isNotEmpty;
  bool get isReady => !isLoading.value && !hasError;
  bool get shouldShowPersonalDetailsDialog =>
      isNewUser.value &&
          isAuthenticated.value &&
          !_hasCompletedPersonalDetailsFlow.value &&
          !_isDialogShowing.value;
}

// Enum to track user completion status
enum UserStatus {
  needsPersonalDetails,
  needsPolicy,
  complete,
}

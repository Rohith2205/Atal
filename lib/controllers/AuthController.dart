import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../components/personaldetails.dart';
import '../screens/PolicyScreen.dart';
import 'ConnectivityController.dart';
import 'UserTableController.dart';
import '../utils/routes.dart';

class AuthController extends GetxController {
  final RxBool isLoading = true.obs;
  final RxBool isAuthenticated = false.obs;
  final RxString authError = ''.obs;
  final RxString _userId = ''.obs;
  final RxBool isNewUser = false.obs;

  final RxBool _hasCompletedPersonalDetailsFlow = false.obs;
  final RxBool _isDialogShowing = false.obs;
  static const Duration _dialogCloseDelay = Duration(milliseconds: 300);

  // Prevent duplicate concurrent status resolutions
  final RxBool _resolvingStatus = false.obs;

  late UserController _userController;
  late ConnectivityController _connectivityController;

  String? get userId => _userId.value.isNotEmpty ? _userId.value : null;

  @override
  Future onInit() async {
    super.onInit();
    await _initializeController();
    _listenToAuthChanges();
  }

  Future _initializeController() async {
    try {
      _connectivityController = Get.put(ConnectivityController(), permanent: true);
      await _connectivityController.onInitialized;

      _userController = Get.put(UserController(), permanent: true);
      await _userController.onReady();

      await _checkAuthenticationStatus();
    } catch (e) {
      authError.value = 'Failed to initialize authentication';
      safePrint('Auth initialization error: $e');
    } finally {
      isLoading.value = false;
    }
  }

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
    if (isLoading.value || _resolvingStatus.value) return;
    isLoading.value = true;
    _resolvingStatus.value = true;

    try {
      await _fetchCognitoUserAttributes();      // 1) seed basics
      await _userController.loadFullUserData(); // 2) pull server truth
      final status = await _checkUserStatus();  // 3) decide from truth

      isAuthenticated.value = true;
      await _handleUserStatus(status);
    } catch (e) {
      safePrint('Error handling sign in: $e');
      authError.value = 'Failed to process sign in';
    } finally {
      _resolvingStatus.value = false;
      isLoading.value = false;
    }
  }

  Future<void> _handleUserStatus(UserStatus userStatus) async {
    switch (userStatus) {
      case UserStatus.needsPersonalDetails:
        isNewUser.value = true;
        Future.delayed(const Duration(milliseconds: 200), _showPersonalDetailsDialog);
        break;

      case UserStatus.needsPolicy:
        isNewUser.value = false;
        if (Get.currentRoute != Routes.HOME) Get.offAllNamed(Routes.HOME);
        Future.delayed(const Duration(milliseconds: 150), showPolicyDialogNow);
        break;

      case UserStatus.complete:
        isNewUser.value = false;
        if (Get.currentRoute != Routes.HOME) Get.offAllNamed(Routes.HOME);
        break;
    }
  }

  Future<UserStatus> _checkUserStatus() async {
    try {
      if (_userId.value.isEmpty) return UserStatus.needsPersonalDetails;

      // Make extra-sure we are fresh (prevents races)
      await _userController.refreshUserData();

      final registered = await _userController.isUserRegistered();
      if (!registered) return UserStatus.needsPersonalDetails;

      final hasDetails = await _userController.hasCompletedPersonalDetails();
      if (!hasDetails) return UserStatus.needsPersonalDetails;

      final accepted = await _userController.checkPolicyStatus();
      return accepted ? UserStatus.complete : UserStatus.needsPolicy;
    } catch (e) {
      safePrint('Error checking user status: $e');
      return UserStatus.needsPersonalDetails;
    }
  }

  void _showPersonalDetailsDialog() {
    if (_isDialogShowing.value || _hasCompletedPersonalDetailsFlow.value) return;
    if (Get.isDialogOpen == true) return;
    if (Get.context == null) return;

    _isDialogShowing.value = true;
    Get.dialog(
      const PersonalDetailsDialog(),
      barrierDismissible: false,
      barrierColor: Colors.black54,
    ).whenComplete(() => _isDialogShowing.value = false);
  }

  /// Public: can be called after personal-details success or on sign-in if needed.
  void showPolicyDialogNow() {
    if (Get.context == null) return;
    if (Get.isDialogOpen == true) return;

    Get.dialog(
      const PolicyDialog(),
      barrierDismissible: false,
      barrierColor: Colors.black54,
    );
  }

  Future<void> _handleSignOut() async {
    isAuthenticated.value = false;
    isNewUser.value = false;
    _userId.value = '';
    _hasCompletedPersonalDetailsFlow.value = false;
    _isDialogShowing.value = false;
    _resolvingStatus.value = false;
    await _userController.clearUserData();
  }

  Future<void> _handleSessionExpired() async {
    isAuthenticated.value = false;
    isNewUser.value = false;
    _hasCompletedPersonalDetailsFlow.value = false;
    _isDialogShowing.value = false;
    _resolvingStatus.value = false;

    if (Get.isDialogOpen == true) Get.back();

    Get.snackbar(
      'Session Expired',
      'Please sign in again',
      snackPosition: SnackPosition.TOP,
      backgroundColor: Colors.orange.shade100,
      colorText: Colors.orange.shade700,
    );
  }

  Future<void> _handleUserDeleted() async {
    isAuthenticated.value = false;
    isNewUser.value = false;
    _hasCompletedPersonalDetailsFlow.value = false;
    _isDialogShowing.value = false;
    _resolvingStatus.value = false;
    await _userController.clearUserData();
  }

  Future<void> _checkAuthenticationStatus() async {
    try {
      final session = await Amplify.Auth.fetchAuthSession();
      if (session.isSignedIn) {
        await _fetchCognitoUserAttributes();
        await _userController.loadFullUserData();

        final status = await _checkUserStatus();
        isAuthenticated.value = true;
        if (!isLoading.value) await _handleUserStatus(status);
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
      final attrs = await Amplify.Auth.fetchUserAttributes();

      final email = _getAttributeValue(attrs, 'email');
      final phone = _getAttributeValue(attrs, 'phone_number');
      final name  = _getAttributeValue(attrs, 'name');
      final sub   = _getAttributeValue(attrs, 'sub');

      _userId.value = sub; // PK of your UserTable row

      await _userController.setUserBasicInfo(
        name: name,
        emailAddress: email,
        phone: phone,
        id: sub,
      );
    } catch (e) {
      authError.value = 'Failed to load user attributes';
      if (kDebugMode) print('Error fetching user attributes: $e');
    }
  }

  String _getAttributeValue(List<AuthUserAttribute> attrs, String key) {
    try {
      return attrs.firstWhere((a) => a.userAttributeKey.key == key).value;
    } catch (_) {
      return '';
    }
  }

  /// Called when personal details are saved successfully
  Future<void> onPersonalDetailsCompleted() async {
    try {
      isNewUser.value = false;
      isAuthenticated.value = true;
      _hasCompletedPersonalDetailsFlow.value = true;

      await _closeAnyOpenDialogs();

      // Don’t wait for read-after-write to settle. Open policy now.
      if (Get.currentRoute != Routes.HOME) {
        Get.offAllNamed(Routes.HOME);
        await Future.delayed(const Duration(milliseconds: 150));
      }
      showPolicyDialogNow();

      // In the background, hydrate server truth with a few retries
      await _userController.refreshUserDataWithRetry();
    } catch (e, st) {
      await _handleCompletionError(e, st);
    }
  }

  Future<void> _closeAnyOpenDialogs() async {
    if (Get.isDialogOpen == true) {
      Get.back();
      await Future.delayed(_dialogCloseDelay);
    }
    _isDialogShowing.value = false;
  }

  Future<void> _handleCompletionError(dynamic error, StackTrace st) async {
    safePrint('Error completing personal details: $error');
    _isDialogShowing.value = false;
    _hasCompletedPersonalDetailsFlow.value = false;

    Get.snackbar(
      'Setup Error',
      'Unable to complete profile setup. Please try again.',
      snackPosition: SnackPosition.TOP,
      backgroundColor: Colors.red.shade100,
      colorText: Colors.red.shade700,
      icon: const Icon(Icons.error, color: Colors.red),
    );
  }

  /// Called after pressing “I Agree”
  Future<void> onPolicyAccepted() async {
    try {
      _userController.isPolicyAccepted.value = true;
      await _userController.persistCache();      // persist locally
      await _userController.refreshUserDataWithRetry(); // pull server truth with retry

      if (Get.isDialogOpen == true) Get.back();
      await Future.delayed(const Duration(milliseconds: 100));
      Get.offAllNamed(Routes.HOME);

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

  // Exposed
  UserController get userController => _userController;
  ConnectivityController get connectivityController => _connectivityController;

  bool get hasError => authError.value.isNotEmpty;
  bool get isReady  => !isLoading.value && !hasError;

  bool get shouldShowPersonalDetailsDialog =>
      isNewUser.value && isAuthenticated.value && !_hasCompletedPersonalDetailsFlow.value && !_isDialogShowing.value;

  Future<void> refreshAuthState() async {}
}

enum UserStatus { needsPersonalDetails, needsPolicy, complete }

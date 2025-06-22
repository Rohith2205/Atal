import 'dart:async';

import 'package:amplify_api/amplify_api.dart';
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:atl_membership/screens/PolicyScreen.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart' hide GraphQLResponse;

import '../components/personaldetails.dart';
import '../models/UserTable.dart';
import '../models/UserTableGender.dart';
import '../services/user_table_amplify_service.dart';
import '../utils/CacheManager.dart';
import '../utils/bgcolorconverter.dart';
import 'ConnectivityController.dart';

class UserController extends GetxController {
  // Observable properties
  final Rx<UserTable?> currentUser = Rx<UserTable?>(null);
  final RxString userName = ''.obs;
  final RxString email = ''.obs;
  final RxString phoneNumber = ''.obs;
  final Rx<Color> profileColor = const Color(0xFF000000).obs;
  final RxString userId = ''.obs;
  final RxBool isUserDataLoaded = false.obs;
  final RxBool isPolicyAccepted = false.obs;
  final RxBool isOfflineMode = false.obs;
  final RxBool shouldShowDialog = false.obs;
  final RxBool isInitialized = false.obs;
  final RxString userError = ''.obs;

  // Dependencies
  late final CacheManager _cacheManager;
  late ConnectivityController _connectivityController;

  // Subscription stream
  StreamSubscription<GraphQLResponse<UserTable>>? _userSubscription;

  // Completer for initialization
  Completer<void>? _initCompleter;

  @override
  Future<void> onInit() async {
    super.onInit();
    _initCompleter = Completer<void>();
    await _initializeController();
  }

  @override
  void onClose() {
    _userSubscription?.cancel();
    _initCompleter?.complete();
    super.onClose();
  }

  Future<void> _initializeController() async {
    try {
      _cacheManager = CacheManager();
      _connectivityController = Get.find<ConnectivityController>();

      // Load cached data first
      await _loadCachedUserData();

      isInitialized.value = true;
      _initCompleter?.complete();

      safePrint('UserController initialized successfully');
    } catch (e) {
      userError.value = 'Failed to initialize user controller';
      safePrint('UserController initialization error: $e');
      _initCompleter?.complete();
    }
  }

  // Wait for controller to be ready
  Future<void> onReady() async {
    if (_initCompleter != null && !_initCompleter!.isCompleted) {
      await _initCompleter!.future;
    }
  }

  Future<void> _loadCachedUserData() async {
    try {
      final cachedData = await _cacheManager.getUserData();
      if (cachedData != null) {
        _updateUserDataFromCache(cachedData);
        safePrint('Cached user data loaded successfully');
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error loading cached user data: $e');
      }
    }
  }

  Future<void> loadFullUserData() async {
    if (userId.value.isEmpty) {
      safePrint('Cannot load user data: userId is empty');
      return;
    }

    if (_connectivityController.isOnline.value) {
      await _loadOnlineUserData();
    } else {
      _handleOfflineMode();
    }
  }

  Future<void> _loadOnlineUserData() async {
    try {
      userError.value = '';

      // Fetch user from database
      final user = await UserTableAmplifyService.getUserById(userId.value);
      safePrint("User data fetched: ${user?.name}");

      if (user != null) {
        await _updateUserData(user);
        await _setupUserSubscription();
        isUserDataLoaded.value = true;

        // Check policy status
        final policyAccepted = user.isPolicy ?? false;
        isPolicyAccepted.value = policyAccepted;

        if (!policyAccepted) {
          // User exists but hasn't accepted policy - show policy dialog
          _showPolicyDialog();
          safePrint('User exists but policy not accepted - showing policy dialog');
        } else {
          safePrint('User exists and policy is accepted');
        }
      } else {
        // User not found in database, show dialog to collect details
        _showPersonalDetailsDialog();
      }
    } catch (e) {
      userError.value = 'Failed to load user data';
      safePrint('Error loading online user data: $e');
      _handleOfflineMode();
    }
  }

  void _showPersonalDetailsDialog() {
    shouldShowDialog.value = true;
    Future.delayed(const Duration(milliseconds: 200), () {
      if (Get.context != null) {
        showDialog(
          context: Get.context!,
          barrierDismissible: false,
          builder: (context) => PersonalDetailsDialog(),
        );
      }
    });
  }

  void _showPolicyDialog() {
    shouldShowDialog.value = true;
    Future.delayed(const Duration(milliseconds: 200), () {
      if (Get.context != null) {
        showDialog(
          context: Get.context!,
          barrierDismissible: false,
          builder: (context) => AlertDialog(content:  PolicyDialog()));
      }
    });
  }

  // Method called from PersonalDetailsDialog
  Future<void> updateUiAndSaveUserDetails({
    required String university,
    required String district,
    required String mandal,
    required String college,
    required String rollNumber,
    required UserTableGender gender,
  }) async {
    try {
      final success = await saveUserDetails(
        university: university,
        district: district,
        mandal: mandal,
        college: college,
        rollNumber: rollNumber,
        gender: gender,
      );

      safePrint("User details save result: $success");

      if (success) {
        shouldShowDialog.value = false;
        userError.value = '';

        // Check policy status
        final policyAccepted = await checkPolicyStatus();
        isPolicyAccepted.value = policyAccepted;

        if (!policyAccepted) {
          // User exists but hasn't accepted policy - show policy dialog
          _showPolicyDialog();
          safePrint('User exists but policy not accepted - showing policy dialog');
        } else {
          safePrint('User exists and policy is accepted');
        }
      }
    } catch (e) {
      userError.value = 'Failed to save user details';
      safePrint('Error in updateUiAndSaveUserDetails: $e');
    }
  }

  void _handleOfflineMode() {
    isOfflineMode.value = true;
    if (userName.value.isEmpty) {
      safePrint('Running in offline mode with cached data');
    }
  }

  void _updateUserDataFromCache(Map<String, dynamic> cachedData) {
    userName.value = cachedData['userName'] ?? '';
    email.value = cachedData['email'] ?? '';
    phoneNumber.value = cachedData['phoneNumber'] ?? '';
    userId.value = cachedData['userId'] ?? '';
    isPolicyAccepted.value = cachedData['isPolicyAccepted'] ?? false;

    if (userName.value.isNotEmpty) {
      _updateProfileColor();
    }
  }

  Future<void> _updateUserData(UserTable user) async {
    currentUser.value = user;
    userName.value = user.name ?? '';
    email.value = user.email ?? '';
    phoneNumber.value = user.phone ?? '';
    userId.value = user.id;
    isPolicyAccepted.value = user.isPolicy ?? false;

    await _updateProfileColor();
    await _cacheUserData();
  }

  Future<void> _updateProfileColor() async {
    try {
      if (userName.value.isNotEmpty) {
        profileColor.value = await getColorFromStringAsync(userName.value);
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error updating profile color: $e');
      }
    }
  }

  Future<void> _cacheUserData() async {
    try {
      final userData = {
        'userName': userName.value,
        'email': email.value,
        'phoneNumber': phoneNumber.value,
        'userId': userId.value,
        'isPolicyAccepted': isPolicyAccepted.value,
      };
      await _cacheManager.saveUserData(userData);
    } catch (e) {
      if (kDebugMode) {
        print('Error caching user data: $e');
      }
    }
  }

  Future<void> _setupUserSubscription() async {
    if (userId.value.isEmpty) return;

    try {
      await _userSubscription?.cancel();

      final queryPredicate = UserTable.ID.eq(userId.value);
      final stream = Amplify.API.subscribe<UserTable>(
        ModelSubscriptions.onUpdate(
          UserTable.classType,
          authorizationMode: APIAuthorizationType.userPools,
          where: queryPredicate,
        ),
      );

      _userSubscription = stream.listen(
            (event) {
          final updatedUser = event.data;
          if (updatedUser != null) {
            _handleUserUpdate(updatedUser);
          }
        },
        onError: (error) {
          safePrint('User subscription error: $error');
        },
      );

      safePrint('User subscription setup for userId: ${userId.value}');
    } catch (e) {
      safePrint('Error setting up user subscription: $e');
    }
  }

  void _handleUserUpdate(UserTable updatedUser) {
    safePrint('Received user update: ${updatedUser.id}');

    // Update reactive variables
    _updateUserData(updatedUser);

    // Show notification if policy status changed
    if (currentUser.value?.isPolicy != updatedUser.isPolicy) {
      _showPolicyUpdateNotification(updatedUser.isPolicy ?? false);
    }
  }

  void _showPolicyUpdateNotification(bool isPolicyAccepted) {
    Get.snackbar(
      'Policy Update',
      isPolicyAccepted
          ? 'Your policy acceptance has been confirmed'
          : 'Policy acceptance status updated',
      snackPosition: SnackPosition.TOP,
      backgroundColor: isPolicyAccepted
          ? Colors.green.shade100
          : Colors.orange.shade100,
      colorText: isPolicyAccepted
          ? Colors.green.shade700
          : Colors.orange.shade700,
    );
  }

  // Public methods for external use
  Future<bool> acceptPolicy() async {
    if (userId.value.isEmpty) return false;

    try {
      final result = await UserTableAmplifyService.updatePolicy(userId.value);
      if (result == true) {
        isPolicyAccepted.value = true;
        Get.snackbar('Success', 'Policy accepted successfully!');
        return true;
      }
      return false;
    } catch (e) {
      userError.value = 'Failed to accept policy';
      safePrint('Error accepting policy: $e');
      Get.snackbar('Error', 'Failed to accept policy. Please try again.');
      return false;
    }
  }

  Future<bool> checkPolicyStatus() async {
    if (userId.value.isEmpty) return false;

    try {
      final policyStatus = await UserTableAmplifyService.isPolicyAccepted(userId.value);
      if (policyStatus != null) {
        isPolicyAccepted.value = policyStatus;
        return policyStatus;
      }
      return false;
    } catch (e) {
      safePrint('Error checking policy status: $e');
      return false;
    }
  }

  Future<void> refreshUserData() async {
    if (userId.value.isEmpty) return;

    try {
      final user = await UserTableAmplifyService.getUserById(userId.value);
      if (user != null) {
        await _updateUserData(user);
      }
    } catch (e) {
      userError.value = 'Failed to refresh user data';
      safePrint('Error refreshing user data: $e');
    }
  }

  Future<void> setUserBasicInfo({
    required String name,
    required String emailAddress,
    required String phone,
    required String id,
  }) async {
    userName.value = name;
    email.value = emailAddress;
    phoneNumber.value = phone;
    userId.value = id;

    await _updateProfileColor();
    await _cacheUserData();

    // Now load full user data from the server
    await loadFullUserData();
  }

  // Method to save user details (moved from AuthController)
  Future<bool> saveUserDetails({
    required String university,
    required String district,
    required String mandal,
    required String college,
    required String rollNumber,
    required UserTableGender gender,
  }) async {
    if (userId.value.isEmpty) return false;

    try {
      safePrint("Creating user with ID: ${userId.value}");

      final newUser = UserTable(
        id: userId.value,
        university: university,
        district: district,
        mandal: mandal,
        college: college,
        reg_no: rollNumber,
        email: email.value,
        phone: phoneNumber.value,
        name: userName.value,
        gender: gender,
        isPolicy: false,
      );

      final request = ModelMutations.create(
        newUser,
        authorizationMode: APIAuthorizationType.userPools,
      );
      final response = await Amplify.API.mutate(request: request).response;

      if (response.errors.isNotEmpty) {
        for (final error in response.errors) {
          safePrint('GraphQL Error: ${error.message}');
        }
        return false;
      }

      if (response.data != null) {
        await _updateUserData(response.data!);
        safePrint("User creation successful: ${response.data}");
        await _setupUserSubscription();
        Get.snackbar('Success', 'Personal details saved successfully!');
        return true;
      }

      return false;
    } catch (e) {
      userError.value = 'Failed to save user details';
      safePrint('Error saving user details: $e');
      Get.snackbar('Error', 'Failed to save personal details. Please try again.');
      return false;
    }
  }

  Future<bool> isUserRegistered() async {
    if (userId.value.isEmpty) return false;

    try {
      final user = await UserTableAmplifyService.getUserById(userId.value);
      return user != null;
    } catch (e) {
      safePrint('Error checking user registration: $e');
      return false;
    }
  }

  /// Clear all user data and reset state
  Future<void> clearUserData() async {
    await _userSubscription?.cancel();
    await _cacheManager.clearUserData();

    // Reset all observable values
    currentUser.value = null;
    userName.value = '';
    email.value = '';
    phoneNumber.value = '';
    userId.value = '';
    profileColor.value = const Color(0xFF000000);
    isPolicyAccepted.value = false;
    isUserDataLoaded.value = false;
    isOfflineMode.value = false;
    shouldShowDialog.value = false;
    userError.value = '';
  }

  // Getters for convenience
  bool get hasUserData => currentUser.value != null;
  bool get isUserComplete => hasUserData &&
      userName.value.isNotEmpty &&
      email.value.isNotEmpty;
  String get displayName => userName.value.isNotEmpty
      ? userName.value
      : 'User';
  bool get hasError => userError.value.isNotEmpty;
  bool get isReady => isInitialized.value && !hasError;
}
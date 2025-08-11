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

  // Additional observable properties for user details
  final RxString university = ''.obs;
  final RxString district = ''.obs;
  final RxString mandal = ''.obs;
  final RxString college = ''.obs;
  final RxString rollNumber = ''.obs;

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
          safePrint('User exists but policy not accepted');
          // Don't show dialog here - let AuthController handle it
        } else {
          safePrint('User exists and policy is accepted - user is complete');
        }
      } else {
        safePrint('User not found in database - needs personal details');
        // Don't show dialog here - let AuthController handle it
        // Just mark that user needs setup
        isUserDataLoaded.value = false;
      }
    } catch (e) {
      userError.value = 'Failed to load user data';
      safePrint('Error loading online user data: $e');
      _handleOfflineMode();
    }
  }

// Add helper methods to check user status without showing dialogs
  Future<bool> isUserRegistered() async {
    try {
      if (userId.value.isEmpty) return false;

      final user = await UserTableAmplifyService.getUserById(userId.value);
      return user != null;
    } catch (e) {
      safePrint('Error checking if user is registered: $e');
      return false;
    }
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

      if (success != null) {
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

    // Update additional user details
    university.value = cachedData['university'] ?? '';
    district.value = cachedData['district'] ?? '';
    mandal.value = cachedData['mandal'] ?? '';
    college.value = cachedData['college'] ?? '';
    rollNumber.value = cachedData['rollNumber'] ?? '';

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

    // Update additional user details
    university.value = user.university ?? '';
    district.value = user.district ?? '';
    mandal.value = user.mandal ?? '';
    college.value = user.college ?? '';
    rollNumber.value = user.reg_no ?? '';

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
        'university': university.value,
        'district': district.value,
        'mandal': mandal.value,
        'college': college.value,
        'rollNumber': rollNumber.value,
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
    if (userId.value.isEmpty) {
      userError.value = 'User ID not available';
      return false;
    }

    try {
      // Optimistic UI update
      isPolicyAccepted.value = true;

      // Update remote
      final result = await UserTableAmplifyService.updatePolicy(userId.value);

      if (result != true) {
        // Revert if update failed
        isPolicyAccepted.value = false;
        userError.value = 'Failed to update policy status';
        return false;
      }

      // Update local user model
      if (currentUser.value != null) {
        currentUser.value = currentUser.value!.copyWith(isPolicy: true);
        await _cacheUserData();
      }

      return true;
    } catch (e) {
      // Revert on error
      isPolicyAccepted.value = false;
      userError.value = 'Policy update error: ${e.toString()}';
      safePrint('Error accepting policy: $e');
      return false;
    }
  }


  Future<bool> checkPolicyStatus() async {
    try {
      if (userId.value.isEmpty) return false;

      final user = await UserTableAmplifyService.getUserById(userId.value);
      return user?.isPolicy ?? false;
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
  Future<Object?> saveUserDetails({
    required String university,
    required String district,
    required String mandal,
    required String college,
    required String rollNumber,
    required UserTableGender gender,
  }) async {
    try {
      safePrint('Saving user details for user ID: ${userId.value}');

      // First check if user already exists
      final existingUser = await UserTableAmplifyService.getUserById(userId.value);

      if (existingUser != null) {
        // User exists - update their details
        safePrint('User exists, updating personal details');

        final updatedUser = existingUser.copyWith(
          university: university,
          district: district,
          mandal: mandal,
          college: college,
          reg_no: rollNumber,
          gender: gender,
          // Keep existing data
          name: existingUser.name,
          email: existingUser.email,
          phone: existingUser.phone,
          isPolicy: existingUser.isPolicy,
        );

        final success = await UserTableAmplifyService.updateUser(updatedUser);

        if (success != null) {
          await _updateUserData(updatedUser);
          safePrint('User details updated successfully');
        }

        return success;

      } else {
        // User doesn't exist - create new user
        safePrint('User does not exist, creating new user');

        final newUser = UserTable(
          id: userId.value,
          name: userName.value,
          email: email.value,
          phone: phoneNumber.value,
          university: university,
          district: district,
          mandal: mandal,
          college: college,
          reg_no: rollNumber,
          gender: gender,
          isPolicy: false, // Default to false, will be updated when policy is accepted
        );

        final success = await UserTableAmplifyService.createUser(newUser);

        if (success != null) {
          await _updateUserData(newUser);
          safePrint('New user created successfully');
        }

        return success;
      }

    } catch (e) {
      safePrint('Error saving user details: $e');
      userError.value = 'Failed to save user details';
      return false;
    }
  }

  // Replace these methods in your UserController

  Future<bool> hasCompletedPersonalDetails() async {
    try {
      if (userId.value.isEmpty) return false;

      final user = await UserTableAmplifyService.getUserById(userId.value);
      if (user == null) return false;

      // Check if user has all required personal details
      return user.university != null &&
          user.district != null &&
          user.mandal != null &&
          user.college != null;
    } catch (e) {
      safePrint('Error checking personal details completion: $e');
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

    // Reset additional user details
    university.value = '';
    district.value = '';
    mandal.value = '';
    college.value = '';
    rollNumber.value = '';
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

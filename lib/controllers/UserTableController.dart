import 'dart:async';
import 'package:amplify_api/amplify_api.dart';
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart' hide GraphQLResponse;

import '../models/UserTable.dart';
import '../models/UserTableGender.dart';
import '../services/user_table_amplify_service.dart';
import '../utils/CacheManager.dart';
import '../utils/bgcolorconverter.dart';
import 'ConnectivityController.dart';

class UserController extends GetxController {
  // Server truth
  final Rx<UserTable?> currentUser = Rx<UserTable?>(null);

  // Mirrors
  final RxString userName = ''.obs;
  final RxString email = ''.obs;
  final RxString phoneNumber = ''.obs;
  final Rx<Color> profileColor = const Color(0xFF000000).obs;
  final RxString userId = ''.obs;

  // State
  final RxBool isUserDataLoaded = false.obs;
  final RxBool isPolicyAccepted = false.obs;
  final RxBool isOfflineMode = false.obs;
  final RxBool isInitialized = false.obs;
  final RxString userError = ''.obs;

  // Extra details
  final RxString university = ''.obs;
  final RxString district = ''.obs;
  final RxString mandal = ''.obs;
  final RxString college = ''.obs;
  final RxString rollNumber = ''.obs;

  late final CacheManager _cacheManager;
  late ConnectivityController _connectivityController;

  StreamSubscription<GraphQLResponse<UserTable>>? _userSubscription;
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
      await _loadCachedUserData();
      isInitialized.value = true;
      _initCompleter?.complete();
    } catch (e) {
      userError.value = 'Failed to initialize user controller';
      _initCompleter?.complete();
    }
  }

  Future<void> onReady() async {
    if (_initCompleter != null && !_initCompleter!.isCompleted) {
      await _initCompleter!.future;
    }
  }

  Future<void> _loadCachedUserData() async {
    try {
      final cached = await _cacheManager.getUserData();
      if (cached != null) {
        _updateUserDataFromCache(cached);
      }
    } catch (_) {}
  }

  Future<void> loadFullUserData() async {
    if (userId.value.isEmpty) return;
    if (_connectivityController.isOnline.value) {
      await _loadOnlineUserData();
    } else {
      _handleOfflineMode();
    }
  }

  Future<void> _loadOnlineUserData() async {
    try {
      userError.value = '';
      final user = await UserTableAmplifyService.getUserById(userId.value);
      if (user != null) {
        await _updateUserData(user);
        await _setupUserSubscription();
        isUserDataLoaded.value = true;
        isPolicyAccepted.value = user.isPolicy ?? false;
        await _cacheUserData();
      } else {
        isUserDataLoaded.value = false;
      }
    } catch (e) {
      userError.value = 'Failed to load user data';
      _handleOfflineMode();
    }
  }

  Future<bool> isUserRegistered() async {
    try {
      if (userId.value.isEmpty) return false;
      final user = await UserTableAmplifyService.getUserById(userId.value);
      return user != null;
    } catch (_) {
      return false;
    }
  }

  void _handleOfflineMode() => isOfflineMode.value = true;

  void _updateUserDataFromCache(Map<String, dynamic> c) {
    userName.value = c['userName'] ?? userName.value;
    email.value = c['email'] ?? email.value;
    phoneNumber.value = c['phoneNumber'] ?? phoneNumber.value;
    userId.value = c['userId'] ?? userId.value;
    if (c.containsKey('isPolicyAccepted')) {
      isPolicyAccepted.value = c['isPolicyAccepted'] == true;
    }
    university.value = c['university'] ?? university.value;
    district.value = c['district'] ?? district.value;
    mandal.value = c['mandal'] ?? mandal.value;
    college.value = c['college'] ?? college.value;
    rollNumber.value = c['rollNumber'] ?? rollNumber.value;
    if (userName.value.isNotEmpty) _updateProfileColor();
  }

  Future<void> _updateUserData(UserTable user) async {
    currentUser.value = user;
    userName.value = user.name ?? '';
    email.value = user.email ?? '';
    phoneNumber.value = user.phone ?? '';
    userId.value = user.id;
    isPolicyAccepted.value = user.isPolicy ?? false;

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
    } catch (_) {}
  }

  Future<void> _cacheUserData() async {
    try {
      final userData = {
        'userName': userName.value,
        'email': email.value,
        'phoneNumber': phoneNumber.value,
        'userId': userId.value,
        'isPolicyAccepted': policyAccepted,
        'university': university.value,
        'district': district.value,
        'mandal': mandal.value,
        'college': college.value,
        'rollNumber': rollNumber.value,
      };
      await _cacheManager.saveUserData(userData);
    } catch (_) {}
  }

  Future<void> persistCache() => _cacheUserData();

  Future<void> _setupUserSubscription() async {
    if (userId.value.isEmpty) return;
    try {
      await _userSubscription?.cancel();
      final where = UserTable.ID.eq(userId.value);
      final stream = Amplify.API.subscribe<UserTable>(
        ModelSubscriptions.onUpdate(
          UserTable.classType,
          authorizationMode: APIAuthorizationType.userPools,
          where: where,
        ),
      );
      _userSubscription = stream.listen(
            (event) {
          final updated = event.data;
          if (updated != null) _handleUserUpdate(updated);
        },
        onError: (error) => safePrint('User subscription error: $error'),
      );
    } catch (_) {}
  }

  void _handleUserUpdate(UserTable updatedUser) async {
    final prevPolicy = currentUser.value?.isPolicy;
    await _updateUserData(updatedUser);
    if (prevPolicy != updatedUser.isPolicy) {
      Get.snackbar(
        'Policy Update',
        updatedUser.isPolicy == true ? 'Your policy acceptance has been confirmed' : 'Policy status updated',
        snackPosition: SnackPosition.TOP,
      );
    }
  }

  Future<bool> acceptPolicy() async {
    if (userId.value.isEmpty) {
      userError.value = 'User ID not available';
      return false;
    }
    try {
      isPolicyAccepted.value = true; // optimistic
      final ok = await UserTableAmplifyService.updatePolicy(userId.value);
      if (ok != true) {
        isPolicyAccepted.value = false;
        userError.value = 'Failed to update policy status';
        return false;
      }
      if (currentUser.value != null) {
        currentUser.value = currentUser.value!.copyWith(isPolicy: true);
      }
      await _cacheUserData();
      await refreshUserDataWithRetry();
      return true;
    } catch (e) {
      isPolicyAccepted.value = false;
      userError.value = 'Policy update error: ${e.toString()}';
      return false;
    }
  }

  Future<bool> checkPolicyStatus() async {
    try {
      if (userId.value.isEmpty) return false;
      final user = await UserTableAmplifyService.getUserById(userId.value);
      return user?.isPolicy ?? false;
    } catch (_) {
      return false;
    }
  }

  Future<void> refreshUserData() async {
    if (userId.value.isEmpty) return;
    try {
      final user = await UserTableAmplifyService.getUserById(userId.value);
      if (user != null) await _updateUserData(user);
    } catch (e) {
      userError.value = 'Failed to refresh user data';
    }
  }

  /// Retry helper to survive eventual consistency after create/update
  Future<void> refreshUserDataWithRetry({int maxAttempts = 5, int delayMs = 300}) async {
    for (int i = 0; i < maxAttempts; i++) {
      await refreshUserData();
      if (currentUser.value != null) return;
      await Future.delayed(Duration(milliseconds: delayMs * (i + 1)));
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
    await loadFullUserData();
  }

  Future<Object?> saveUserDetails({
    required String university,
    required String district,
    required String mandal,
    required String college,
    required String rollNumber,
    required UserTableGender gender,
  }) async {
    try {
      final existing = await UserTableAmplifyService.getUserById(userId.value);
      if (existing != null) {
        final updated = existing.copyWith(
          university: university,
          district: district,
          mandal: mandal,
          college: college,
          reg_no: rollNumber,
          gender: gender,
          name: existing.name,
          email: existing.email,
          phone: existing.phone,
          isPolicy: existing.isPolicy,
        );
        final success = await UserTableAmplifyService.updateUser(updated);
        if (success != null) await _updateUserData(updated);
        return success;
      } else {
        final newUser = UserTable(
          id: userId.value, // PK == Cognito sub
          name: userName.value,
          email: email.value,
          phone: phoneNumber.value,
          university: university,
          district: district,
          mandal: mandal,
          college: college,
          reg_no: rollNumber,
          gender: gender,
          isPolicy: false,
        );
        final success = await UserTableAmplifyService.createUser(newUser);
        if (success != null) await _updateUserData(newUser);
        return success;
      }
    } catch (e) {
      userError.value = 'Failed to save user details';
      return false;
    }
  }

  Future<bool> hasCompletedPersonalDetails() async {
    try {
      if (userId.value.isEmpty) return false;
      final user = await UserTableAmplifyService.getUserById(userId.value);
      if (user == null) return false;
      bool filled(String? s) => s != null && s.trim().isNotEmpty;
      return filled(user.university) &&
          filled(user.district)   &&
          filled(user.mandal)     &&
          filled(user.college)    &&
          filled(user.reg_no);
    } catch (_) {
      return false;
    }
  }

  Future<void> clearUserData() async {
    await _userSubscription?.cancel();
    await _cacheManager.clearUserData();

    currentUser.value = null;
    userName.value = '';
    email.value = '';
    phoneNumber.value = '';
    userId.value = '';
    profileColor.value = const Color(0xFF000000);
    isPolicyAccepted.value = false;
    isUserDataLoaded.value = false;
    isOfflineMode.value = false;
    userError.value = '';

    university.value = '';
    district.value = '';
    mandal.value = '';
    college.value = '';
    rollNumber.value = '';
  }

  // Convenience
  bool get hasUserData => currentUser.value != null;
  bool get isUserComplete => hasUserData && userName.value.isNotEmpty && email.value.isNotEmpty;
  String get displayName => userName.value.isNotEmpty ? userName.value : 'User';
  bool get hasError => userError.value.isNotEmpty;
  bool get isReady => isInitialized.value && !hasError;

  // One accessor so the UI always asks a single question
  bool get policyAccepted => (currentUser.value?.isPolicy ?? isPolicyAccepted.value) == true;
}

import 'package:amplify_api/amplify_api.dart';
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:atl_membership/models/ModelProvider.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../components/personaldetails.dart';
import '../utils/CacheManager.dart';
import '../utils/bgcolorconverter.dart';
import 'ConnectivityController.dart';


class AuthController extends GetxController {
  // Observable properties
  final RxString userName = ''.obs;
  final RxString email = ''.obs;
  final RxString phoneNumber = ''.obs;
  final Rx<Color> profileColor = const Color(0xFF000000).obs;
  final RxString userId = ''.obs;
  final RxBool isLoading = true.obs;
  final RxBool shouldShowDialog = false.obs;
  final RxBool isOfflineMode = false.obs;

  // Dependencies
  late final CacheManager _cacheManager;
  late ConnectivityController _connectivityController;

  @override
  Future<void> onInit() async {
    super.onInit();
   _initializeController();
  }

  Future<void> _initializeController() async {
    _cacheManager = CacheManager();
    _connectivityController = Get.put(ConnectivityController());

    await _connectivityController.onInitialized;
    await _loadUserData();
    isLoading.value = false;
  }

  Future<void> _loadUserData() async {
    // Always try to load cached data first
    await _loadCachedUserData();
    if ( _connectivityController.isOnline.value ) {
      await _loadOnlineUserData();
    } else {
      _handleOfflineMode();
    }
  }

  Future<void> _loadCachedUserData() async {
    try {
      final cachedData = await _cacheManager.getUserData();
      if (cachedData != null) {
        _updateUserDataFromCache(cachedData);
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error loading cached user data: $e');
      }
    }
  }

  Future<void> _loadOnlineUserData() async {
    try {
      await fetchCognitoUserAttributes();
      final isUserPresent = await validateUserDetailsRegistration(userId.value);

      // Cache the fresh data
      await _cacheManager.saveUserData({
        'userName': userName.value,
        'email': email.value,
        'phoneNumber': phoneNumber.value,
        'userId': userId.value,
        'isUserPresent' : isUserPresent
      });

      if (!isUserPresent) {
        _showPersonalDetailsDialog();
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error loading online user data: $e');
      }
      _handleOfflineMode();
    }
  }

  void _handleOfflineMode() {
    isOfflineMode.value = true;
    if (userName.value.isEmpty) {
      // Set default offline values
      // userName.value = 'Offline User';
      // email.value = 'offline@local.com';
    }
  }

  void _updateUserDataFromCache(Map<String, dynamic> cachedData) {
    userName.value = cachedData['userName'] ?? '';
    email.value = cachedData['email'] ?? '';
    phoneNumber.value = cachedData['phoneNumber'] ?? '';
    userId.value = cachedData['userId'] ?? '';

    // Update profile color if we have a username
    if (userName.value.isNotEmpty) {
      _updateProfileColor();
    }
  }

  Future<void> _updateProfileColor() async {
    try {
      profileColor.value = await getColorFromStringAsync(userName.value);
    } catch (e) {
      if (kDebugMode) {
        print('Error updating profile color: $e');
      }
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

  Future<void> fetchCognitoUserAttributes() async {
    try {
      var attributes = await Amplify.Auth.fetchUserAttributes();
      email.value = attributes[0].value;
      phoneNumber.value = attributes[2].value;
      userName.value = attributes[4].value;
      profileColor.value = await getColorFromStringAsync(userName.value);
      userId.value = attributes[5].value;
      safePrint(attributes);
    } catch (e) {
      if (kDebugMode) {
        print('Error fetching user attributes: $e');
      }
    }
  }

  Future<bool> validateUserDetailsRegistration(String currentUserId) async {
    try {
      // You might want to get the user ID from Cognito attributes or another source
      // For now, I'll assume you have a way to get the current user's ID
      // String currentUserId = await getCurrentUserId(); // Implement this method

      final request = ModelQueries.get(
          UserTable.classType,
          UserTableModelIdentifier(id: currentUserId)
      );
      final response = await Amplify.API.query(request: request).response;
      final userData = response.data;
      final returnedUserId = userData?.id;
      safePrint("1 returned : $returnedUserId current : $currentUserId");

      // if (returnedUserId != null) {
      //   userId.value = returnedUserId;
      // }
      if(returnedUserId==currentUserId){
        safePrint("returned : $returnedUserId current : $currentUserId");
        return true;
      }
      safePrint("returning false");
      return false;
    } on ApiException catch (e) {
      if (kDebugMode) {
        print('Query failed: $e');
      }
      // If query fails, assume user doesn't exist in database
      return false;
    }
  }

  Future<String> getCurrentUserId() async {
    // Implement this method to get the current user's ID from Cognito
    // This is just a placeholder - you'll need to implement based on your setup
    try {
      final user = await Amplify.Auth.getCurrentUser();
      return user.userId;
    } catch (e) {
      if (kDebugMode) {
        print('Error getting current user ID: $e');
      }
      return '';
    }
  }

// Method to save user details after form submission
  Future<void> saveUserDetails({
    required String university,
    required String district,
    required String mandal,
    required String college,
    required String rollNumber,
    required UserTableGender gender
  }) async {
    try {
      safePrint("inserting user-id = $userId");
      // Create new user record in database
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
        gender:gender
        // Add other required fields
      );

      final request = ModelMutations.create(newUser,authorizationMode: APIAuthorizationType.userPools);
      final response = await Amplify.API.mutate(request: request).response;

      if (response.errors.isNotEmpty) {
        for (final error in response.errors) {
          if (kDebugMode) {
            print('GraphQL Error: ${error.message}');
          }
        }
      }

      if (response.data != null) {
        userId.value = response.data!.id;
        shouldShowDialog.value = false;
        Get.snackbar('Success', 'Personal details saved successfully!');
      }else{
        safePrint("pushed details : ${response.data}");
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error saving user details: $e');
      }
      Get.snackbar('Error', 'Failed to save personal details. Please try again.');   }
  }

  /// Setup Amplify auth state listener - Key for cache clearing
  void _setupAuthStateListener() {
    Amplify.Hub.listen(HubChannel.Auth, (AuthHubEvent event) {
      switch (event.type) {
        case AuthHubEventType.signedOut:
          _handleSignOut();
          break;
        case AuthHubEventType.sessionExpired:
          _handleSessionExpired();
          break;
        case AuthHubEventType.signedIn:
          _handleSignIn();
          break;
        default:
          break;
      }
    });
  }

  /// Handle sign out event - Critical for cache clearing
  void _handleSignOut() async {
    if (kDebugMode) {
      print('User signed out - clearing cache');
    }

    await _clearAllUserData();

    Future.delayed(Duration(milliseconds: 100), () {
      if (Get.context != null) {
        Get.snackbar(
          'Signed Out',
          'You have been signed out successfully',
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.green.shade100,
          colorText: Colors.green.shade700,
        );
      }
    });
  }

  /// Handle session expired event
  void _handleSessionExpired() async {
    if (kDebugMode) {
      print('Session expired - clearing cache');
    }

    await _clearAllUserData();

    Get.snackbar(
      'Session Expired',
      'Your session has expired. Please sign in again.',
      snackPosition: SnackPosition.TOP,
      backgroundColor: Colors.orange.shade100,
      colorText: Colors.orange.shade700,
    );
  }

  /// Handle sign in event
  void _handleSignIn() async {
    if (kDebugMode) {
      print('User signed in - loading data');
    }

    // Reload user data when signed in
    isLoading.value = true;
    await _loadUserData();
    isLoading.value = false;
  }

  /// Clear all user data and reset state
  Future<void> _clearAllUserData() async {
    // Clear cache
    await _cacheManager.clearUserData();

    // Reset all observable values
    userName.value = '';
    email.value = '';
    phoneNumber.value = '';
    userId.value = '';
    profileColor.value = const Color(0xFF000000);
    shouldShowDialog.value = false;
    isOfflineMode.value = false;
  }


}



// class AuthController extends GetxController {
//   RxString userName = ''.obs;
//   RxString email = ''.obs;
//   RxString phoneNumber = ''.obs;
//   Rx<Color> profileColor = Color(0xFF000000).obs;
//   RxString userId = ''.obs;
//   RxBool isLoading = true.obs;
//   RxBool shouldShowDialog = false.obs;
//
//   @override
//   Future<void> onInit() async {
//     super.onInit();
//     await fetchCognitoUserAttributes();
//     bool isUserPresent = await validateUserDetailsRegistration(userId.value);
//     isLoading.value = false;
//
//     // Check if we need to show the dialog after loading is complete
//     if (!isUserPresent) {
//       shouldShowDialog.value = true;
//       // Show dialog after a small delay to ensure the widget tree is built
//       Future.delayed(Duration(milliseconds: 200), () {
//         _showPersonalDetailsDialog();
//       });
//     }
//   }
//
//   Future<void> fetchCognitoUserAttributes() async {
//     try {
//       var attributes = await Amplify.Auth.fetchUserAttributes();
//       email.value = attributes[0].value;
//       phoneNumber.value = attributes[2].value;
//       userName.value = attributes[4].value;
//       profileColor.value = await getColorFromStringAsync(userName.value);
//       userId.value = attributes[5].value;
//       safePrint(attributes);
//     } catch (e) {
//       if (kDebugMode) {
//         print('Error fetching user attributes: $e');
//       }
//     }
//   }
//
//   Future<bool> validateUserDetailsRegistration(String currentUserId) async {
//     try {
//       // You might want to get the user ID from Cognito attributes or another source
//       // For now, I'll assume you have a way to get the current user's ID
//       // String currentUserId = await getCurrentUserId(); // Implement this method
//
//       final request = ModelQueries.get(
//           UserTable.classType,
//           UserTableModelIdentifier(id: currentUserId)
//       );
//       final response = await Amplify.API.query(request: request).response;
//       final userData = response.data;
//       final returnedUserId = userData?.id;
//       safePrint("1 returned : $returnedUserId current : $currentUserId");
//
//       // if (returnedUserId != null) {
//       //   userId.value = returnedUserId;
//       // }
//       if(returnedUserId==currentUserId){
//         safePrint("returned : $returnedUserId current : $currentUserId");
//         return true;
//       }
//       safePrint("returning false");
//       return false;
//     } on ApiException catch (e) {
//       if (kDebugMode) {
//         print('Query failed: $e');
//       }
//       // If query fails, assume user doesn't exist in database
//       return false;
//     }
//   }
//
//   Future<String> getCurrentUserId() async {
//     // Implement this method to get the current user's ID from Cognito
//     // This is just a placeholder - you'll need to implement based on your setup
//     try {
//       final user = await Amplify.Auth.getCurrentUser();
//       return user.userId;
//     } catch (e) {
//       if (kDebugMode) {
//         print('Error getting current user ID: $e');
//       }
//       return '';
//     }
//   }
//
//   void _showPersonalDetailsDialog() {
//     if (Get.context != null) {
//       showDialog(
//         context: Get.context!,
//         barrierDismissible: false, // Prevent dismissing by tapping outside
//         builder: (context) => PersonalDetailsDialog(),
//       );
//     }
//   }
//
//   // Method to save user details after form submission
//   Future<void> saveUserDetails({
//     required String university,
//     required String district,
//     required String mandal,
//     required String college,
//     required String rollNumber,
//     required UserTableGender gender
//   }) async {
//     try {
//       safePrint("inserting user-id = $userId");
//       // Create new user record in database
//       final newUser = UserTable(
//         id: userId.value,
//         university: university,
//         district: district,
//         mandal: mandal,
//         college: college,
//         reg_no: rollNumber,
//         email: email.value,
//         phone: phoneNumber.value,
//         name: userName.value,
//         gender:gender
//         // Add other required fields
//       );
//
//       final request = ModelMutations.create(newUser,authorizationMode: APIAuthorizationType.userPools);
//       final response = await Amplify.API.mutate(request: request).response;
//
//       if (response.errors.isNotEmpty) {
//         for (final error in response.errors) {
//           if (kDebugMode) {
//             print('GraphQL Error: ${error.message}');
//           }
//         }
//       }
//
//       if (response.data != null) {
//         userId.value = response.data!.id;
//         shouldShowDialog.value = false;
//         Get.snackbar('Success', 'Personal details saved successfully!');
//       }else{
//         safePrint("pushed details : ${response.data}");
//       }
//     } catch (e) {
//       if (kDebugMode) {
//         print('Error saving user details: $e');
//       }
//       Get.snackbar('Error', 'Failed to save personal details. Please try again.');   }
//   }
// }

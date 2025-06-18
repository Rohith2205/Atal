import 'package:amplify_api/amplify_api.dart';
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:atl_membership/models/ModelProvider.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../models/UserTable.dart';
import '../screens/personaldetails.dart';
import '../utils/bgcolorconverter.dart';

class AuthController extends GetxController {
  RxString userName = ''.obs;
  RxString email = ''.obs;
  RxString phoneNumber = ''.obs;
  Rx<Color> profileColor = Color(0xFF000000).obs;
  RxString userId = ''.obs;
  RxBool isLoading = true.obs;
  RxBool shouldShowDialog = false.obs;

  @override
  Future<void> onInit() async {
    super.onInit();
    await fetchCognitoUserAttributes();
    bool isUserPresent = await validateUserDetailsRegistration(userId.value);
    isLoading.value = false;

    // Check if we need to show the dialog after loading is complete
    if (!isUserPresent) {
      shouldShowDialog.value = true;
      // Show dialog after a small delay to ensure the widget tree is built
      Future.delayed(Duration(milliseconds: 200), () {
        _showPersonalDetailsDialog();
      });
    }
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

  void _showPersonalDetailsDialog() {
    if (Get.context != null) {
      showDialog(
        context: Get.context!,
        barrierDismissible: false, // Prevent dismissing by tapping outside
        builder: (context) => PersonalDetailsDialog(),
      );
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
          print('GraphQL Error: ${error.message}');
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
}
import 'package:amplify_api/amplify_api.dart';
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:flutter/foundation.dart';

import '../models/UserTable.dart';

// class UserTableAmplifyService{
//   static Future<bool?> isPolicyAccepted(String userId)  async {
//     try {
//       final queryPredicate = UserTable.ID.eq(userId);
//       final request = ModelQueries.list<UserTable>(
//           UserTable.classType,
//           limit: 1,
//           where: queryPredicate,
//           authorizationMode: APIAuthorizationType.userPools
//       );
//       final response = await Amplify.API
//           .query(request: request)
//           .response;
//       final queriedUser = response.data?.items.first;
//      bool? userPolicyAcceptanceBool = queriedUser?.isPolicy;
//       return userPolicyAcceptanceBool;
//     } catch (e) {
//       if (kDebugMode) {
//         print('Error getting current user ID: $e');
//       }
//       return null;
//     }
//   }
//
//   static Future<UserTable?> getUserById(String userId) async {
//     try {
//       final queryPredicate = UserTable.ID.eq(userId);
//       final request = ModelQueries.list<UserTable>(
//           UserTable.classType,
//           limit: 1,
//           where: queryPredicate,
//           authorizationMode: APIAuthorizationType.userPools
//       );
//       final response = await Amplify.API
//           .query(request: request)
//           .response;
//
//       if(response.hasErrors){
//         safePrint("response errors : ${response.errors}");
//       }
//       final queriedUser = response.data?.items.first;
//       return queriedUser;
//     }catch(e){
//       if (kDebugMode) {
//         print('Error getting current user ID: $e');
//       }
//       return null;
//     }
//   }
//
//   static Future<bool?> updatePolicy(String userId) async{
//     try{
//       final UserTable? user = await getUserById(userId);
//       final newuser = user?.copyWith(isPolicy: true);
//       final request = ModelMutations.update<UserTable>(newuser!,authorizationMode: APIAuthorizationType.userPools);
//       final response = await Amplify.API.mutate(request: request).response;
//       if(response.hasErrors){
//         safePrint("response errors : ${response.errors}");
//         return null;
//       }
//       return true;
//     }catch(e){
//       if (kDebugMode) {
//         print('Error getting current user ID: $e');
//       }
//       return null;
//     }
//   }
//
//   static Future<void> setupSubscriptionForUser(String userId)async {
//     final queryPredicate = UserTable.ID.eq(userId);
//     final stream = Amplify.API.subscribe<UserTable>(ModelSubscriptions.onUpdate(UserTable.classType,authorizationMode: APIAuthorizationType.userPools,where: queryPredicate));
//
//   }
//
// }

import 'dart:async';
import 'package:amplify_api/amplify_api.dart';
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:flutter/foundation.dart';

import '../models/UserTable.dart';

class UserTableAmplifyService {
  /// Check if user has accepted the policy
  static Future<bool?> isPolicyAccepted(String userId) async {
    try {
      final queryPredicate = UserTable.ID.eq(userId);
      final request = ModelQueries.list<UserTable>(
        UserTable.classType,
        limit: 1,
        where: queryPredicate,
        authorizationMode: APIAuthorizationType.userPools,
      );
      final response = await Amplify.API.query(request: request).response;

      if (response.hasErrors) {
        safePrint("Response errors: ${response.errors}");
        return null;
      }

      final queriedUser = response.data?.items.first;
      return queriedUser?.isPolicy;
    } catch (e) {
      if (kDebugMode) {
        print('Error checking policy acceptance: $e');
      }
      return null;
    }
  }

  /// Get user by ID
  static Future<UserTable?> getUserById(String userId) async {
    try {
      final queryPredicate = UserTable.ID.eq(userId);
      final request = ModelQueries.list<UserTable>(
        UserTable.classType,
        limit: 1,
        where: queryPredicate,
        authorizationMode: APIAuthorizationType.userPools,
      );
      final response = await Amplify.API.query(request: request).response;

      if (response.hasErrors) {
        safePrint("Response errors: ${response.errors}");
        return null;
      }

      if (response.data?.items.isNotEmpty == true) {
        return response.data!.items.first;
      }

      return null;
    } catch (e) {
      if (kDebugMode) {
        print('Error getting user by ID: $e');
      }
      return null;
    }
  }

  /// Update user policy acceptance status
  static Future<bool?> updatePolicy(String userId) async {
    try {
      final user = await getUserById(userId);
      if (user == null) {
        safePrint("User not found for policy update");
        return null;
      }

      final updatedUser = user.copyWith(isPolicy: true);
      final request = ModelMutations.update<UserTable>(
        updatedUser,
        authorizationMode: APIAuthorizationType.userPools,
      );
      final response = await Amplify.API.mutate(request: request).response;

      if (response.hasErrors) {
        safePrint("Response errors: ${response.errors}");
        return null;
      }

      return response.data != null;
    } catch (e) {
      if (kDebugMode) {
        print('Error updating policy: $e');
      }
      return null;
    }
  }

  /// Create a new user
  static Future<UserTable?> createUser(UserTable user) async {
    try {
      final request = ModelMutations.create(
        user,
        authorizationMode: APIAuthorizationType.userPools,
      );
      final response = await Amplify.API.mutate(request: request).response;

      if (response.hasErrors) {
        for (final error in response.errors) {
          safePrint("GraphQL Error: ${error.message}");
        }
        return null;
      }

      return response.data;
    } catch (e) {
      if (kDebugMode) {
        print('Error creating user: $e');
      }
      return null;
    }
  }

  /// Update user information
  static Future<UserTable?> updateUser(UserTable user) async {
    try {
      final request = ModelMutations.update(
        user,
        authorizationMode: APIAuthorizationType.userPools,
      );
      final response = await Amplify.API.mutate(request: request).response;

      if (response.hasErrors) {
        for (final error in response.errors) {
          safePrint("GraphQL Error: ${error.message}");
        }
        return null;
      }

      return response.data;
    } catch (e) {
      if (kDebugMode) {
        print('Error updating user: $e');
      }
      return null;
    }
  }

  /// Delete user
  static Future<bool> deleteUser(String userId) async {
    try {
      final user = await getUserById(userId);
      if (user == null) {
        safePrint("User not found for deletion");
        return false;
      }

      final request = ModelMutations.delete(
        user,
        authorizationMode: APIAuthorizationType.userPools,
      );
      final response = await Amplify.API.mutate(request: request).response;

      if (response.hasErrors) {
        for (final error in response.errors) {
          safePrint("GraphQL Error: ${error.message}");
        }
        return false;
      }

      return response.data != null;
    } catch (e) {
      if (kDebugMode) {
        print('Error deleting user: $e');
      }
      return false;
    }
  }

  /// Setup subscription for user updates
  static Stream<GraphQLResponse<UserTable>> setupUserSubscription(String userId) {
    final queryPredicate = UserTable.ID.eq(userId);
    return Amplify.API.subscribe<UserTable>(
      ModelSubscriptions.onUpdate(
        UserTable.classType,
        authorizationMode: APIAuthorizationType.userPools,
        where: queryPredicate,
      ),
    );
  }

  /// Setup subscription for user creation
  static Stream<GraphQLResponse<UserTable>> setupUserCreationSubscription() {
    return Amplify.API.subscribe<UserTable>(
      ModelSubscriptions.onCreate(
        UserTable.classType,
        authorizationMode: APIAuthorizationType.userPools,
      ),
    );
  }

  /// Setup subscription for user deletion
  static Stream<GraphQLResponse<UserTable>> setupUserDeletionSubscription() {
    return Amplify.API.subscribe<UserTable>(
      ModelSubscriptions.onDelete(
        UserTable.classType,
        authorizationMode: APIAuthorizationType.userPools,
      ),
    );
  }

  /// Check if user exists in the database
  static Future<bool> userExists(String userId) async {
    final user = await getUserById(userId);
    return user != null;
  }

  /// Get users by university (for admin purposes)
  static Future<List<UserTable?>?> getUsersByUniversity(String university) async {
    try {
      final queryPredicate = UserTable.UNIVERSITY.eq(university);
      final request = ModelQueries.list<UserTable>(
        UserTable.classType,
        where: queryPredicate,
        authorizationMode: APIAuthorizationType.userPools,
      );
      final response = await Amplify.API.query(request: request).response;

      if (response.hasErrors) {
        safePrint("Response errors: ${response.errors}");
        return null;
      }

      return response.data?.items;
    } catch (e) {
      if (kDebugMode) {
        print('Error getting users by university: $e');
      }
      return null;
    }
  }

  /// Get users by college (for admin purposes)
  static Future<List<UserTable?>?> getUsersByCollege(String college) async {
    try {
      final queryPredicate = UserTable.COLLEGE.eq(college);
      final request = ModelQueries.list<UserTable>(
        UserTable.classType,
        where: queryPredicate,
        authorizationMode: APIAuthorizationType.userPools,
      );
      final response = await Amplify.API.query(request: request).response;

      if (response.hasErrors) {
        safePrint("Response errors: ${response.errors}");
        return null;
      }

      return response.data?.items;
    } catch (e) {
      if (kDebugMode) {
        print('Error getting users by college: $e');
      }
      return null;
    }
  }

  /// Get users with policy not accepted (for admin purposes)
  static Future<List<UserTable?>?> getUsersWithoutPolicyAcceptance() async {
    try {
      final queryPredicate = UserTable.ISPOLICY.eq(false);
      final request = ModelQueries.list<UserTable>(
        UserTable.classType,
        where: queryPredicate,
        authorizationMode: APIAuthorizationType.userPools,
      );
      final response = await Amplify.API.query(request: request).response;

      if (response.hasErrors) {
        safePrint("Response errors: ${response.errors}");
        return null;
      }

      return response.data?.items;
    } catch (e) {
      if (kDebugMode) {
        print('Error getting users without policy acceptance: $e');
      }
      return null;
    }
  }
}
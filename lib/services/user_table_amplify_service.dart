import 'dart:async';
import 'package:amplify_api/amplify_api.dart';
import 'package:amplify_flutter/amplify_flutter.dart';
import '../models/UserTable.dart';

class UserTableAmplifyService {
  // Private method using ModelIdentifier for direct gets
  static Future<UserTable?> _getUserById(String userId) async {
    try {
      final modelId = UserTableModelIdentifier(id: userId);
      final request = ModelQueries.get<UserTable>(
        UserTable.classType,
        modelId,
        authorizationMode: APIAuthorizationType.userPools,
      );
      final response = await Amplify.API.query(request: request).response;

      if (response.hasErrors) {
        safePrint("Get user errors: ${response.errors}");
        return null;
      }
      return response.data;
    } catch (e) {
      safePrint('Get user exception: $e');
      return null;
    }
  }

  /// Check if user has accepted the policy (optimized version)
  static Future<bool?> isPolicyAccepted(String userId) async {
    try {
      final user = await _getUserById(userId);
      return user?.isPolicy;
    } catch (e) {
      safePrint('Policy check exception: $e');
      return null;
    }
  }

  /// Get user by ID (FIXED: Handle empty list properly)
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
        safePrint("List user errors: ${response.errors}");
        return null;
      }

      // FIXED: Check if items exist before accessing first
      final items = response.data?.items;
      if (items == null || items.isEmpty) {
        safePrint("No user found with ID: $userId");
        return null;
      }

      return items.first;
    } catch (e) {
      safePrint('List user exception: $e');
      return null;
    }
  }

  /// Update user policy acceptance status (IMPROVED: Better error handling)
  static Future<bool> updatePolicy(String userId) async {
    try {
      safePrint("Attempting to update policy for user: $userId");

      // Use the more efficient _getUserById method
      final user = await _getUserById(userId);
      if (user == null) {
        safePrint("User not found for policy update: $userId");
        return false;
      }

      safePrint("Found user: ${user.name}, current policy status: ${user.isPolicy}");

      final updatedUser = user.copyWith(isPolicy: true);
      final request = ModelMutations.update(
        updatedUser,
        authorizationMode: APIAuthorizationType.userPools,
      );
      final response = await Amplify.API.mutate(request: request).response;

      if (response.hasErrors) {
        safePrint("Update policy errors: ${response.errors}");
        return false;
      }

      safePrint("Policy update successful for user: $userId");
      return response.data != null;
    } catch (e) {
      safePrint('Update policy exception: $e');
      return false;
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
        safePrint("Create user errors: ${response.errors}");
        return null;
      }
      return response.data;
    } catch (e) {
      safePrint('Create user exception: $e');
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
        safePrint("Update user errors: ${response.errors}");
        return null;
      }
      return response.data;
    } catch (e) {
      safePrint('Update user exception: $e');
      return null;
    }
  }

  /// Delete user
  static Future<bool> deleteUser(String userId) async {
    try {
      final user = await getUserById(userId);
      if (user == null) return false;

      final request = ModelMutations.delete(
        user,
        authorizationMode: APIAuthorizationType.userPools,
      );
      final response = await Amplify.API.mutate(request: request).response;

      if (response.hasErrors) {
        safePrint("Delete user errors: ${response.errors}");
        return false;
      }
      return response.data != null;
    } catch (e) {
      safePrint('Delete user exception: $e');
      return false;
    }
  }

  /// Subscription for user updates
  static Stream<GraphQLResponse<UserTable>> userUpdatesSubscription(String userId) {
    final queryPredicate = UserTable.ID.eq(userId);
    return Amplify.API.subscribe<UserTable>(
      ModelSubscriptions.onUpdate(
        UserTable.classType,
        authorizationMode: APIAuthorizationType.userPools,
        where: queryPredicate,
      ),
    );
  }

  /// Check if user exists
  static Future<bool> userExists(String userId) async {
    final user = await _getUserById(userId);
    return user != null;
  }

  /// Get users by university
  static Future<List<UserTable>> getUsersByUniversity(String university) async {
    try {
      final queryPredicate = UserTable.UNIVERSITY.eq(university);
      final request = ModelQueries.list<UserTable>(
        UserTable.classType,
        where: queryPredicate,
        authorizationMode: APIAuthorizationType.userPools,
      );
      final response = await Amplify.API.query(request: request).response;

      if (response.hasErrors) {
        safePrint("University query errors: ${response.errors}");
        return [];
      }
      return response.data?.items.whereType<UserTable>().toList() ?? [];
    } catch (e) {
      safePrint('University query exception: $e');
      return [];
    }
  }

  /// Get users who haven't accepted policy
  static Future<List<UserTable>> getUsersWithoutPolicyAcceptance() async {
    try {
      final queryPredicate = UserTable.ISPOLICY.eq(false);
      final request = ModelQueries.list<UserTable>(
        UserTable.classType,
        where: queryPredicate,
        authorizationMode: APIAuthorizationType.userPools,
      );
      final response = await Amplify.API.query(request: request).response;

      if (response.hasErrors) {
        safePrint("Policy query errors: ${response.errors}");
        return [];
      }
      return response.data?.items.whereType<UserTable>().toList() ?? [];
    } catch (e) {
      safePrint('Policy query exception: $e');
      return [];
    }
  }
}
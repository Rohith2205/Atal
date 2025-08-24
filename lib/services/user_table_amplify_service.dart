import 'dart:async';
import 'package:amplify_api/amplify_api.dart';
import 'package:amplify_flutter/amplify_flutter.dart';
import '../models/UserTable.dart';

class UserTableAmplifyService {
  // ---------- Core: strong read with retries ----------
  static Future<UserTable?> _getUserByIdStrong(
      String userId, {
        int maxAttempts = 5,
        Duration initialDelay = const Duration(milliseconds: 200),
      }) async {
    Duration delay = initialDelay;
    for (int attempt = 1; attempt <= maxAttempts; attempt++) {
      final user = await _getUserByIdOnce(userId);
      if (user != null) return user;

      if (attempt < maxAttempts) {
        await Future.delayed(delay);
        // simple backoff
        delay = Duration(milliseconds: (delay.inMilliseconds * 1.6).round());
      }
    }
    return null;
  }

  // Single GET by ModelIdentifier (stronger than list)
  static Future<UserTable?> _getUserByIdOnce(String userId) async {
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

  /// Public: Get user by ID (defaults to strong read with retry)
  static Future<UserTable?> getUserById(String userId) async {
    return _getUserByIdStrong(userId);
  }

  /// Check if user has accepted the policy
  static Future<bool?> isPolicyAccepted(String userId) async {
    try {
      final user = await _getUserByIdStrong(userId);
      return user?.isPolicy;
    } catch (e) {
      safePrint('Policy check exception: $e');
      return null;
    }
  }

  /// Update user policy acceptance status
  static Future<bool> updatePolicy(String userId) async {
    try {
      safePrint("Attempting to update policy for user: $userId");

      // Use strong get with retries to avoid missing the item
      final user = await _getUserByIdStrong(userId);
      if (user == null) {
        safePrint("User not found for policy update: $userId");
        return false;
        // If this happens regularly, ensure your UserTable.id == Cognito sub.
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

      // Optional: confirm write
      await _getUserByIdStrong(userId);
      safePrint("Policy update successful for user: $userId");
      return response.data != null;
    } catch (e) {
      safePrint('Update policy exception: $e');
      return false;
    }
  }

  /// Create a new user (then confirm with a strong read)
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

      // Confirm presence (handles eventual consistency)
      final confirmed = await _getUserByIdStrong(user.id);
      return confirmed ?? response.data;
    } catch (e) {
      safePrint('Create user exception: $e');
      return null;
    }
  }

  /// Update user information (then confirm with a strong read)
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

      // Confirm presence (handles eventual consistency)
      final confirmed = await _getUserByIdStrong(user.id);
      return confirmed ?? response.data;
    } catch (e) {
      safePrint('Update user exception: $e');
      return null;
    }
  }

  /// Delete user
  static Future<bool> deleteUser(String userId) async {
    try {
      final user = await _getUserByIdStrong(userId);
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

  /// Existence check (strong)
  static Future<bool> userExists(String userId) async {
    final user = await _getUserByIdStrong(userId);
    return user != null;
  }

  /// Example filter by university (unchanged; list is fine here)
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

  /// Users who haven't accepted policy (list is appropriate here)
  static Future<List<UserTable>> getUsersWithoutPolicyAcceptance() async {
    try {
      final request = ModelQueries.list<UserTable>(
        UserTable.classType,
        where: UserTable.ISPOLICY.eq(false),
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

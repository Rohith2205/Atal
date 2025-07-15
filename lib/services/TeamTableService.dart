import 'dart:math';

import 'package:amplify_api/amplify_api.dart';
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:atl_membership/models/ModelProvider.dart';
import 'package:flutter/foundation.dart';

class TeamTableService {
  // Constants for better maintainability
  static const int _maxTeamMembers = 5; // Team size limit
  static const int _teamCodeLength = 7; // Shorter team code format

  /// Creates a new team with the given userId as the initial member
  /// Returns the team code if successful, null if failed
  static Future<String?> createTeam(String userId) async {
    if (userId.trim().isEmpty) {
      if (kDebugMode) {
        print('Error: User ID cannot be empty');
      }
      return null;
    }

    try {
      final teamCode = _generateTeamCode(userId);
      final TeamTable team = TeamTable(
          team_code: teamCode,
          team_members: [userId]
      );

      final request = ModelMutations.create(
        team,
        authorizationMode: APIAuthorizationType.userPools,
      );

      final response = await Amplify.API.mutate(request: request).response;

      if (response.hasErrors) {
        safePrint("Response errors: ${response.errors}");
        return null;
      }

      safePrint("Team created successfully: ${response.data}");
      return response.data?.team_code; // Return team_code instead of ID
    } catch (e) {
      if (kDebugMode) {
        print('Error creating team: $e');
      }
      return null;
    }
  }

  /// Generates a unique team code based on userId and timestamp
  static String _generateTeamCode(String userId) {
    // Get current timestamp (last 4 digits for brevity)
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    final timestampStr = timestamp.toString();
    final shortTimestamp = timestampStr.substring(timestampStr.length - 4);

    // Get first 2 characters of userId (or pad if shorter)
    final userPrefix = userId.length >= 2
        ? userId.substring(0, 2).toUpperCase()
        : userId.padRight(2, 'X').toUpperCase();

    // Simple random 1-digit number (0-9)
    final random = Random().nextInt(10);
    final randomStr = random.toString();

    // Combine: USER(2) + TIMESTAMP(4) + RANDOM(1) = 7 characters
    return '$userPrefix$shortTimestamp$randomStr';
  }

  /// Allows a user to join an existing team
  /// Returns true if successful, false if failed
  static Future<bool> joinTeam(String teamCode, String userId) async {
    if (teamCode.trim().isEmpty || userId.trim().isEmpty) {
      if (kDebugMode) {
        print('Error: Team code and user ID cannot be empty');
      }
      return false;
    }

    try {
      // Find team by team_code
      final queryPredicate = TeamTable.TEAM_CODE.eq(teamCode);

      final teamRequest = ModelQueries.list<TeamTable>(
          TeamTable.classType,
          where: queryPredicate,
          limit: 1,
          authorizationMode: APIAuthorizationType.userPools
      );

      final teamResponse = await Amplify.API.query(request: teamRequest).response;
      final team = teamResponse.data?.items.isNotEmpty == true
          ? teamResponse.data!.items.first
          : null;

      if (team == null) {
        safePrint("Team with code $teamCode does not exist");
        return false;
      }

      // Check if user is already in team
      if (team.team_members?.contains(userId) == true) {
        safePrint("User is already in this team");
        return false;
      }

      // Check team size limit
      if ((team.team_members?.length ?? 0) >= _maxTeamMembers) {
        safePrint("Team is full (maximum $_maxTeamMembers members)");
        return false;
      }

      // Add user to team
      final newTeamMembers = List<String>.from(team.team_members ?? []);
      newTeamMembers.add(userId);

      final updateTeamRequest = ModelMutations.update(
          team.copyWith(team_members: newTeamMembers),
          authorizationMode: APIAuthorizationType.userPools
      );

      final updateTeamResponse = await Amplify.API.mutate(request: updateTeamRequest).response;

      if (updateTeamResponse.hasErrors) {
        safePrint("Error joining team: ${updateTeamResponse.errors}");
        return false;
      }

      safePrint("Successfully joined team");
      return true;
    } catch (e) {
      if (kDebugMode) {
        print('Error joining team: $e');
      }
      return false;
    }
  }

  /// Retrieves a team by its team code
  static Future<TeamTable?> getTeamByCode(String teamCode) async {
    if (teamCode.trim().isEmpty) {
      return null;
    }

    try {
      final queryPredicate = TeamTable.TEAM_CODE.eq(teamCode);

      final teamRequest = ModelQueries.list<TeamTable>(
          TeamTable.classType,
          where: queryPredicate,
          limit: 1,
          authorizationMode: APIAuthorizationType.userPools
      );

      final teamResponse = await Amplify.API.query(request: teamRequest).response;
      return teamResponse.data?.items.isNotEmpty == true
          ? teamResponse.data!.items.first
          : null;
    } catch (e) {
      if (kDebugMode) {
        print('Error getting team: $e');
      }
      return null;
    }
  }

  /// Removes a user from a team
  /// Returns true if successful, false if failed
  static Future<bool> exitTeam(String teamCode, String userId) async {
    if (teamCode.trim().isEmpty || userId.trim().isEmpty) {
      if (kDebugMode) {
        print('Error: Team code and user ID cannot be empty');
      }
      return false;
    }

    try {
      final team = await getTeamByCode(teamCode);

      if (team == null) {
        safePrint("Team with code $teamCode does not exist");
        return false;
      }

      final newTeamMembers = List<String>.from(team.team_members ?? []);
      if (!newTeamMembers.remove(userId)) {
        safePrint("User is not in this team");
        return false;
      }

      // If team becomes empty, delete it
      if (newTeamMembers.isEmpty) {
        return await deleteTeam(teamCode, userId);
      }

      final updateTeamRequest = ModelMutations.update(
          team.copyWith(team_members: newTeamMembers),
          authorizationMode: APIAuthorizationType.userPools
      );

      final updateTeamResponse = await Amplify.API.mutate(request: updateTeamRequest).response;

      if (updateTeamResponse.hasErrors) {
        safePrint("Error leaving team: ${updateTeamResponse.errors}");
        return false;
      }

      safePrint("Successfully left team");
      return true;
    } catch (e) {
      if (kDebugMode) {
        print('Error leaving team: $e');
      }
      return false;
    }
  }

  /// Gets all teams that a user belongs to
  static Future<List<TeamTable>> getUserTeams(String userId) async {
    if (userId.trim().isEmpty) {
      return [];
    }

    try {
      final queryPredicate = TeamTable.TEAM_MEMBERS.contains(userId);

      final teamRequest = ModelQueries.list<TeamTable>(
          TeamTable.classType,
          where: queryPredicate,
          authorizationMode: APIAuthorizationType.userPools
      );

      final teamResponse = await Amplify.API.query(request: teamRequest).response;
      return teamResponse.data?.items.where((team) => team != null).cast<TeamTable>().toList() ?? [];
    } catch (e) {
      if (kDebugMode) {
        print('Error getting user teams: $e');
      }
      return [];
    }
  }

  /// Deletes a team (only if user is the only member)
  /// Returns true if successful, false if failed
  static Future<bool> deleteTeam(String teamCode, String userId) async {
    if (teamCode.trim().isEmpty || userId.trim().isEmpty) {
      if (kDebugMode) {
        print('Error: Team code and user ID cannot be empty');
      }
      return false;
    }

    try {
      final team = await getTeamByCode(teamCode);

      if (team == null) {
        safePrint("Team does not exist");
        return false;
      }

      // Check if user is the only member
      if (team.team_members?.length != 1 || team.team_members?.first != userId) {
        safePrint("Cannot delete team - either not the only member or not a member");
        return false;
      }

      final deleteRequest = ModelMutations.delete(
          team,
          authorizationMode: APIAuthorizationType.userPools
      );

      final deleteResponse = await Amplify.API.mutate(request: deleteRequest).response;

      if (deleteResponse.hasErrors) {
        safePrint("Error deleting team: ${deleteResponse.errors}");
        return false;
      }

      safePrint("Team deleted successfully");
      return true;
    } catch (e) {
      if (kDebugMode) {
        print('Error deleting team: $e');
      }
      return false;
    }
  }

  /// Validates if a team code has the expected format
  static bool isValidTeamCode(String teamCode) {
    return teamCode.length == _teamCodeLength &&
        RegExp(r'^[A-Z0-9]+$').hasMatch(teamCode);
  }

  /// Gets team member count without fetching full team data
  static Future<int> getTeamMemberCount(String teamCode) async {
    final team = await getTeamByCode(teamCode);
    return team?.team_members?.length ?? 0;
  }
}
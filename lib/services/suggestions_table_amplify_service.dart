import 'dart:io';
import 'package:amplify_api/amplify_api.dart';
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:amplify_storage_s3/amplify_storage_s3.dart';
import 'package:flutter/foundation.dart';
import '../models/SuggestionsTable.dart';

class SuggestionsTableAmplifyService {
  static Future<SuggestionsTable?> getSuggestionById(String suggestionId) async {
    try {
      final queryPredicate = SuggestionsTable.ID.eq(suggestionId);
      final request = ModelQueries.list<SuggestionsTable>(
        SuggestionsTable.classType,
        limit: 1,
        where: queryPredicate,
        authorizationMode: APIAuthorizationType.userPools,
      );
      final response = await Amplify.API.query(request: request).response;

      if (response.hasErrors) {
        safePrint("Error: ${response.errors}");
        return null;
      }
      return response.data?.items.firstOrNull;
    } catch (e) {
      if (kDebugMode) {
        print('Error: $e');
      }
      return null;
    }
  }

  static Future<List<SuggestionsTable>> getSuggestionsByUser(String userId) async {
    try {
      final queryPredicate = SuggestionsTable.USER.eq(userId);
      final request = ModelQueries.list<SuggestionsTable>(
        SuggestionsTable.classType,
        limit: 100,
        where: queryPredicate,
        authorizationMode: APIAuthorizationType.userPools,
      );
      final response = await Amplify.API.query(request: request).response;

      if (response.hasErrors) {
        safePrint("Error: ${response.errors}");
        return [];
      }
      return response.data?.items.whereType<SuggestionsTable>().toList() ?? [];
    } catch (e) {
      if (kDebugMode) {
        print('Error getting suggestions by user: $e');
      }
      return [];
    }
  }

  static Future<bool> createSuggestion(SuggestionsTable suggestion) async {
    try {
      final request = ModelMutations.create(
        suggestion,
        authorizationMode: APIAuthorizationType.userPools,
      );
      final response = await Amplify.API.mutate(request: request).response;

      if (response.hasErrors) {
        for (final error in response.errors) {
          safePrint("Error: ${error.message}");
        }
        return false;
      }

      safePrint("Suggestion created successfully: ${response.data?.id}");
      return true;
    } catch (e) {
      if (kDebugMode) {
        print('Error creating suggestion: $e');
      }
      return false;
    }
  }

  static Future<String?> uploadPhoto(String photoPath) async {
    try {
      if (kDebugMode) {
        print('Starting photo upload: $photoPath');
      }

      final file = File(photoPath);
      if (!await file.exists()) {
        if (kDebugMode) {
          print('Photo file does not exist: $photoPath');
        }
        return null;
      }

      final fileName = 'suggestions/${DateTime.now().millisecondsSinceEpoch}_${file.path.split('/').last}';

      if (kDebugMode) {
        print('Uploading with filename: $fileName');
      }

      final uploadTask = Amplify.Storage.uploadFile(
        localFile: AWSFile.fromPath(photoPath),
        path: StoragePath.fromString(fileName),
        onProgress: (progress) {
          if (kDebugMode) {
            print('Upload progress: ${progress.fractionCompleted * 100}%');
          }
        },
      );

      final result = await uploadTask.result;
      return result.uploadedItem.path;
    } catch (e) {
      if (kDebugMode) {
        print('Error uploading photo: $e');
      }
      return null;
    }
  }

  static Future<String?> getPhotoDownloadUrl(String photoPath) async {
    try {
      final result = await Amplify.Storage.getUrl(
        path: StoragePath.fromString(photoPath),
        options: const StorageGetUrlOptions(
          pluginOptions: S3GetUrlPluginOptions(
            expiresIn: Duration(hours: 24),
          ),
        ),
      );
      return result.url.toString();
    } catch (e) {
      if (kDebugMode) {
        print('Error getting photo download URL: $e');
      }
      return null;
    }
  }

  static Future<bool> saveSuggestion({
    required String type,
    required String concern,
    String? photo,
    required String userId,
    int? schoolUID,
  }) async {
    try {
      // Validate required fields
      if (!validateSuggestionData(type: type, concern: concern)) {
        return false;
      }

      String? photoS3Key;
      if (photo != null && photo.isNotEmpty) {
        photoS3Key = await uploadPhoto(photo);
      }

      final newSuggestion = SuggestionsTable(
        type: type,
        concern: concern.trim(),
        photo: photoS3Key,
        UserId: userId, // Store user ID directly
        schoolUID: schoolUID,
      );

      return await createSuggestion(newSuggestion);
    } catch (e) {
      if (kDebugMode) {
        print('Error saving suggestion: $e');
      }
      return false;
    }
  }

  static bool validateSuggestionData({
    required String type,
    required String concern,
  }) {
    if (type.trim().isEmpty || type == 'Default') {
      return false;
    }

    if (concern.trim().isEmpty || concern.trim().length < 10) {
      return false;
    }

    return true;
  }

  static Future<List<SuggestionsTable>> getSuggestionsBySchool(int schoolUID) async {
    try {
      final queryPredicate = SuggestionsTable.SCHOOLUID.eq(schoolUID);
      final request = ModelQueries.list<SuggestionsTable>(
        SuggestionsTable.classType,
        where: queryPredicate,
        authorizationMode: APIAuthorizationType.userPools,
      );
      final response = await Amplify.API.query(request: request).response;

      if (response.hasErrors) {
        safePrint("Error: ${response.errors}");
        return [];
      }
      return response.data?.items.whereType<SuggestionsTable>().toList() ?? [];
    } catch (e) {
      if (kDebugMode) {
        print('Error getting suggestions by school: $e');
      }
      return [];
    }
  }

  static Future<bool> deleteSuggestion(String suggestionId) async {
    try {
      final suggestion = await getSuggestionById(suggestionId);
      if (suggestion == null) return false;

      if (suggestion.photo != null && suggestion.photo!.isNotEmpty) {
        try {
          await Amplify.Storage.remove(
            path: StoragePath.fromString(suggestion.photo!),
          );
        } catch (e) {
          if (kDebugMode) {
            print('Error deleting photo from S3: $e');
          }
        }
      }

      final request = ModelMutations.delete(
        suggestion,
        authorizationMode: APIAuthorizationType.userPools,
      );
      final response = await Amplify.API.mutate(request: request).response;

      if (response.hasErrors) {
        for (final error in response.errors) {
          safePrint("Error: ${error.message}");
        }
        return false;
      }

      return true;
    } catch (e) {
      if (kDebugMode) {
        print('Error deleting suggestion: $e');
      }
      return false;
    }
  }
}

extension on StorageGetUrlOperation<StorageGetUrlRequest, StorageGetUrlResult> {
  get url => null;
}
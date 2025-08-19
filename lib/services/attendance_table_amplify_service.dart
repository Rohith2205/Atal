import 'dart:convert';
import 'package:amplify_api/amplify_api.dart';
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:flutter/foundation.dart';
import '../models/attendanceTable.dart';
import 'package:amplify_storage_s3/amplify_storage_s3.dart';

class AttendanceTableAmplifyService {
  static Future<attendanceTable?> getAttendanceById(String attendanceId) async {
    try {
      final queryPredicate = attendanceTable.ID.eq(attendanceId);
      final request = ModelQueries.list<attendanceTable>(
        attendanceTable.classType,
        limit: 1,
        where: queryPredicate,
        authorizationMode: APIAuthorizationType.userPools,
      );
      final response = await Amplify.API.query(request: request).response;

      if (response.hasErrors) {
        safePrint("Error getting attendance: ${response.errors}");
        return null;
      }
      return response.data?.items.firstOrNull;
    } catch (e) {
      if (kDebugMode) {
        print('Error getting attendance: $e');
      }
      return null;
    }
  }

  // Add this method to your service class
  static Future<String?> uploadImageToS3(String imagePath) async {
    try {
      final key = 'attendance-photos/${DateTime.now().millisecondsSinceEpoch}.jpg';

      final uploadTask = Amplify.Storage.uploadFile(
        localFile: AWSFile.fromPath(imagePath),
        path: StoragePath.fromString(key),
      );

      final result = await uploadTask.result;
      return result.uploadedItem.path; // this is the key you save in DynamoDB
    } catch (e) {
      if (kDebugMode) {
        print('Error uploading image: $e');
      }
      return null;
    }
  }


  /// Check if attendance already exists for a specific date
  static Future<bool> checkAttendanceForDate(DateTime date) async {
    try {
      final temporalDate = TemporalDate(date);
      final queryPredicate = attendanceTable.DATE.eq(temporalDate);

      final request = ModelQueries.list<attendanceTable>(
        attendanceTable.classType,
        limit: 1,
        where: queryPredicate,
        authorizationMode: APIAuthorizationType.userPools,
      );

      final response = await Amplify.API.query(request: request).response;

      if (response.hasErrors) {
        safePrint("Error checking attendance for date: ${response.errors}");
        return false;
      }

      // If we have any items, attendance exists for this date
      return response.data?.items.isNotEmpty ?? false;
    } catch (e) {
      if (kDebugMode) {
        print('Error checking attendance for date: $e');
      }
      return false;
    }
  }

  /// Create new attendance record
  static Future<bool> createAttendance(attendanceTable attendance) async {
    try {
      final request = ModelMutations.create(
        attendance,
        authorizationMode: APIAuthorizationType.userPools,
      );
      final response = await Amplify.API.mutate(request: request).response;

      if (response.hasErrors) {
        for (final error in response.errors) {
          safePrint("GraphQL Error: ${error.message}");
        }
        return false; // Return false on GraphQL errors
      }

      return true; // Successfully created attendance
    } catch (e) {
      if (kDebugMode) {
        print('Error creating attendance: $e');
      }
      return false; // Return false on exception
    }
  }

  static Future<bool> saveAttendance({
    required DateTime date,
    required double latitude,
    required double longitude,
    required int no_of_boys,
    required int no_of_girls,
    required int total,
    required String teachers, // Should be number of teachers as string
    required String start_time, // use HH:mm format
    required String end_time,
    required List<String> class_attended, // This should remain as List<String>
    required String module_name,
    required int module_no,
    required String remarks,
    required String topics_covered,
    String? photo, // Added photo parameter
  }) async {
    try {
      // Convert List<String> to List<int> for proper JSON handling
      List<int> classesAsIntegers = class_attended.map((e) => int.parse(e)).toList();
      // Convert to JSON string for storage
      String classesJsonString = jsonEncode(classesAsIntegers);

      // Debug print to see what classes are being sent
      if (kDebugMode) {
        print('=== ATTENDANCE SAVE DEBUG ===');
        print('Date: $date');
        print('Classes selected: $class_attended');
        print('Classes as integers: $classesAsIntegers');
        print('Classes as JSON string: $classesJsonString');
        print('Start time: $start_time');
        print('End time: $end_time');
        print('Teachers: $teachers');
        print('Module name: $module_name');
        print('Module no: $module_no');
        print('Boys: $no_of_boys, Girls: $no_of_girls, Total: $total');
        print('Photo: ${photo != null ? 'Present' : 'Not provided'}');
        print('=============================');
      }

      // First check if attendance already exists for this date
      bool attendanceExists = await checkAttendanceForDate(date);
      if (attendanceExists) {
        if (kDebugMode) {
          print('Attendance already exists for date: $date');
        }
        return false; // Don't allow duplicate attendance for the same date
      }

      // Validate required fields
      if (class_attended.isEmpty) {
        if (kDebugMode) {
          print('ERROR: No classes selected');
        }
        return false;
      }

      // Convert time strings to proper format if needed
      String formatTimeString(String timeStr) {
        if (timeStr.trim().isEmpty) {
          throw Exception('Time string is empty');
        }

        // If time is in "h:mm AM/PM" format, convert to 24-hour "HH:mm" format
        if (timeStr.contains('AM') || timeStr.contains('PM')) {
          // Parse and reformat
          final parts = timeStr.split(' ');
          if (parts.length != 2) {
            throw Exception('Invalid time format: $timeStr');
          }

          final timePart = parts[0];
          final period = parts[1];

          final timeParts = timePart.split(':');
          if (timeParts.length != 2) {
            throw Exception('Invalid time format: $timeStr');
          }

          int hour = int.parse(timeParts[0]);
          final minute = timeParts[1];

          if (period == 'PM' && hour != 12) {
            hour += 12;
          } else if (period == 'AM' && hour == 12) {
            hour = 0;
          }

          return '${hour.toString().padLeft(2, '0')}:$minute';
        }
        return timeStr; // Already in correct format
      }

      // Format times with error handling
      String formattedStartTime;
      String formattedEndTime;

      try {
        formattedStartTime = formatTimeString(start_time);
        formattedEndTime = formatTimeString(end_time);
      } catch (e) {
        if (kDebugMode) {
          print('ERROR formatting time: $e');
        }
        return false;
      }

      final newRecord = attendanceTable(
        date: TemporalDate(date),
        latitude: latitude,
        longitude: longitude,
        no_of_boys: no_of_boys,
        no_of_girls: no_of_girls,
        total: total,
        teachers: int.parse(teachers),
        start_time: TemporalTime.fromString(formattedStartTime),
        end_time: TemporalTime.fromString(formattedEndTime),
        class_attended: classesJsonString, // Send as JSON string for proper handling
        module_name: module_name,
        module_no: module_no,
        remarks: remarks,
        topics_covered: topics_covered,
        photo: photo, // Include photo in the record
        timestamp: TemporalTimestamp.now(),
      );

      if (kDebugMode) {
        print('Created attendance record with class_attended JSON: ${newRecord.class_attended}');
      }

      // Use the existing createAttendance method
      final result = await createAttendance(newRecord);

      if (kDebugMode) {
        print('Save result: $result');
      }

      return result;

    } catch (e) {
      if (kDebugMode) {
        print('Error in saving attendance: $e');
        print('Stack trace: ${StackTrace.current}');
      }
      return false;
    }
  }

  /// Get all attendance records for a specific date range
  static Future<List<attendanceTable?>> getAttendanceByDateRange(
      DateTime startDate,
      DateTime endDate,
      ) async {
    try {
      final startTemporalDate = TemporalDate(startDate);
      final endTemporalDate = TemporalDate(endDate);

      final queryPredicate = attendanceTable.DATE
          .between(startTemporalDate, endTemporalDate);

      final request = ModelQueries.list<attendanceTable>(
        attendanceTable.classType,
        where: queryPredicate,
        authorizationMode: APIAuthorizationType.userPools,
      );

      final response = await Amplify.API.query(request: request).response;

      if (response.hasErrors) {
        safePrint("Error getting attendance by date range: ${response.errors}");
        return [];
      }

      return response.data?.items ?? [];
    } catch (e) {
      if (kDebugMode) {
        print('Error getting attendance by date range: $e');
      }
      return [];
    }
  }

  /// Get attendance records for today
  static Future<List<attendanceTable?>> getTodayAttendance() async {
    final today = DateTime.now();
    final startOfDay = DateTime(today.year, today.month, today.day);
    final endOfDay = DateTime(today.year, today.month, today.day, 23, 59, 59);

    return await getAttendanceByDateRange(startOfDay, endOfDay);
  }

  /// Helper method to parse class_attended when retrieving data
  /// Since we're now storing as JSON string, this helps convert back to List<String> if needed
  static List<String> parseClassesAttended(String? classAttended) {
    if (classAttended == null || classAttended.isEmpty) return [];

    try {
      // Try to parse as JSON array first (new format)
      final decoded = jsonDecode(classAttended);
      if (decoded is List) {
        return decoded.map((e) => e.toString()).toList();
      }
    } catch (e) {
      // If JSON parsing fails, try comma-separated string (old format)
      if (classAttended.contains(',')) {
        return classAttended.split(',').where((s) => s.trim().isNotEmpty).toList();
      }
      // Single value
      return [classAttended.trim()];
    }

    return [];
  }
}

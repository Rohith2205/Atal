import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:amplify_api/amplify_api.dart';
import 'package:atl_membership/models/ModelProvider.dart';
import 'package:atl_membership/services/SchoolsDetailsFirestoreService.dart';
import 'package:atl_membership/services/TeamTableService.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import '../controllers/AuthController.dart';

class SchoolScreen extends StatefulWidget {
  const SchoolScreen({super.key});

  @override
  State<SchoolScreen> createState() => _SchoolScreenPageState();
}

class _SchoolScreenPageState extends State<SchoolScreen> {
  String? selectedDistrict;
  String? selectedMandal;
  String? selectedSchool;
  bool isInitialLoading = true;
  bool isSubmitting = false;
  bool hasAlreadyJoined = false;
  bool isCheckingJoinStatus = true;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  List<String> districts = [];
  List<String> mandals = [];
  List<String> schools = [];

  bool isLoadingMandals = false;
  bool isLoadingSchools = false;

  final AuthController authController = Get.put(AuthController());

  // Helper method to remove duplicates while preserving order
  List<String> _removeDuplicates(List<String> list) {
    return list.toSet().toList();
  }

  // Helper method to validate dropdown value
  bool _isValidDropdownValue(String? value, List<String> items) {
    if (value == null || items.isEmpty) return true;
    return items.contains(value);
  }

  Future<void> _checkIfUserAlreadyJoined() async {
    try {
      setState(() {
        isCheckingJoinStatus = true;
      });

      String? userId = await _getCurrentUserId();
      if (userId == null) {
        setState(() {
          isCheckingJoinStatus = false;
        });
        return;
      }

      // Check if user already has a team with school information
      final existingTeams = await TeamTableService.getUserTeams(userId);

      if (existingTeams.isNotEmpty) {
        final team = existingTeams.first;

        // Check if team has school information
        if (team.school_name != null &&
            team.district != null &&
            team.mandal != null) {

          setState(() {
            hasAlreadyJoined = true;
            selectedSchool = team.school_name;
            selectedDistrict = team.district;
            selectedMandal = team.mandal;

            // Populate the lists with the selected values
            districts = [team.district!];
            mandals = [team.mandal!];
            schools = [team.school_name!];
          });
        }
      }

      setState(() {
        isCheckingJoinStatus = false;
      });
    } catch (e) {
      if (kDebugMode) {
        print('Error checking join status: $e');
      }
      setState(() {
        isCheckingJoinStatus = false;
      });
    }
  }

  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate() &&
        selectedDistrict != null &&
        selectedMandal != null &&
        selectedSchool != null) {

      setState(() {
        isSubmitting = true;
      });

      try {
        // Get current user ID from AuthController or Amplify Auth
        String? userId = await _getCurrentUserId();

        if (userId == null) {
          _showErrorSnackbar('User not authenticated');
          return;
        }

        // Update Firestore (your existing logic)
        final schoolDocRef = FirebaseFirestore.instance
            .collection('districts')
            .doc(selectedDistrict)
            .collection('mandals')
            .doc(selectedMandal)
            .collection('schools')
            .doc(selectedSchool);

        await schoolDocRef.update({'isSelected': true}); // Changed to true when joining

        // Store school selection in AWS Amplify
        await _storeSchoolSelectionInAmplify(userId);

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('School selection saved successfully!'),
            backgroundColor: Colors.green,
          ),
        );

        // Update the join status
        setState(() {
          hasAlreadyJoined = true;
        });

        // Optional: Navigate back or to next screen
        // Navigator.pop(context);

      } catch (e) {
        if (kDebugMode) {
          print('Error in _submitForm: $e');
        }
        _showErrorSnackbar('Failed to save school selection: $e');
      } finally {
        setState(() {
          isSubmitting = false;
        });
      }
    }
  }

  Future<String?> _getCurrentUserId() async {
    try {
      // Method 1: If you have user ID in AuthController
      // return authController.userId;

      // Method 2: Get from Amplify Auth
      final user = await Amplify.Auth.getCurrentUser();
      return user.userId;
    } catch (e) {
      if (kDebugMode) {
        print('Error getting current user: $e');
      }
      return null;
    }
  }

  Future<void> _storeSchoolSelectionInAmplify(String userId) async {
    try {
      // Option 1: Create or update a team with school information
      await _createOrUpdateTeamWithSchoolInfo(userId);

      // Option 2: Create a separate UserProfile model (if you have one)
      // await _updateUserProfileWithSchoolInfo(userId);

    } catch (e) {
      if (kDebugMode) {
        print('Error storing school selection in Amplify: $e');
      }
      throw e;
    }
  }

  Future<void> _createOrUpdateTeamWithSchoolInfo(String userId) async {
    try {
      // First, check if user already has a team
      final existingTeams = await TeamTableService.getUserTeams(userId);

      if (existingTeams.isNotEmpty) {
        // Update existing team with school information
        final existingTeam = existingTeams.first;
        final updatedTeam = existingTeam.copyWith(
          school_name: selectedSchool,
          district: selectedDistrict,
          mandal: selectedMandal,
        );

        final updateRequest = ModelMutations.update(
          updatedTeam,
          authorizationMode: APIAuthorizationType.userPools,
        );

        final response = await Amplify.API.mutate(request: updateRequest).response;

        if (response.hasErrors) {
          throw Exception('Failed to update team: ${response.errors}');
        }

        safePrint("Team updated with school info: ${response.data}");
      } else {
        // Create new team with school information
        final teamCode = await TeamTableService.createTeam(userId);

        if (teamCode != null) {
          // Get the created team and update it with school info
          final createdTeam = await TeamTableService.getTeamByCode(teamCode);

          if (createdTeam != null) {
            final updatedTeam = createdTeam.copyWith(
              school_name: selectedSchool,
              district: selectedDistrict,
              mandal: selectedMandal,
            );

            final updateRequest = ModelMutations.update(
              updatedTeam,
              authorizationMode: APIAuthorizationType.userPools,
            );

            final response = await Amplify.API.mutate(request: updateRequest).response;

            if (response.hasErrors) {
              throw Exception('Failed to update team with school info: ${response.errors}');
            }

            safePrint("New team created and updated with school info: ${response.data}");
          }
        } else {
          throw Exception('Failed to create team');
        }
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error in _createOrUpdateTeamWithSchoolInfo: $e');
      }
      throw e;
    }
  }

  // Alternative method if you have a separate UserProfile model
  Future<void> _updateUserProfileWithSchoolInfo(String userId) async {
    try {
      // This is an example - adjust based on your actual UserProfile model
      /*
      final userProfile = UserProfile(
        userId: userId,
        schoolName: selectedSchool,
        district: selectedDistrict,
        mandal: selectedMandal,
      );

      final request = ModelMutations.create(
        userProfile,
        authorizationMode: APIAuthorizationType.userPools,
      );

      final response = await Amplify.API.mutate(request: request).response;

      if (response.hasErrors) {
        throw Exception('Failed to create user profile: ${response.errors}');
      }

      safePrint("User profile created: ${response.data}");
      */
    } catch (e) {
      if (kDebugMode) {
        print('Error updating user profile: $e');
      }
      throw e;
    }
  }

  @override
  void initState() {
    super.initState();
    _checkIfUserAlreadyJoined().then((_) {
      if (!hasAlreadyJoined) {
        _loadInitialData();
      }
    });
  }

  Future<void> _loadInitialData() async {
    try {
      final fetchedDistricts = await SchoolsDetailsFirestoreService.FetchDistricts();
      safePrint("data loaded : $fetchedDistricts");

      setState(() {
        districts = _removeDuplicates(fetchedDistricts);
        isInitialLoading = false;
      });
    } catch (e) {
      if (kDebugMode) {
        print('Error loading districts: $e');
      }
      setState(() {
        districts = ['Fetching Error'];
        isInitialLoading = false;
      });

      _showErrorSnackbar('Failed to load districts. Using default options.');
    }
  }

  Future<void> _loadMandals(String districtId) async {
    if (hasAlreadyJoined) return; // Don't load if already joined

    setState(() {
      isLoadingMandals = true;
      selectedMandal = null;
      selectedSchool = null;
      mandals.clear();
      schools.clear();
    });

    try {
      final fetchedMandals = await SchoolsDetailsFirestoreService.fetchMandalsByDistrict(districtId);

      setState(() {
        mandals = _removeDuplicates(fetchedMandals);
        isLoadingMandals = false;
      });
    } catch (e) {
      if (kDebugMode) {
        print('Error loading mandals: $e');
      }
      setState(() {
        mandals = ['Fetching Error'];
        isLoadingMandals = false;
      });

      _showErrorSnackbar('Failed to load mandals. Using default options.');
    }
  }

  Future<void> _loadSchools(String districtId, String mandalId) async {
    if (hasAlreadyJoined) return; // Don't load if already joined

    setState(() {
      isLoadingSchools = true;
      selectedSchool = null;
      schools.clear();
    });

    try {
      final fetchedSchools = await SchoolsDetailsFirestoreService.fetchSchoolsByMandal(districtId, mandalId);

      setState(() {
        schools = _removeDuplicates(fetchedSchools);
        isLoadingSchools = false;

        // Reset selected school if it's no longer in the updated list
        if (selectedSchool != null && !schools.contains(selectedSchool)) {
          selectedSchool = null;
        }
      });
    } catch (e) {
      if (kDebugMode) {
        print('Error loading schools: $e');
      }
      setState(() {
        schools = ['Fetching Error'];
        isLoadingSchools = false;
      });

      _showErrorSnackbar('Failed to load schools. Using default options.');
    }
  }

  void _showErrorSnackbar(String message) {
    Get.snackbar(
      'Error',
      message,
      snackPosition: SnackPosition.TOP,
      backgroundColor: Colors.red.withOpacity(0.7),
      colorText: Colors.white,
      duration: const Duration(seconds: 3),
    );
  }

  Widget _buildLoadingWidget() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(color: Colors.blue),
          SizedBox(height: 20),
          Text('Checking your school status...', style: TextStyle(fontSize: 16)),
        ],
      ),
    );
  }

  Widget _buildAlreadyJoinedWidget() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.check_circle,
            color: Colors.green,
            size: 80,
          ),
          SizedBox(height: 20),
          Text(
            'School Already Selected!',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.green,
            ),
          ),
          SizedBox(height: 20),
          Container(
            padding: EdgeInsets.all(20),
            margin: EdgeInsets.symmetric(horizontal: 20),
            decoration: BoxDecoration(
              color: Colors.green.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.green.withOpacity(0.3)),
            ),
            child: Column(
              children: [
                Text(
                  'Your School Details:',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 15),
                _buildInfoRow('District:', selectedDistrict ?? 'N/A'),
                _buildInfoRow('Mandal:', selectedMandal ?? 'N/A'),
                _buildInfoRow('School:', selectedSchool ?? 'N/A'),
              ],
            ),
          ),
          SizedBox(height: 30),
          Text(
            'You have already joined this school.\nContact your team leader for any changes.',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 80,
            child: Text(
              label,
              style: TextStyle(
                fontWeight: FontWeight.w600,
                color: Colors.grey[700],
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('School Mapping', style: TextStyle(color: Colors.white, fontSize: 24)),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        backgroundColor: Colors.blue,
      ),
      body: SafeArea(
        child: isCheckingJoinStatus
            ? _buildLoadingWidget()
            : hasAlreadyJoined
            ? _buildAlreadyJoinedWidget()
            : SingleChildScrollView(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  Image.asset('assets/images/school.png', height: 300, width: 300),
                  Text('Choose your ATL School:', style: TextStyle(fontSize: 19)),
                  SizedBox(height: 16),
                  Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        // District Dropdown
                        SizedBox(
                          child: DropdownButtonFormField<String>(
                            value: _isValidDropdownValue(selectedDistrict, districts) ? selectedDistrict : null,
                            items: districts.map((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(value, overflow: TextOverflow.ellipsis, maxLines: 1),
                              );
                            }).toList(),
                            decoration: InputDecoration(
                              labelText: 'Choose District',
                              border: OutlineInputBorder(),
                            ),
                            onChanged: (newValue) {
                              setState(() {
                                selectedDistrict = newValue;
                                selectedMandal = null;
                                selectedSchool = null;
                                mandals.clear();
                                schools.clear();
                              });
                              if (newValue != null) {
                                _loadMandals(newValue);
                              }
                            },
                            validator: (value) {
                              if (value == null) {
                                return 'Please select a District';
                              }
                              return null;
                            },
                          ),
                        ),
                        SizedBox(height: 20),

                        // Mandal Dropdown
                        SizedBox(
                          child: DropdownButtonFormField<String>(
                            value: _isValidDropdownValue(selectedMandal, mandals) ? selectedMandal : null,
                            items: mandals.map((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(value, overflow: TextOverflow.ellipsis, maxLines: 1),
                              );
                            }).toList(),
                            decoration: InputDecoration(
                              labelText: 'Choose Mandal',
                              border: OutlineInputBorder(),
                            ),
                            onChanged: (newValue) {
                              setState(() {
                                selectedMandal = newValue;
                                selectedSchool = null;
                                schools.clear();
                              });
                              if (newValue != null && selectedDistrict != null) {
                                _loadSchools(selectedDistrict!, newValue);
                              }
                            },
                            validator: (value) {
                              if (value == null) {
                                return 'Please select a Mandal';
                              }
                              return null;
                            },
                          ),
                        ),
                        SizedBox(height: 20),

                        // School Dropdown
                        SizedBox(
                          width: double.infinity,
                          child: DropdownButtonFormField<String>(
                            isExpanded: true,
                            value: _isValidDropdownValue(selectedSchool, schools) ? selectedSchool : null,
                            items: schools.map((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(value, overflow: TextOverflow.ellipsis, maxLines: 1),
                              );
                            }).toList(),
                            decoration: InputDecoration(
                              labelText: 'ATL School Mapping',
                              border: OutlineInputBorder(),
                            ),
                            onChanged: (newValue) {
                              setState(() {
                                selectedSchool = newValue;
                              });
                            },
                            validator: (value) {
                              if (value == null) {
                                return 'Please select a school';
                              }
                              return null;
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 40),
                  Center(
                    child: ElevatedButton(
                      onPressed: isSubmitting ? null : _submitForm,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: isSubmitting
                          ? SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 2,
                        ),
                      )
                          : Text(
                        'Join',
                        style: TextStyle(color: Colors.white, fontSize: 20),
                      ),
                    ),
                  ),
                  SizedBox(height: 30),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
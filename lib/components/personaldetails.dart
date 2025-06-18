import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:atl_membership/models/ModelProvider.dart';
import 'package:atl_membership/utils/PersonalDetailsFirestoreService.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:atl_membership/utils/routes.dart';

import '../controllers/AuthController.dart';

class PersonalDetailsDialog extends StatefulWidget {
  const PersonalDetailsDialog({super.key});

  @override
  State<PersonalDetailsDialog> createState() => _PersonalDetailsDialogState();
}

class _PersonalDetailsDialogState extends State<PersonalDetailsDialog> {
  String? selectedUniversity;
  String? selectedDistrict;
  String? selectedMandal;
  String? selectedCollege;
  final TextEditingController rollNoController = TextEditingController();
  bool isSubmitting = false;
  bool isInitialLoading = true;

  // Data lists
  List<String> universities = [];
  List<String> districts = [];
  List<String> mandals = [];
  List<String> colleges = [];

  // Loading states for each dropdown
  bool isLoadingDistricts = false;
  bool isLoadingMandals = false;
  bool isLoadingColleges = false;

  // Get the AuthController instance
  final AuthController authController = Get.put(AuthController());

  @override
  void initState() {
    super.initState();
    _loadInitialData();
  }

  Future<void> _loadInitialData() async {
    try {
      // Load universities from Firestore
      final fetchedUniversities = await PersonalDetailsFirestoreService.FetchAffiliatedUniversities();
      safePrint("data loaded : $fetchedUniversities");

      setState(() {
        universities = fetchedUniversities;
        isInitialLoading = false;
      });
    } catch (e) {
      if (kDebugMode) {
        print('Error loading universities: $e');
      }
      setState(() {
        // Fallback to default universities if loading fails
        universities = ['Fetching Error'];
        isInitialLoading = false;
      });

      _showErrorSnackbar('Failed to load universities. Using default options.');
    }
  }

  Future<void> _loadDistricts(String universityId) async {
    setState(() {
      isLoadingDistricts = true;
      // Clear dependent dropdowns
      selectedDistrict = null;
      selectedMandal = null;
      selectedCollege = null;
      districts.clear();
      mandals.clear();
      colleges.clear();
    });

    try {
      // Replace with your actual Firestore service method
      final fetchedDistricts = await PersonalDetailsFirestoreService.fetchDistrictsByUniversity(universityId);

      setState(() {
        districts = fetchedDistricts;
        isLoadingDistricts = false;
      });
    } catch (e) {
      if (kDebugMode) {
        print('Error loading districts: $e');
      }
      setState(() {
        districts = ['Fetching Error']; // Fallback
        isLoadingDistricts = false;
      });

      _showErrorSnackbar('Failed to load districts. Using default options.');
    }
  }

  Future<void> _loadMandals(String universityId,String districtId) async {
    setState(() {
      isLoadingMandals = true;
      // Clear dependent dropdowns
      selectedMandal = null;
      selectedCollege = null;
      mandals.clear();
      colleges.clear();
    });

    try {
      // Replace with your actual Firestore service method
      final fetchedMandals = await PersonalDetailsFirestoreService.fetchMandalsByDistrict(universityId,districtId);

      setState(() {
        mandals = fetchedMandals;
        isLoadingMandals = false;
      });
    } catch (e) {
      if (kDebugMode) {
        print('Error loading mandals: $e');
      }
      setState(() {
        mandals = ['Fetching Error']; // Fallback
        isLoadingMandals = false;
      });

      _showErrorSnackbar('Failed to load mandals. Using default options.');
    }
  }

  Future<void> _loadColleges(String universityId,String districtId,String mandalId) async {
    setState(() {
      isLoadingColleges = true;
      selectedCollege = null;
      colleges.clear();
    });

    try {
      // Replace with your actual Firestore service method
      final fetchedColleges = await PersonalDetailsFirestoreService.fetchCollegesByMandal(universityId,districtId,mandalId);

      setState(() {
        colleges = fetchedColleges;
        isLoadingColleges = false;
      });
    } catch (e) {
      if (kDebugMode) {
        print('Error loading colleges: $e');
      }
      setState(() {
        colleges = ['Fetching Error']; // Fallback
        isLoadingColleges = false;
      });

      _showErrorSnackbar('Failed to load colleges. Using default options.');
    }
  }

  void _showErrorSnackbar(String message) {
    Get.snackbar(
      'Loading Error',
      message,
      snackPosition: SnackPosition.TOP,
      backgroundColor: Colors.orange.withOpacity(0.7),
      colorText: Colors.white,
      duration: const Duration(seconds: 3),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      title: const Text('Complete Your Profile', textAlign: TextAlign.center),
      content: isInitialLoading
          ? const SizedBox(
        height: 200,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircularProgressIndicator(),
              SizedBox(height: 16),
              Text('Loading form data...'),
            ],
          ),
        ),
      )
          : SingleChildScrollView(
        child: Column(
          children: [
            const Text(
              'Please provide your personal details to continue',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 14, color: Colors.grey),
            ),
            const SizedBox(height: 20),

            // University Dropdown
            _buildDropdown(
              'University',
              selectedUniversity,
              universities,
                  (value) {
                setState(() => selectedUniversity = value);
                if (value != null) {
                  _loadDistricts(value);
                }
              },
            ),

            const SizedBox(height: 10),

            // District Dropdown
            _buildDropdownWithLoading(
              'District',
              selectedDistrict,
              districts,
              isLoadingDistricts,
              selectedUniversity == null ? 'Select University first' : null,
                  (value) {
                setState(() => selectedDistrict = value);
                if (value != null) {
                  _loadMandals(selectedUniversity!,value);
                }
              },
            ),

            const SizedBox(height: 10),

            // Mandal Dropdown
            _buildDropdownWithLoading(
              'Mandal',
              selectedMandal,
              mandals,
              isLoadingMandals,
              selectedDistrict == null ? 'Select District first' : null,
                  (value) {
                setState(() => selectedMandal = value);
                if (value != null) {
                  _loadColleges(selectedUniversity!,selectedDistrict!,value);
                }
              },
            ),

            const SizedBox(height: 10),

            // College Dropdown
            _buildDropdownWithLoading(
              'College',
              selectedCollege,
              colleges,
              isLoadingColleges,
              selectedMandal == null ? 'Select Mandal first' : null,
                  (value) {
                setState(() => selectedCollege = value);
              },
            ),

            const SizedBox(height: 10),

            // Roll Number Field
            TextField(
              controller: rollNoController,
              decoration: const InputDecoration(
                labelText: 'Roll Number',
                border: UnderlineInputBorder(),
              ),
            ),
          ],
        ),
      ),
      actionsAlignment: MainAxisAlignment.end,
      actions: [
        TextButton(
          onPressed: (isSubmitting || isInitialLoading || _isAnyDropdownLoading()) ? null : _submitForm,
          child: isSubmitting
              ? const SizedBox(
            width: 20,
            height: 20,
            child: CircularProgressIndicator(strokeWidth: 2),
          )
              : const Text('Submit', style: TextStyle(color: Colors.deepPurple)),
        ),
      ],
    );
  }

  bool _isAnyDropdownLoading() {
    return isLoadingDistricts || isLoadingMandals || isLoadingColleges;
  }

  Widget _buildDropdown(String label, String? selectedValue, List<String> items, Function(String?) onChanged) {
    return DropdownButtonFormField<String>(
      value: selectedValue,
      isExpanded: true,
      decoration: InputDecoration(
        labelText: label,
        border: const UnderlineInputBorder(),
      ),
      items: items.map((item) => DropdownMenuItem(value: item, child: Text(item))).toList(),
      onChanged: onChanged,
      validator: (value) => value == null ? 'Please select $label' : null,
    );
  }

  Widget _buildDropdownWithLoading(
      String label,
      String? selectedValue,
      List<String> items,
      bool isLoading,
      String? disabledHint,
      Function(String?) onChanged
      ) {
    return DropdownButtonFormField<String>(
      value: selectedValue,
      isExpanded: true,
      decoration: InputDecoration(
        labelText: label,
        border: const UnderlineInputBorder(),
        suffixIcon: isLoading
            ? const SizedBox(
          width: 20,
          height: 20,
          child: Padding(
            padding: EdgeInsets.all(12.0),
            child: CircularProgressIndicator(strokeWidth: 2),
          ),
        )
            : null,
      ),
      hint: isLoading
          ? Text('Loading $label...', style: const TextStyle(color: Colors.grey))
          : disabledHint != null
          ? Text(disabledHint, style: const TextStyle(color: Colors.grey))
          : null,
      items: items.isEmpty
          ? null
          : items.map((item) => DropdownMenuItem(value: item, child: Text(item))).toList(),
      onChanged: (items.isEmpty || isLoading) ? null : onChanged,
      validator: (value) => value == null ? 'Please select $label' : null,
    );
  }


  Future<void> _submitForm() async {
    // Validate form
    if (selectedUniversity == null ||
        selectedDistrict == null ||
        selectedMandal == null ||
        selectedCollege == null ||
        rollNoController.text.trim().isEmpty) {
      Get.snackbar(
        'Incomplete Form',
        'Please fill in all fields',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.withOpacity(0.7),
        colorText: Colors.white,
      );
      return;
    }

    setState(() {
      isSubmitting = true;
    });

    try {
      await authController.saveUserDetails(
        university: selectedUniversity!,
        district: selectedDistrict!,
        mandal: selectedMandal!,
        college: selectedCollege!,
        rollNumber: rollNoController.text.trim(),
        gender: UserTableGender.MALE,
      );

      // Close dialog and navigate to home
      if (context.mounted) {
        Navigator.of(context).pop();
      }
      Get.offAllNamed(Routes.HOME);
    } catch (e) {
      if (kDebugMode) {
        print('Error submitting form: $e');
      }
      Get.snackbar(
        'Error',
        'Failed to save details. Please try again.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.withOpacity(0.7),
        colorText: Colors.white,
      );
    } finally {
      if (mounted) {
        setState(() {
          isSubmitting = false;
        });
      }
    }
  }

  @override
  void dispose() {
    rollNoController.dispose();
    super.dispose();
  }
}
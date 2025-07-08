import 'dart:io';
import 'package:amplify_authenticator/amplify_authenticator.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:image_picker/image_picker.dart';
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:amplify_api/amplify_api.dart';

import '../controllers/AuthController.dart';
import '../models/UserTable.dart';
import '../models/UserTableGender.dart';
// You'll need to import your generated models
// import 'models/ModelProvider.dart';

class Profilescreen extends StatefulWidget {
  final String? userId; // Pass user ID when navigating to this screen

  const Profilescreen({super.key, this.userId});

  @override
  State<Profilescreen> createState() => _ProfileState();
}

class _ProfileState extends State<Profilescreen> {
  bool _isEditing = false;
  bool _isLoading = true;
  String? _currentUserId;
  final AuthController authController = Get.find<AuthController>();


  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController collegeController = TextEditingController();
  final TextEditingController universityController = TextEditingController();
  final TextEditingController rollNoController = TextEditingController();
  final TextEditingController branchController = TextEditingController();
  final TextEditingController districtController = TextEditingController();
  final TextEditingController mandalController = TextEditingController();

  String _selectedGender = 'MALE';
  String _selectedBranch = 'CSE';
  bool _isPolicy = false;

  final ImagePicker _picker = ImagePicker();

  // Branch options matching your schema
  final List<String> _branchOptions = [
    'CSE',
    'CSIT',
    'CSE (Allied Specializations)',
    'ECE',
    'ECE (Allied Specializations)',
    'EEE',
    'MECH ENGG',
    'MECH ENGG (Allied Specializations)',
    'Other'
  ];

  @override
  void initState() {
    super.initState();
    _currentUserId = widget.userId;
    _fetchUserProfile();
  }

  Future<void> _fetchUserProfile() async {
    if (_currentUserId == null) {
      // If no user ID provided, try to get current authenticated user
      try {
        final user = await Amplify.Auth.getCurrentUser();
        _currentUserId = user.userId;
      } catch (e) {
        if (kDebugMode) {
          print('Error getting current user: $e');
        }
        setState(() {
          _isLoading = false;
        });
        return;
      }
    }

    try {
      final request = ModelQueries.get(
        UserTable.classType,
        UserTableModelIdentifier(id: _currentUserId!),
      );

      final response = await Amplify.API.query(request: request).response;

      if (response.data != null) {
        final userData = response.data!;
        _populateFields(userData);
      } else {
        if (kDebugMode) {
          print('No user data found');
        }
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error fetching user profile: $e');
      }
      _showErrorSnackBar('Failed to load profile data');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _populateFields(dynamic userData) {
    setState(() {
      nameController.text = userData.name ?? '';
      emailController.text = userData.email ?? '';
      phoneController.text = userData.phone ?? '';
      collegeController.text = userData.college ?? '';
      universityController.text = userData.university ?? '';
      rollNoController.text = userData.reg_no ?? '';
      branchController.text = userData.branch ?? '';
      districtController.text = userData.district ?? '';
      mandalController.text = userData.mandal ?? '';

      // Handle enum values
      if (userData.gender != null) {
        _selectedGender = userData.gender.toString().split('.').last;
      }

      if (userData.branch != null && _branchOptions.contains(userData.branch)) {
        _selectedBranch = userData.branch;
      }

      _isPolicy = userData.isPolicy ?? false;
    });
  }

  Future<void> _saveProfile() async {
    if (_currentUserId == null) return;

    setState(() {
      _isLoading = true;
    });

    try {
      // Create or update user profile
      final updatedUser = UserTable(
        id: _currentUserId!,
        name: nameController.text.trim(),
        email: emailController.text.trim(),
        phone: phoneController.text.trim(),
        college: collegeController.text.trim(),
        university: universityController.text.trim(),
        reg_no: rollNoController.text.trim(),
        branch: _selectedBranch,
        district: districtController.text.trim(),
        mandal: mandalController.text.trim(),
        gender: _parseGender(_selectedGender),
        isPolicy: _isPolicy,
      );

      final request = ModelMutations.update(updatedUser);
      final response = await Amplify.API.mutate(request: request).response;

      if (response.data != null) {
        setState(() {
          _isEditing = false;
        });
        _showSuccessSnackBar('Profile updated successfully!');
      } else {
        _showErrorSnackBar('Failed to update profile');
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error saving profile: $e');
      }
      _showErrorSnackBar('Failed to save profile');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  // Helper method to parse gender enum
  dynamic _parseGender(String gender) {
    switch (gender.toUpperCase()) {
      case 'MALE':
        return UserTableGender.MALE;
      case 'FEMALE':
        return UserTableGender.FEMALE;
      case 'OTHER':
        return UserTableGender.OTHER;
      default:
        return UserTableGender.MALE;
    }
  }



  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
      ),
    );
  }

  void _showSuccessSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.green,
      ),
    );
  }

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    phoneController.dispose();
    collegeController.dispose();
    universityController.dispose();
    rollNoController.dispose();
    branchController.dispose();
    districtController.dispose();
    mandalController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Profile', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.blue,
        iconTheme: const IconThemeData(color: Colors.white),
        actions: [
          if (!_isEditing)
            IconButton(
              icon: const Icon(Icons.edit),
              onPressed: () {
                setState(() {
                  _isEditing = true;
                });
              },
            ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const SizedBox(height: 16),
            _buildProfileImage(),
            const SizedBox(height: 20),
            _buildTextField("Full Name", nameController),
            _buildTextField("Email", emailController, keyboardType: TextInputType.emailAddress),
            _buildGenderDropdown(),
            _buildTextField("Phone", phoneController, keyboardType: TextInputType.phone),
            _buildTextField("Registration No", rollNoController),
            _buildTextField("College", collegeController),
            _buildTextField("University", universityController),
            _buildBranchDropdown(),
            _buildTextField("District", districtController),
            _buildTextField("Mandal", mandalController),

            const SizedBox(height: 20),
            _buildActionButtons(),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileImage() {
    return GestureDetector(
      child: Stack(
        children: [
          Obx(() => CircleAvatar(
            backgroundColor: authController.userController.profileColor.value,
            radius: 45,
            child: Center(
              child: Text(
                authController.userController.userName.value[0]??"",
                style: const TextStyle(
                    color: Colors.white, fontSize: 60),
              ),
            ),
          )),
        ],
      ),
    );
  }

  Widget _buildTextField(String label, TextEditingController controller, {TextInputType? keyboardType}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: TextField(
        controller: controller,
        readOnly: !_isEditing,
        keyboardType: keyboardType,
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
          filled: !_isEditing,
          fillColor: !_isEditing ? Colors.grey[100] : null,
        ),
      ),
    );
  }

  Widget _buildGenderDropdown() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: InputDecorator(
        decoration: InputDecoration(
          labelText: 'Gender',
          border: const OutlineInputBorder(),
          filled: !_isEditing,
          fillColor: !_isEditing ? Colors.grey[100] : null,
        ),
        child: DropdownButtonHideUnderline(
          child: DropdownButton<String>(
            value: _selectedGender,
            isExpanded: true,
            items: ['MALE', 'FEMALE', 'OTHER'].map((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
            onChanged: _isEditing
                ? (String? newValue) {
              setState(() {
                _selectedGender = newValue!;
              });
            }
                : null,
          ),
        ),
      ),
    );
  }

  Widget _buildBranchDropdown() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: InputDecorator(
        decoration: InputDecoration(
          labelText: 'Branch',
          border: const OutlineInputBorder(),
          filled: !_isEditing,
          fillColor: !_isEditing ? Colors.grey[100] : null,
        ),
        child: DropdownButtonHideUnderline(
          child: DropdownButton<String>(
            value: _selectedBranch,
            isExpanded: true,
            items: _branchOptions.map((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
            onChanged: _isEditing
                ? (String? newValue) {
              setState(() {
                _selectedBranch = newValue!;
              });
            }
                : null,
          ),
        ),
      ),
    );
  }


  Widget _buildActionButtons() {
    return Row(
      children: [
        if (_isEditing)
          Expanded(
            child: ElevatedButton(
              onPressed: () {
                setState(() {
                  _isEditing = false;
                });
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.grey,
              ),
              child: const Text("Cancel"),
            ),
          ),
        if (_isEditing) const SizedBox(width: 16),
        Expanded(
          child: ElevatedButton(
            onPressed: _isEditing ? _saveProfile : () => Navigator.pop(context),
            style: ElevatedButton.styleFrom(
              backgroundColor: _isEditing ? Colors.blue : Colors.grey,
            ),
            child: Text(_isEditing ? "Save" : "Back"),
          ),
        ),
      ],
    );
  }
}
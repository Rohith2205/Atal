import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import '../controllers/AuthController.dart';
import '../services/suggestions_table_amplify_service.dart';

class Suggestionscreen extends StatefulWidget {
  @override
  _SuggestionPageState createState() => _SuggestionPageState();
}

class _SuggestionPageState extends State<Suggestionscreen> {
  String? _selectedOption = 'Default';
  String? _fileName;
  File? _file;
  bool _isSubmitting = false;

  final List<String> _dropdownOptions = ['Default', 'App Related', 'ATL Program'];
  final TextEditingController _concernController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final ImagePicker _picker = ImagePicker();
  late final AuthController authController;

  @override
  void initState() {
    super.initState();
    authController = Get.find<AuthController>();
  }

  Future<void> _pickImage() async {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: Icon(Icons.photo_library),
                title: Text('Choose from Gallery'),
                onTap: () async {
                  Navigator.pop(context);
                  final XFile? image = await _picker.pickImage(
                    source: ImageSource.gallery,
                    imageQuality: 85,
                  );
                  if (image != null) {
                    setState(() {
                      _file = File(image.path);
                      _fileName = image.name;
                    });
                  }
                },
              ),
              Divider(height: 1),
              ListTile(
                leading: Icon(Icons.camera_alt),
                title: Text('Take a Photo'),
                onTap: () async {
                  Navigator.pop(context);
                  final XFile? image = await _picker.pickImage(
                    source: ImageSource.camera,
                    imageQuality: 85,
                    preferredCameraDevice: CameraDevice.rear,
                  );
                  if (image != null) {
                    setState(() {
                      _file = File(image.path);
                      _fileName = 'Camera_${DateTime.now().millisecondsSinceEpoch}.jpg';
                    });
                  }
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _submitForm() async {
    if (!_formKey.currentState!.validate() || _selectedOption == 'Default') {
      return;
    }

    if (!authController.isAuthenticated.value) {
      Get.snackbar(
        'Authentication Required',
        'Please login to submit suggestions',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
        duration: Duration(seconds: 3),
      );
      return;
    }

    setState(() {
      _isSubmitting = true;
    });

    try {
      // Ensure user is refreshed
      await authController.refreshAuthState();

      final userId = await authController.userController.userId.value;

      if (userId == null || userId.isEmpty) {
        Get.snackbar(
          'Authentication Error',
          'Unable to verify your account. Please login again.',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
          duration: Duration(seconds: 3),
        );
        return;
      }

      bool success = await SuggestionsTableAmplifyService.saveSuggestion(
        type: _selectedOption!,
        concern: _concernController.text.trim(),
        photo: _file?.path,
        userId: userId,
      );

      if (success) {
        Get.snackbar(
          'Success',
          'Suggestion submitted successfully!',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green,
          colorText: Colors.white,
          duration: Duration(seconds: 3),
        );
        _clearForm();
      } else {
        Get.snackbar(
          'Error',
          'Failed to submit suggestion. Please try again.',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
          duration: Duration(seconds: 3),
        );
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to submit suggestion: ${e.toString()}',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
        duration: Duration(seconds: 3),
      );
    } finally {
      setState(() {
        _isSubmitting = false;
      });
    }
  }

  void _clearForm() {
    _concernController.clear();
    setState(() {
      _selectedOption = 'Default';
      _file = null;
      _fileName = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Suggestions',
          style: TextStyle(color: Colors.white, fontSize: 24),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        backgroundColor: Colors.blue,
        elevation: 1,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                Image.asset('assets/images/Grievance.png', height: 300, width: 300),
                SizedBox(height: 20),
                DropdownButtonFormField<String>(
                  value: _selectedOption,
                  items: _dropdownOptions.map((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    contentPadding: EdgeInsets.symmetric(horizontal: 15, vertical: 12),
                  ),
                  onChanged: (newValue) {
                    setState(() {
                      _selectedOption = newValue!;
                    });
                  },
                  validator: (value) {
                    if (value == null || value == 'Default') {
                      return 'Please select a valid option';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 20),
                TextFormField(
                  controller: _concernController,
                  decoration: InputDecoration(
                    labelText: 'Concern',
                    border: OutlineInputBorder(),
                    contentPadding: EdgeInsets.symmetric(horizontal: 15, vertical: 12),
                  ),
                  maxLines: 5,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Please enter your concern';
                    }
                    if (value.trim().length < 10) {
                      return 'Concern should be at least 10 characters';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 20),
                ElevatedButton.icon(
                  onPressed: _pickImage,
                  icon: Icon(Icons.camera_alt),
                  label: Text(
                    _fileName ?? 'Upload Photo',
                    style: TextStyle(fontSize: 16),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: Colors.black,
                    side: BorderSide(color: Colors.grey),
                    minimumSize: Size(double.infinity, 50),
                  ),
                ),
                if (_file != null) ...[
                  SizedBox(height: 15),
                  Container(
                    height: 200,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey.shade300),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.file(
                        _file!,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ],
                SizedBox(height: 30),
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: _isSubmitting ? null : _submitForm,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: _isSubmitting
                        ? CircularProgressIndicator(color: Colors.white)
                        : Text(
                      'SUBMIT',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:atl_membership/models/ModelProvider.dart';
import 'package:atl_membership/services/SchoolsDetailsFirestoreService.dart';
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
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  List<String> districts = [];
  List<String> mandals = [];
  List<String> schools = [];

  bool isLoadingMandals = false;
  bool isLoadingSchools = false;

  final AuthController authController = Get.put(AuthController());
  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate() &&
        selectedDistrict != null &&
        selectedMandal != null &&
        selectedSchool != null) {
      try {
        // Reference to the specific school document
        final schoolDocRef = FirebaseFirestore.instance
            .collection('districts')
            .doc(selectedDistrict)
            .collection('mandals')
            .doc(selectedMandal)
            .collection('schools')
            .doc(selectedSchool); // Assuming school name is the document ID

        // Update the isSelected field
        await schoolDocRef.update({'isSelected': false});

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Joined successfully!')),
        );

        // Refresh the school list so the selected school disappears
        _loadSchools(selectedDistrict!, selectedMandal!);
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to update school: $e')),
        );
      }
    }
  }

  @override
  void initState() {
    super.initState();
    _loadInitialData();
  }

  Future<void> _loadInitialData() async {
    try {
      // Load districts from Firestore
      final fetchedDistricts = await SchoolsDetailsFirestoreService.FetchDistricts();
      safePrint("data loaded : $fetchedDistricts");

      setState(() {
        districts = fetchedDistricts;
        isInitialLoading = false;
      });
    } catch (e) {
      if (kDebugMode) {
        print('Error loading districts: $e');
      }
      setState(() {
        // Fallback to default districts if loading fails
        districts = ['Fetching Error'];
        isInitialLoading = false;
      });

      _showErrorSnackbar('Failed to load districts. Using default options.');
    }
  }


  Future<void> _loadMandals(String districtId) async {
    setState(() {
      isLoadingMandals = true;
      // Clear dependent dropdowns
      selectedMandal = null;
      selectedSchool = null;
      mandals.clear();
      schools.clear();
    });

    try {
      // Replace with your actual Firestore service method
      final fetchedMandals = await SchoolsDetailsFirestoreService.fetchMandalsByDistrict(districtId);

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

  Future<void> _loadSchools(String districtId,String mandalId) async {
    setState(() {
      isLoadingSchools = true;
      // Clear dependent dropdowns
      selectedSchool = null;
      schools.clear();
    });

    try {
      // Replace with your actual Firestore service method
      final fetchedSchools = await SchoolsDetailsFirestoreService.fetchSchoolsByMandal(districtId,mandalId);

      setState(() {
        schools = fetchedSchools;
        isLoadingSchools = false;
      });
    } catch (e) {
      if (kDebugMode) {
        print('Error loading schools: $e');
      }
      setState(() {
        schools = ['Fetching Error']; // Fallback
        isLoadingSchools = false;
      });

      _showErrorSnackbar('Failed to load schools. Using default options.');
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
        child: SingleChildScrollView(
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
                            value: selectedDistrict,
                            items: districts.map((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(value,overflow: TextOverflow.ellipsis,maxLines: 1),
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
                              _loadMandals(newValue!);
                            },
                            validator: (value) {
                              if (value == null) {
                                return 'Please select a District';
                              }
                              return null;
                            },
                          ),
                        ),
                        SizedBox(height: 20,),
                        SizedBox(
                          child: DropdownButtonFormField<String>(
                            value: selectedMandal,
                            items: mandals.map((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(value,overflow: TextOverflow.ellipsis,maxLines: 1),
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
                              _loadSchools(selectedDistrict!, newValue!);
                            },
                            validator: (value) {
                              if (value == null) {
                                return 'Please select a  Mandal';
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
                            value: selectedSchool,
                            items: schools.map((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(value,overflow: TextOverflow.ellipsis,maxLines: 1,),
                              );
                            }).toList(),
                            decoration: InputDecoration(
                              labelText: 'ATL School Mapping',
                              border: OutlineInputBorder(),
                            ),
                            onChanged: (newValue) {
                              setState(() {
                                selectedSchool = newValue!;
                              });
                            },
                            validator: (value) {
                              if (value == null ) {
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
                      onPressed: _submitForm,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: Text(
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


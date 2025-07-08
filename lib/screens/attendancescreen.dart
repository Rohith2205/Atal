import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:intl/intl.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';
import '../controllers/AuthController.dart';
import '../services/attendance_table_amplify_service.dart';

class Attendancescreen extends StatefulWidget {
  const Attendancescreen({super.key});

  @override
  State<Attendancescreen> createState() => _AttendancescreenState();
}

class _AttendancescreenState extends State<Attendancescreen> {
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _startTimeController = TextEditingController();
  final TextEditingController _endTimeController = TextEditingController();
  final TextEditingController _latitudeController = TextEditingController();
  final TextEditingController _longitudeController = TextEditingController();
  final TextEditingController _teacherController = TextEditingController();
  final TextEditingController _moduleController = TextEditingController();
  final TextEditingController _boysController = TextEditingController();
  final TextEditingController _girlsController = TextEditingController();
  final TextEditingController _totalController = TextEditingController();
  final TextEditingController _mnameController = TextEditingController();
  final TextEditingController _topicsController = TextEditingController();
  final TextEditingController _remarksController = TextEditingController();

  Map<String, bool> options = {
    '6': false,
    '7': false,
    '8': false,
    '9': false,
    '10':false,
  };

  XFile? _attendanceImage;
  final ImagePicker _picker = ImagePicker();
  final authController = Get.put(AuthController());
  bool _isAttendanceAlreadyTaken = false;
  bool _isCheckingAttendance = false;

  List<String> get selectedClasses =>
      options.entries.where((e) => e.value).map((e) => e.key).toList();

  @override
  void initState() {
    super.initState();
    _fetchLocation();
    _dateController.text = DateFormat('dd/MM/yyyy').format(DateTime.now());
    _startTimeController.addListener(() => setState(() {}));
    _endTimeController.addListener(() => setState(() {}));
    _teacherController.addListener(() => setState(() {}));
    _moduleController.addListener(() => setState(() {}));

    // Add listeners for boys and girls to auto-calculate total
    _boysController.addListener(_calculateTotal);
    _girlsController.addListener(_calculateTotal);

    _mnameController.addListener(() => setState(() {}));
    _topicsController.addListener(() => setState(() {}));
    _remarksController.addListener(() => setState(() {}));

    // Check if attendance is already taken for today
    _checkAttendanceForToday();
  }

  // Auto-calculate total when boys or girls count changes
  void _calculateTotal() {
    final boys = int.tryParse(_boysController.text) ?? 0;
    final girls = int.tryParse(_girlsController.text) ?? 0;
    final total = boys + girls;
    _totalController.text = total.toString();
    setState(() {});
  }

  // Check if attendance is already taken for today
  Future<void> _checkAttendanceForToday() async {
    setState(() {
      _isCheckingAttendance = true;
    });

    try {
      final today = DateTime.now();
      final todayString = DateFormat('dd/MM/yyyy').format(today);

      // Check if attendance exists for today
      bool attendanceExists = await AttendanceTableAmplifyService.checkAttendanceForDate(today);

      setState(() {
        _isAttendanceAlreadyTaken = attendanceExists;
        _isCheckingAttendance = false;
      });

      if (attendanceExists) {
        Get.snackbar(
          'Attendance Already Taken',
          'Attendance has already been recorded for today ($todayString)',
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.orange.withOpacity(0.8),
          colorText: Colors.white,
          duration: const Duration(seconds: 5),
        );
      }
    } catch (e) {
      setState(() {
        _isCheckingAttendance = false;
      });
      print('Error checking attendance: $e');
    }
  }

  // Fixed _isFormValid method - replace in your AttendanceScreen class

  Future<void> _isFormValid() async {
    // Check if attendance is already taken
    if (_isAttendanceAlreadyTaken) {
      Get.snackbar(
        'Attendance Already Taken',
        'Attendance has already been recorded for today. You cannot submit again.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.orange.withOpacity(0.7),
        colorText: Colors.white,
      );
      return;
    }

    if (_startTimeController.text.isEmpty ||
        _endTimeController.text.isEmpty ||
        _teacherController.text.isEmpty ||
        _moduleController.value.text.isEmpty ||
        _boysController.value.text.isEmpty ||
        _girlsController.value.text.isEmpty ||
        _mnameController.text.isEmpty ||
        _topicsController.text.isEmpty ||
        _remarksController.text.isEmpty ||
        selectedClasses.isEmpty ||
        _attendanceImage == null) {
      Get.snackbar(
        'Incomplete Form',
        'Please fill in all fields',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.withOpacity(0.7),
        colorText: Colors.white,
      );
      return;
    }

    // Validate that boys and girls are numbers
    if (int.tryParse(_boysController.text) == null || int.tryParse(_girlsController.text) == null) {
      Get.snackbar(
        'Invalid Input',
        'Number of boys and girls must be valid numbers',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.withOpacity(0.7),
        colorText: Colors.white,
      );
      return;
    }

    try {
      // Parse the date correctly from dd/MM/yyyy format
      DateTime parsedDate = DateFormat('dd/MM/yyyy').parse(_dateController.text);

      // Get the photo path/data for storage
      String? photoPath = _attendanceImage?.path;

      bool success = await AttendanceTableAmplifyService.saveAttendance(
        start_time: _startTimeController.text,
        end_time: _endTimeController.text,
        teachers: _teacherController.text,
        module_no: int.parse(_moduleController.text),
        no_of_boys: int.parse(_boysController.text),
        no_of_girls: int.parse(_girlsController.text),
        total: int.parse(_totalController.text),
        module_name: _mnameController.text,
        topics_covered: _topicsController.text,
        remarks: _remarksController.text,
        class_attended: selectedClasses,
        longitude: double.parse(_longitudeController.text),
        latitude: double.parse(_latitudeController.text),
        date: parsedDate,
        photo: photoPath, // Pass the photo path
      );

      if (success) {
        _clearForm();
        // Update the attendance status
        _isAttendanceAlreadyTaken = true;

        Get.snackbar(
          'Success',
          'Attendance saved successfully',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green.withOpacity(0.7),
          colorText: Colors.white,
        );
      } else {
        Get.snackbar(
          'Error',
          'Failed to save attendance',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to save attendance: $e',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

// Fixed _clearForm method - add this to your class
  void _clearForm() {
    _startTimeController.clear();
    _endTimeController.clear();
    _teacherController.clear();
    _moduleController.clear();
    _boysController.clear();
    _girlsController.clear();
    _totalController.clear();
    _mnameController.clear();
    _topicsController.clear();
    _remarksController.clear();
    _attendanceImage = null;
    options.updateAll((key, value) => false);
    _dateController.text = DateFormat('dd/MM/yyyy').format(DateTime.now());
    _fetchLocation();
    setState(() {});
  }

  Future<void> _pickAttendanceImage() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.camera);
    if (image != null) {
      setState(() {
        _attendanceImage = image;
      });
    }
  }

  Future<void> _fetchLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Location services are disabled.')),
      );
      return;
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Location permission denied')),
        );
        return;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Location permission permanently denied')),
      );
      return;
    }

    try {
      final position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      setState(() {
        _latitudeController.text = position.latitude.toString();
        _longitudeController.text = position.longitude.toString();
      });
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to fetch location: $e')),
        );
      }
    }
  }

  Future<void> _pickTime(TextEditingController controller) async {
    final picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (picked != null) {
      controller.text = picked.format(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: const Color(0xffeef1f5),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Center(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 6),
                margin: const EdgeInsets.only(bottom: 30),
                color: Colors.blue,
                child: const Text(
                  'Attendance',
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 26,
                    color: Colors.white,
                  ),
                ),
              ),
            ),

            // Show loading indicator while checking attendance
            if (_isCheckingAttendance)
              const Padding(
                padding: EdgeInsets.all(16.0),
                child: CircularProgressIndicator(),
              ),

            // Show warning if attendance is already taken
            if (_isAttendanceAlreadyTaken)
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                margin: const EdgeInsets.only(bottom: 20),
                decoration: BoxDecoration(
                  color: Colors.orange.withOpacity(0.1),
                  border: Border.all(color: Colors.orange),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Row(
                  children: [
                    Icon(Icons.warning, color: Colors.orange),
                    SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'Attendance has already been recorded for today',
                        style: TextStyle(
                          color: Colors.orange,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

            Image.asset('assets/images/AttendanceScreen.png'),

            // Date Field (auto-filled with today)
            TextField(
              controller: _dateController,
              readOnly: true,
              decoration: const InputDecoration(
                labelText: 'Date',
                hintText: 'dd/mm/yyyy',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),

            // Start & End Time Fields
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _startTimeController,
                    readOnly: true,
                    onTap: _isAttendanceAlreadyTaken ? null : () => _pickTime(_startTimeController),
                    decoration: const InputDecoration(
                      labelText: 'Start Time',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.access_time),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: TextField(
                    controller: _endTimeController,
                    readOnly: true,
                    onTap: _isAttendanceAlreadyTaken ? null : () => _pickTime(_endTimeController),
                    decoration: const InputDecoration(
                      labelText: 'End Time',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.access_time),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Latitude Field
            TextField(
              controller: _latitudeController,
              readOnly: true,
              decoration: const InputDecoration(
                labelText: 'Latitude',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),

            // Longitude Field
            TextField(
              controller: _longitudeController,
              readOnly: true,
              decoration: const InputDecoration(
                labelText: 'Longitude',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),

            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _teacherController,
                    enabled: !_isAttendanceAlreadyTaken,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      labelText: 'No. of teachers attended',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: TextField(
                    controller: _moduleController,
                    enabled: !_isAttendanceAlreadyTaken,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      labelText: 'Module No.',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 20),

            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _boysController,
                    enabled: !_isAttendanceAlreadyTaken,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      labelText: 'No. of Boys',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: TextField(
                    controller: _girlsController,
                    enabled: !_isAttendanceAlreadyTaken,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      labelText: 'No. of girls',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: TextField(
                    controller: _totalController,
                    readOnly: true, // Made readonly as requested
                    decoration: InputDecoration(
                      labelText: 'Total students',
                      border: const OutlineInputBorder(),
                      fillColor: Colors.grey[200], // Visual indication it's readonly
                      filled: true,
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 20),

            TextField(
              controller: _mnameController,
              enabled: !_isAttendanceAlreadyTaken,
              decoration: const InputDecoration(
                labelText: 'Module name',
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 20),
            TextField(
              controller: _topicsController,
              enabled: !_isAttendanceAlreadyTaken,
              decoration: const InputDecoration(
                labelText: 'Topics covered',
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 20),
            TextField(
              controller: _remarksController,
              enabled: !_isAttendanceAlreadyTaken,
              decoration: const InputDecoration(
                labelText: 'Remarks',
                border: OutlineInputBorder(),
              ),
            ),

            ExpansionTile(
              title: const Text("Select Classes"),
              children: options.keys.map((String key) {
                return CheckboxListTile(
                  title: Text('Class $key'),
                  value: options[key],
                  onChanged: _isAttendanceAlreadyTaken ? null : (bool? value) {
                    setState(() {
                      options[key] = value ?? false;
                    });
                  },
                );
              }).toList(),
            ),
            const SizedBox(height: 10),
            Text(
              "Selected: ${selectedClasses.join(", ")}",
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
            ),

            const SizedBox(height: 20),

            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Proof of Attendance (Photo)",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 8),
                InkWell(
                  onTap: _isAttendanceAlreadyTaken ? null : _pickAttendanceImage,
                  child: Container(
                    height: 150,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey),
                      borderRadius: BorderRadius.circular(8),
                      color: _isAttendanceAlreadyTaken ? Colors.grey[200] : Colors.white,
                    ),
                    child: _attendanceImage != null
                        ? Image.file(
                      File(_attendanceImage!.path),
                      fit: BoxFit.cover,
                    )
                        : Center(
                      child: Icon(
                        Icons.camera_alt,
                        size: 40,
                        color: _isAttendanceAlreadyTaken ? Colors.grey[400] : Colors.grey,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),

            // Submit Button
            SizedBox(
              width: width * 0.3,
              height: 38,
              child: ElevatedButton(
                onPressed: _isAttendanceAlreadyTaken ? null : () async {
                  await _isFormValid();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: _isAttendanceAlreadyTaken ? Colors.grey : Colors.blue,
                  disabledBackgroundColor: Colors.grey,
                ),
                child: Text(
                  _isAttendanceAlreadyTaken ? 'Already Submitted' : 'Submit',
                  style: const TextStyle(fontSize: 20),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
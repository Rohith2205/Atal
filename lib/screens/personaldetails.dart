import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:atl_membership/utils/routes.dart';

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

  final List<String> universities = ['University A', 'University B', 'University C'];
  final List<String> districts = ['District X', 'District Y', 'District Z'];
  final List<String> mandals =['mandal1','mandal2','mandal3'];
  final List<String> colleges = ['College 1', 'College 2', 'College 3'];

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      title: const Text('Personal Details', textAlign: TextAlign.center),
      content: SingleChildScrollView(
        child: Column(
          children: [
            _buildDropdown('University', selectedUniversity, universities, (value) {
              setState(() => selectedUniversity = value);
            }),

            
            const SizedBox(height: 10),
            _buildDropdown('District', selectedDistrict, districts, (value) {
              setState(() => selectedDistrict = value);
            }),
            const SizedBox(height: 10),
            _buildDropdown('Mandal', selectedMandal, mandals, (value) {
              setState(() => selectedDistrict = value);
            }),
            const SizedBox(height: 10),
            _buildDropdown('College', selectedCollege, colleges, (value) {
              setState(() => selectedCollege = value);
            }),
            const SizedBox(height: 10),
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
      actionsAlignment: MainAxisAlignment.spaceEvenly,
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancel', style: TextStyle(color: Colors.deepPurple)),
        ),
        TextButton(
          onPressed: () {
            //print("University: $selectedUniversity");
            
            print("District: $selectedDistrict");
            print("College: $selectedCollege");
            print("Mandal: $selectedMandal");
            print("Roll No: ${rollNoController.text}");

            Navigator.of(context).pop();
            Get.offAllNamed(Routes.HOME); // Navigates to MainScreen after submit
          },
          child: const Text('Submit', style: TextStyle(color: Colors.deepPurple)),
        ),
      ],
    );
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
    );
  }
}
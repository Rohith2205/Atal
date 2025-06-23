import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class Suggestionscreen extends StatefulWidget {
  @override
  _SuggestionPageState createState() => _SuggestionPageState();
}

class _SuggestionPageState extends State<Suggestionscreen> {
  String? _selectedOption = 'Default';
  String? _fileName;
  File? _file;

  final List<String> _dropdownOptions = ['Default', 'App Related', 'ATL Program'];
  final TextEditingController _concernController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final ImagePicker _picker = ImagePicker();

  Future<void> _pickImage() async {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return SafeArea(
          child: Wrap(
            children: [
              ListTile(
                leading: Icon(Icons.image),
                title: Text('Pick Image'),
                onTap: () async {
                  Navigator.pop(context);
                  final XFile? image =
                  await _picker.pickImage(source: ImageSource.gallery);
                  if (image != null) {
                    setState(() {
                      _file = File(image.path);
                      _fileName = image.name;
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

  void _submitForm() {
    if (_formKey.currentState!.validate() && _selectedOption != 'Default') {
      // All validations passed
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Submitted successfully!')),
      );
    }
    // Submit logic here
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
          icon: Icon(Icons.arrow_back,color: Colors.white,),
          onPressed: () => Navigator.pop(context),
        ),
        backgroundColor: Colors.blue,
        elevation: 1,
        iconTheme: IconThemeData(color: Colors.black),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                Image.asset('assets/images/Grievance.png',height: 300,width: 300,),
                SizedBox(height: 20),
                DropdownButtonFormField<String>(
                  value: _selectedOption,
                  items: _dropdownOptions.map((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                  decoration: InputDecoration(border: OutlineInputBorder()),
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
                  ),
                  maxLines: 3,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Please enter your concern';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 20),
                ElevatedButton.icon(
                  onPressed: _pickImage,
                  icon: Icon(Icons.upload),
                  label: Text(
                    _fileName ?? 'Photo Upload',
                    style: TextStyle(fontSize: 16),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: Colors.black,
                    side: BorderSide(color: Colors.grey),
                  ),
                ),
                SizedBox(height: 40),
                Center(
                  child: ElevatedButton(
                    onPressed: _submitForm,

                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      padding:
                      EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: Text(
                      'Submit',
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
    );
  }
}
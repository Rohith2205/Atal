import 'package:flutter/material.dart';

class Schoolscreen extends StatefulWidget {
  const Schoolscreen ({super.key});

  @override
  _SchoolscreenPageState createState() => _SchoolscreenPageState();
}

class _SchoolscreenPageState extends State<Schoolscreen> {
  String? _selectedOption = 'Default';
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final List<String> _dropdownOptions = ['Default', 'School A', 'School B','School C'];
  void _submitForm() {
    if ( _formKey.currentState!.validate() && _selectedOption != 'Default') {
      // All validations passed
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Joined successfully!')),
      );
    }


    // Submit logic here
  }
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar: AppBar(
        title: Text('School Mapping',style: TextStyle(color: Colors.white,fontSize: 24),),

        leading: IconButton(
          icon: Icon(Icons.arrow_back,color: Colors.white,),
          onPressed: () => Navigator.pop(context),
        ),
        backgroundColor: Colors.blue,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Image.asset('assets/images/school.png',height: 300,width: 300,),
              Text('Choose one of the ATL schools:',style: TextStyle(fontSize: 19),),
              SizedBox(height: 16,),
              SizedBox(
                width: 300,
                child: Form(
                  key: _formKey,
                  child: DropdownButtonFormField<String>(
                    value: _selectedOption,
                    items: _dropdownOptions.map((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                    decoration: InputDecoration(border: OutlineInputBorder(),),
                    onChanged: (newValue) {
                      setState(() {
                        _selectedOption = newValue!;
                      });
                    },
                    validator: (value) {
                      if (value == null || value == 'Default') {
                        return 'Please select a valid school';
                      }
                      return null;
                    },
                  ),
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
    );
  }
}
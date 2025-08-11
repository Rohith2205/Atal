import 'resources_screen.dart';
import 'package:flutter/material.dart';
import 'ResourceButton.dart';
import 'about_atl_curriculum.dart';
import 'modules_screen.dart';

class Resourcesscreen extends StatelessWidget {
  const Resourcesscreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        children: [
          const SizedBox(height: 20),
          Center(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 6),
              margin: const EdgeInsets.only(bottom: 30),
              color: Colors.blue,
              child: const Text(
                'Resources',
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 26,
                  color: Colors.white,
                ),
              ),
            ),
          ),
          Center(
            child: Image.asset(
              'assets/images/resources.jpg',
              width: 250,
              fit: BoxFit.contain,
            ),
          ),
          const SizedBox(height: 30),
          CustomButton(
            label: 'About ATL Curriculum',
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const ATLCurriculumScreen()),
              );
            },
          ),
          const SizedBox(height: 15),
          CustomButton(
            label: 'Resources',
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const Resources_screen()),
              );
            },
          ),
          const SizedBox(height: 15),
          CustomButton(
            label: 'Modules',
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const ModulesScreen()),
              );
            },
          ),
          const SizedBox(height: 16,)
        ],
      ),
    );
  }
}
